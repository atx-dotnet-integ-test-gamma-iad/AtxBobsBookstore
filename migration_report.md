# SQL Server to PostgreSQL Migration Report

## BobsBookstore .NET Application

**Migration Date:** 2026-03-21  
**Source Database:** Microsoft SQL Server  
**Target Database:** PostgreSQL  

---

## Executive Summary

This report documents the migration of the BobsBookstore .NET ADO application from Microsoft SQL Server to PostgreSQL. The migration involved extracting, converting, and re-integrating SQL statements, replacing SQL Server ADO.NET classes with Npgsql equivalents, and verifying the complete removal of all SQL Server dependencies.

---

## SQL Statement Processing Summary

| Metric | Count |
|--------|-------|
| Total SQL statements processed | 5 |
| Successfully converted by DMS tool | 0 |
| Requiring manual intervention (DMS failure) | 5 |
| Validated as equivalent (SQL Equivalency tool) | 0 |
| Validated as non-equivalent | 0 |
| Equivalency validation errors | 5 |

### DMS Tool Results
All 5 SQL statements were passed through the DMS MCP tool (`dms-mcp___statement_conversion_tool`) with the following parameters:
- `schema_name`: dbo
- `database_name`: BobsBookstore
- `migration_project_identifier`: arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI

All 5 conversions failed with the same error:
> "Metadata model creation failed: No objects were found according to the specified selection rules. Please review your selection rules and try again."

Manual conversion was applied using lowercase schema object names per the `DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA` procedure.

### SQL Equivalency Tool Results
All 5 statement pairs were validated through the SQL Equivalency MCP tool (`sql-equivalency___validate_sql_equivalence`). All returned ERROR status with `'uniqueID'` error, indicating a tool-level issue rather than statement-level incompatibility.

---

## Detailed Statement Listing

### Statement 1: EditUsingStoredProcedure
- **Source File:** `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method:** `EditUsingStoredProcedure`
- **Line:** ~163
- **Original SQL (MS SQL):**
  ```sql
  DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
  ```
- **Converted SQL (PostgreSQL):**
  ```sql
  SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
  ```
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status:** ERROR (tool returned `'uniqueID'` error)
- **Re-integration Status:** ✅ Integrated into source code

### Statement 2: FindAllAuthorsEmbeddedSql
- **Source File:** `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method:** `FindAllAuthorsEmbeddedSql`
- **Line:** ~187
- **Original SQL (MS SQL):**
  ```sql
  SELECT * FROM [dbo].[Author]
  ```
- **Converted SQL (PostgreSQL):**
  ```sql
  SELECT * FROM bobsbookstore_dbo.author
  ```
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status:** ERROR (tool returned `'uniqueID'` error)
- **Re-integration Status:** ✅ Integrated into source code

### Statement 3: DeleteAuthorEmbeddedSql
- **Source File:** `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method:** `DeleteAuthorEmbeddedSql`
- **Line:** ~208
- **Original SQL (MS SQL):**
  ```sql
  DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
  ```
- **Converted SQL (PostgreSQL):**
  ```sql
  SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);
  ```
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status:** ERROR (tool returned `'uniqueID'` error)
- **Re-integration Status:** ✅ Integrated into source code

### Statement 4: SelectAuthorsByHireYear
- **Source File:** `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method:** `SelectAuthorsByHireYear`
- **Line:** ~228
- **Original SQL (MS SQL):**
  ```sql
  SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate;
  ```
- **Converted SQL (PostgreSQL):**
  ```sql
  SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
  ```
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status:** ERROR (tool returned `'uniqueID'` error)
- **Re-integration Status:** ✅ Integrated into source code

### Statement 5: FindAllProducts
- **Source File:** `app/Bookstore.Web/Controllers/ProductsController.cs`
- **Method:** `FindAllProducts`
- **Line:** ~34
- **Original SQL (MS SQL):**
  ```sql
  EXEC [dbo].[uspGetProductData];
  ```
- **Converted SQL (PostgreSQL):**
  ```sql
  SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
  ```
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status:** ERROR (tool returned `'uniqueID'` error)
- **Re-integration Status:** ✅ Integrated into source code

---

## Code Changes Summary

