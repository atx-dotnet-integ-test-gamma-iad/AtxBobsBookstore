# Migration Report: MS SQL Server to PostgreSQL

## Executive Summary
This report documents the migration of the BobsBookstore .NET ADO application from Microsoft SQL Server to PostgreSQL. The migration involved extracting, converting, and re-integrating 5 SQL statements, replacing all SQL Server ADO.NET classes with Npgsql equivalents, and updating all configuration to target PostgreSQL.

## SQL Statement Migration Statistics

| Metric | Count |
|--------|-------|
| Total SQL statements processed | 5 |
| Statements in AuthorsController.cs | 4 |
| Statements in ProductsController.cs | 1 |
| Successfully converted by DMS MCP tool | 0 |
| Requiring manual intervention (DMS failure) | 5 |
| Validated as equivalent (SQL Equivalency tool) | 0 |
| Validated as non-equivalent (SQL Equivalency tool) | 0 |
| With equivalency validation errors | 5 |

## DMS MCP Tool Results

All 5 SQL statements were passed to the DMS MCP tool (`dms-mcp___statement_conversion_tool`) with the following configuration:
- **migration_project_identifier**: `arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI`
- **database_name**: `BobsBookstore`
- **schema_name**: `dbo`
- **region**: `us-east-1`
- **server_name**: `172.31.93.178`

**Result**: All 5 statements failed with error:
```
Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
```

**Action Taken**: Manual conversion applied with lowercase schema object names per transformation definition guidelines (`DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA`).

## SQL Equivalency Validation Results

All 5 statement pairs were validated using the SQL Equivalency MCP tool (`sql-equivalency___validate_sql_equivalence`).

**Result**: All 5 validations returned `ERROR` status with error `'uniqueID'` (tool infrastructure error). No agent judgment was used - all statuses come exclusively from the SQL Equivalency tool output.

## Detailed Statement Conversion Log

### Statement 1: FindAllAuthorsEmbeddedSql
- **Source File**: `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method**: `FindAllAuthorsEmbeddedSql()`
- **Line**: ~187
- **Original MS SQL**: `SELECT * FROM dbo.Author`
- **Converted PostgreSQL**: `SELECT * FROM bobsbookstore_dbo.author`
- **DMS Status**: FAILED (Metadata model creation failed)
- **DMS Timestamp**: 2026-03-05T00:48:34.279626
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status**: ERROR (tool returned `'uniqueID'` error)
- **Equivalency Timestamp**: 2026-03-05T00:50:44.209281

### Statement 2: EditUsingStoredProcedure
- **Source File**: `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method**: `EditUsingStoredProcedure()`
- **Line**: ~163
- **Original MS SQL**: `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;`
- **Converted PostgreSQL**: `SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);`
- **DMS Status**: FAILED (Metadata model creation failed)
- **DMS Timestamp**: 2026-03-05T00:48:57.570223
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status**: ERROR (tool returned `'uniqueID'` error)
- **Equivalency Timestamp**: 2026-03-05T00:50:58.094503

### Statement 3: DeleteAuthorEmbeddedSql
- **Source File**: `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method**: `DeleteAuthorEmbeddedSql()`
- **Line**: ~208
- **Original MS SQL**: `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;`
- **Converted PostgreSQL**: `SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);`
- **DMS Status**: FAILED (Metadata model creation failed)
- **DMS Timestamp**: 2026-03-05T00:49:19.935347
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status**: ERROR (tool returned `'uniqueID'` error)
- **Equivalency Timestamp**: 2026-03-05T00:51:09.563456

### Statement 4: SelectAuthorsByHireYear
- **Source File**: `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method**: `SelectAuthorsByHireYear()`
- **Line**: ~228
- **Original MS SQL**: `SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;`
- **Converted PostgreSQL**: `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;`
- **DMS Status**: FAILED (Metadata model creation failed)
- **DMS Timestamp**: 2026-03-05T00:49:43.754048
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status**: ERROR (tool returned `'uniqueID'` error)
- **Equivalency Timestamp**: 2026-03-05T00:51:21.070800
- **Conversion Notes**: FORMAT → TO_CHAR, DATEDIFF → EXTRACT/AGE, GETDATE() → CURRENT_DATE, DATEPART → EXTRACT, all column/table names lowercased, schema changed from dbo to bobsbookstore_dbo

