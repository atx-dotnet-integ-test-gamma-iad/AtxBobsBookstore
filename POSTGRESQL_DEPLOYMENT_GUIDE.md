# PostgreSQL Deployment Guide
## Bob's Bookstore - SQL Server to PostgreSQL Migration

---

## Document Overview

**Purpose:** This guide provides step-by-step instructions for deploying and validating the Bob's Bookstore application after migration from SQL Server to PostgreSQL.

**Target Audience:** Database Administrators, DevOps Engineers, QA Engineers

**Prerequisites:**
- PostgreSQL database instance (version 12 or higher recommended)
- Database schema `bobsbookstore_dbo` created and populated with tables
- Access credentials with CREATE FUNCTION and EXECUTE privileges
- .NET 8.0 SDK installed
- Application source code from this repository

---

## Phase 1: PostgreSQL Function Deployment

### Step 1.1: Verify Database Schema Exists

Connect to your PostgreSQL database and verify the schema exists:

```sql
-- Check if schema exists
SELECT schema_name 
FROM information_schema.schemata 
WHERE schema_name = 'bobsbookstore_dbo';

-- If schema doesn't exist, create it
CREATE SCHEMA IF NOT EXISTS bobsbookstore_dbo;
```

### Step 1.2: Verify Required Tables Exist

Verify that the required tables exist with the correct structure:

```sql
-- Check for author table
SELECT table_name, column_name, data_type 
FROM information_schema.columns 
WHERE table_schema = 'bobsbookstore_dbo' 
  AND table_name = 'author'
ORDER BY ordinal_position;

-- Check for product table
SELECT table_name, column_name, data_type 
FROM information_schema.columns 
WHERE table_schema = 'bobsbookstore_dbo' 
  AND table_name = 'product'
ORDER BY ordinal_position;
```

**Required columns for author table:**
- businessentityid (integer, PRIMARY KEY)
- nationalidnumber (character varying, 15)
- birthdate (timestamp)
- maritalstatus (character, 1)
- gender (character, 1)
- hiredate (timestamp)
- modifieddate (timestamp)

**Required columns for product table:**
- productid (integer, PRIMARY KEY)
- name (character varying)
- productnumber (character varying)
- safetystocklevel (integer)

### Step 1.3: Deploy PostgreSQL Functions

Execute the function creation script:

```bash
# Option 1: Using psql command line
psql -h <hostname> -U <username> -d <database_name> -f db/postgresql_functions.sql

# Option 2: Using psql interactive
psql -h <hostname> -U <username> -d <database_name>
\i db/postgresql_functions.sql

# Option 3: Copy and paste the SQL from db/postgresql_functions.sql into your SQL client
```

### Step 1.4: Verify Functions Were Created

Run the verification queries from the postgresql_functions.sql file:

```sql
-- Verify function 1: uspupdateauthorpersonalinfo
SELECT 
    proname AS function_name,
    pg_get_function_arguments(oid) AS arguments,
    pg_get_function_result(oid) AS return_type
FROM pg_proc 
WHERE proname = 'uspupdateauthorpersonalinfo'
  AND pronamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'bobsbookstore_dbo');

-- Expected result:
-- function_name: uspupdateauthorpersonalinfo
-- arguments: p_businessentityid integer, p_nationalidnumber character varying, 
--            p_birthdate timestamp without time zone, p_maritalstatus character, 
--            p_gender character
-- return_type: integer

-- Verify function 2: uspdeleteauthor
SELECT 
    proname AS function_name,
    pg_get_function_arguments(oid) AS arguments,
    pg_get_function_result(oid) AS return_type
FROM pg_proc 
WHERE proname = 'uspdeleteauthor'
  AND pronamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'bobsbookstore_dbo');

-- Expected result:
-- function_name: uspdeleteauthor
-- arguments: p_businessentityid integer
-- return_type: integer
```

### Step 1.5: Test Functions with Sample Data

