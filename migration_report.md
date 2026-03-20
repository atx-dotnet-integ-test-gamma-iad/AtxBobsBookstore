# BobsBookstore Migration Report
## Microsoft SQL Server to PostgreSQL Migration

**Date:** 2026-03-20  
**Application:** BobsBookstore (.NET 8.0 ADO.NET / Entity Framework Core)  
**Source Database:** Microsoft SQL Server  
**Target Database:** PostgreSQL  
**DMS Migration Project:** arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI  

---

## 1. SQL Statement Processing Summary

| Metric | Count |
|--------|-------|
| **Total SQL statements processed** | 5 |
| **Successfully converted by DMS MCP tool** | 0 |
| **Requiring manual intervention after DMS failure** | 5 |
| **Validated as equivalent by SQL Equivalency tool** | 0 |
| **Validated as non-equivalent** | 0 |
| **With equivalency validation errors** | 5 |

### DMS Conversion Details

All 5 statements were passed through the DMS MCP tool (`dms-mcp___statement_conversion_tool`). All failed with the same error:

> **Metadata model creation failed:** No objects were found according to the specified selection rules. Please review your selection rules and try again.

Manual conversions were applied using `DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA` rules:
- All schema object names (tables, columns, procedures) converted to lowercase
- SQL Server-specific syntax converted to PostgreSQL equivalents
- `EXEC stored_proc` converted to `SELECT function_name()`
- SQL Server date functions converted to PostgreSQL date functions

### SQL Equivalency Validation Details

All 5 statement pairs were validated using the SQL Equivalency MCP tool (`sql-equivalency___validate_sql_equivalence`). All returned ERROR status with error `'uniqueID'`. This is a tool-level error, not a determination of non-equivalency.

---

## 2. Detailed Statement Listing

### Statement 1: EditUsingStoredProcedure
- **Source File:** `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method:** `EditUsingStoredProcedure`
- **Original (MS SQL):** `EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender`
- **Converted (PostgreSQL):** `SELECT uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);`
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status:** ERROR (tool error: 'uniqueID')

### Statement 2: FindAllAuthorsEmbeddedSql
- **Source File:** `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method:** `FindAllAuthorsEmbeddedSql`
- **Original (MS SQL):** `SELECT * FROM Author`
- **Converted (PostgreSQL):** `SELECT * FROM author`
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status:** ERROR (tool error: 'uniqueID')