### Files Modified
| File | Changes |
|------|---------|
| `app/Bookstore.Web/Controllers/AuthorsController.cs` | 4 SQL statements converted to PostgreSQL; SqlParameter → NpgsqlParameter; using Npgsql added |
| `app/Bookstore.Web/Controllers/ProductsController.cs` | 1 SQL statement converted to PostgreSQL; using Npgsql added |
| `app/Bookstore.Web/Startup/ServicesSetup.cs` | SqlConnectionStringBuilder → NpgsqlConnectionStringBuilder; UseNpgsql() for DbContext |
| `app/Bookstore.Web/Bookstore.Web.csproj` | Microsoft.Data.SqlClient removed; Npgsql.EntityFrameworkCore.PostgreSQL added |
| `app/Bookstore.Data/Bookstore.Data.csproj` | Package references updated for PostgreSQL |
| `app/Bookstore.Data/ApplicationDbContext.cs` | Table mappings updated to use bobsbookstore_dbo schema |
| `app/Bookstore.Domain/*.cs` | Entity annotations updated with PostgreSQL table/column mappings |
| `app/Bookstore.Web/appsettings.json` | Connection string updated for PostgreSQL |

### SqlParameter to NpgsqlParameter Replacements
- **File:** `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Total Replacements:** 7
  - `EditUsingStoredProcedure` method: 5 `SqlParameter` → `NpgsqlParameter`
  - `DeleteAuthorEmbeddedSql` method: 1 `SqlParameter` → `NpgsqlParameter`
  - `SelectAuthorsByHireYear` method: 1 `SqlParameter` → `NpgsqlParameter`

### SQL Statement Changes
- **AuthorsController.cs:** 2 stored procedure calls converted from DECLARE/EXEC/SELECT pattern to PostgreSQL function call pattern; 1 complex SELECT with date functions converted; 1 simple SELECT updated with schema
- **ProductsController.cs:** 1 EXEC stored procedure converted to PostgreSQL function call

---

## Verification Checklist

| Check | Status |
|-------|--------|
| No SQL Server packages in .csproj files | ✅ PASS |
| No SqlParameter references in .cs files | ✅ PASS |
| No SqlConnection references in .cs files | ✅ PASS |
| No SqlCommand references in .cs files | ✅ PASS |
| No SqlDataReader references in .cs files | ✅ PASS |
| No SqlTransaction references in .cs files | ✅ PASS |
| UseNpgsql in DbContext configuration | ✅ PASS |
| NpgsqlConnectionStringBuilder in ServicesSetup | ✅ PASS |
| EF Core table mappings use bobsbookstore_dbo schema | ✅ PASS |
| Solution builds with zero errors | ✅ PASS |
| extracted_statements.sql contains all 5 statements | ✅ PASS |
| converted_statements.sql contains all 5 statements | ✅ PASS |
| sql_equivalency_validation_report.json is complete | ✅ PASS (5 statements) |
| All 5 statements processed through DMS MCP tool | ✅ PASS (all attempted, all failed) |
| All 5 statement pairs validated through SQL Equivalency tool | ✅ PASS (all attempted, all returned ERROR) |

---

## Migration Artifacts

| Artifact | Location | Description |
|----------|----------|-------------|
| extracted_statements.sql | Project root | All 5 original MS SQL Server statements |
| converted_statements.sql | Project root | All 5 converted PostgreSQL statements |
| sql_equivalency_validation_report.json | Project root | Complete equivalency validation report |
| migration_report.md | Project root | This report |

---

## Notes

1. The DMS tool failed for all 5 statements due to metadata model creation issues ("No objects were found according to the specified selection rules"). Manual conversion was applied following the `DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA` procedure.
2. The SQL Equivalency tool returned ERROR for all 5 statement pairs with a `'uniqueID'` error, which appears to be a tool-level issue rather than a statement incompatibility.
3. All SQL Server specific packages (Microsoft.Data.SqlClient, System.Data.SqlClient) have been removed from the project.
4. The Npgsql packages are present in the project configuration.
5. Connection strings are configured for PostgreSQL using NpgsqlConnectionStringBuilder.
6. All domain entities have been updated with PostgreSQL-compatible table/column annotations using the `bobsbookstore_dbo` schema.
