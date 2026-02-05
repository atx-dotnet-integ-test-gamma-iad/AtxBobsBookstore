# PostgreSQL Migration Deployment Guide
## Bob's Bookstore - Database Functions Installation

### Overview
This guide provides step-by-step instructions for completing the PostgreSQL migration by creating the required database functions. The code migration is complete; this document addresses the database-side requirements.

---

## Prerequisites

1. **PostgreSQL Database Instance** (version 12 or higher recommended)
2. **Database Connection Access** with privileges to:
   - Create functions in the `bobsbookstore_dbo` schema
   - Grant execute permissions
3. **Database Schema** (`bobsbookstore_dbo`) must exist and contain:
   - `author` table
   - `product` table

---

## Migration Status Summary

### ✅ Completed (Code-Level)
- All SQL Server packages replaced with Npgsql
- All ADO.NET classes converted (SqlConnection → NpgsqlConnection, etc.)
- All SQL statements converted to PostgreSQL syntax
- Application compiles without errors
- Connection strings configured for PostgreSQL

### ⚠️ Pending (Database-Level)
- Creation of 3 PostgreSQL functions to replace SQL Server stored procedures
- Runtime testing of database operations
- End-to-end application testing with PostgreSQL

---

## Required PostgreSQL Functions

The following three functions must be created in your PostgreSQL database:

### 1. **uspupdateauthorpersonalinfo**
- **Purpose**: Updates author personal information
- **Parameters**: 
  - businessentityid (INTEGER)
  - nationalidnumber (VARCHAR)
  - birthdate (TIMESTAMP)
  - maritalstatus (CHAR)
  - gender (CHAR)
- **Returns**: INTEGER (rows affected)
- **Used by**: `AuthorsController.EditUsingStoredProcedure()`

### 2. **uspdeleteauthor**
- **Purpose**: Deletes an author record
- **Parameters**:
  - businessentityid (INTEGER)
- **Returns**: INTEGER (rows affected)
- **Used by**: `AuthorsController.DeleteAuthorEmbeddedSql()`

### 3. **uspgetproductdata**
- **Purpose**: Retrieves all product data
- **Parameters**: None
- **Returns**: TABLE (productid, name, productnumber, safetystocklevel)
- **Used by**: `ProductsController.FindAllProducts()`

---

## Installation Instructions

### Step 1: Connect to PostgreSQL Database

```bash
# Using psql command line
psql -h your-hostname -U your-username -d your-database-name

# Or use your preferred PostgreSQL client (pgAdmin, DBeaver, etc.)
```

### Step 2: Verify Schema Exists

```sql
-- Check if schema exists
SELECT schema_name 
FROM information_schema.schemata 
WHERE schema_name = 'bobsbookstore_dbo';

-- If schema doesn't exist, create it
CREATE SCHEMA IF NOT EXISTS bobsbookstore_dbo;
```

### Step 3: Execute Function Creation Script

```bash
# From command line
psql -h your-hostname -U your-username -d your-database-name -f db/postgresql_functions.sql

# Or copy/paste the contents of postgresql_functions.sql into your PostgreSQL client
```

The script is located at:
```
sourceCode/db/postgresql_functions.sql
```

### Step 4: Verify Function Creation

```sql
-- List all functions in the schema
SELECT routine_name, routine_type
FROM information_schema.routines
WHERE routine_schema = 'bobsbookstore_dbo'
AND routine_type = 'FUNCTION';

-- Expected results:
-- uspupdateauthorpersonalinfo | FUNCTION
-- uspdeleteauthor              | FUNCTION
-- uspgetproductdata            | FUNCTION
```

### Step 5: Test Functions

```sql
-- Test uspgetproductdata (should return product data)
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- Test uspupdateauthorpersonalinfo (use actual author ID from your data)
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(
    1,                                    -- businessentityid
    '123456789',                          -- nationalidnumber
    '1980-01-01'::TIMESTAMP,             -- birthdate
    'M',                                  -- maritalstatus
    'M'                                   -- gender
);

-- Verify the author table to see if update worked
SELECT * FROM bobsbookstore_dbo.author WHERE businessentityid = 1;
```

