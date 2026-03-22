# Migration Log - BobsBookstore SQL Server to PostgreSQL

## Date: 2026-03-22
## Migration Project ARN: arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI

---

## 1. Summary Statistics

| Metric | Count |
|--------|-------|
| Total SQL statements processed | 5 |
| Successfully converted by DMS MCP tool | 0 |
| Requiring manual intervention (DMS failure) | 5 |
| Validated as equivalent by SQL Equivalency tool | 0 |
| Validated as non-equivalent | 0 |
| With equivalency validation errors | 5 |

---

## 2. DMS Tool Conversion Results

### DMS Failure Details

All 5 statements were passed to the DMS MCP tool (`dms-mcp___statement_conversion_tool`) with `schema_name='dbo'`. All 5 failed with the same error:

```
Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
```

**DMS Conversion Timestamps:**
- Statement 1: 2026-03-22T16:01:04.288453 → Error at 2026-03-22T16:01:18.931474
- Statement 2: 2026-03-22T16:01:26.821061 → Error at 2026-03-22T16:01:41.611451
- Statement 3: 2026-03-22T16:01:49.480420 → Error at 2026-03-22T16:02:04.129094
- Statement 4: 2026-03-22T16:02:12.404603 → Error at 2026-03-22T16:02:27.014265
- Statement 5: 2026-03-22T16:02:35.152651 → Error at 2026-03-22T16:02:49.782075

**Root Cause**: The DMS migration project metadata model could not find objects matching the specified selection rules for schema 'dbo'. This indicates the source database schema objects may not be accessible through the migration project at the time of conversion.

**Action Taken**: Applied manual conversion with lowercase schema mapping (DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA) for all 5 statements per transformation definition rules.

---

## 3. Manual Conversion Rules Applied

Since DMS failed for all statements, the following manual conversion rules were applied:
- `[dbo]` schema → `bobsbookstore_dbo`
- All schema object names → lowercase
- MS SQL EXEC/DECLARE patterns → PostgreSQL SELECT function() patterns
- MS SQL date functions → PostgreSQL equivalents:
  - `CONVERT(VARCHAR, col, 120)` → `TO_CHAR(col, 'YYYY-MM-DD HH24:MI:SS')`
  - `DATEDIFF(YEAR, col, GETDATE())` → `EXTRACT(YEAR FROM AGE(CURRENT_DATE, col))::INTEGER`
  - `YEAR(col)` → `EXTRACT(YEAR FROM col)`
  - `GETDATE()` → `CURRENT_DATE`

---

## 4. Detailed Statement Listing

### Statement 1: EditUsingStoredProcedure
- **Source File**: app/Bookstore.Web/Controllers/AuthorsController.cs
- **Method**: EditUsingStoredProcedure
- **Line**: 163

**Original MS SQL:**
```sql
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
```

**Converted PostgreSQL:**
```sql
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
```

**Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
**DMS Status**: FAILED - Metadata model creation error
**DMS Failure Reason**: Metadata model creation failed: No objects found for selection rules

**Conversion Notes:**
- MS SQL `DECLARE @var INT; EXEC @var = proc; SELECT @var;` pattern → PostgreSQL `SELECT function()` pattern
- Schema `[dbo]` → `bobsbookstore_dbo`
- Procedure name → lowercase (`uspupdateauthorpersonalinfo`)

---

### Statement 2: FindAllAuthorsEmbeddedSql
- **Source File**: app/Bookstore.Web/Controllers/AuthorsController.cs
- **Method**: FindAllAuthorsEmbeddedSql
- **Line**: 187

**Original MS SQL:**
```sql
SELECT * FROM [dbo].[author]
```

**Converted PostgreSQL:**
```sql
SELECT * FROM bobsbookstore_dbo.author
```

**Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
**DMS Status**: FAILED - Metadata model creation error
**DMS Failure Reason**: Metadata model creation failed: No objects found for selection rules

**Conversion Notes:**
- Schema `[dbo]` → `bobsbookstore_dbo`
- Table name already lowercase

---

### Statement 3: DeleteAuthorEmbeddedSql
- **Source File**: app/Bookstore.Web/Controllers/AuthorsController.cs
- **Method**: DeleteAuthorEmbeddedSql
- **Line**: 208

**Original MS SQL:**
```sql
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
```

**Converted PostgreSQL:**
```sql
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);
```

**Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
**DMS Status**: FAILED - Metadata model creation error
**DMS Failure Reason**: Metadata model creation failed: No objects found for selection rules

**Conversion Notes:**
- Same DECLARE/EXEC pattern as Statement 1
- Schema `[dbo]` → `bobsbookstore_dbo`
- Procedure name → lowercase (`uspdeleteauthor`)

---

### Statement 4: SelectAuthorsByHireYear
- **Source File**: app/Bookstore.Web/Controllers/AuthorsController.cs
- **Method**: SelectAuthorsByHireYear
- **Line**: 228

**Original MS SQL:**
```sql
SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[author] WHERE YEAR(HireDate) = @HireDate;
```

**Converted PostgreSQL:**
```sql
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
```

**Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
**DMS Status**: FAILED - Metadata model creation error
**DMS Failure Reason**: Metadata model creation failed: No objects found for selection rules

