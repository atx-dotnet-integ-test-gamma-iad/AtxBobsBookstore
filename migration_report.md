# BobsBookstore Migration Report: MS SQL Server to PostgreSQL

## 1. Migration Overview

| Item | Details |
|------|---------|
| **Application** | BobsBookstore .NET Web Application |
| **Framework** | .NET 8.0, ASP.NET Core MVC |
| **Source Database** | Microsoft SQL Server 2019 |
| **Target Database** | PostgreSQL 13 |
| **Source Database Name** | BobsBookstore |
| **Target Database Name** | postgres |
| **ORM** | Entity Framework Core 8.0 |
| **Migration Date** | 2026-03-21 |
| **DMS Migration Project ARN** | arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI |

---

## 2. SQL Statement Processing Summary

| Metric | Count |
|--------|-------|
| **Total SQL Statements Processed** | 5 |
| **DMS Tool Conversion Successes** | 0 |
| **DMS Tool Conversion Failures** | 5 |
| **Manual Conversions (DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA)** | 5 |
| **SQL Equivalency: EQUIVALENT** | 0 |
| **SQL Equivalency: NOT_EQUIVALENT** | 0 |
| **SQL Equivalency: ERROR** | 5 |

### DMS Tool Failure Reason
All 5 DMS conversion attempts failed across 3 rounds of attempts with:
```
Metadata model creation failed: No objects were found according to the specified selection rules.
Please review your selection rules and try again.
```
Manual conversion was applied using lowercase schema mapping rules per the transformation definition.

### DMS Attempt Timeline
| Round | Timestamp Range | Statements | Result |
|-------|-----------------|------------|--------|
| Attempt 1 | 2026-03-21T03:22:14 to 03:24:01 | All 5 | FAILED |
| Attempt 2 | 2026-03-21T03:50:55 to 03:52:13 | All 5 | FAILED |
| Attempt 3 | 2026-03-21T04:20:34 to 04:22:19 | All 5 | FAILED |

### SQL Equivalency Tool Error
All 5 equivalency validation attempts returned ERROR across 4 rounds:
```json
{"equivalence_status": "ERROR", "error": "'uniqueID'"}
```
This error persisted across all rounds, confirming it is a service-level issue. Equivalency status is marked as ERROR based solely on tool output - no agent judgment was applied.

### SQL Equivalency Attempt Timeline
| Round | Timestamp Range | Statements | Result |
|-------|-----------------|------------|--------|
| Attempt 1 | 2026-03-21T03:26:08 to 03:27:24 | All 5 | ERROR |
| Attempt 2 | 2026-03-21T03:38:33 to 03:38:38 | All 5 | ERROR |
| Attempt 3 | 2026-03-21T03:54:21 to 03:54:25 | All 5 | ERROR |
| Attempt 4 | 2026-03-21T04:24:27 to 04:25:07 | All 5 | ERROR |

---

## 3. Detailed Per-Statement Migration Information

### Statement 1: EditUsingStoredProcedure (Stored Procedure Call)

| Property | Value |
|----------|-------|
| **Source File** | app/Bookstore.Web/Controllers/AuthorsController.cs |
| **Method** | EditUsingStoredProcedure |
| **Line** | ~163 |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **DMS Status** | FAILED (3 attempts) |
| **Equivalency Status** | ERROR (tool service error, 4 attempts) |

**Original MS SQL:**
```sql
EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
```

**Converted PostgreSQL:**
```sql
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo($1, $2, $3, $4, $5)
```

**DMS Tool Output (Attempt 3):**
```json
{
  "conversion_timestamp": "2026-03-21T04:20:34.559505",
  "status": "error",
  "error": "Metadata model creation failed: No objects were found according to the specified selection rules.",
  "error_timestamp": "2026-03-21T04:20:49.520193"
}
```

**Equivalency Tool Output (Attempt 4):**
```json
{"equivalence_status": "ERROR", "error": "'uniqueID'", "timestamp": "2026-03-21T04:24:27.334357"}
```