### Step 6: Grant Permissions

```sql
-- Replace 'your_application_user' with your actual database user
GRANT EXECUTE ON FUNCTION bobsbookstore_dbo.uspupdateauthorpersonalinfo TO your_application_user;
GRANT EXECUTE ON FUNCTION bobsbookstore_dbo.uspdeleteauthor TO your_application_user;
GRANT EXECUTE ON FUNCTION bobsbookstore_dbo.uspgetproductdata TO your_application_user;
```

---

## Connection String Configuration

Ensure your application's connection string is configured for PostgreSQL:

```
Host=your-hostname;Database=your-database-name;Username=your-username;Password=your-password
```

Configuration location:
- `appsettings.json` or environment variables
- Entity Framework Core configuration in `ApplicationDbContext.cs`

---

## Validation Testing

After deploying the functions, perform these tests:

### 1. **Application Build Test**
```bash
cd sourceCode
dotnet build BobsBookstore.sln
# Should complete with 0 errors
```

### 2. **Database Connection Test**
- Start the application
- Navigate to `/Authors` endpoint
- Should successfully retrieve author list (tests uspgetproductdata pattern)

### 3. **CRUD Operations Test**
- **Read**: Navigate to Authors list → Should display authors
- **Update**: Edit an author → Should successfully update via uspupdateauthorpersonalinfo
- **Delete**: Delete an author → Should successfully delete via uspdeleteauthor
- **Create**: Add new author → Should successfully insert via EF Core

### 4. **Products Test**
- Navigate to `/Products` endpoint
- Should successfully retrieve products via uspgetproductdata function

---

## Troubleshooting

### Issue: Functions not found
**Symptom**: Application throws "function does not exist" error

**Solution**:
1. Verify schema name matches: `bobsbookstore_dbo`
2. Check function names are lowercase: `uspupdateauthorpersonalinfo` (not `uspUpdateAuthorPersonalInfo`)
3. Verify search_path includes your schema:
   ```sql
   SHOW search_path;
   SET search_path TO bobsbookstore_dbo, public;
   ```

### Issue: Parameter type mismatch
**Symptom**: "function does not exist" with hint about argument types

**Solution**:
1. Check parameter types in function definition match C# code expectations
2. Verify date/time parameters are using TIMESTAMP (not DATE)
3. Check VARCHAR lengths match or are sufficient

### Issue: Permission denied
**Symptom**: "permission denied for function" error

**Solution**:
1. Execute GRANT statements (see Step 6)
2. Verify application connection string uses correct username
3. Check user has USAGE privilege on schema:
   ```sql
   GRANT USAGE ON SCHEMA bobsbookstore_dbo TO your_application_user;
   ```

### Issue: Date/time format errors
**Symptom**: Invalid timestamp or date format errors

**Solution**:
1. Code converts DateTime to UTC: `birthDate.ToUniversalTime()`
2. Verify PostgreSQL timezone settings: `SHOW timezone;`
3. Check `Npgsql.EnableLegacyTimestampBehavior` setting in ApplicationDbContext.cs

---

## Known Limitations & Considerations

### SQL Equivalency Validation Results
- **Statement 1 (uspupdateauthorpersonalinfo)**: Equivalency tool returned UNKNOWN
  - **Reason**: Complex stored procedure logic with DECLARE/EXEC pattern
  - **Status**: Manual conversion applied, function created
  - **Action**: Runtime testing recommended

- **Statement 3 (uspdeleteauthor)**: Equivalency tool returned UNKNOWN
  - **Reason**: Complex stored procedure with error handling
  - **Status**: Manual conversion applied, function created
  - **Action**: Runtime testing recommended

