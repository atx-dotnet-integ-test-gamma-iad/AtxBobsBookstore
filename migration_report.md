# Migration Report: MS SQL Server to PostgreSQL

## Summary

This report documents the migration of the BobsBookstore .NET ADO application from Microsoft SQL Server to PostgreSQL. The migration covers all embedded SQL statements in the application code, package references, connection configuration, and ADO.NET class replacements.

## SQL Statement Processing

### Overview

| Metric | Count |
|--------|-------|
| Total SQL statements processed | 5 |
| Successfully converted by DMS MCP tool | 0 |
| Manual conversion required (DMS failure) | 5 |
| Validated as equivalent (by SQL Equivalency tool) | 0 |
| Validated as non-equivalent (by SQL Equivalency tool) | 0 |
| Equivalency validation errors | 5 |

### Embedded SQL Statements (Application Code)

| # | Source File | Method | Original MS SQL Statement | Converted PostgreSQL Statement | Conversion Method | Equivalency Status |
|---|-----------|--------|--------------------------|-------------------------------|-------------------|-------------------|
| 1 | AuthorsController.cs (line ~188) | FindAllAuthorsEmbeddedSql | `SELECT * FROM [dbo].[Author];` | `SELECT * FROM bobsbookstore_dbo.author;` | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA | ERROR |
| 2 | AuthorsController.cs (line ~164) | EditUsingStoredProcedure | `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;` | `SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);` | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA | ERROR |
| 3 | AuthorsController.cs (line ~210) | DeleteAuthorEmbeddedSql | `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;` | `SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);` | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA | ERROR |
| 4 | AuthorsController.cs (line ~230) | SelectAuthorsByHireYear | `SELECT BusinessEntityID, CONVERT(VARCHAR(19), ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate;` | `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;` | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA | ERROR |
| 5 | ProductsController.cs (line ~35) | FindAllProducts | `EXEC [dbo].[uspGetProductData];` | `SELECT * FROM bobsbookstore_dbo.uspgetproductdata();` | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA | ERROR |

### DMS Tool Failure Details

All 5 statements were attempted through the DMS MCP tool (dms-mcp___statement_conversion_tool) with:
- `migration_project_identifier`: `arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI`
- `database_name`: `BobsBookstore`
- `schema_name`: `dbo`

All failed with the same error:
```
Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': 
{'message': 'No objects were found according to the specified selection rules. Please review your 
selection rules and try again.'}}"}
```

DMS Attempt Timestamps:
- Statement 1: 2026-03-22T00:23:48.603291 (error: 2026-03-22T00:24:03.546900)
- Statement 2: 2026-03-22T00:24:12.032435 (error: 2026-03-22T00:24:26.863378)
- Statement 3: 2026-03-22T00:24:34.479600 (error: 2026-03-22T00:24:49.337125)
- Statement 4: 2026-03-22T00:24:57.718677 (error: 2026-03-22T00:25:13.087831)
- Statement 5: 2026-03-22T00:25:21.183447 (error: 2026-03-22T00:25:36.182940)

All statements were then manually converted applying lowercase schema object names per the `DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA` protocol.

### SQL Equivalency Validation Details

All 5 statement pairs were validated through the SQL Equivalency MCP tool (sql-equivalency___validate_sql_equivalence). All returned:
```json
{"equivalence_status": "ERROR", "error": "'uniqueID'"}
```

Validation Timestamps:
- Statement 1: 2026-03-22T00:25:53.773252
- Statement 2: 2026-03-22T00:26:03.257818
- Statement 3: 2026-03-22T00:26:14.067096
- Statement 4: 2026-03-22T00:26:24.988630
- Statement 5: 2026-03-22T00:26:34.319320

**CRITICAL NOTE**: Equivalency status is reported EXACTLY as returned by the tool. No agent judgment was used to determine equivalency.

### Manual Conversion Rules Applied

Since DMS failed for all statements, the following lowercase schema mapping rules were applied:

1. **Schema Mapping**: `[dbo]` → `bobsbookstore_dbo`
2. **Table Names**: PascalCase → lowercase (e.g., `[Author]` → `author`)
3. **Column Names**: PascalCase → lowercase (e.g., `BusinessEntityID` → `businessentityid`)
4. **Function Names**: PascalCase → lowercase (e.g., `[uspUpdateAuthorPersonalInfo]` → `uspupdateauthorpersonalinfo`)
5. **SQL Server Functions → PostgreSQL Functions**:
   - `CONVERT(VARCHAR(19), col, 120)` → `TO_CHAR(col, 'YYYY-MM-DD HH24:MI:SS')`
   - `DATEDIFF(YEAR, date1, GETDATE())` → `EXTRACT(YEAR FROM AGE(CURRENT_DATE, date1))::INTEGER`
   - `YEAR(col)` → `EXTRACT(YEAR FROM col)`
6. **Stored Procedure Calls**: `EXEC [dbo].[proc] params` → `SELECT schema.proc(params)`

## Dependency Status

### Package References (Already PostgreSQL-Compatible)

| Project | Package | Version | Status |
|---------|---------|---------|--------|
| Bookstore.Data | Npgsql.EntityFrameworkCore.PostgreSQL | 8.0.0 | ✅ Already Npgsql |
| Bookstore.Web | Npgsql.EntityFrameworkCore.PostgreSQL | 8.0.0 | ✅ Already Npgsql |
| Bookstore.Domain | (no database packages) | N/A | ✅ Clean |

