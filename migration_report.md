# SQL Server to PostgreSQL Migration Report

## Migration Summary

| Metric | Count |
|--------|-------|
| Total SQL statements processed | 5 |
| Statements converted by DMS MCP tool | 0 |
| Statements requiring manual conversion (DMS failure) | 5 |
| Statements validated as equivalent | 0 |
| Statements validated as non-equivalent | 0 |
| Statements with equivalency validation errors | 5 |

## DMS Tool Conversion Results

All 5 SQL statements were passed through the DMS MCP tool (`dms-mcp___statement_conversion_tool`) with `schema_name='dbo'`. All 5 failed with the same error:

**Error:** `Metadata model creation failed: No objects were found according to the specified selection rules. Please review your selection rules and try again.`

Since DMS failed for all statements, manual conversion was applied with lowercase schema object names per the transformation definition (reason: `DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA`).

## SQL Statement Conversions

### Statement 1: FindAllAuthorsEmbeddedSql
- **File:** `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method:** `FindAllAuthorsEmbeddedSql()`
- **Original (MS SQL):** `SELECT * FROM Author`
- **Converted (PostgreSQL):** `SELECT * FROM author`
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA

### Statement 2: EditUsingStoredProcedure
- **File:** `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method:** `EditUsingStoredProcedure()`
- **Original (MS SQL):** `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;`
- **Converted (PostgreSQL):** `CALL uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);`
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA

### Statement 3: DeleteAuthorEmbeddedSql
- **File:** `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method:** `DeleteAuthorEmbeddedSql()`
- **Original (MS SQL):** `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;`
- **Converted (PostgreSQL):** `CALL uspdeleteauthor(@BusinessEntityID);`
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA

### Statement 4: SelectAuthorsByHireYear
- **File:** `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method:** `SelectAuthorsByHireYear()`
- **Original (MS SQL):** `SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;`
- **Converted (PostgreSQL):** `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;`
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Notes:** SQL Server functions converted: FORMAT→TO_CHAR, DATEDIFF→EXTRACT/AGE, GETDATE→NOW, DATEPART→EXTRACT

### Statement 5: FindAllProducts
- **File:** `app/Bookstore.Web/Controllers/ProductsController.cs`
- **Method:** `FindAllProducts()`
- **Original (MS SQL):** `EXEC [dbo].[uspGetProductData];`
- **Converted (PostgreSQL):** `SELECT * FROM uspgetproductdata();`
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA

## SQL Equivalency Validation Results

All 5 statement pairs were validated through the SQL Equivalency MCP tool (`sql-equivalency___validate_sql_equivalence`). All returned ERROR status with error `'uniqueID'`.

See `sql_equivalency_validation_report.json` for detailed results.

## Static Code Changes

### ADO.NET Class Replacements
- `SqlParameter` → `NpgsqlParameter` (7 instances in AuthorsController.cs)
- `UseSqlServer` → `UseNpgsql` (1 instance in ServicesSetup.cs)
- `SqlConnectionStringBuilder` → `NpgsqlConnectionStringBuilder` (1 instance in ServicesSetup.cs)

### Connection String Format Update
- **Before (SQL Server):** `Server={host},{port}; Initial Catalog=BobsUsedBookStore;MultipleActiveResultSets=true; Integrated Security=false;TrustServerCertificate=True`
- **After (PostgreSQL):** `Host={host};Port={port};Database=BobsUsedBookStore;`
- `UserID` property → `Username` property on connection string builder

### Package Reference Updates
| File | Package | Action |
|------|---------|--------|
| Bookstore.Data.csproj | Microsoft.EntityFrameworkCore.SqlServer 6.0.6 | Removed |
| Bookstore.Web.csproj | Microsoft.EntityFrameworkCore.SqlServer 8.0.10 | Removed |
| Bookstore.Web.csproj | Microsoft.EntityFrameworkCore.Sqlite 5.0.7 | Removed |
| Both .csproj files | Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0 | Already present (kept) |

### Import Updates
- `using Npgsql;` was already present in all files that needed it (AuthorsController.cs, ProductsController.cs, ServicesSetup.cs)

## Files Modified
1. `app/Bookstore.Web/Controllers/AuthorsController.cs` - SQL statements, SqlParameter→NpgsqlParameter
2. `app/Bookstore.Web/Controllers/ProductsController.cs` - SQL statement
3. `app/Bookstore.Web/Startup/ServicesSetup.cs` - UseSqlServer→UseNpgsql, connection string, builder
4. `app/Bookstore.Data/Bookstore.Data.csproj` - Removed SqlServer package
5. `app/Bookstore.Web/Bookstore.Web.csproj` - Removed SqlServer and Sqlite packages

## Artifacts Generated
1. `extracted_statements.sql` - All 5 original MS SQL statements
2. `converted_statements.sql` - All 5 converted PostgreSQL statements
3. `sql_equivalency_validation_report.json` - Complete equivalency validation report
4. `migration_report.md` - This report

## Build Status
**Final build: SUCCESS** - 0 errors, warnings only (pre-existing Magick.NET vulnerability warnings and ISystemClock deprecation warnings)
