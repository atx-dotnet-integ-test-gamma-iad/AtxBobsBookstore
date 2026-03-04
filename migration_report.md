# Migration Report: Microsoft SQL Server to PostgreSQL
## BobsBookstore .NET Application

### Report Date: 2026-03-04

---

## 1. Executive Summary

This report documents the migration of the BobsBookstore .NET ADO application from Microsoft SQL Server to PostgreSQL. The migration involved extracting and converting all SQL statements, replacing SQL Server-specific packages with Npgsql equivalents, updating connection strings, and ensuring all entity mappings use PostgreSQL-compatible lowercase naming.

**Key Metrics:**
- Total SQL Statements: 5
- DMS Conversion Success: 0/5 (all failed - metadata model creation error, retried twice)
- Manual Conversions Applied: 5/5 (with lowercase schema naming)
- SQL Equivalency Validation: 0/5 equivalent, 0/5 non-equivalent, 5/5 errors (tool returned ERROR for all pairs, retried twice)
- Build Status: SUCCESS (0 errors, 136 pre-existing warnings)

---

## 2. SQL Statement Processing Summary

| Metric | Count |
|--------|-------|
| Total SQL Statements Processed | 5 |
| Statements Successfully Converted by DMS MCP Tool | 0 |
| Statements Requiring Manual Conversion (DMS Failed) | 5 |
| Statements Validated as Equivalent (Equivalency Tool) | 0 |
| Statements Validated as Non-Equivalent (Equivalency Tool) | 0 |
| Statements with Equivalency Validation Errors | 5 |

### DMS Tool Failure Details
All 5 DMS tool calls failed with the same error across two separate runs (10 total DMS calls):
- **Error**: `Metadata model creation failed: The selected objects were not found.`
- **Root Cause**: The DMS migration project metadata model could not locate the specified database objects.
- **DMS Parameters Used**: schema_name='dbo', database_name='BobsBookstore', migration_project_identifier='arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI', region='us-east-1'

### DMS Tool Run History
| Statement | Run 1 Timestamp | Run 1 Error | Run 2 Timestamp | Run 2 Error |
|-----------|----------------|-------------|-----------------|-------------|
| Statement 1 | 2026-03-04T01:56:11 | 2026-03-04T01:56:26 | 2026-03-04T02:20:29 | 2026-03-04T02:20:44 |
| Statement 2 | 2026-03-04T01:56:34 | 2026-03-04T01:56:49 | 2026-03-04T02:20:55 | 2026-03-04T02:21:10 |
| Statement 3 | 2026-03-04T01:56:57 | 2026-03-04T01:57:12 | 2026-03-04T02:21:17 | 2026-03-04T02:21:32 |
| Statement 4 | 2026-03-04T01:57:22 | 2026-03-04T01:57:37 | 2026-03-04T02:21:42 | 2026-03-04T02:21:56 |
| Statement 5 | 2026-03-04T01:57:45 | 2026-03-04T01:58:00 | 2026-03-04T02:22:05 | 2026-03-04T02:22:19 |

### Manual Conversion Applied
Per transformation rules, when DMS fails, manual conversion with lowercase schema object names (`DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA`) was applied:
- Schema `[dbo]` mapped to `bobsbookstore_dbo`
- `EXEC procedure` → `CALL procedure` or `SELECT * FROM function()`
- `FORMAT` → `TO_CHAR`, `DATEDIFF` → `EXTRACT/AGE`, `GETDATE` → `CURRENT_TIMESTAMP`, `DATEPART` → `EXTRACT`
- All object names converted to lowercase

---

## 3. SQL Statement Conversion Details

### Statement 1: EditUsingStoredProcedure (AuthorsController.cs)
- **Source**: `AuthorsController.cs` - `EditUsingStoredProcedure` method
- **Original MS SQL**: `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;`
- **Converted PostgreSQL**: `CALL bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);`
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Status**: FAILED (both runs) - Metadata model creation failed
- **Equivalency Status**: ERROR (tool error: 'uniqueID')
- **Equivalency Run 1 Timestamp**: 2026-03-04T02:02:02.298191
- **Equivalency Run 2 Timestamp**: 2026-03-04T02:26:14.687887

### Statement 2: FindAllAuthorsEmbeddedSql (AuthorsController.cs)
- **Source**: `AuthorsController.cs` - `FindAllAuthorsEmbeddedSql` method
- **Original MS SQL**: `SELECT * FROM [dbo].[Author]`
- **Converted PostgreSQL**: `SELECT * FROM bobsbookstore_dbo.author`
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Status**: FAILED (both runs) - Metadata model creation failed
- **Equivalency Status**: ERROR (tool error: 'uniqueID')
- **Equivalency Run 1 Timestamp**: 2026-03-04T02:02:16.664525
- **Equivalency Run 2 Timestamp**: 2026-03-04T02:26:24.558231

### Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs)
- **Source**: `AuthorsController.cs` - `DeleteAuthorEmbeddedSql` method
- **Original MS SQL**: `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;`
- **Converted PostgreSQL**: `CALL bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);`
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Status**: FAILED (both runs) - Metadata model creation failed
- **Equivalency Status**: ERROR (tool error: 'uniqueID')
- **Equivalency Run 1 Timestamp**: 2026-03-04T02:02:26.997889
- **Equivalency Run 2 Timestamp**: 2026-03-04T02:26:37.990056

### Statement 4: SelectAuthorsByHireYear (AuthorsController.cs)
- **Source**: `AuthorsController.cs` - `SelectAuthorsByHireYear` method
- **Original MS SQL**: `SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE DATEPART(YEAR, HireDate) = @HireDate;`
- **Converted PostgreSQL**: `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, birthdate))::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;`
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Status**: FAILED (both runs) - Metadata model creation failed
- **SQL Function Mappings Applied**:
  - `FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss')` → `TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS')`
  - `DATEDIFF(YEAR, BirthDate, GETDATE())` → `EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, birthdate))::INT`
  - `DATEPART(YEAR, HireDate)` → `EXTRACT(YEAR FROM hiredate)`
  - `GETDATE()` → `CURRENT_TIMESTAMP`
- **Equivalency Status**: ERROR (tool error: 'uniqueID')
- **Equivalency Run 1 Timestamp**: 2026-03-04T02:02:37.626802
- **Equivalency Run 2 Timestamp**: 2026-03-04T02:26:50.692267

### Statement 5: FindAllProducts (ProductsController.cs)
- **Source**: `ProductsController.cs` - `FindAllProducts` method
- **Original MS SQL**: `EXEC [dbo].[uspGetProductData];`
- **Converted PostgreSQL**: `SELECT * FROM bobsbookstore_dbo.uspgetproductdata();`
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Status**: FAILED (both runs) - Metadata model creation failed
- **Equivalency Status**: ERROR (tool error: 'uniqueID')
- **Equivalency Run 1 Timestamp**: 2026-03-04T02:02:47.673886
- **Equivalency Run 2 Timestamp**: 2026-03-04T02:27:00.817047

---

## 4. Files Modified

| File | Changes |
|------|---------|
| `app/Bookstore.Web/Controllers/AuthorsController.cs` | Replaced SQL Server imports with Npgsql, converted 4 SQL statements to PostgreSQL syntax, updated parameter types to NpgsqlParameter |
| `app/Bookstore.Web/Controllers/ProductsController.cs` | Replaced SQL Server imports with Npgsql, converted 1 SQL statement to PostgreSQL syntax |
| `app/Bookstore.Web/Startup/ServicesSetup.cs` | Replaced SqlConnectionStringBuilder with NpgsqlConnectionStringBuilder, updated UseNpgsql, updated imports |
| `app/Bookstore.Web/Bookstore.Web.csproj` | Replaced Microsoft.Data.SqlClient with Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0 |
| `app/Bookstore.Data/Bookstore.Data.csproj` | Replaced Microsoft.Data.SqlClient with Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0 |
| `app/Bookstore.Data/ApplicationDbContext.cs` | Updated entity mappings to use lowercase table/column names, added bobsbookstore_dbo schema, added Npgsql import, added EnableLegacyTimestampBehavior |

---

## 5. Package Dependency Status

| Original Package | Replacement Package | Version |
|-----------------|-------------------|---------|
| Microsoft.Data.SqlClient | Npgsql.EntityFrameworkCore.PostgreSQL | 8.0.0 |

Both Bookstore.Data.csproj and Bookstore.Web.csproj now reference `Npgsql.EntityFrameworkCore.PostgreSQL` version 8.0.0.

---

## 6. Connection String Status

- **Original**: SQL Server connection string using `SqlConnectionStringBuilder` with `Server`, `Database`, `User Id`, `Password`
- **Converted**: PostgreSQL connection string using `NpgsqlConnectionStringBuilder` with `Host`, `Port`, `Database`, `Username`, `Password`
- **Provider**: `UseNpgsql()` method used in `ServicesSetup.cs`
- **Secrets Management**: Database credentials retrieved from AWS Secrets Manager (unchanged)

---

## 7. Entity Framework Mapping Status

All 11 entity mappings in `ApplicationDbContext.cs` use lowercase table and column names for PostgreSQL compatibility:

| Entity | Table Name | Schema | Status |
|--------|-----------|--------|--------|
| Address | address | bobsbookstore_dbo | ✓ |
| Book | book | bobsbookstore_dbo | ✓ |
| Customer | customer | bobsbookstore_dbo | ✓ |
| Order | order | bobsbookstore_dbo | ✓ |
| ShoppingCart | shoppingcart | bobsbookstore_dbo | ✓ |
| ShoppingCartItem | shoppingcartitem | bobsbookstore_dbo | ✓ |
| OrderItem | orderitem | bobsbookstore_dbo | ✓ |
| Offer | offer | bobsbookstore_dbo | ✓ |
| Author | author | bobsbookstore_dbo | ✓ |
| Product | product | bobsbookstore_dbo | ✓ |
| ReferenceDataItem | referencedata | bobsbookstore_dbo | ✓ |

Additional PostgreSQL configuration:
- `Npgsql.EnableLegacyTimestampBehavior` set to `true` in ApplicationDbContext static constructor

---

## 8. ADO.NET Class Replacement Status

| Original Class | Replacement Class | Status |
|---------------|------------------|--------|
| SqlConnection | NpgsqlConnection | ✓ No remaining SqlConnection references |
| SqlCommand | NpgsqlCommand | ✓ No remaining SqlCommand references |
| SqlDataReader | NpgsqlDataReader | ✓ No remaining SqlDataReader references |
| SqlParameter | NpgsqlParameter | ✓ No remaining SqlParameter references |
| SqlConnectionStringBuilder | NpgsqlConnectionStringBuilder | ✓ No remaining SqlConnectionStringBuilder references |
| Microsoft.Data.SqlClient | Npgsql | ✓ No remaining Microsoft.Data.SqlClient imports |
| System.Data.SqlClient | Npgsql | ✓ No remaining System.Data.SqlClient imports |

---

## 9. Build Status

- **Build Command**: `dotnet build BobsBookstore.sln`
- **Build Result**: SUCCESS
- **Errors**: 0
- **Warnings**: 136 (all pre-existing, unrelated to migration)

---

## 10. Transformation Artifacts

| Artifact | Location | Description |
|----------|----------|-------------|
| extracted_statements.sql | sourceCode/ | Catalog of all 5 original MS SQL statements with source locations |
| converted_statements.sql | sourceCode/ | Catalog of all 5 converted PostgreSQL statements with DMS failure documentation (2 runs) |
| sql_equivalency_validation_report.json | sourceCode/ | JSON report with all 5 statement pairs and equivalency validation results (2 runs) |
| migration_report.md | sourceCode/ | This comprehensive migration report |

---

## 11. Statements Requiring Manual Review

All 5 statements require manual review due to:
1. **DMS Tool Failure**: All statements failed DMS conversion (across 2 runs, 10 total calls) with "Metadata model creation failed: The selected objects were not found."
2. **Equivalency Tool Error**: All statement pairs returned ERROR status from the SQL Equivalency tool (across 2 runs, 10 total calls) with error "'uniqueID'".

**Manual review should verify:**
- Stored procedure CALL syntax is correct for PostgreSQL
- SQL function mappings (FORMAT→TO_CHAR, DATEDIFF→EXTRACT/AGE, DATEPART→EXTRACT, GETDATE→CURRENT_TIMESTAMP) produce equivalent results
- Schema object names are correctly mapped to lowercase PostgreSQL equivalents
- Parameter binding syntax is compatible with Npgsql
- The `bobsbookstore_dbo` schema exists in the target PostgreSQL database
- All stored procedures/functions (uspupdateauthorpersonalinfo, uspdeleteauthor, uspgetproductdata) exist in the target PostgreSQL database

---

## 12. Migration Completion Checklist

| Criterion | Status |
|-----------|--------|
| All SQL Server packages replaced with PostgreSQL equivalents | ✓ |
| All ADO.NET classes replaced with Npgsql equivalents | ✓ |
| All SQL statements processed through DMS MCP tool | ✓ (5/5, all failed in 2 runs) |
| Complete SQL statement catalog exists | ✓ |
| All statement pairs validated through SQL Equivalency tool | ✓ (5/5, all returned ERROR in 2 runs) |
| Comprehensive equivalency report generated | ✓ |
| DMS failures documented with manual conversion | ✓ |
| Connection strings updated for PostgreSQL | ✓ |
| Transaction handling updated for PostgreSQL | ✓ |
| Application compiles without errors | ✓ |
| Entity mappings use lowercase naming | ✓ |
| Npgsql.EnableLegacyTimestampBehavior configured | ✓ |