### Statement 3: DeleteAuthorEmbeddedSql
- **Source File:** `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method:** `DeleteAuthorEmbeddedSql`
- **Original (MS SQL):** `EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID`
- **Converted (PostgreSQL):** `SELECT uspdeleteauthor(@BusinessEntityID);`
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status:** ERROR (tool error: 'uniqueID')

### Statement 4: SelectAuthorsByHireYear
- **Source File:** `app/Bookstore.Web/Controllers/AuthorsController.cs`
- **Method:** `SelectAuthorsByHireYear`
- **Original (MS SQL):** `SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate`
- **Converted (PostgreSQL):** `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;`
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status:** ERROR (tool error: 'uniqueID')
- **Conversion Notes:**
  - `FORMAT()` → `TO_CHAR()`
  - `DATEDIFF(YEAR, ...)` → `EXTRACT(YEAR FROM AGE(...))`
  - `GETDATE()` → `NOW()`
  - `DATEPART(YEAR, ...)` → `EXTRACT(YEAR FROM ...)`

### Statement 5: FindAllProducts
- **Source File:** `app/Bookstore.Web/Controllers/ProductsController.cs`
- **Method:** `FindAllProducts`
- **Original (MS SQL):** `EXEC [dbo].[uspGetProductData]`
- **Converted (PostgreSQL):** `SELECT * FROM uspgetproductdata();`
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status:** ERROR (tool error: 'uniqueID')

---

## 3. Package Dependency Changes

| Original Package | Version | Replacement Package | Version |
|-----------------|---------|-------------------|---------|
| Microsoft.Data.SqlClient | (removed) | Npgsql.EntityFrameworkCore.PostgreSQL | 8.0.0 |

**Files modified:**
- `app/Bookstore.Data/Bookstore.Data.csproj` - Added `Npgsql.EntityFrameworkCore.PostgreSQL` 8.0.0
- `app/Bookstore.Web/Bookstore.Web.csproj` - Added `Npgsql.EntityFrameworkCore.PostgreSQL` 8.0.0

---

## 4. ADO.NET Class Replacement Summary

| Original (SQL Server) | Replacement (PostgreSQL) |
|----------------------|-------------------------|
| `SqlConnection` | `NpgsqlConnection` (via EF Core) |
| `SqlCommand` | Not used directly (EF Core abstracts) |
| `SqlDataReader` | Not used directly (EF Core abstracts) |
| `SqlParameter` | `NpgsqlParameter` |
| `SqlConnectionStringBuilder` | `NpgsqlConnectionStringBuilder` |
| `UseSqlServer()` | `UseNpgsql()` |

**Files modified:**
- `app/Bookstore.Web/Controllers/AuthorsController.cs` - `NpgsqlParameter` usage
- `app/Bookstore.Web/Controllers/ProductsController.cs` - `using Npgsql;`
- `app/Bookstore.Web/Startup/ServicesSetup.cs` - `NpgsqlConnectionStringBuilder`, `UseNpgsql`

---

## 5. Connection String Format Changes

| Parameter | SQL Server | PostgreSQL |
|-----------|-----------|------------|
| Server | `Server=` / `Data Source=` | `Host=` |
| Port | (implicit 1433) | `Port=` |
| Database | `Database=` / `Initial Catalog=` | `Database=` |
| Authentication | `Integrated Security=true` | `Username=` / `Password=` |

**Connection string builder changed:** `SqlConnectionStringBuilder` → `NpgsqlConnectionStringBuilder`

---

## 6. Import Statement Changes

| File | Original Import | New Import |
|------|----------------|------------|
| AuthorsController.cs | `using Microsoft.Data.SqlClient;` | `using Npgsql;` |
| ProductsController.cs | `using Microsoft.Data.SqlClient;` | `using Npgsql;` |
| ServicesSetup.cs | `using Microsoft.Data.SqlClient;` | `using Npgsql;` |

---

## 7. Build Verification

**Build command:** `dotnet build BobsBookstore.sln`  
**Build result:** ✅ **BUILD SUCCEEDED**  
**Errors:** 0  
**Warnings:** 184 (all pre-existing, primarily Magick.NET vulnerability warnings and CS8618 nullable warnings)

---

## 8. Transformation Artifacts

| Artifact | Status |
|----------|--------|
| `extracted_statements.sql` | ✅ Complete - 5 original MS SQL statements |
| `converted_statements.sql` | ✅ Complete - 5 converted PostgreSQL statements |
| `sql_equivalency_validation_report.json` | ✅ Complete - 5 statement pairs with ERROR status |
| `dms_migration_log.txt` | ✅ Complete - 5 DMS interactions documented |
| `migration_report.md` | ✅ This document |

---

## 9. Remaining Items for Manual Review

1. **DMS Tool Errors:** All 5 DMS conversions failed with metadata model creation error. This appears to be a DMS configuration issue with the migration project, not a statement-level issue. Manual conversions were applied per specification.

2. **SQL Equivalency Errors:** All 5 equivalency validations returned ERROR with `'uniqueID'` error. This appears to be a tool-level error, not a determination about statement equivalence. Manual review of conversions is recommended.

3. **Statements requiring manual review:**
   - Stored procedure calls (Statements 1, 3, 5): Converted from EXEC syntax to PostgreSQL function call syntax. Assumes corresponding PostgreSQL functions exist with lowercase names.
   - Date function conversion (Statement 4): Complex date function conversions from SQL Server to PostgreSQL syntax. Should be verified with actual data.

---

*Report generated as part of BobsBookstore SQL Server to PostgreSQL migration.*
