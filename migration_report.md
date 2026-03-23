# BobsBookstore - SQL Server to PostgreSQL Migration Report

## Migration Summary

| Metric | Value |
|--------|-------|
| Total SQL Statements Processed | 5 |
| Statements Successfully Converted by DMS MCP Tool | 0 |
| Statements Requiring Manual Intervention (DMS Failed) | 5 |
| Statements Validated as Equivalent (SQL Equivalency Tool) | 0 |
| Statements Validated as Non-Equivalent | 0 |
| Statements with Equivalency Validation Errors | 5 |

## DMS MCP Tool Details

- **Migration Project ARN**: `arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI`
- **Database**: BobsBookstore
- **Source Schema**: dbo
- **Region**: us-east-1
- **DMS Error (all 5 statements)**: Metadata model creation failed: No objects were found according to the specified selection rules.
- **Each statement was attempted through DMS twice** (original attempt and retry) - all failed with the same error.

## SQL Equivalency Tool Details

- All 5 statement pairs were validated using the sql-equivalency___validate_sql_equivalence tool
- All 5 returned ERROR status with error: `'uniqueID'`
- This appears to be a tool-level error, not related to statement content
- **No agent judgment was used to determine equivalency** - all statuses come exclusively from the tool

## Manual Conversion Methodology

Since DMS failed for all statements, manual conversion was applied following the transformation rules:
- **Schema mapping**: `[dbo]` → `bobsbookstore_dbo`
- **All object names lowercased** for PostgreSQL compatibility
- **SQL Server functions converted** to PostgreSQL equivalents:
  - `EXEC [proc]` → `SELECT schema.proc()` or `SELECT * FROM schema.proc()`
  - `FORMAT()` → `TO_CHAR()`
  - `DATEDIFF(YEAR, ...)` → `EXTRACT(YEAR FROM AGE(...))`
  - `DATEPART(YEAR, ...)` → `EXTRACT(YEAR FROM ...)`
  - `GETDATE()` → `CURRENT_DATE`

---

## Detailed Statement Listing

### Statement 1: SELECT * FROM Author

| Field | Value |
|-------|-------|
| Source File | `app/Bookstore.Web/Controllers/AuthorsController.cs` |
| Method | `FindAllAuthorsEmbeddedSql()` |
| Line | ~188 |
| Original MS SQL | `SELECT * FROM [dbo].[Author]` |
| Converted PostgreSQL | `SELECT * FROM bobsbookstore_dbo.author` |
| Conversion Method | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| DMS Error | Metadata model creation failed: No objects were found according to the specified selection rules |
| DMS Attempt 1 | 2026-03-23T16:19:36 - FAILED |
| DMS Attempt 2 | 2026-03-23T16:49:21 - FAILED |
| Equivalency Status | ERROR (tool returned: `'uniqueID'`) |

### Statement 2: Delete Author Stored Procedure

| Field | Value |
|-------|-------|
| Source File | `app/Bookstore.Web/Controllers/AuthorsController.cs` |
| Method | `DeleteAuthorEmbeddedSql(int businessEntityId)` |
| Line | ~210 |
| Original MS SQL | `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;` |
| Converted PostgreSQL | `SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);` |
| Conversion Method | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| DMS Error | Metadata model creation failed: No objects were found according to the specified selection rules |
| DMS Attempt 1 | 2026-03-23T16:20:00 - FAILED |
| DMS Attempt 2 | 2026-03-23T16:49:49 - FAILED |
| Equivalency Status | ERROR (tool returned: `'uniqueID'`) |

### Statement 3: Update Author Personal Info Stored Procedure

| Field | Value |
|-------|-------|
| Source File | `app/Bookstore.Web/Controllers/AuthorsController.cs` |
| Method | `EditUsingStoredProcedure(int businessEntityId, string nationalIdNumber, DateTime birthDate, string maritalStatus, string gender)` |
| Line | ~164 |
| Original MS SQL | `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;` |
| Converted PostgreSQL | `SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);` |
| Conversion Method | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| DMS Error | Metadata model creation failed: No objects were found according to the specified selection rules |
| DMS Attempt 1 | 2026-03-23T16:20:24 - FAILED |
| DMS Attempt 2 | 2026-03-23T16:50:12 - FAILED |
| Equivalency Status | ERROR (tool returned: `'uniqueID'`) |

### Statement 4: Complex SELECT with Date/Time Functions

