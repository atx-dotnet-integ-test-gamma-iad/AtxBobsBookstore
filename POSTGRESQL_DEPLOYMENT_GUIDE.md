# PostgreSQL Migration Deployment Guide
## BobsBookstore Application - Database Migration from SQL Server to PostgreSQL

### Document Version: 1.0
### Date: 2026-01-02
### Status: Ready for PostgreSQL Database Deployment

---

## Overview

This guide provides step-by-step instructions for completing the PostgreSQL migration for the BobsBookstore .NET application. The code transformation is **COMPLETE** and the application **compiles successfully**. What remains is deploying the PostgreSQL database infrastructure and executing runtime validation tests.

---

## Current Status

### ✅ COMPLETED - Code Transformation (Exit Criteria 1-11, 16)

All static code transformations have been successfully completed:

1. ✅ All SQL Server packages replaced with Npgsql equivalents
2. ✅ All ADO.NET classes migrated (SqlConnection → NpgsqlConnection, etc.)
3. ✅ All 4 SQL statements processed through DMS MCP tool
4. ✅ Comprehensive SQL statement catalog created
5. ✅ All SQL statement pairs validated through SQL Equivalency tool
6. ✅ Comprehensive equivalency validation report generated
7. ✅ No agent judgment used for equivalency determinations
8. ✅ All DMS failures documented with manual conversions
9. ✅ Connection strings updated to PostgreSQL format
10. ✅ Transaction handling updated for PostgreSQL
11. ✅ Application compiles with zero errors
16. ✅ Final report with complete SQL equivalency status

### ⚠️ PENDING - Runtime Validation (Exit Criteria 12-15)

The following criteria require a **running PostgreSQL database instance**:

12. ⚠️ **PARTIAL** - Database connection verification (code configured, runtime test pending)
13. ❌ **PENDING** - Database operations execution (requires PostgreSQL instance)
14. ❌ **PENDING** - Transaction atomicity verification (requires PostgreSQL instance)
15. ❌ **PENDING** - Unit and integration tests (requires PostgreSQL instance)

---

## Prerequisites

### Required Software
- PostgreSQL 12 or higher
- pgAdmin 4 (optional, for database management)
- AWS CLI configured (if using AWS RDS PostgreSQL)
- .NET 8.0 SDK (already installed)

### Required Access
- PostgreSQL database server with admin privileges
- Ability to create schemas, tables, and functions
- Network access to PostgreSQL instance from application server

---

## Deployment Steps

### Phase 1: PostgreSQL Database Setup

#### Step 1.1: Create PostgreSQL Database

```sql
-- Connect to PostgreSQL server as admin user
CREATE DATABASE bobsbookstore
    WITH 
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8';
```

#### Step 1.2: Create Schema

```sql
-- Connect to bobsbookstore database
CREATE SCHEMA IF NOT EXISTS bobsbookstore_dbo;
```

#### Step 1.3: Execute Database Schema Migration

The database schema (tables, indexes, constraints) should be migrated from SQL Server to PostgreSQL. You have two options:

**Option A: Use AWS DMS Schema Conversion Tool**
```bash
# Use the DMS migration project that was referenced during code conversion
# ARN: arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI
# Follow AWS DMS documentation for schema migration
```

**Option B: Manual Schema Migration**
```bash
# If schema SQL files exist in db/ directory, convert and execute them
# Check files: adven.sql, bobsusedbooks.sql
# Convert SQL Server DDL to PostgreSQL DDL and execute
```

#### Step 1.4: Create PostgreSQL Functions

Execute the generated PostgreSQL functions script:

```bash
# Navigate to the db directory
cd /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/db

# Execute the PostgreSQL functions script
psql -U your_postgres_user -d bobsbookstore -f postgresql_functions.sql
```

**Functions Created:**
- `bobsbookstore_dbo.uspupdateauthorpersonalinfo(int, text, timestamp, text, text)` → Returns INTEGER
- `bobsbookstore_dbo.uspdeleteauthor(int)` → Returns INTEGER

#### Step 1.5: Verify Function Creation

