# Migration Report: MS SQL Server to PostgreSQL

## Summary
**Migration Date:** 2026-03-04  
**Source Database:** Microsoft SQL Server 2019  
**Target Database:** PostgreSQL 13  
**Application:** BobsBookstore (.NET ADO Application)  
**Build Status:** ✅ SUCCESS (0 errors)

---

## SQL Statement Processing

### Total SQL Statements Processed: 5

| # | Method | File | Conversion Method | Equivalency Status |
|---|--------|------|-------------------|-------------------|
| 1 | EditUsingStoredProcedure | AuthorsController.cs | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA | ERROR |
| 2 | FindAllAuthorsEmbeddedSql | AuthorsController.cs | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA | ERROR |
| 3 | DeleteAuthorEmbeddedSql | AuthorsController.cs | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA | ERROR |
| 4 | SelectAuthorsByHireYear | AuthorsController.cs | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA | ERROR |
| 5 | FindAllProducts | ProductsController.cs | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA | ERROR |

### DMS Conversion Results
- **Statements successfully converted by DMS:** 0
- **Statements requiring manual intervention after DMS failure:** 5
- **DMS Error:** `Metadata model creation failed: The selected objects were not found.`
- **DMS Retry Timestamps:** 2026-03-04T12:12:20 through 2026-03-04T12:13:30

### SQL Equivalency Validation Results
- **Statements validated as equivalent:** 0
- **Statements validated as non-equivalent:** 0
- **Statements with equivalency validation errors:** 5
- **Error:** The SQL Equivalency tool returned ERROR with `'uniqueID'` for all statement pairs (systematic tool issue)
- **Equivalency Validation Timestamps:** 2026-03-04T12:15:34 through 2026-03-04T12:15:37

---

## Conversion Details

### Statement 1: EditUsingStoredProcedure
- **Original:** `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;`
- **Converted:** `SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);`
- **Changes:** DECLARE/EXEC stored procedure syntax → PostgreSQL function call syntax with lowercase naming

### Statement 2: FindAllAuthorsEmbeddedSql
- **Original:** `SELECT * FROM bobsbookstore_dbo.author`
- **Converted:** `SELECT * FROM bobsbookstore_dbo.author`
- **Changes:** No changes needed (already PostgreSQL compatible with lowercase naming)

### Statement 3: DeleteAuthorEmbeddedSql
- **Original:** `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;`
- **Converted:** `SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);`
- **Changes:** DECLARE/EXEC stored procedure syntax → PostgreSQL function call syntax with lowercase naming

### Statement 4: SelectAuthorsByHireYear
- **Original:** `SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;`
- **Converted:** `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, birthdate))::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;`
- **Changes:** FORMAT→TO_CHAR, DATEDIFF→EXTRACT/AGE, GETDATE()→CURRENT_TIMESTAMP, DATEPART→EXTRACT, column/table names lowercased, schema prefix added

### Statement 5: FindAllProducts
- **Original:** `EXEC [dbo].[uspGetProductData];`
- **Converted:** `SELECT * FROM bobsbookstore_dbo.uspgetproductdata();`
- **Changes:** EXEC stored procedure syntax → PostgreSQL function call syntax with lowercase naming

---

## Code Changes Summary

### Files Modified
1. **AuthorsController.cs** - 4 SQL statements converted, 7 SqlParameter→NpgsqlParameter replacements, using Npgsql import added
2. **ProductsController.cs** - 1 SQL statement converted, using Npgsql import added

### Static Code Changes
- All `SqlParameter` references replaced with `NpgsqlParameter` (7 instances total)
- Both files have `using Npgsql;` import
- No `SqlConnection`, `SqlCommand`, `SqlDataReader`, `Microsoft.Data.SqlClient`, `System.Data.SqlClient`, or `UseSqlServer` references remain in the codebase

### Package Dependencies
- Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0 referenced in Bookstore.Data.csproj and Bookstore.Web.csproj
- No Microsoft.Data.SqlClient or System.Data.SqlClient references remain

### Connection Strings
- Updated to PostgreSQL format using NpgsqlConnectionStringBuilder (Host, Port, Database, Username, Password)
- Uses option.UseNpgsql(connString) for DbContext configuration

### EF Core Configuration
- ApplicationDbContext.cs uses lowercase table/column names for PostgreSQL
- Schema set to 'bobsbookstore_dbo' throughout
- Npgsql.EnableLegacyTimestampBehavior set in static constructor

---

## Artifacts Generated
1. `extracted_statements.sql` - Catalog of all 5 original MS SQL statements
2. `converted_statements.sql` - Catalog of all 5 converted PostgreSQL statements with DMS error details
3. `sql_equivalency_validation_report.json` - Comprehensive validation report with all 5 statement pairs
4. `migration_report.md` - This report

---

## Notes for Manual Review
1. **DMS Tool Failure:** All 5 statements failed DMS conversion with "Metadata model creation failed: The selected objects were not found." error on both initial and retry attempts. Manual conversions were applied using lowercase schema mapping rules (DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA).
2. **SQL Equivalency Tool Error:** All 5 statement pairs returned ERROR (`'uniqueID'`) from the equivalency tool on both initial and retry attempts. This appears to be a systematic tool issue. These statements should be manually verified for correctness.
3. **Stored Procedure Calls:** Statements 1, 3, and 5 involve stored procedures that were converted to PostgreSQL function call syntax. The corresponding PostgreSQL functions (uspupdateauthorpersonalinfo, uspdeleteauthor, uspgetproductdata) must exist in the bobsbookstore_dbo schema on the target PostgreSQL database.
4. **Build Status:** The application compiles successfully with 0 errors after all changes.
5. **No Agent Judgment Used for Equivalency:** All equivalency statuses come directly from the SQL Equivalency tool output. No agent judgment was substituted for tool results.