### Statement 5: FindAllProducts
- **Source File**: `app/Bookstore.Web/Controllers/ProductsController.cs`
- **Method**: `FindAllProducts()`
- **Line**: ~34
- **Original MS SQL**: `EXEC [dbo].[uspGetProductData];`
- **Converted PostgreSQL**: `SELECT * FROM bobsbookstore_dbo.uspgetproductdata();`
- **DMS Status**: FAILED (Metadata model creation failed)
- **DMS Timestamp**: 2026-03-05T00:50:09.733710
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status**: ERROR (tool returned `'uniqueID'` error)
- **Equivalency Timestamp**: 2026-03-05T00:51:30.885700

## ADO.NET Class Replacements

| Original (SQL Server) | Replacement (PostgreSQL) | Count | Status |
|------------------------|--------------------------|-------|--------|
| SqlParameter | NpgsqlParameter | 7 | Complete |
| SqlConnection | NpgsqlConnection | 0 | N/A (EF Core used) |
| SqlCommand | NpgsqlCommand | 0 | N/A (EF Core used) |
| SqlDataReader | NpgsqlDataReader | 0 | N/A (EF Core used) |
| using System.Data.SqlClient | using Npgsql | 2 | Complete |

**NpgsqlParameter Instances (7 total)**:
- `EditUsingStoredProcedure()`: 5 parameters (@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender)
- `DeleteAuthorEmbeddedSql()`: 1 parameter (@BusinessEntityID)
- `SelectAuthorsByHireYear()`: 1 parameter (@HireDate)

## Package Reference Status

| Project | Package | Version | Status |
|---------|---------|---------|--------|
| Bookstore.Data | Npgsql.EntityFrameworkCore.PostgreSQL | 8.0.0 | Present (PASS) |
| Bookstore.Web | Npgsql.EntityFrameworkCore.PostgreSQL | 8.0.0 | Present (PASS) |
| Bookstore.Data | Microsoft.Data.SqlClient | - | Absent (PASS) |
| Bookstore.Web | Microsoft.Data.SqlClient | - | Absent (PASS) |
| Bookstore.Domain | (no DB packages) | - | Clean (PASS) |

## Connection String Status

| Component | Configuration | Status |
|-----------|---------------|--------|
| ServicesSetup.cs | `UseNpgsql()` | PostgreSQL (PASS) |
| ServicesSetup.cs | `NpgsqlConnectionStringBuilder` | PostgreSQL (PASS) |
| appsettings.json | Via AWS Secrets Manager | PostgreSQL compatible (PASS) |
| ApplicationDbContext.cs | `Npgsql.EnableLegacyTimestampBehavior = true` | PostgreSQL (PASS) |

## EF Core Entity Configuration

All entities are mapped to the `bobsbookstore_dbo` schema with lowercase column names:
- Address, Book, Customer, Order, ShoppingCart, ShoppingCartItem, OrderItem, Offer, Author, Product, ReferenceDataItem

## Build Verification

| Build # | Command | Result |
|---------|---------|--------|
| Step 3 | `dotnet build BobsBookstore.sln` | SUCCESS (0 errors, 136 warnings) |
| Step 4 | `dotnet build BobsBookstore.sln` | SUCCESS (0 errors, 136 warnings) |
| Step 5 (Final) | `dotnet build BobsBookstore.sln` | SUCCESS (0 errors, 136 warnings) |

All warnings are pre-existing CS8618 nullable property warnings and CS0618 obsolete API warnings. None are related to the migration.

## Transformation Artifacts

| Artifact | Location | Contents |
|----------|----------|----------|
| extracted_statements.sql | Project root | All 5 original MS SQL Server statements with source documentation |
| converted_statements.sql | Project root | All 5 converted PostgreSQL statements with DMS status and conversion method |
| sql_equivalency_validation_report.json | Project root | Complete equivalency validation report for all 5 statement pairs |
| migration_report.md | Project root | This comprehensive migration report |

## Statements Requiring Manual Review

All 5 statements require manual review due to:
1. **DMS Conversion Failure**: All statements failed DMS conversion (metadata model creation error)
2. **Equivalency Validation Error**: All statement pairs returned ERROR from the SQL Equivalency tool (infrastructure error, not a logic issue)

The manual conversions follow standard MS SQL Server to PostgreSQL conversion patterns and the lowercase schema naming convention required by the transformation definition.