```sql
-- Verify functions exist
SELECT 
    n.nspname as schema,
    p.proname as function_name,
    pg_get_function_arguments(p.oid) as arguments,
    pg_get_function_result(p.oid) as return_type
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'bobsbookstore_dbo'
ORDER BY p.proname;

-- Expected output:
-- schema              | function_name                 | arguments                                                              | return_type
-- bobsbookstore_dbo   | uspdeleteauthor               | p_businessentityid integer                                            | integer
-- bobsbookstore_dbo   | uspupdateauthorpersonalinfo   | p_businessentityid integer, p_nationalidnumber text, ...              | integer
```

#### Step 1.6: Load Sample Data (if applicable)

```bash
# If sample data exists in db/ directory
# Convert and load: adven-data.sql
psql -U your_postgres_user -d bobsbookstore -f adven-data-postgresql.sql
```

---

### Phase 2: Application Configuration

#### Step 2.1: Configure AWS Secrets Manager

The application uses AWS Secrets Manager for database credentials. Update the secret with PostgreSQL connection details:

```json
{
  "host": "your-postgresql-host.amazonaws.com",
  "port": 5432,
  "database": "bobsbookstore",
  "username": "your_postgres_user",
  "password": "your_secure_password"
}
```

**Secret ARN Format in appsettings.json:**
```json
{
  "DatabaseSecret": "arn:aws:secretsmanager:region:account:secret:secret-name"
}
```

#### Step 2.2: Update Connection String Configuration

Verify the connection string builder in code (already configured):

**File:** `sourceCode/app/Bookstore.Web/ServicesSetup.cs`

```csharp
// This is already in place - verify it's correct
var builder = new NpgsqlConnectionStringBuilder
{
    Host = credentials["host"],
    Port = int.Parse(credentials["port"] ?? "5432"),
    Database = credentials["database"],
    Username = credentials["username"],
    Password = credentials["password"],
    SslMode = SslMode.Require // Adjust based on your PostgreSQL configuration
};
```

#### Step 2.3: Test Connection String Generation

```bash
cd /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode

# Build the application
dotnet build BobsBookstore.sln

# Expected: Build succeeded, 0 Error(s)
```

---

### Phase 3: Runtime Validation

#### Step 3.1: Database Connection Test

Run the application and verify successful database connection:

```bash
cd /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web

# Run the application
dotnet run

# Expected: Application starts without connection errors
# Check logs for successful database connection messages
```

#### Step 3.2: Test SELECT Operations

Test the converted SELECT queries:

**Test 1: FindAllAuthorsEmbeddedSql**
```bash
# Access the endpoint (adjust URL based on your application)
curl http://localhost:5000/api/authors/embedded

# Expected: JSON array of authors
# Verify data is returned without errors
```

**Test 2: SelectAuthorsByHireYear**
```bash
# Access the endpoint with year parameter
curl http://localhost:5000/api/authors/by-hire-year?year=2020

# Expected: JSON array with BusinessEntityID, FormattedModifiedDate, Age fields
# Verify date formatting and age calculation are correct
```

#### Step 3.3: Test Function Calls (UPDATE Operation)

**Test: EditUsingStoredProcedure**
```bash
# Test the update operation
curl -X PUT http://localhost:5000/api/authors/stored-procedure \
  -H "Content-Type: application/json" \
  -d '{
    "businessEntityID": 1,
    "nationalIDNumber": "123456789",
    "birthDate": "1980-01-01T00:00:00Z",
    "maritalStatus": "M",
    "gender": "M"
  }'

# Expected: Success response with rows affected
# Verify the function returns an integer (rows affected)
```

#### Step 3.4: Test Function Calls (DELETE Operation)

**Test: DeleteAuthorEmbeddedSql**
```bash
# Test the delete operation (use a test record)
curl -X DELETE http://localhost:5000/api/authors/9999

# Expected: Appropriate response based on whether record exists
# Verify error handling works correctly when record not found
```

#### Step 3.5: Test Transaction Handling

Create test scenarios that exercise transaction logic:
- Multiple operations in a transaction
- Rollback scenarios
- Commit scenarios

Verify atomicity is maintained.

#### Step 3.6: Run Unit Tests

```bash
cd /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode

# Run all tests
dotnet test BobsBookstore.sln

# Expected: All tests pass with PostgreSQL backend
# Document any test failures for review
```

---

## Validation Checklist

Use this checklist to track completion of runtime validation criteria:

### Exit Criterion 12: Database Connection
- [ ] Application starts without connection errors
- [ ] Connection pool initializes successfully
- [ ] AWS Secrets Manager credential retrieval works
- [ ] SSL/TLS connection established (if required)
- [ ] Connection timeout settings appropriate