**Conversion Notes:**
- `EXEC [dbo].[proc] @params` → `SELECT * FROM schema.proc($n)` (PostgreSQL function call syntax)
- Schema `[dbo]` → `bobsbookstore_dbo`
- Procedure name lowercased: `uspUpdateAuthorPersonalInfo` → `uspupdateauthorpersonalinfo`
- Named parameters (`@param`) → positional parameters (`$n`)

---

### Statement 2: FindAllAuthorsEmbeddedSql (Direct Table Query)

| Property | Value |
|----------|-------|
| **Source File** | app/Bookstore.Web/Controllers/AuthorsController.cs |
| **Method** | FindAllAuthorsEmbeddedSql |
| **Line** | ~187 |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **DMS Status** | FAILED (3 attempts) |
| **Equivalency Status** | ERROR (tool service error, 4 attempts) |

**Original MS SQL:**
```sql
SELECT * FROM [dbo].[Author]
```

**Converted PostgreSQL:**
```sql
SELECT * FROM bobsbookstore_dbo.author
```

**DMS Tool Output (Attempt 3):**
```json
{
  "conversion_timestamp": "2026-03-21T04:20:57.089384",
  "status": "error",
  "error": "Metadata model creation failed: No objects were found according to the specified selection rules.",
  "error_timestamp": "2026-03-21T04:21:11.940847"
}
```

**Equivalency Tool Output (Attempt 4):**
```json
{"equivalence_status": "ERROR", "error": "'uniqueID'", "timestamp": "2026-03-21T04:24:36.780265"}
```

**Conversion Notes:**
- Schema `[dbo]` → `bobsbookstore_dbo`
- Table name lowercased: `[Author]` → `author`

---

### Statement 3: DeleteAuthorEmbeddedSql (Stored Procedure Call)

| Property | Value |
|----------|-------|
| **Source File** | app/Bookstore.Web/Controllers/AuthorsController.cs |
| **Method** | DeleteAuthorEmbeddedSql |
| **Line** | ~207 |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **DMS Status** | FAILED (3 attempts) |
| **Equivalency Status** | ERROR (tool service error, 4 attempts) |

**Original MS SQL:**
```sql
EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID
```

**Converted PostgreSQL:**
```sql
SELECT bobsbookstore_dbo.uspdeleteauthor($1)
```

**DMS Tool Output (Attempt 3):**
```json
{
  "conversion_timestamp": "2026-03-21T04:21:19.613827",
  "status": "error",
  "error": "Metadata model creation failed: No objects were found according to the specified selection rules.",
  "error_timestamp": "2026-03-21T04:21:34.448323"
}
```

**Equivalency Tool Output (Attempt 4):**
```json
{"equivalence_status": "ERROR", "error": "'uniqueID'", "timestamp": "2026-03-21T04:24:46.446668"}
```

**Conversion Notes:**
- `EXEC [dbo].[proc] @param` → `SELECT schema.proc($n)` (PostgreSQL function call syntax)
- Schema `[dbo]` → `bobsbookstore_dbo`
- Procedure name lowercased: `uspDeleteAuthor` → `uspdeleteauthor`
- Parameter `@BusinessEntityID` → `$1` positional

---

### Statement 4: SelectAuthorsByHireYear (Complex Query with SQL Server Functions)

| Property | Value |
|----------|-------|
| **Source File** | app/Bookstore.Web/Controllers/AuthorsController.cs |
| **Method** | SelectAuthorsByHireYear |
| **Line** | ~227 |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **DMS Status** | FAILED (3 attempts) |
| **Equivalency Status** | ERROR (tool service error, 4 attempts) |

**Original MS SQL:**
```sql
SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireYear
```

**Converted PostgreSQL:**
```sql
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = $1
```

**DMS Tool Output (Attempt 3):**
```json
{
  "conversion_timestamp": "2026-03-21T04:21:42.361184",
  "status": "error",
  "error": "Metadata model creation failed: No objects were found according to the specified selection rules.",
  "error_timestamp": "2026-03-21T04:21:57.204213"
}
```

