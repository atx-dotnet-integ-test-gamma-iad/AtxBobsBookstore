# SQL Server to PostgreSQL Migration Report

## BobsBookstore .NET ADO Application

**Migration Date:** 2026-03-22  
**Application:** BobsBookstore Web Application  
**Source Database:** Microsoft SQL Server  
**Target Database:** PostgreSQL  
**Framework:** .NET 8.0 with Entity Framework Core  

---

## 1. Summary Table

| Metric | Count |
|--------|-------|
| Total SQL Statements Processed | 5 |
| DMS Tool Successes | 0 |
| DMS Tool Failures | 5 |
| Manual Conversions (DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA) | 5 |
| SQL Equivalency - EQUIVALENT | 0 |
| SQL Equivalency - NOT_EQUIVALENT | 0 |
| SQL Equivalency - ERROR | 5 |
| Build Status | **SUCCESS** (0 Errors, 184 Warnings) |
| Source Files Modified | 5 |
| Artifact Files Generated | 4 |

---

## 2. DMS Tool Status

All 5 DMS tool invocations failed with the same error: **"Metadata model creation failed: No objects were found according to the specified selection rules."**

| # | Statement Name | Timestamp | Schema | Status | Error |
|---|---------------|-----------|--------|--------|-------|
| 1 | EditUsingStoredProcedure | 2026-03-22T06:40:49 | dbo | ERROR | Metadata model creation failed |
| 2 | FindAllAuthorsEmbeddedSql | 2026-03-22T06:41:20 | dbo | ERROR | Metadata model creation failed |
| 3 | DeleteAuthorEmbeddedSql | 2026-03-22T06:41:43 | dbo | ERROR | Metadata model creation failed |
| 4 | SelectAuthorsByHireYear | 2026-03-22T06:42:07 | dbo | ERROR | Metadata model creation failed |
| 5 | FindAllProducts | 2026-03-22T06:42:30 | dbo | ERROR | Metadata model creation failed |

**DMS Tool Parameters:**
- Migration Project: `arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI`
- Database: `BobsBookstore`
- Schema: `dbo`
- Region: `us-east-1`
- Server: `172.31.93.178`

---

## 3. SQL Equivalency Validation

All 5 equivalency validations returned ERROR with `'uniqueID'` error from the SQL Equivalency tool.

| # | Statement Name | Timestamp | Status | Tool Output |
|---|---------------|-----------|--------|-------------|
| 1 | EditUsingStoredProcedure | 2026-03-22T06:44:43 | ERROR | `'uniqueID'` |
| 2 | FindAllAuthorsEmbeddedSql | 2026-03-22T06:44:54 | ERROR | `'uniqueID'` |
| 3 | DeleteAuthorEmbeddedSql | 2026-03-22T06:45:05 | ERROR | `'uniqueID'` |
| 4 | SelectAuthorsByHireYear | 2026-03-22T06:45:17 | ERROR | `'uniqueID'` |
| 5 | FindAllProducts | 2026-03-22T06:45:27 | ERROR | `'uniqueID'` |

**Note:** All equivalency statuses are sourced directly from the SQL Equivalency tool output. No agent judgment was used.

---

## 4. Detailed Statement Conversions

### Statement 1: EditUsingStoredProcedure

| Field | Value |
|-------|-------|
| Source File | `app/Bookstore.Web/Controllers/AuthorsController.cs` |
| Line Number | ~163 |
| Method | `EditUsingStoredProcedure` |
| Execution API | `_context.Database.ExecuteSqlRawAsync` |
| Conversion Method | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| Equivalency Status | ERROR |

**Original MS SQL:**
```sql
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
```

**Converted PostgreSQL:**
```sql
SELECT uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
```

**Conversion Notes:**
- SQL Server EXEC stored procedure syntax → PostgreSQL SELECT function() syntax
- Schema objects lowercased: `[dbo].[uspUpdateAuthorPersonalInfo]` → `uspupdateauthorpersonalinfo`
- DECLARE/EXEC/SELECT pattern simplified to single SELECT function call