**Status:** ⚠️ PARTIAL → Update to ✅ PASS when verified

### Exit Criterion 13: Database Operations
- [ ] SELECT query 1 (FindAllAuthorsEmbeddedSql) executes successfully
- [ ] SELECT query 2 (SelectAuthorsByHireYear) executes successfully
- [ ] Function call 1 (uspupdateauthorpersonalinfo) executes successfully
- [ ] Function call 2 (uspdeleteauthor) executes successfully
- [ ] Parameter binding with NpgsqlParameter works correctly
- [ ] Result sets have correct structure and data types
- [ ] Date/time conversions work correctly (FORMAT→TO_CHAR, etc.)
- [ ] Column name case handling is correct

**Status:** ❌ PENDING → Update to ✅ PASS when verified

### Exit Criterion 14: Transaction Atomicity
- [ ] Successful transaction commits all changes
- [ ] Failed transaction rolls back all changes
- [ ] Nested transactions (if used) work correctly
- [ ] Isolation levels behave as expected
- [ ] Deadlock handling works correctly

**Status:** ❌ PENDING → Update to ✅ PASS when verified

### Exit Criterion 15: Test Suite
- [ ] All unit tests pass with PostgreSQL
- [ ] All integration tests pass with PostgreSQL
- [ ] Performance tests (if any) pass
- [ ] Test coverage maintained
- [ ] No test degradation from SQL Server version

**Status:** ❌ PENDING → Update to ✅ PASS when verified

---

## Known Issues and Considerations

### SQL Equivalency Validation Results

Three SQL statements returned ERROR status from the SQL Equivalency tool due to UNKNOWN determination:

**Statement 2:** `uspupdateauthorpersonalinfo` function call
- **Issue:** Stored procedure to function conversion
- **Recommendation:** Extra runtime validation for parameter binding and return value
- **Testing:** Verify the function returns correct row count and updates data properly

**Statement 3:** `uspdeleteauthor` function call  
- **Issue:** Stored procedure to function conversion
- **Recommendation:** Extra runtime validation for error handling when record not found
- **Testing:** Test both success case (record exists) and failure case (record not found)

**Statement 4:** Complex date function transformations
- **Issue:** Multiple SQL Server date functions converted: FORMAT→TO_CHAR, DATEDIFF→DATE_PART+AGE, GETDATE()→CURRENT_DATE, DATEPART→DATE_PART
- **Recommendation:** Verify date calculations match SQL Server results
- **Testing:** Compare Age calculation results between SQL Server and PostgreSQL for same test data

### Column Name Case Sensitivity

PostgreSQL treats unquoted identifiers as lowercase. The conversion applied these rules:
- Column names in SELECT queries are lowercase with double quotes
- Function parameters use lowercase
- Table/schema names preserved as specified

**If you encounter "column does not exist" errors:**
1. Check the actual PostgreSQL schema column names
2. If they're mixed-case, you may need to add double quotes in queries
3. Review the converted SQL in `converted_statements.sql` and adjust as needed

---

## Troubleshooting

### Issue: Connection Fails

**Symptoms:** Application cannot connect to PostgreSQL
**Solutions:**
1. Verify PostgreSQL is running: `pg_isready -h hostname -p 5432`
2. Check firewall rules allow port 5432
3. Verify AWS Secrets Manager secret has correct credentials
4. Check `pg_hba.conf` for authentication settings
5. Enable connection logging in PostgreSQL for debugging

### Issue: Function Not Found

**Symptoms:** Error calling `uspupdateauthorpersonalinfo` or `uspdeleteauthor`
**Solutions:**
1. Verify functions were created: See Step 1.5 query
2. Check schema name is correct: `bobsbookstore_dbo`
3. Verify function signatures match call parameters
4. Grant execute permissions to application user

### Issue: Column Does Not Exist

**Symptoms:** Error "column 'ColumnName' does not exist"
**Solutions:**
1. Check actual column names in PostgreSQL: `\d bobsbookstore_dbo.author`
2. If mixed-case, add double quotes: `"ColumnName"`
3. Review schema migration to ensure column names migrated correctly

### Issue: Date Calculations Incorrect

