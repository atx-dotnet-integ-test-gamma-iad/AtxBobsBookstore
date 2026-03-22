# Migration Summary: SQL Server to PostgreSQL - BobsBookstore

## Migration Date: 2026-03-22
## Last Updated: 2026-03-22 (Step 1 re-execution with fresh DMS attempts)

## Overview
This document records the complete migration log for converting SQL statements in the BobsBookstore .NET ADO application from Microsoft SQL Server to PostgreSQL.

## DMS Migration Project
- **ARN**: `arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI`
- **Database**: BobsBookstore
- **Source Schema**: dbo
- **Target Schema**: bobsbookstore_dbo

## SQL Statement Processing Summary

| Metric | Count |
|--------|-------|
| Total SQL Statements Identified | 5 |
| Statements Passed to DMS Tool | 5 |
| DMS Conversions Successful | 0 |
| DMS Conversions Failed | 5 |
| Manual Conversions Required | 5 |
| Equivalency Validated as EQUIVALENT | 0 |
| Equivalency Validated as NOT_EQUIVALENT | 0 |
| Equivalency Validation ERRORS | 5 |

## DMS Tool Status
The DMS MCP tool (dms-mcp___statement_conversion_tool) consistently returned errors for all 5 statements across multiple attempts:

**Error**: `Metadata model creation failed: No objects were found according to the specified selection rules. Please review your selection rules and try again.`

### DMS Attempts Log (Step 1 Re-execution)

**Statement 1** - uspupdateauthorpersonalinfo:
- Attempt 1: `schema_name='dbo'`, `database_name='BobsBookstore'`, sql_text=`SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(...)` → Failed (2026-03-22T14:13:28)
- Attempt 2: `schema_name='dbo'`, `database_name='BobsBookstore'`, sql_text=`EXEC dbo.uspUpdateAuthorPersonalInfo ...` → Failed (2026-03-22T14:13:52)

**Statement 2** - SELECT all authors:
- Attempt: `schema_name='dbo'`, `database_name='BobsBookstore'`, sql_text=`SELECT * FROM dbo.Author;` → Failed (2026-03-22T14:14:19)

**Statement 3** - uspdeleteauthor:
- Attempt: `schema_name='dbo'`, `database_name='BobsBookstore'`, sql_text=`EXEC dbo.uspDeleteAuthor @BusinessEntityID;` → Failed (2026-03-22T14:14:41)

**Statement 4** - Complex SELECT with date functions:
- Attempt: `schema_name='dbo'`, `database_name='BobsBookstore'`, sql_text=`SELECT BusinessEntityID, CONVERT(...) ...` → Failed (2026-03-22T14:15:05)

**Statement 5** - uspgetproductdata:
- Attempt: `schema_name='dbo'`, `database_name='BobsBookstore'`, sql_text=`EXEC dbo.uspGetProductData;` → Failed (2026-03-22T14:15:28)

## SQL Equivalency Tool Status
The SQL Equivalency tool (sql-equivalency___validate_sql_equivalence) returned ERROR for all 5 statement pairs:

**Error**: `'uniqueID'` - This is a systemic internal tool error affecting all validations, not related to the SQL statements themselves.

All 5 statement pairs were validated through the tool:
1. Statement 1 (uspupdateauthorpersonalinfo): ERROR at 2026-03-22T14:18:24.535984 (query_complexity: medium)
2. Statement 2 (SELECT all authors): ERROR at 2026-03-22T14:18:34.382550 (query_complexity: easy)
3. Statement 3 (uspdeleteauthor): ERROR at 2026-03-22T14:18:57.814193 (query_complexity: medium)
4. Statement 4 (Complex SELECT with dates): ERROR at 2026-03-22T14:19:09.217375 (query_complexity: hard)
5. Statement 5 (uspgetproductdata): ERROR at 2026-03-22T14:19:17.682831 (query_complexity: medium)

An additional retry with sample_data parameter was attempted for Statement 2 but produced the same error.

Per transformation definition: equivalency status marked as ERROR for all statements since the tool failed. Agent judgment was NOT used to determine equivalency.

## Manual Conversion Details (DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA)

Since DMS failed for all statements, manual conversion was applied with the following rules:
1. All schema object names converted to lowercase
2. `dbo` schema prefix replaced with `bobsbookstore_dbo`
3. SQL Server `EXEC` procedure calls converted to PostgreSQL `SELECT * FROM function_name()` syntax
4. SQL Server date functions converted to PostgreSQL equivalents:
   - `CONVERT(VARCHAR(19), date, 120)` → `TO_CHAR(date, 'YYYY-MM-DD HH24:MI:SS')`
   - `DATEDIFF(YEAR, date1, GETDATE())` → `EXTRACT(YEAR FROM AGE(CURRENT_DATE, date1))::INTEGER`
   - `DATEPART(YEAR, date)` → `EXTRACT(YEAR FROM date)`