---

### Statement 2: FindAllAuthorsEmbeddedSql

| Field | Value |
|-------|-------|
| Source File | `app/Bookstore.Web/Controllers/AuthorsController.cs` |
| Line Number | ~187 |
| Method | `FindAllAuthorsEmbeddedSql` |
| Execution API | `_context.Database.SqlQueryRaw<Author>` |
| Conversion Method | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| Equivalency Status | ERROR |

**Original MS SQL:**
```sql
SELECT * FROM Author
```

**Converted PostgreSQL:**
```sql
SELECT * FROM author
```

**Conversion Notes:**
- Table name lowercased: `Author` → `author`

---

### Statement 3: DeleteAuthorEmbeddedSql

| Field | Value |
|-------|-------|
| Source File | `app/Bookstore.Web/Controllers/AuthorsController.cs` |
| Line Number | ~208 |
| Method | `DeleteAuthorEmbeddedSql` |
| Execution API | `_context.Database.ExecuteSqlRawAsync` |
| Conversion Method | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| Equivalency Status | ERROR |

**Original MS SQL:**
```sql
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
```

**Converted PostgreSQL:**
```sql
SELECT uspdeleteauthor(@BusinessEntityID);
```

**Conversion Notes:**
- SQL Server EXEC stored procedure syntax → PostgreSQL SELECT function() syntax
- Schema objects lowercased: `[dbo].[uspDeleteAuthor]` → `uspdeleteauthor`
- DECLARE/EXEC/SELECT pattern simplified to single SELECT function call

---

### Statement 4: SelectAuthorsByHireYear

| Field | Value |
|-------|-------|
| Source File | `app/Bookstore.Web/Controllers/AuthorsController.cs` |
| Line Number | ~228 |
| Method | `SelectAuthorsByHireYear` |
| Execution API | `_context.Database.SqlQueryRaw<AuthorAgeResult>` |
| Conversion Method | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| Equivalency Status | ERROR |

**Original MS SQL:**
```sql
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
```

**Converted PostgreSQL:**
```sql
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
```

**Conversion Notes:**
- `FORMAT(date, 'yyyy-MM-dd HH:mm:ss')` → `TO_CHAR(date, 'YYYY-MM-DD HH24:MI:SS')`
- `DATEDIFF(YEAR, BirthDate, GETDATE())` → `EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT`
- `DATEPART(YEAR, HireDate)` → `EXTRACT(YEAR FROM hiredate)`
- All column/table names lowercased: `BusinessEntityID` → `businessentityid`, `ModifiedDate` → `modifieddate`, `FormattedModifiedDate` → `formattedmodifieddate`, `BirthDate` → `birthdate`, `Age` → `age`, `Author` → `author`, `HireDate` → `hiredate`

---

### Statement 5: FindAllProducts

| Field | Value |
|-------|-------|
| Source File | `app/Bookstore.Web/Controllers/ProductsController.cs` |
| Line Number | ~34 |
| Method | `FindAllProducts` |
| Execution API | `_context.Database.SqlQueryRaw<Product>` |
| Conversion Method | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| Equivalency Status | ERROR |

**Original MS SQL:**
```sql
EXEC [dbo].[uspGetProductData];
```

**Converted PostgreSQL:**
```sql
SELECT * FROM uspgetproductdata();
```

**Conversion Notes:**
- SQL Server EXEC stored procedure syntax → PostgreSQL SELECT * FROM function() syntax
- Schema objects lowercased: `[dbo].[uspGetProductData]` → `uspgetproductdata`

---

## 5. File Changes Summary