**Equivalency Tool Output (Attempt 4):**
```json
{"equivalence_status": "ERROR", "error": "'uniqueID'", "timestamp": "2026-03-21T04:24:57.930411"}
```

**Conversion Notes:**
- Schema `[dbo]` → `bobsbookstore_dbo`
- Table name lowercased: `[Author]` → `author`
- Column names lowercased: `BusinessEntityID` → `businessentityid`, `ModifiedDate` → `modifieddate`, etc.
- `CONVERT(VARCHAR, col, 120)` → `TO_CHAR(col, 'YYYY-MM-DD HH24:MI:SS')` (date format 120 = ODBC canonical)
- `DATEDIFF(YEAR, BirthDate, GETDATE())` → `EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INTEGER`
- `YEAR(HireDate)` → `EXTRACT(YEAR FROM hiredate)`
- `@HireYear` → `$1` positional parameter

---

### Statement 5: FindAllProducts (Stored Procedure Call)

| Property | Value |
|----------|-------|
| **Source File** | app/Bookstore.Web/Controllers/ProductsController.cs |
| **Method** | FindAllProducts |
| **Line** | ~34 |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **DMS Status** | FAILED (3 attempts) |
| **Equivalency Status** | ERROR (tool service error, 4 attempts) |

**Original MS SQL:**
```sql
EXEC [dbo].[uspGetProductData]
```

**Converted PostgreSQL:**
```sql
SELECT * FROM bobsbookstore_dbo.uspgetproductdata()
```

**DMS Tool Output (Attempt 3):**
```json
{
  "conversion_timestamp": "2026-03-21T04:22:05.134908",
  "status": "error",
  "error": "Metadata model creation failed: No objects were found according to the specified selection rules.",
  "error_timestamp": "2026-03-21T04:22:19.964047"
}
```

**Equivalency Tool Output (Attempt 4):**
```json
{"equivalence_status": "ERROR", "error": "'uniqueID'", "timestamp": "2026-03-21T04:25:07.335925"}
```

**Conversion Notes:**
- `EXEC [dbo].[proc]` → `SELECT * FROM schema.proc()` (PostgreSQL function call syntax)
- Schema `[dbo]` → `bobsbookstore_dbo`
- Procedure name lowercased: `uspGetProductData` → `uspgetproductdata`

---

## 4. Static Code Verification Results

### Package References

| Check | File | Expected | Status |
|-------|------|----------|--------|
| Npgsql.EntityFrameworkCore.PostgreSQL (8.0.0) | Bookstore.Data.csproj | Present | ✅ VERIFIED |
| Npgsql.EntityFrameworkCore.PostgreSQL (8.0.0) | Bookstore.Web.csproj | Present | ✅ VERIFIED |
| Microsoft.Data.SqlClient | All files | Absent | ✅ VERIFIED |
| System.Data.SqlClient | All files | Absent | ✅ VERIFIED |
| Microsoft.EntityFrameworkCore.SqlServer | All files | Absent | ✅ VERIFIED |

### Database Access Code

| Check | File | Expected | Status |
|-------|------|----------|--------|
| UseNpgsql() | ServicesSetup.cs | Present | ✅ VERIFIED |
| NpgsqlConnectionStringBuilder | ServicesSetup.cs | Present | ✅ VERIFIED |
| bobsbookstore_dbo schema mappings | ApplicationDbContext.cs | Present (12 occurrences) | ✅ VERIFIED |
| using Npgsql | AuthorsController.cs | Present | ✅ VERIFIED |
| NpgsqlParameter usage | AuthorsController.cs | Present (7 occurrences) | ✅ VERIFIED |
| using Npgsql | ProductsController.cs | Present | ✅ VERIFIED |
| SqlConnection/SqlCommand/SqlDataReader/SqlParameter | All source files | Absent | ✅ VERIFIED |

### Connection String Configuration