Test each function to ensure they work correctly:

```sql
-- Test 1: Insert a test author (if not exists)
INSERT INTO bobsbookstore_dbo.author 
    (businessentityid, nationalidnumber, birthdate, maritalstatus, gender, hiredate, modifieddate)
VALUES 
    (99999, '999999999', '1990-01-01', 'S', 'M', '2020-01-01', CURRENT_TIMESTAMP)
ON CONFLICT (businessentityid) DO NOTHING;

-- Test 2: Update author using function
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(
    99999,                  -- businessentityid
    '111111111',           -- nationalidnumber
    '1990-06-15'::TIMESTAMP, -- birthdate
    'M',                   -- maritalstatus
    'M'                    -- gender
);
-- Expected result: 1 (one row affected)

-- Test 3: Verify the update
SELECT businessentityid, nationalidnumber, birthdate, maritalstatus, gender
FROM bobsbookstore_dbo.author
WHERE businessentityid = 99999;
-- Expected: Updated values should be reflected

-- Test 4: Delete author using function
SELECT bobsbookstore_dbo.uspdeleteauthor(99999);
-- Expected result: 1 (one row deleted)

-- Test 5: Attempt to delete non-existent author (should raise exception)
-- SELECT bobsbookstore_dbo.uspdeleteauthor(99999);
-- Expected: ERROR: No author found with the provided BusinessEntityID: 99999

-- Clean up test data (if needed)
DELETE FROM bobsbookstore_dbo.author WHERE businessentityid = 99999;
```

---

## Phase 2: Application Configuration

### Step 2.1: Update Connection String

The application uses AWS Secrets Manager for connection strings. Ensure the secret contains the correct PostgreSQL connection string:

**Secret ARN:** `arn:aws:secretsmanager:us-east-1:812756961751:secret:atx-db-modernization-test-DBConnector-setup-bobsBookStoreDB-source-target-FU71Bm`

**Expected format:**
```
Host=<hostname>;Port=5432;Database=<database_name>;Username=<username>;Password=<password>
```

Or retrieve and update the secret:

```bash
# Retrieve current secret
aws secretsmanager get-secret-value \
  --secret-id arn:aws:secretsmanager:us-east-1:812756961751:secret:atx-db-modernization-test-DBConnector-setup-bobsBookStoreDB-source-target-FU71Bm \
  --region us-east-1

# Update secret with new PostgreSQL connection string
aws secretsmanager update-secret \
  --secret-id arn:aws:secretsmanager:us-east-1:812756961751:secret:atx-db-modernization-test-DBConnector-setup-bobsBookStoreDB-source-target-FU71Bm \
  --secret-string '{"ConnectionString":"Host=<hostname>;Port=5432;Database=<database>;Username=<user>;Password=<password>"}' \
  --region us-east-1
```

### Step 2.2: Build the Application

Build the application to ensure all dependencies are resolved:

```bash
cd app
dotnet build BobsBookstore.sln -c Release
```

**Expected result:**
- Build succeeded
- 0 errors
- Warnings (if any) should be pre-existing nullable reference warnings

### Step 2.3: Verify Package Dependencies

Ensure only PostgreSQL packages are referenced:

```bash
dotnet list package

# Expected output should include:
# > Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0
# > Microsoft.EntityFrameworkCore 8.0.10

# Should NOT include:
# > Microsoft.Data.SqlClient
# > System.Data.SqlClient
```

---

## Phase 3: Runtime Validation Testing

### Step 3.1: Database Connectivity Test

Test basic database connectivity:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --urls "http://localhost:5000"

