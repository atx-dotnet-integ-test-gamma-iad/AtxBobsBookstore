# BobsBookstore Migration Report: MS SQL Server to PostgreSQL

## Migration Summary

| Metric | Value |
|--------|-------|
| **Migration Date** | 2026-03-22 |
| **Application** | BobsBookstore .NET ADO Application |
| **Source Database** | Microsoft SQL Server |
| **Target Database** | PostgreSQL |
| **Framework** | .NET 8.0 with Entity Framework Core |
| **Total SQL Statements Processed** | 5 |
| **DMS Conversion Successes** | 0 |
| **DMS Conversion Failures** | 5 |
| **Manual Conversions Applied** | 5 |
| **Equivalency Validated (EQUIVALENT)** | 0 |
| **Equivalency Validated (NOT_EQUIVALENT)** | 0 |
| **Equivalency Validation ERRORS** | 5 |
| **Build Status** | SUCCESS |

---

## 1. SQL Statement Conversion Details

### Statement 1: EditUsingStoredProcedure
- **Source File**: `app/Bookstore.Web/Controllers/AuthorsController.cs` (line 165)
- **Method**: `EditUsingStoredProcedure`
- **Original (MS SQL)**:
  ```sql
  DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
  ```
- **Converted (PostgreSQL)**:
  ```sql
  SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Error**: Metadata model creation failed - No objects found according to selection rules
- **Equivalency Status**: ERROR (tool returned `'uniqueID'` error)

### Statement 2: FindAllAuthorsEmbeddedSql
- **Source File**: `app/Bookstore.Web/Controllers/AuthorsController.cs` (line 189)
- **Method**: `FindAllAuthorsEmbeddedSql`
- **Original (MS SQL)**:
  ```sql
  SELECT * FROM bobsbookstore_dbo.author
  ```
- **Converted (PostgreSQL)**:
  ```sql
  SELECT * FROM bobsbookstore_dbo.author
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Error**: Metadata model creation failed - No objects found according to selection rules
- **Equivalency Status**: ERROR (tool returned `'uniqueID'` error)
- **Note**: Statement was already PostgreSQL-compatible with lowercase schema naming

### Statement 3: DeleteAuthorEmbeddedSql
- **Source File**: `app/Bookstore.Web/Controllers/AuthorsController.cs` (line 212)
- **Method**: `DeleteAuthorEmbeddedSql`
- **Original (MS SQL)**:
  ```sql
  DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
  ```
- **Converted (PostgreSQL)**:
  ```sql
  SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Error**: Metadata model creation failed - No objects found according to selection rules
- **Equivalency Status**: ERROR (tool returned `'uniqueID'` error)

### Statement 4: SelectAuthorsByHireYear
- **Source File**: `app/Bookstore.Web/Controllers/AuthorsController.cs` (line 232)
- **Method**: `SelectAuthorsByHireYear`
- **Original (MS SQL)**:
  ```sql
  SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate))::INTEGER AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;
  ```
- **Converted (PostgreSQL)**:
  ```sql
  SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Error**: Metadata model creation failed - No objects found according to selection rules
- **Equivalency Status**: ERROR (tool returned `'uniqueID'` error)
- **Note**: Column names lowercased for PostgreSQL compatibility

### Statement 5: FindAllProducts
- **Source File**: `app/Bookstore.Web/Controllers/ProductsController.cs` (line 36)
- **Method**: `FindAllProducts`
- **Original (MS SQL)**:
  ```sql
  EXEC [dbo].[uspGetProductData];
  ```
- **Converted (PostgreSQL)**:
  ```sql
  SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
  ```
- **Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **DMS Error**: Metadata model creation failed - No objects found according to selection rules
- **Equivalency Status**: ERROR (tool returned `'uniqueID'` error)

---

## 2. Package Reference Changes

### Bookstore.Web.csproj
| Change | Package | Version |
|--------|---------|---------|
| **Removed** | `Microsoft.EntityFrameworkCore.Sqlite` | 5.0.7 |
| **Already Present** | `Npgsql.EntityFrameworkCore.PostgreSQL` | 8.0.0 |

### Bookstore.Data.csproj
| Change | Package | Version |
|--------|---------|---------|
| **Already Present** | `Npgsql.EntityFrameworkCore.PostgreSQL` | 8.0.0 |
| **No SqlClient packages** | - | - |

### Bookstore.Domain.csproj
- No database dependencies. No changes needed.

---

## 3. Code Changes Summary

### ADO.NET Classes
| Original | Replacement | Status |
|----------|------------|--------|
| `SqlConnection` | `NpgsqlConnection` | Already migrated (not found in code) |
| `SqlCommand` | `NpgsqlCommand` | Already migrated (not found in code) |
| `SqlDataReader` | `NpgsqlDataReader` | Already migrated (not found in code) |
| `SqlParameter` | `NpgsqlParameter` | Already using NpgsqlParameter |

### Import Statements
- `using Npgsql;` present in AuthorsController.cs, ProductsController.cs, ServicesSetup.cs
- No `Microsoft.Data.SqlClient` or `System.Data.SqlClient` references found

### Connection Strings
- ServicesSetup.cs uses `NpgsqlConnectionStringBuilder` with Host, Port, Database, Username, Password
- DbContext registration uses `UseNpgsql()` 

### Entity Framework Configuration
- ApplicationDbContext uses `Npgsql.EnableLegacyTimestampBehavior`
- All entity mappings use lowercase PostgreSQL table and column naming
- Schema is `bobsbookstore_dbo` across all entities

---

## 4. Files Modified

| File | Changes |
|------|---------|
| `app/Bookstore.Web/Controllers/AuthorsController.cs` | Replaced 3 SQL statements with PostgreSQL equivalents, removed TODO comments |
| `app/Bookstore.Web/Controllers/ProductsController.cs` | Replaced 1 SQL statement with PostgreSQL equivalent, removed TODO comment |
| `app/Bookstore.Web/Bookstore.Web.csproj` | Removed `Microsoft.EntityFrameworkCore.Sqlite` package |

## 5. Artifact Files Created

| File | Purpose |
|------|---------|
| `extracted_statements.sql` | Catalog of all 5 original SQL statements |
| `converted_statements.sql` | Catalog of all 5 converted PostgreSQL statements |
| `sql_equivalency_validation_report.json` | Comprehensive equivalency validation report |
| `migration_report.md` | This final migration report |

---

## 6. DMS Tool Analysis

All 5 DMS conversion attempts failed with the same error:
> "Metadata model creation failed: {'error': 'Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}'}"

This indicates a configuration issue with the DMS migration project's metadata model. Per the transformation definition, manual conversion was applied with lowercase schema object names for PostgreSQL compatibility.

## 7. SQL Equivalency Tool Analysis

All 5 equivalency validation attempts returned ERROR with:
> `{'equivalence_status': 'ERROR', 'error': "'uniqueID'"}`

This error appears to be an internal issue with the SQL Equivalency tool. Per the transformation definition, all pairs are marked as ERROR status in the report.

---

## 8. Build Verification

**Final Build Status: SUCCESS**
- 0 Errors
- 156 Warnings (all pre-existing Magick.NET package vulnerability warnings, not related to this migration)
- All 3 projects compile successfully:
  - Bookstore.Domain.dll
  - Bookstore.Data.dll
  - Bookstore.Web.dll