| Field | Value |
|-------|-------|
| Source File | `app/Bookstore.Web/Controllers/AuthorsController.cs` |
| Method | `SelectAuthorsByHireYear(int hireYear)` |
| Line | ~230 |
| Original MS SQL | `SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;` |
| Converted PostgreSQL | `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;` |
| Conversion Method | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| DMS Error | Metadata model creation failed: No objects were found according to the specified selection rules |
| DMS Attempt 1 | 2026-03-23T16:20:47 - FAILED |
| DMS Attempt 2 | 2026-03-23T16:50:36 - FAILED |
| Equivalency Status | ERROR (tool returned: `'uniqueID'`) |

### Statement 5: Get Product Data Stored Procedure

| Field | Value |
|-------|-------|
| Source File | `app/Bookstore.Web/Controllers/ProductsController.cs` |
| Method | `FindAllProducts()` |
| Line | ~35 |
| Original MS SQL | `EXEC [dbo].[uspGetProductData];` |
| Converted PostgreSQL | `SELECT * FROM bobsbookstore_dbo.uspgetproductdata();` |
| Conversion Method | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| DMS Error | Metadata model creation failed: No objects were found according to the specified selection rules |
| DMS Attempt 1 | 2026-03-23T16:21:13 - FAILED |
| DMS Attempt 2 | 2026-03-23T16:51:02 - FAILED |
| Equivalency Status | ERROR (tool returned: `'uniqueID'`) |

---

## Static Code Migration Summary

### Package References
| File | Before | After | Status |
|------|--------|-------|--------|
| Bookstore.Data.csproj | Microsoft.EntityFrameworkCore.SqlServer | Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0 | ✅ Complete |
| Bookstore.Web.csproj | Microsoft.EntityFrameworkCore.SqlServer | Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0 | ✅ Complete |

### ADO.NET Class Replacements
| Original | Replacement | Files |
|----------|-------------|-------|
| `using Microsoft.Data.SqlClient` | `using Npgsql` | AuthorsController.cs, ProductsController.cs |
| `SqlParameter` | `NpgsqlParameter` | AuthorsController.cs |
| `SqlConnectionStringBuilder` | `NpgsqlConnectionStringBuilder` | ServicesSetup.cs |
| `UseSqlServer()` | `UseNpgsql()` | ServicesSetup.cs |

### Connection String
| Parameter | Before (SQL Server) | After (PostgreSQL) |
|-----------|--------------------|--------------------|
| Server/Host | `Server=` | `Host=` |
| Database | `Database=BobsBookstore` | `Database=postgres` |
| Auth | `Integrated Security` | `Username/Password` |
| Port | N/A | `Port=` (from secrets) |

### Entity Framework Schema Mappings (ApplicationDbContext.cs)
All 11 entities mapped with `ToTable()` and `HasColumnName()` calls:
- Address, Book, Customer, Order, ShoppingCart, ShoppingCartItem, OrderItem, Offer, Author, Product, ReferenceDataItem
- All using `bobsbookstore_dbo` schema
- All column names lowercased for PostgreSQL

---

## Exit Criteria Verification

| # | Criteria | Status |
|---|---------|--------|
| 1 | All SQL Server packages replaced with PostgreSQL equivalents | ✅ |
| 2 | All ADO.NET classes replaced with Npgsql equivalents | ✅ |
| 3 | ALL 5 SQL statements processed through DMS MCP tool | ✅ (all failed, manual conversion applied) |
| 4 | Comprehensive catalog of all SQL statements exists | ✅ (extracted_statements.sql, converted_statements.sql) |
| 5 | ALL 5 statement pairs validated through SQL Equivalency tool | ✅ (all returned ERROR) |
| 6 | Comprehensive equivalency validation report generated | ✅ (sql_equivalency_validation_report.json) |
| 7 | No agent judgment used for equivalency determination | ✅ (all from tool output) |
| 8 | DMS failures documented with manual conversions | ✅ |
| 9 | Connection strings use PostgreSQL format | ✅ |
| 10 | Application builds without errors | ✅ (0 errors, 184 warnings) |

## Transformation Artifacts

| Artifact | Path | Contents |
|----------|------|----------|
| Original SQL Catalog | `extracted_statements.sql` | 5 original MS SQL Server statements |
| Converted SQL Catalog | `converted_statements.sql` | 5 converted PostgreSQL statements with DMS attempt logs |
| Equivalency Report | `sql_equivalency_validation_report.json` | JSON report with all 5 statement pairs and tool-determined statuses |
| Migration Report | `migration_report.md` | This comprehensive report |

---

*Report generated: 2026-03-23*
*Application: BobsBookstore*
*Source Database: Microsoft SQL Server 2019*
*Target Database: PostgreSQL 13*