## Detailed Statement Log

### Statement 1: uspupdateauthorpersonalinfo (Stored Procedure Call)
- **File**: `AuthorsController.cs` line 163
- **Method**: `EditUsingStoredProcedure`
- **Original MS SQL**: `EXEC dbo.uspUpdateAuthorPersonalInfo @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;`
- **DMS Input**: Passed to DMS with schema_name='dbo', database_name='BobsBookstore'
- **DMS Output**: Error - Metadata model creation failed
- **Manual Conversion**: Converted EXEC to SELECT * FROM function call, lowercase names, bobsbookstore_dbo schema
- **Converted PostgreSQL**: `SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);`
- **Re-integration**: No code change needed - source already contains converted statement

### Statement 2: SELECT all authors
- **File**: `AuthorsController.cs` line 187
- **Method**: `FindAllAuthorsEmbeddedSql`
- **Original MS SQL**: `SELECT * FROM dbo.Author;`
- **DMS Input**: Passed to DMS with schema_name='dbo', database_name='BobsBookstore'
- **DMS Output**: Error - Metadata model creation failed
- **Manual Conversion**: Lowercase table name, bobsbookstore_dbo schema
- **Converted PostgreSQL**: `SELECT * FROM bobsbookstore_dbo.author;`
- **Re-integration**: No code change needed - source already contains converted statement

### Statement 3: uspdeleteauthor (Stored Procedure Call)
- **File**: `AuthorsController.cs` line 208
- **Method**: `DeleteAuthorEmbeddedSql`
- **Original MS SQL**: `EXEC dbo.uspDeleteAuthor @BusinessEntityID;`
- **DMS Input**: Passed to DMS with schema_name='dbo', database_name='BobsBookstore'
- **DMS Output**: Error - Metadata model creation failed
- **Manual Conversion**: Converted EXEC to SELECT * FROM function call, lowercase names, bobsbookstore_dbo schema
- **Converted PostgreSQL**: `SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);`
- **Re-integration**: No code change needed - source already contains converted statement

### Statement 4: Complex SELECT with Date Functions
- **File**: `AuthorsController.cs` line 228
- **Method**: `SelectAuthorsByHireYear`
- **Original MS SQL**: `SELECT BusinessEntityID, CONVERT(VARCHAR(19), ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM dbo.Author WHERE DATEPART(YEAR, HireDate) = @HireDate;`
- **DMS Input**: Passed to DMS with schema_name='dbo', database_name='BobsBookstore'
- **DMS Output**: Error - Metadata model creation failed
- **Manual Conversion**: Converted CONVERT/DATEDIFF/DATEPART/GETDATE to PostgreSQL equivalents (TO_CHAR/EXTRACT/AGE/CURRENT_DATE), lowercase names, bobsbookstore_dbo schema
- **Converted PostgreSQL**: `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;`
- **Re-integration**: No code change needed - source already contains converted statement

### Statement 5: uspgetproductdata (Stored Procedure Call)
- **File**: `ProductsController.cs` line 34
- **Method**: `FindAllProducts`
- **Original MS SQL**: `EXEC dbo.uspGetProductData;`
- **DMS Input**: Passed to DMS with schema_name='dbo', database_name='BobsBookstore'
- **DMS Output**: Error - Metadata model creation failed
- **Manual Conversion**: Converted EXEC to SELECT * FROM function call with (), lowercase names, bobsbookstore_dbo schema
- **Converted PostgreSQL**: `SELECT * FROM bobsbookstore_dbo.uspgetproductdata();`
- **Re-integration**: No code change needed - source already contains converted statement

## Re-integration Notes
All 5 SQL statements were found to already be in PostgreSQL-compatible syntax in the source code. The codebase was previously partially migrated:
- Schema prefix `bobsbookstore_dbo` is already in use (matching PostgreSQL target schema)
- All table and object names are already lowercase
- PostgreSQL-specific functions (TO_CHAR, EXTRACT, AGE, CURRENT_DATE) are already used
- PostgreSQL type casting (::INTEGER) is already used
- NpgsqlParameter is already used for parameter binding
- NpgsqlConnection is already referenced in the codebase

No source code changes were required for the SQL statements as they are already PostgreSQL-compatible.

## Static Code Changes (Verified in Step 3)
- Package references use Npgsql.EntityFrameworkCore.PostgreSQL (no SQL Server packages)
- Using Npgsql namespace in controller files
- NpgsqlParameter used for all parameter bindings
- UseNpgsql() in ServicesSetup.cs
- Connection string in PostgreSQL format (Host=, Port=, Database=, Username=, Password=)
- ApplicationDbContext uses lowercase table/column names with bobsbookstore_dbo schema