**Conversion Notes:**
- `CONVERT(VARCHAR, col, 120)` → `TO_CHAR(col, 'YYYY-MM-DD HH24:MI:SS')` (ODBC canonical date format)
- `DATEDIFF(YEAR, col, GETDATE())` → `EXTRACT(YEAR FROM AGE(CURRENT_DATE, col))::INTEGER`
- `YEAR(col)` → `EXTRACT(YEAR FROM col)`
- All column names → lowercase for PostgreSQL compatibility
- All alias names → lowercase
- Schema `[dbo]` → `bobsbookstore_dbo`

---

### Statement 5: FindAllProducts
- **Source File**: app/Bookstore.Web/Controllers/ProductsController.cs
- **Method**: FindAllProducts
- **Line**: 34

**Original MS SQL:**
```sql
EXEC [dbo].[uspGetProductData];
```

**Converted PostgreSQL:**
```sql
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
```

**Conversion Method**: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
**DMS Status**: FAILED - Metadata model creation error
**DMS Failure Reason**: Metadata model creation failed: No objects found for selection rules

**Conversion Notes:**
- MS SQL `EXEC proc` → PostgreSQL `SELECT * FROM function()`
- Schema `[dbo]` → `bobsbookstore_dbo`
- Procedure name → lowercase (`uspgetproductdata`)

---

## 5. Re-Integration Status

## SQL Equivalency Validation Results

All 5 statement pairs were independently validated using the SQL Equivalency tool (`sql-equivalency___validate_sql_equivalence`). All returned ERROR status.

**Common Error**: `{ "equivalence_status": "ERROR", "error": "'uniqueID'" }`

**Validation Timestamps:**
- Pair 1 (uspUpdateAuthorPersonalInfo): 2026-03-22T16:06:43.926955 → ERROR
- Pair 2 (SELECT * FROM author): 2026-03-22T16:06:53.824420 → ERROR
- Pair 3 (uspDeleteAuthor): 2026-03-22T16:07:04.094917 → ERROR
- Pair 4 (SELECT with date functions): 2026-03-22T16:07:16.976466 → ERROR
- Pair 5 (uspGetProductData): 2026-03-22T16:07:26.351174 → ERROR

Per transformation definition: Equivalency errors are recorded as-is from tool output. Agent judgment is NEVER used to determine equivalency status. Each pair was validated independently - errors in one pair do not affect others.

---



All 5 converted SQL statements have been re-integrated into the source files:

| Statement | File | Method | Status |
|-----------|------|--------|--------|
| 1 | AuthorsController.cs | EditUsingStoredProcedure | ✅ Integrated |
| 2 | AuthorsController.cs | FindAllAuthorsEmbeddedSql | ✅ Integrated |
| 3 | AuthorsController.cs | DeleteAuthorEmbeddedSql | ✅ Integrated |
| 4 | AuthorsController.cs | SelectAuthorsByHireYear | ✅ Integrated |
| 5 | ProductsController.cs | FindAllProducts | ✅ Integrated |

---

## 6. Artifacts

## Final Validation Checklist (Step 3)

| # | Validation Item | Status | Details |
|---|----------------|--------|---------|
| 1 | Bookstore.Data.csproj has Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0 | ✅ | Confirmed |
| 2 | Bookstore.Data.csproj has NO Microsoft.Data.SqlClient or System.Data.SqlClient | ✅ | No matches found |
| 3 | Bookstore.Web.csproj has Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0 | ✅ | Confirmed |
| 4 | Bookstore.Web.csproj has NO SQL Server packages | ✅ | No matches found |
| 5 | Bookstore.Domain.csproj has no SQL Server dependencies | ✅ | No matches found |
| 6 | AuthorsController.cs uses `using Npgsql;` and NpgsqlParameter | ✅ | Line 10, Lines 166-170, 211, 231 |
| 7 | ProductsController.cs uses `using Npgsql;` | ✅ | Line 10 |
| 8 | ServicesSetup.cs uses NpgsqlConnectionStringBuilder and UseNpgsql() | ✅ | Lines 15, 35, 92 |
| 9 | No SqlConnection/SqlCommand/SqlDataReader/SqlParameter/SqlTransaction in ANY .cs file | ✅ | grep returned 0 matches |
| 10 | ServicesSetup.cs uses Host, Port, Database, Username, Password | ✅ | Lines 94-98 |
| 11 | No SQL Server connection patterns (Server=, Integrated Security=) in codebase | ✅ | grep returned 0 matches |
| 12 | ApplicationDbContext.cs has Npgsql.EnableLegacyTimestampBehavior switch | ✅ | Line 19 |
| 13 | All 11 entities have .ToTable("tablename", "bobsbookstore_dbo") | ✅ | Lines 72-220 |
| 14 | 104 properties have .HasColumnName("lowercase") mappings | ✅ | 104 occurrences |
| 15 | All 5 SQL statements processed through DMS MCP tool | ✅ | All 5 attempted, all 5 failed |
| 16 | All 5 SQL statement pairs validated through SQL Equivalency tool | ✅ | All 5 validated, all 5 returned ERROR |
| 17 | Comprehensive equivalency report generated | ✅ | sql_equivalency_validation_report.json |
| 18 | Final build successful | ✅ | 0 Errors |

---



| Artifact | Location | Content |
|----------|----------|---------|
| extracted_statements.sql | sourceCode/extracted_statements.sql | All 5 original MS SQL statements with source locations |
| converted_statements.sql | sourceCode/converted_statements.sql | All 5 converted PostgreSQL statements |
| sql_equivalency_validation_report.json | sourceCode/sql_equivalency_validation_report.json | Complete JSON report with all 5 statement pairs and ERROR statuses |
| migration_log.md | sourceCode/migration_log.md | This comprehensive migration log |
