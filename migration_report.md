# BobsBookstore Migration Report: MS SQL Server to PostgreSQL

## Date: 2026-03-22

---

## 1. Summary

| Metric | Count |
|--------|-------|
| Total SQL statements processed | 5 |
| Successfully converted by DMS MCP tool | 0 |
| Requiring manual intervention after DMS failure | 5 |
| Validated as equivalent by SQL Equivalency tool | 0 |
| Validated as non-equivalent | 0 |
| With equivalency validation errors | 5 |

### DMS Tool Status
All 5 SQL statements were passed through the DMS MCP tool (`dms-mcp___statement_conversion_tool`) twice each (10 total calls). All calls failed with the same error:
```
Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
```
As per the transformation rules, manual conversion was applied using lowercase schema mapping (`DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA`).

### SQL Equivalency Tool Status
All 5 statement pairs were passed through the SQL Equivalency tool (`sql-equivalency___validate_sql_equivalence`) twice each (11 total calls, including a baseline test). All calls returned:
```json
{"equivalence_status": "ERROR", "error": "'uniqueID'"}
```
This appears to be an infrastructure/configuration issue. As per the transformation rules, all pairs are marked as ERROR.

---

## 2. Detailed Statement Catalog

### Statement 1: EditUsingStoredProcedure

- **Source File:** `app/Bookstore.Web/Controllers/AuthorsController.cs` (line 165)
- **Original MS SQL Statement:**
  ```sql
  DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
  ```
- **Converted PostgreSQL Statement:**
  ```sql
  SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
  ```
- **DMS Tool Output:** Error — Metadata model creation failed (No objects found)
- **Conversion Method:** `DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA`
- **Equivalency Status:** ERROR (tool returned `'uniqueID'` error)
- **Manual Intervention:** Converted MS SQL DECLARE/EXEC stored procedure call pattern to PostgreSQL SELECT from function pattern. Schema and function names lowercased per rules.

### Statement 2: FindAllAuthorsEmbeddedSql

- **Source File:** `app/Bookstore.Web/Controllers/AuthorsController.cs` (line 189)
- **Original MS SQL Statement:**
  ```sql
  SELECT * FROM bobsbookstore_dbo.author
  ```
- **Converted PostgreSQL Statement:**
  ```sql
  SELECT * FROM bobsbookstore_dbo.author;
  ```
- **DMS Tool Output:** Error — Metadata model creation failed (No objects found)
- **Conversion Method:** `DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA`
- **Equivalency Status:** ERROR (tool returned `'uniqueID'` error)
- **Manual Intervention:** Statement was already PostgreSQL-compatible with lowercase schema. Added trailing semicolon for consistency.

### Statement 3: DeleteAuthorEmbeddedSql

- **Source File:** `app/Bookstore.Web/Controllers/AuthorsController.cs` (line 212)
- **Original MS SQL Statement:**
  ```sql
  DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
  ```
- **Converted PostgreSQL Statement:**
  ```sql
  SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);
  ```
- **DMS Tool Output:** Error — Metadata model creation failed (No objects found)
- **Conversion Method:** `DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA`
- **Equivalency Status:** ERROR (tool returned `'uniqueID'` error)
- **Manual Intervention:** Converted MS SQL DECLARE/EXEC stored procedure call pattern to PostgreSQL SELECT from function pattern. Schema and function names lowercased per rules.

### Statement 4: SelectAuthorsByHireYear

- **Source File:** `app/Bookstore.Web/Controllers/AuthorsController.cs` (line 232)
- **Original MS SQL Statement:**
  ```sql
  SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate))::INTEGER AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;
  ```
- **Converted PostgreSQL Statement:**
  ```sql
  SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
  ```
- **DMS Tool Output:** Error — Metadata model creation failed (No objects found)
- **Conversion Method:** `DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA`
- **Equivalency Status:** ERROR (tool returned `'uniqueID'` error)
- **Manual Intervention:** Applied lowercase to column names (BusinessEntityID→businessentityid, ModifiedDate→modifieddate, BirthDate→birthdate, HireDate→hiredate) and aliases (FormattedModifiedDate→formattedmodifieddate, Age→age). SQL functions and structure preserved.