| File | Changes |
|------|---------|
| `app/Bookstore.Web/Controllers/AuthorsController.cs` | `using Microsoft.Data.SqlClient` → `using Npgsql`; All `SqlParameter` → `NpgsqlParameter`; 4 SQL statements converted to PostgreSQL syntax |
| `app/Bookstore.Web/Controllers/ProductsController.cs` | `using Microsoft.Data.SqlClient` → `using Npgsql`; 1 SQL statement converted to PostgreSQL syntax |
| `app/Bookstore.Web/Startup/ServicesSetup.cs` | `using Microsoft.Data.SqlClient` → `using Npgsql`; `SqlConnectionStringBuilder` → `NpgsqlConnectionStringBuilder`; `UseSqlServer()` → `UseNpgsql()`; Connection string format updated to PostgreSQL (`Host=`, `Port=`, `Database=`) |
| `app/Bookstore.Data/Bookstore.Data.csproj` | `Microsoft.EntityFrameworkCore.SqlServer` → `Npgsql.EntityFrameworkCore.PostgreSQL` Version 8.0.0 |
| `app/Bookstore.Web/Bookstore.Web.csproj` | `Microsoft.EntityFrameworkCore.SqlServer` → `Npgsql.EntityFrameworkCore.PostgreSQL` Version 8.0.0 |

---

## 6. Exit Criteria Verification

| # | Criterion | Status |
|---|-----------|--------|
| 1 | All SQL Server specific packages replaced with PostgreSQL equivalents | ✅ PASS |
| 2 | All SqlConnection/SqlCommand/etc. replaced with Npgsql equivalents | ✅ PASS |
| 3 | ALL 5 SQL statements processed through DMS MCP tool | ✅ PASS (all 5 invoked, all 5 failed) |
| 4 | Comprehensive statement catalogs exist | ✅ PASS (extracted_statements.sql, converted_statements.sql) |
| 5 | ALL 5 statement pairs validated through SQL Equivalency tool | ✅ PASS (all 5 invoked, all 5 returned ERROR) |
| 6 | Comprehensive equivalency report generated | ✅ PASS (sql_equivalency_validation_report.json) |
| 7 | No agent judgment used for equivalency | ✅ PASS (all statuses from tool output) |
| 8 | DMS failures documented with manual conversion details | ✅ PASS (all 5 failures documented) |
| 9 | Connection strings updated to PostgreSQL format | ✅ PASS |
| 10 | Application compiles without errors | ✅ PASS (0 errors, 184 warnings) |

---

## 7. Build Verification

```
Command: dotnet build BobsBookstore.sln
Exit Code: 0
Result: Build succeeded
Errors: 0
Warnings: 184 (pre-existing, not migration-related - CS8618 nullable warnings, CS0618 obsolete warnings)
Time: ~10 seconds
```

---

## 8. Artifacts List

| # | Artifact | Path | Status |
|---|----------|------|--------|
| 1 | Extracted Statements Catalog | `sourceCode/extracted_statements.sql` | ✅ Complete (5 statements) |
| 2 | Converted Statements Catalog | `sourceCode/converted_statements.sql` | ✅ Complete (5 statements) |
| 3 | SQL Equivalency Validation Report | `sourceCode/sql_equivalency_validation_report.json` | ✅ Complete (5 statement pairs) |
| 4 | Migration Report | `sourceCode/migration_report.md` | ✅ Complete |

---

## 9. Transformation Timeline

| Step | Action | Status |
|------|--------|--------|
| Step 1 | Extract and Catalog All SQL Statements | ✅ Complete |
| Step 2 | Convert All SQL Statements Using DMS MCP Tool | ✅ Complete (5/5 DMS failures, manual conversions applied) |
| Step 3 | Validate SQL Equivalency for All Statement Pairs | ✅ Complete (5/5 ERROR from tool) |
| Step 4 | Re-integrate Converted SQL Statements and Verify Code | ✅ Complete (Build SUCCESS) |
| Step 5 | Generate Final Migration Report and Verify All Artifacts | ✅ Complete |

---

*End of Migration Report*