- **Statement 4 (SelectAuthorsByHireYear)**: Equivalency tool returned UNKNOWN
  - **Reason**: Complex date function conversions (FORMAT→TO_CHAR, DATEDIFF→AGE)
  - **Status**: Manual conversion applied, embedded in code
  - **Action**: Test with actual data to verify date calculations match expectations

- **Statement 5 (uspgetproductdata)**: Equivalency tool returned UNKNOWN
  - **Reason**: Cursor-based stored procedure converted to table-returning function
  - **Status**: Manual conversion applied, function created
  - **Action**: Runtime testing recommended

### Behavioral Differences: SQL Server vs PostgreSQL

1. **Case Sensitivity**:
   - SQL Server: Case-insensitive by default
   - PostgreSQL: Case-sensitive for unquoted identifiers
   - **Impact**: All identifiers converted to lowercase in PostgreSQL functions

2. **Error Handling**:
   - SQL Server: TRY/CATCH blocks
   - PostgreSQL: EXCEPTION blocks
   - **Impact**: Error handling converted to PostgreSQL syntax in functions

3. **Date Functions**:
   - SQL Server: FORMAT(), DATEDIFF(), GETDATE(), DATEPART()
   - PostgreSQL: TO_CHAR(), AGE(), CURRENT_TIMESTAMP, EXTRACT()
   - **Impact**: Date calculations may have minor behavioral differences
   - **Recommendation**: Verify date calculations with actual data

4. **Cursors**:
   - SQL Server: OUTPUT cursor parameters
   - PostgreSQL: RETURNS TABLE pattern
   - **Impact**: uspgetproductdata converted from cursor to table-returning function
   - **Note**: Application code already uses `SqlQueryRaw<Product>()` which is compatible

---

## Post-Deployment Validation Checklist

- [ ] All 3 functions created in PostgreSQL database
- [ ] Function permissions granted to application user
- [ ] Application successfully connects to PostgreSQL
- [ ] Authors list page loads successfully
- [ ] Author edit operation works (tests uspupdateauthorpersonalinfo)
- [ ] Author delete operation works (tests uspdeleteauthor)
- [ ] Products list page loads successfully (tests uspgetproductdata)
- [ ] Date formatting displays correctly in UI
- [ ] Age calculations are accurate
- [ ] Transaction rollback behavior tested
- [ ] Error handling tested (e.g., delete non-existent author)

---

## Additional Resources

### Files Created During Migration
- `extracted_statements.sql` - Original SQL Server statements
- `converted_statements.sql` - Converted PostgreSQL statements
- `manual_conversion_required.log` - DMS conversion attempts and manual conversions
- `migration_changes.log` - All code changes made during migration
- `sql_equivalency_validation_report.json` - Equivalency validation results
- `final_migration_report.md` - Comprehensive migration report
- `postgresql_functions.sql` - **THIS FILE** - PostgreSQL function definitions

### Documentation Locations
- Transformation artifacts: `sourceCode/` directory
- Database scripts: `sourceCode/db/` directory
- Application code: `sourceCode/app/` directory

---

## Support & Next Steps

### If Functions Work Correctly
- Update validation status to PASS for Criterion 13
- Proceed with end-to-end application testing
- Consider adding integration tests for database operations

### If Issues Arise
1. Review error messages carefully
2. Check PostgreSQL logs: `pg_log` directory or `SELECT * FROM pg_stat_activity;`
3. Verify table structures match expected schema
4. Test functions individually using SQL before testing through application
5. Review manual_conversion_required.log for conversion reasoning

### Recommended: Create Integration Tests
The solution currently has no test projects. Consider adding:
- Unit tests for controller methods
- Integration tests for database operations
- End-to-end tests for critical workflows

---

## Summary

**Code migration**: ✅ 100% Complete
**Database functions**: ⚠️ Awaiting deployment
**Overall migration**: 🟡 14/16 exit criteria passed (87.5%)

Once the PostgreSQL functions are deployed and tested, the migration will be complete with all 16 exit criteria satisfied (or 15/15 for applicable criteria, as no tests exist in the codebase).