| Check | File | Expected | Status |
|-------|------|----------|--------|
| Host parameter | ServicesSetup.cs | Present | ✅ VERIFIED |
| Port parameter | ServicesSetup.cs | Present | ✅ VERIFIED |
| Database parameter | ServicesSetup.cs | Present | ✅ VERIFIED |
| Username parameter | ServicesSetup.cs | Present | ✅ VERIFIED |
| Password parameter | ServicesSetup.cs | Present | ✅ VERIFIED |
| dbsecretsname config | appsettings.json | Present | ✅ VERIFIED |

### ADO.NET Class Replacements

| SQL Server Class | PostgreSQL Equivalent | Files Affected | Status |
|------------------|----------------------|----------------|--------|
| `SqlConnection` | `NpgsqlConnection` (via EF Core) | ServicesSetup.cs | ✅ VERIFIED |
| `SqlCommand` | EF Core `ExecuteSqlRawAsync` / `SqlQueryRaw` | AuthorsController.cs, ProductsController.cs | ✅ VERIFIED |
| `SqlParameter` | `NpgsqlParameter` | AuthorsController.cs | ✅ VERIFIED |
| `SqlConnectionStringBuilder` | `NpgsqlConnectionStringBuilder` | ServicesSetup.cs | ✅ VERIFIED |
| `UseSqlServer()` | `UseNpgsql()` | ServicesSetup.cs | ✅ VERIFIED |

### Import Changes

| File | Old Import | New Import | Status |
|------|-----------|------------|--------|
| AuthorsController.cs | `using Microsoft.Data.SqlClient` | `using Npgsql` | ✅ VERIFIED |
| ProductsController.cs | `using Microsoft.Data.SqlClient` | `using Npgsql` | ✅ VERIFIED |
| ServicesSetup.cs | `using Microsoft.Data.SqlClient` | `using Npgsql` | ✅ VERIFIED |

### Parameter Binding Changes

| Pattern | Old (SQL Server) | New (PostgreSQL) | Status |
|---------|-------------------|------------------|--------|
| Named parameters | `@ParameterName` | `$N` (positional) | ✅ VERIFIED |
| Parameter creation | `new SqlParameter("@name", value)` | `new NpgsqlParameter("pN", value)` | ✅ VERIFIED |
| DateTime handling | Direct pass | `.ToUniversalTime()` for timestamps | ✅ VERIFIED |

---

## 5. Schema Mapping Table

### Schema Name Mapping
| SQL Server Schema | PostgreSQL Schema |
|-------------------|-------------------|
| `[dbo]` | `bobsbookstore_dbo` |

### Table Name Mappings
| SQL Server Table | PostgreSQL Table |
|------------------|------------------|
| `[dbo].[Address]` | `bobsbookstore_dbo.address` |
| `[dbo].[Book]` | `bobsbookstore_dbo.book` |
| `[dbo].[Customer]` | `bobsbookstore_dbo.customer` |
| `[dbo].[Order]` | `bobsbookstore_dbo.order` |
| `[dbo].[ShoppingCart]` | `bobsbookstore_dbo.shoppingcart` |
| `[dbo].[ShoppingCartItem]` | `bobsbookstore_dbo.shoppingcartitem` |
| `[dbo].[OrderItem]` | `bobsbookstore_dbo.orderitem` |
| `[dbo].[Offer]` | `bobsbookstore_dbo.offer` |
| `[dbo].[Author]` | `bobsbookstore_dbo.author` |
| `[dbo].[Product]` | `bobsbookstore_dbo.product` |
| `[dbo].[ReferenceData]` | `bobsbookstore_dbo.referencedata` |

### Stored Procedure to Function Mappings
| SQL Server Procedure | PostgreSQL Function |
|---------------------|---------------------|
| `[dbo].[uspUpdateAuthorPersonalInfo]` | `bobsbookstore_dbo.uspupdateauthorpersonalinfo()` |
| `[dbo].[uspDeleteAuthor]` | `bobsbookstore_dbo.uspdeleteauthor()` |
| `[dbo].[uspGetProductData]` | `bobsbookstore_dbo.uspgetproductdata()` |