**Symptoms:** Age calculation or date formatting returns unexpected results
**Solutions:**
1. Compare SQL Server and PostgreSQL results for same input
2. Check timezone handling (SQL Server vs PostgreSQL)
3. Verify date format strings: 'yyyy-MM-dd HH:mm:ss' vs 'YYYY-MM-DD HH24:MI:SS'
4. Review AGE() function behavior for year calculations

---

## Rollback Plan

If critical issues are discovered during runtime validation:

### Option 1: Revert to SQL Server (Temporary)
The original SQL Server code is preserved in Git history. To revert:
```bash
git log --oneline  # Find commit before migration
git checkout <commit-hash>
```

### Option 2: Parallel Deployment
Run both SQL Server and PostgreSQL versions side-by-side:
- Deploy PostgreSQL version to staging environment
- Keep SQL Server version in production
- Migrate traffic gradually after validation

---

## Success Criteria

The migration is **COMPLETE** when all 16 exit criteria are met:

- ✅ Criteria 1-11: Static code transformation (ALREADY COMPLETE)
- ⚠️ Criterion 12: Database connection verified
- ❌ Criterion 13: All database operations work
- ❌ Criterion 14: Transactions maintain atomicity
- ❌ Criterion 15: All tests pass
- ✅ Criterion 16: Final report complete (ALREADY COMPLETE)

**Current Status:** 12 of 16 criteria complete (75%)
**Remaining Work:** Runtime validation with PostgreSQL database

---

## Documentation References

### Generated Migration Artifacts
- **SQL Statement Catalog:** `sourceCode/extracted_statements.sql`
- **Converted SQL:** `sourceCode/converted_statements.sql`
- **DMS Conversion Log:** `sourceCode/dms_conversion_log.json`
- **Equivalency Report:** `sourceCode/sql_equivalency_validation_report.json`
- **PostgreSQL Functions:** `sourceCode/db/postgresql_functions.sql` (NEW)
- **This Deployment Guide:** `sourceCode/POSTGRESQL_DEPLOYMENT_GUIDE.md` (NEW)

### Code Files Modified
- `app/Bookstore.Data/Bookstore.Data.csproj` - Package references updated
- `app/Bookstore.Web/Bookstore.Web.csproj` - Package references updated
- `app/Bookstore.Web/ServicesSetup.cs` - Connection string builder updated
- `app/Bookstore.Web/Controllers/AuthorsController.cs` - SQL statements converted

---

## Contact and Support

For issues or questions during deployment:
1. Review the troubleshooting section above
2. Check the migration artifacts for detailed conversion information
3. Consult PostgreSQL documentation for database-specific issues
4. Review .NET Npgsql documentation for driver-specific issues

---

## Appendix A: SQL Statement Conversion Summary

| ID | Statement Type | Conversion Method | Equivalency Status | Notes |
|----|---------------|-------------------|-------------------|-------|
| 1  | Simple SELECT | Manual (DMS failed) | ✅ EQUIVALENT | Schema-qualified table name |
| 2  | Stored Proc Call | Manual (DMS failed) | ⚠️ ERROR (UNKNOWN) | uspupdateauthorpersonalinfo |
| 3  | Stored Proc Call | Manual (DMS failed) | ⚠️ ERROR (UNKNOWN) | uspdeleteauthor |
| 4  | Complex SELECT | Manual (DMS failed) | ⚠️ ERROR (UNKNOWN) | Multiple date function conversions |

**Key:** 
- ✅ EQUIVALENT = SQL Equivalency tool confirmed equivalence
- ⚠️ ERROR (UNKNOWN) = Tool could not determine equivalence, requires extra runtime validation

---

## Appendix B: PostgreSQL Function Signatures

### Function 1: Update Author Personal Info
```sql
bobsbookstore_dbo.uspupdateauthorpersonalinfo(
    p_businessentityid INTEGER,      -- Author ID
    p_nationalidnumber TEXT,          -- National ID
    p_birthdate TIMESTAMP,            -- Birth date
    p_maritalstatus TEXT,             -- Marital status (M/S)
    p_gender TEXT                     -- Gender (M/F)
) RETURNS INTEGER                     -- Returns rows affected
```

### Function 2: Delete Author
```sql
bobsbookstore_dbo.uspdeleteauthor(
    p_businessentityid INTEGER        -- Author ID to delete
) RETURNS INTEGER                     -- Returns rows affected
```

---

**End of Deployment Guide**