### SQL Server Package Scan Results

| Package | Found? |
|---------|--------|
| Microsoft.Data.SqlClient | ❌ NOT FOUND ✅ |
| System.Data.SqlClient | ❌ NOT FOUND ✅ |
| Microsoft.EntityFrameworkCore.SqlServer | ❌ NOT FOUND ✅ |

### Using Statements (Already PostgreSQL-Compatible)

| File | Import | Status |
|------|--------|--------|
| AuthorsController.cs | `using Npgsql;` | ✅ |
| ProductsController.cs | `using Npgsql;` | ✅ |
| ServicesSetup.cs | `using Npgsql;` + `using Npgsql.EntityFrameworkCore.PostgreSQL;` | ✅ |
| ApplicationDbContext.cs | `using Npgsql.EntityFrameworkCore.PostgreSQL;` | ✅ |

### ADO.NET / EF Core Classes (Already PostgreSQL-Compatible)

| Old (SQL Server) | New (PostgreSQL) | Status |
|-------------------|-----------------|--------|
| SqlConnection | NpgsqlConnection | ✅ Not present / Already migrated |
| SqlCommand | NpgsqlCommand | ✅ Not present / Already migrated |
| SqlDataReader | NpgsqlDataReader | ✅ Not present / Already migrated |
| SqlParameter | NpgsqlParameter | ✅ Already using NpgsqlParameter (7 usages) |
| SqlConnectionStringBuilder | NpgsqlConnectionStringBuilder | ✅ Already using Npgsql |
| UseSqlServer | UseNpgsql | ✅ Already using UseNpgsql |

## Connection String Configuration

The connection string is built using `NpgsqlConnectionStringBuilder` in `ServicesSetup.cs` with PostgreSQL parameters:
- `Host` (PostgreSQL host)
- `Port` (PostgreSQL port)
- `Database` (database name: "postgres")
- `Username` (database username)
- `Password` (database password)

Credentials are securely retrieved from AWS Secrets Manager. No hardcoded connection strings exist.

## Database Context Configuration

`ApplicationDbContext.cs` is fully configured for PostgreSQL:
- `Npgsql.EnableLegacyTimestampBehavior` switch is set to `true`
- All 11 entity mappings use lowercase table/column names in the `bobsbookstore_dbo` schema
- `UseNpgsql()` is used for the DbContext configuration

## Changed Files

### Application Code Files
| File | Changes |
|------|---------|
| `app/Bookstore.Web/Controllers/AuthorsController.cs` | 4 SQL statements in PostgreSQL syntax, uses NpgsqlParameter, imports Npgsql |
| `app/Bookstore.Web/Controllers/ProductsController.cs` | 1 SQL statement in PostgreSQL syntax, imports Npgsql |
| `app/Bookstore.Web/Startup/ServicesSetup.cs` | Uses UseNpgsql(), NpgsqlConnectionStringBuilder, imports Npgsql |
| `app/Bookstore.Data/ApplicationDbContext.cs` | PostgreSQL entity mappings with lowercase names, imports Npgsql |

### Configuration Files
| File | Changes |
|------|---------|
| `app/Bookstore.Web/appsettings.json` | DB credentials from Secrets Manager, no SQL Server connection strings |

### Artifact Files
| File | Description |
|------|-------------|
| `extracted_statements.sql` | Catalog of all 5 original MS SQL statements with source references |
| `converted_statements.sql` | Catalog of all 5 converted PostgreSQL statements with DMS error details |
| `sql_equivalency_validation_report.json` | JSON report with all 5 statement pairs and tool-provided equivalency results |
| `migration_report.md` | This comprehensive migration report |

## SQL Server References Audit

After migration, a comprehensive search for SQL Server references was performed:
- `Microsoft.Data.SqlClient`: **NONE found** ✅
- `System.Data.SqlClient`: **NONE found** ✅
- `SqlConnection`: **NONE found** ✅
- `SqlCommand`: **NONE found** ✅
- `SqlDataReader`: **NONE found** ✅
- `SqlParameter`: **NONE found** (only NpgsqlParameter) ✅
- `UseSqlServer`: **NONE found** ✅
- `SqlConnectionStringBuilder`: **NONE found** ✅
- `Microsoft.EntityFrameworkCore.SqlServer`: **NONE found** ✅
- `Server=` connection string pattern: **NONE found** ✅
- `Integrated Security`: **NONE found** ✅

## Items Requiring Manual Review

1. **SQL Equivalency Validation**: All 5 statement pairs returned ERROR status from the equivalency tool with "'uniqueID'" error. Manual review is recommended to confirm functional equivalency.
2. **DMS Tool Access**: DMS tool returned "Metadata model creation failed: No objects were found" for all statements. If DMS access is restored with proper schema objects, re-running conversion is recommended to validate manual conversions.
3. **Stored Procedure Functions**: The following PostgreSQL functions need to exist in the `bobsbookstore_dbo` schema for the application to work:
   - `bobsbookstore_dbo.uspupdateauthorpersonalinfo()`
   - `bobsbookstore_dbo.uspdeleteauthor()`
   - `bobsbookstore_dbo.uspgetproductdata()`

## Build Status

**Final build result: ✅ SUCCESS (0 errors)**