### Statement 5: FindAllProducts

- **Source File:** `app/Bookstore.Web/Controllers/ProductsController.cs` (line 36)
- **Original MS SQL Statement:**
  ```sql
  EXEC [dbo].[uspGetProductData];
  ```
- **Converted PostgreSQL Statement:**
  ```sql
  SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
  ```
- **DMS Tool Output:** Error — Metadata model creation failed (No objects found)
- **Conversion Method:** `DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA`
- **Equivalency Status:** ERROR (tool returned `'uniqueID'` error)
- **Manual Intervention:** Converted MS SQL EXEC stored procedure call to PostgreSQL SELECT from function pattern. Schema and function names lowercased per rules.

---

## 3. Package/Dependency Changes

The following Npgsql packages and components were already in place prior to this migration step (no changes needed):

| Component | Status |
|-----------|--------|
| `Npgsql.EntityFrameworkCore.PostgreSQL` in Bookstore.Data.csproj | Already present |
| `Npgsql` package reference in Bookstore.Web.csproj | Already present |
| `NpgsqlParameter` usage in controllers | Already present |
| `NpgsqlConnectionStringBuilder` in ServicesSetup.cs | Already present |
| `UseNpgsql()` in DbContext configuration | Already present |
| `using Npgsql;` import statements | Already present |

---

## 4. Configuration Changes

| File | Change |
|------|--------|
| `app/Bookstore.Web/Properties/serviceDependencies.json` | Changed `"type": "mssql"` to `"type": "postgresql"`, renamed key from `"mssql1"` to `"postgresql1"` |
| `app/Bookstore.Web/Properties/serviceDependencies.local.json` | Changed `"type": "mssql.local"` to `"type": "postgresql.local"`, renamed key from `"mssql1"` to `"postgresql1"` |
| `app/Bookstore.Web/Startup/ServicesSetup.cs` | Updated comment from "connection string for SQL Server" to "connection string for PostgreSQL" |

---

## 5. Validation

### Final Build Result
- **Command:** `dotnet build BobsBookstore.sln`
- **Result:** Build succeeded
- **Errors:** 0
- **Warnings:** 184 (all pre-existing CS8618 nullable reference type warnings, unrelated to migration)

### Remaining Issues
1. **DMS Tool Unavailable:** All DMS conversion attempts failed. Manual conversions were applied following the lowercase schema mapping rules.
2. **SQL Equivalency Tool Unavailable:** All equivalency validation attempts returned errors. Statement pairs could not be validated for equivalency through the tool.
3. **Stored Procedure Dependencies:** The converted SQL statements call PostgreSQL functions (`uspupdateauthorpersonalinfo`, `uspdeleteauthor`, `uspgetproductdata`) that must exist in the PostgreSQL database with the correct signatures for runtime functionality.

---

## 6. Transformation Artifacts

| Artifact | Location | Status |
|----------|----------|--------|
| `extracted_statements.sql` | Project root | Complete — all 5 original SQL statements |
| `converted_statements.sql` | Project root | Complete — all 5 converted SQL statements |
| `sql_equivalency_validation_report.json` | Project root | Complete — all 5 pairs with ERROR status |
| `migration_report.md` | Project root | Complete — this document |

---

## 7. Files Modified

1. `app/Bookstore.Web/Controllers/AuthorsController.cs` — 4 SQL statements replaced, 2 TODO comments removed
2. `app/Bookstore.Web/Controllers/ProductsController.cs` — 1 SQL statement replaced, 1 TODO comment removed
3. `app/Bookstore.Web/Properties/serviceDependencies.json` — Updated to PostgreSQL type
4. `app/Bookstore.Web/Properties/serviceDependencies.local.json` — Updated to PostgreSQL local type
5. `app/Bookstore.Web/Startup/ServicesSetup.cs` — Updated comment reference from SQL Server to PostgreSQL