# Check application logs for successful database connection
# Look for: "Application started" or similar success messages
```

### Step 3.2: Statement #2 Validation (Baseline - Validated as EQUIVALENT)

**Test:** Find All Authors
**Statement:** `SELECT * FROM bobsbookstore_dbo.author`
**Status:** EQUIVALENT (formally verified)

**Test Steps:**
1. Navigate to the authors list page (or call the API endpoint)
2. Verify all authors are displayed
3. Compare with SQL Server results (if baseline available)

**Expected Result:** All authors retrieved successfully

### Step 3.3: Statement #1 Validation (HIGH PRIORITY)

**Test:** Edit Author Using Stored Procedure
**Statement:** `SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo($1, $2, $3, $4, $5)`
**Status:** ERROR (UNKNOWN equivalency - requires validation)
**Priority:** HIGH

**Test Steps:**
1. Select an existing author
2. Update their personal information:
   - Business Entity ID: (existing ID)
   - National ID Number: (new value)
   - Birth Date: (new value)
   - Marital Status: (new value)
   - Gender: (new value)
3. Submit the update
4. Verify the update was successful
5. Check that the row count returned is 1

**Expected Result:**
- Update succeeds
- Function returns 1 (one row affected)
- Author data is updated in database

**Test Cases:**
- Valid update with all fields
- Update with non-existent business entity ID (should return 0)
- Update with invalid data types (should raise error)

### Step 3.4: Statement #3 Validation (HIGH PRIORITY)

**Test:** Delete Author Using Stored Procedure
**Statement:** `SELECT bobsbookstore_dbo.uspdeleteauthor($1)`
**Status:** ERROR (UNKNOWN equivalency - requires validation)
**Priority:** HIGH

**Test Steps:**
1. Create a test author
2. Delete the author using the application
3. Verify the delete was successful
4. Check that the row count returned is 1
5. Attempt to delete the same author again (should raise exception)

**Expected Result:**
- First delete succeeds and returns 1
- Second delete raises exception: "No author found with the provided BusinessEntityID"

**Test Cases:**
- Valid delete of existing author
- Delete non-existent author (should raise exception)
- Verify cascading deletes if author has related data

### Step 3.5: Statement #4 Validation (MEDIUM PRIORITY)

**Test:** Select Authors By Hire Year (T-SQL Functions)
**Statement:** Complex query with date functions
**Status:** ERROR (UNKNOWN equivalency - requires validation)
**Priority:** MEDIUM

**Test Steps:**
1. Execute the query with a specific hire year (e.g., 2020)
2. Verify the results match expected values
3. Compare formatted dates with SQL Server results
4. Verify age calculations are correct

**Critical Validations:**
- `TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS')` format matches SQL Server `FORMAT` output
- `DATE_PART('year', AGE(CURRENT_DATE, birthdate))` produces same age as SQL Server `DATEDIFF`
- `DATE_PART('year', hiredate)` correctly filters by hire year

**Test Cases:**
- Query with hire year that has results
- Query with hire year that has no results
- Compare date formatting output character by character
- Verify age calculation edge cases (birthdays, leap years)

### Step 3.6: Statement #5 Validation (MEDIUM PRIORITY)

**Test:** Get Product Data (Cursor to SELECT Conversion)
**Statement:** `SELECT productid, name, productnumber, safetystocklevel FROM bobsbookstore_dbo.product`
**Status:** ERROR (UNKNOWN equivalency - requires validation)
**Priority:** MEDIUM

**Test Steps:**
1. Navigate to the products list page
2. Verify all products are displayed
3. Compare columns with SQL Server stored procedure output
4. Verify data completeness

**Critical Validations:**
- All four columns are returned: productid, name, productnumber, safetystocklevel
- Column order matches expected order
- All rows returned (no data loss from cursor conversion)
- No extra columns included

**Test Cases:**
- Retrieve all products
- Verify column names (lowercase in PostgreSQL)
- Compare row count with SQL Server baseline
- Verify data types are correct

---

## Phase 4: Integration Testing

### Step 4.1: Execute Full Test Suite

Run all unit tests and integration tests:

```bash
# Run all tests
dotnet test BobsBookstore.sln -c Release

# Run tests with detailed output
dotnet test BobsBookstore.sln -c Release --logger "console;verbosity=detailed"

# Run tests and generate coverage report
dotnet test BobsBookstore.sln -c Release --collect:"XPlat Code Coverage"
```

### Step 4.2: Document Test Results

Create a test results summary:

```
Total Tests: [count]
Passed: [count]
Failed: [count]
Skipped: [count]

Failed Tests (if any):
- Test Name 1: [reason]
- Test Name 2: [reason]
```

### Step 4.3: Regression Testing

Compare application behavior before and after migration:

**Test Scenarios:**
1. CRUD operations on authors
2. CRUD operations on products
3. Search and filter functionality
4. Date and time calculations
5. Error handling and validation
6. Transaction integrity

---

## Phase 5: Performance Validation

### Step 5.1: Query Performance Comparison

Compare query execution times between SQL Server and PostgreSQL:

```sql
-- Enable timing in psql
\timing on

-- Run Statement #2 (baseline)
SELECT * FROM bobsbookstore_dbo.author;

-- Run Statement #4 (complex functions)
SELECT businessentityid, 
       TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, 
       DATE_PART('year', AGE(CURRENT_DATE, birthdate)) AS age 
FROM bobsbookstore_dbo.author 
WHERE DATE_PART('year', hiredate) = 2020;

-- Run functions
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(1, '123456789', '1980-01-01', 'M', 'M');
SELECT bobsbookstore_dbo.uspdeleteauthor(99999);
```

**Document:**
- Query execution time
- Number of rows returned
- Any performance degradation compared to SQL Server

### Step 5.2: Application Response Time

Measure end-to-end response times:

**Test Cases:**
- Load authors list page
- Load products list page
- Update author
- Delete author
- Search/filter operations

**Acceptance Criteria:**
- Response times should be comparable to SQL Server baseline
- No significant performance degradation (>20% slower)

---

## Phase 6: Validation Checklist

### Exit Criteria Validation

- [ ] **Criterion 12: Database Connectivity**
  - [ ] Application successfully connects to PostgreSQL
  - [ ] Connection string is correctly configured
  - [ ] No connection errors in logs

- [ ] **Criterion 13: Database Operations**
  - [ ] Statement #1 (uspupdateauthorpersonalinfo) executes successfully
  - [ ] Statement #2 (SELECT authors) executes successfully
  - [ ] Statement #3 (uspdeleteauthor) executes successfully
  - [ ] Statement #4 (SELECT with date functions) executes successfully
  - [ ] Statement #5 (SELECT products) executes successfully
  - [ ] All operations return expected results
  - [ ] Error handling works correctly

- [ ] **Criterion 15: Test Suite**
  - [ ] All unit tests pass
  - [ ] All integration tests pass
  - [ ] No new test failures introduced by migration

### Comprehensive Validation Checklist

- [ ] PostgreSQL functions deployed and verified
- [ ] Application builds successfully with 0 errors
- [ ] Database connectivity established
- [ ] Statement #2 (EQUIVALENT) validated in runtime
- [ ] Statement #1 (ERROR status) tested and working
- [ ] Statement #3 (ERROR status) tested and working
- [ ] Statement #4 (ERROR status) tested and working
- [ ] Statement #5 (ERROR status) tested and working
- [ ] Full test suite executed and passed
- [ ] Performance is acceptable
- [ ] Error handling verified
- [ ] Documentation updated

---

## Phase 7: Rollback Procedure (If Needed)

### Rollback Steps

If critical issues are discovered during validation:

1. **Revert Connection String**
   ```bash
   # Update AWS Secrets Manager back to SQL Server connection string
   aws secretsmanager update-secret \
     --secret-id [SECRET_ARN] \
     --secret-string '{"ConnectionString":"[SQL_SERVER_CONNECTION_STRING]"}' \
     --region us-east-1
   ```

