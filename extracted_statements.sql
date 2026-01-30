/*
================================================================================
EXTRACTED SQL STATEMENTS - SQL Server to PostgreSQL Migration
================================================================================
Source Project: BobsBookstore
Date: 2026-01-30
Purpose: Comprehensive catalog of all SQL statements extracted from codebase
         to be converted from SQL Server to PostgreSQL syntax

TOTAL STATEMENTS: 5
================================================================================
*/

-- ============================================================================
-- FILE: app/Bookstore.Web/Controllers/AuthorsController.cs
-- ============================================================================

-- ----------------------------------------------------------------------------
-- STATEMENT 1: Update Author Personal Info (Stored Procedure Call)
-- ----------------------------------------------------------------------------
-- Source Location: AuthorsController.cs, Line 163
-- Method: EditUsingStoredProcedure
-- Statement Type: Stored Procedure Call with Output Parameter
-- Construction Method: Inline string literal
-- Parameters: 5
--   - @BusinessEntityID (int)
--   - @NationalIDNumber (string)
--   - @BirthDate (DateTime)
--   - @MaritalStatus (string)
--   - @Gender (string)
-- SQL Server Features Used:
--   - DECLARE variable
--   - EXEC stored procedure with output parameter
--   - [dbo] schema reference
--   - SELECT to return output parameter value
-- Notes: This is a stored procedure call pattern specific to SQL Server.
--        PostgreSQL uses functions instead of stored procedures.
--        The DECLARE/EXEC/SELECT pattern will need to be converted to
--        PostgreSQL function call syntax.
-- ----------------------------------------------------------------------------
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;


-- ----------------------------------------------------------------------------
-- STATEMENT 2: Select All Authors (Simple SELECT)
-- ----------------------------------------------------------------------------
-- Source Location: AuthorsController.cs, Line 189
-- Method: FindAllAuthorsEmbeddedSql
-- Statement Type: SELECT query
-- Construction Method: Inline string literal
-- Parameters: None
-- SQL Server Features Used:
--   - Schema-qualified table name (bobsbookstore_dbo.author)
--   - SELECT * (returns all columns)
-- Notes: Simple SELECT statement. May need schema name adjustment based on
--        PostgreSQL schema migration.
-- ----------------------------------------------------------------------------
SELECT * FROM bobsbookstore_dbo.author;


-- ----------------------------------------------------------------------------
-- STATEMENT 3: Delete Author (Stored Procedure Call)
-- ----------------------------------------------------------------------------
-- Source Location: AuthorsController.cs, Line 208
-- Method: DeleteAuthorEmbeddedSql
-- Statement Type: Stored Procedure Call with Output Parameter
-- Construction Method: Inline string literal
-- Parameters: 1
--   - @BusinessEntityID (int)
-- SQL Server Features Used:
--   - DECLARE variable
--   - EXEC stored procedure with output parameter
--   - [dbo] schema reference
--   - SELECT to return output parameter value
-- Notes: Similar to Statement 1, this stored procedure call pattern is
--        SQL Server specific and will need conversion to PostgreSQL function.
-- ----------------------------------------------------------------------------
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;


-- ----------------------------------------------------------------------------
-- STATEMENT 4: Select Authors by Hire Year with Age Calculation
-- ----------------------------------------------------------------------------
-- Source Location: AuthorsController.cs, Line 228
-- Method: SelectAuthorsByHireYear
-- Statement Type: SELECT query with SQL Server-specific functions
-- Construction Method: Inline string literal
-- Parameters: 1
--   - @HireDate (int - year value)
-- SQL Server Features Used:
--   - FORMAT() function for date formatting
--   - DATEDIFF() function to calculate age
--   - GETDATE() function for current date
--   - DATEPART() function to extract year
--   - Schema-qualified table name (bobsbookstore_dbo.author)
-- PostgreSQL Equivalents Needed:
--   - FORMAT() -> TO_CHAR()
--   - DATEDIFF(YEAR, ...) -> DATE_PART('year', AGE(...))
--   - GETDATE() -> NOW() or CURRENT_TIMESTAMP
--   - DATEPART(YEAR, ...) -> EXTRACT(YEAR FROM ...)
-- Notes: This is a complex statement with multiple SQL Server-specific
--        date/time functions that all need PostgreSQL equivalents.
-- ----------------------------------------------------------------------------
SELECT 
    BusinessEntityID, 
    FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, 
    DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age 
FROM bobsbookstore_dbo.author 
WHERE DATEPART(YEAR, HireDate) = @HireDate;


-- ============================================================================
-- FILE: app/Bookstore.Web/Controllers/ProductsController.cs
-- ============================================================================

-- ----------------------------------------------------------------------------
-- STATEMENT 5: Get All Products (Stored Procedure Call)
-- ----------------------------------------------------------------------------
-- Source Location: ProductsController.cs, Line 31
-- Method: FindAllProducts
-- Statement Type: Stored Procedure Call (no parameters)
-- Construction Method: Inline string literal
-- Parameters: None
-- SQL Server Features Used:
--   - EXEC stored procedure
--   - [dbo] schema reference
-- Notes: Simple stored procedure call with no parameters or output values.
--        Will need conversion to PostgreSQL function call.
-- ----------------------------------------------------------------------------
EXEC [dbo].[uspGetProductData];


-- ============================================================================
-- SUMMARY STATISTICS
-- ============================================================================
/*
Total SQL Statements Extracted: 5

By Type:
- Stored Procedure Calls: 3 (Statements 1, 3, 5)
- SELECT Queries: 2 (Statements 2, 4)
- INSERT/UPDATE/DELETE: 0

By Complexity:
- Simple: 2 (Statements 2, 5)
- Moderate: 1 (Statements 1, 3)
- Complex: 1 (Statement 4)

SQL Server-Specific Features to Convert:
1. Stored procedure EXEC syntax (3 occurrences)
2. DECLARE/EXEC/SELECT pattern for output parameters (2 occurrences)
3. FORMAT() function (1 occurrence)
4. DATEDIFF() function (1 occurrence)
5. GETDATE() function (1 occurrence)
6. DATEPART() function (1 occurrence)
7. [dbo] schema references (3 occurrences)
8. bobsbookstore_dbo schema qualification (2 occurrences)

Files with SQL Statements:
1. app/Bookstore.Web/Controllers/AuthorsController.cs (4 statements)
2. app/Bookstore.Web/Controllers/ProductsController.cs (1 statement)

Files without SQL Statements:
- All repository files use Entity Framework Core (no raw SQL)
- No SQL found in other controllers or services
*/

-- ============================================================================
-- END OF EXTRACTION
-- ============================================================================