### SQL Function Mappings
| SQL Server Function | PostgreSQL Equivalent |
|--------------------|----------------------|
| `CONVERT(VARCHAR, col, 120)` | `TO_CHAR(col, 'YYYY-MM-DD HH24:MI:SS')` |
| `DATEDIFF(YEAR, col1, col2)` | `EXTRACT(YEAR FROM AGE(col2, col1))::INTEGER` |
| `GETDATE()` | `NOW()` |
| `YEAR(col)` | `EXTRACT(YEAR FROM col)` |

---

## 6. Build Verification Results

| Build Run | Step | Result | Errors | Warnings |
|-----------|------|--------|--------|----------|
| 1 | Step 1 Verification | **SUCCESS** | 0 | 156 |
| 2 | Step 3 Final Build | **SUCCESS** | 0 | 156 |

All warnings are pre-existing NuGet vulnerability warnings for the Magick.NET-Q8-AnyCPU 13.3.0 package and are not related to the migration.

---

## 7. Items Requiring Manual Review

1. **DMS Tool Failures:** All 5 SQL statements failed DMS conversion across 3 rounds of attempts due to "Metadata model creation failed: No objects found." Manual conversions were applied using lowercase schema mapping rules. These should be reviewed to ensure correctness.

2. **SQL Equivalency Validation Errors:** All 5 equivalency validations returned ERROR across 4 rounds of attempts due to a 'uniqueID' service-level error. Manual review of the SQL statement pairs is recommended to verify equivalency.

3. **Stored Procedure Conversions:** The conversion of SQL Server stored procedures (`EXEC [proc]`) to PostgreSQL function calls (`SELECT * FROM func()`) assumes the stored procedures have been migrated as PostgreSQL functions in the `bobsbookstore_dbo` schema. Verify these functions exist in the target database:
   - `bobsbookstore_dbo.uspupdateauthorpersonalinfo(INT, VARCHAR, TIMESTAMP, CHAR, CHAR)`
   - `bobsbookstore_dbo.uspdeleteauthor(INT)`
   - `bobsbookstore_dbo.uspgetproductdata()`

4. **DateTime Handling:** The `.ToUniversalTime()` conversion for `birthDate` in `EditUsingStoredProcedure` method should be verified against the target database's timezone configuration.

5. **Pre-existing NuGet Warnings:** 156 warnings exist for Magick.NET-Q8-AnyCPU 13.3.0 known vulnerabilities. Consider upgrading this package in a separate maintenance task.

---

## 8. Migration Artifacts

| Artifact | Location | Description |
|----------|----------|-------------|
| `extracted_statements.sql` | Project root | Catalog of all 5 original MS SQL statements with source locations |
| `converted_statements.sql` | Project root | All 5 statement pairs (original + converted) with DMS attempt timestamps |
| `sql_equivalency_validation_report.json` | Project root | Comprehensive JSON report with all equivalency results |
| `migration_report.md` | Project root | This comprehensive migration report |

---

## 9. Files Modified During Migration

| File | Changes |
|------|---------|
| `app/Bookstore.Web/Controllers/AuthorsController.cs` | SQL statements converted, imports updated, NpgsqlParameter used |
| `app/Bookstore.Web/Controllers/ProductsController.cs` | SQL statements converted, imports updated |
| `app/Bookstore.Data/ApplicationDbContext.cs` | UseNpgsql(), schema mappings to bobsbookstore_dbo, Npgsql import, legacy timestamp behavior |
| `app/Bookstore.Web/Startup/ServicesSetup.cs` | UseNpgsql(), NpgsqlConnectionStringBuilder, Npgsql import |
| `app/Bookstore.Data/Bookstore.Data.csproj` | Package: Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0 |
| `app/Bookstore.Web/Bookstore.Web.csproj` | Package: Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0 |

---

*Report generated as part of the BobsBookstore MS SQL Server to PostgreSQL migration transformation.*