2. **Restore Previous Code Version**
   ```bash
   git checkout [previous_commit_hash]
   dotnet build BobsBookstore.sln -c Release
   ```

3. **Document Issues**
   - Record all issues encountered
   - Create tickets for remediation
   - Update migration plan

---

## Troubleshooting Guide

### Issue 1: Function Not Found Error

**Error:** `function bobsbookstore_dbo.uspupdateauthorpersonalinfo does not exist`

**Solutions:**
1. Verify schema exists: `SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'bobsbookstore_dbo';`
2. Re-run postgresql_functions.sql
3. Verify function was created: Use verification queries from Step 1.4
4. Check search_path: `SHOW search_path;` - ensure bobsbookstore_dbo is included

### Issue 2: Column Not Found Error

**Error:** `column "businessentityid" does not exist`

**Solutions:**
1. PostgreSQL is case-sensitive for quoted identifiers
2. Verify column names are lowercase in database
3. Check Entity Framework Core mappings in ApplicationDbContext.cs
4. Run: `SELECT column_name FROM information_schema.columns WHERE table_name = 'author';`

### Issue 3: Connection String Error

**Error:** `Connection refused` or `Password authentication failed`

**Solutions:**
1. Verify PostgreSQL server is running and accessible
2. Check hostname, port, and credentials in Secrets Manager
3. Verify firewall rules allow connection
4. Test connection using psql: `psql -h <hostname> -U <username> -d <database>`

### Issue 4: Row Count Mismatch

**Error:** Function returns 0 when row should be updated/deleted

**Solutions:**
1. Verify businessentityid exists in table
2. Check parameter order matches function definition
3. Verify data types match between C# and PostgreSQL
4. Add logging to function to debug: `RAISE NOTICE 'Parameter value: %', p_businessentityid;`

### Issue 5: Date Format Mismatch

**Error:** Date formatting doesn't match SQL Server output

**Solutions:**
1. Compare format strings: `TO_CHAR(date, 'YYYY-MM-DD HH24:MI:SS')` vs `FORMAT(date, 'yyyy-MM-dd HH:mm:ss')`
2. Check for timezone differences between SQL Server and PostgreSQL
3. Use `AT TIME ZONE` if timezone conversion needed
4. Verify time component (HH24 vs HH for 24-hour format)

---

## Success Criteria Summary

**Migration is considered successful when:**

1. ✅ All PostgreSQL functions deployed and verified
2. ✅ Application builds with 0 errors
3. ✅ Application connects to PostgreSQL database
4. ✅ All 5 SQL statements execute successfully
5. ✅ Statement #2 (EQUIVALENT) validated in runtime
6. ✅ Statements #1, #3, #4, #5 (ERROR status) validated through integration testing
7. ✅ Full test suite passes
8. ✅ Performance is acceptable
9. ✅ No data integrity issues
10. ✅ Error handling works correctly

---

## Additional Resources

### Migration Documentation
- `MIGRATION_FINAL_REPORT.md` - Complete migration details
- `extracted_statements.sql` - Original SQL statements catalog
- `converted_statements.sql` - Converted PostgreSQL statements
- `sql_equivalency_validation_report.json` - Equivalency validation results
- `dms_conversion_failure_log.md` - DMS tool failure documentation

### PostgreSQL Resources
- PostgreSQL Official Documentation: https://www.postgresql.org/docs/
- Npgsql Documentation: https://www.npgsql.org/doc/
- SQL Server to PostgreSQL Migration Guide: https://wiki.postgresql.org/wiki/How_to_make_a_proper_migration_from_SQL_Server_to_PostgreSQL

### Support Contacts
- Database Team: [contact information]
- Application Team: [contact information]
- DevOps Team: [contact information]

---

**Document Version:** 1.0  
**Last Updated:** December 18, 2025  
**Author:** AWS Transform CLI Migration Agent  
**Status:** Ready for Deployment
