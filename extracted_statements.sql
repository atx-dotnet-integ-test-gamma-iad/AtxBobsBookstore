-- ============================================================================
-- SQL STATEMENT EXTRACTION CATALOG
-- Microsoft SQL Server to PostgreSQL Migration
-- Source Application: Bob's Bookstore
-- Extraction Date: 2025
-- ============================================================================

-- ----------------------------------------------------------------------------
-- STATEMENT #1: Simple SELECT from Author Table
-- ----------------------------------------------------------------------------
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: ~194
-- Method Name: FindAllAuthorsEmbeddedSql()
-- Context: Retrieves all authors from the database for display in the Index view
-- SQL Server-Specific Elements: None (PostgreSQL compatible as-is)
-- Statement Type: Direct SQL Query
-- Parameters: None

SELECT * FROM bobsbookstore_dbo.author

-- Notes: 
-- - Uses schema-qualified table name (bobsbookstore_dbo.author)
-- - Simple SELECT statement without SQL Server-specific functions
-- - No parameterization

-- ----------------------------------------------------------------------------
-- STATEMENT #2: Stored Procedure Call - Update Author Personal Info
-- ----------------------------------------------------------------------------
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: ~164
-- Method Name: EditUsingStoredProcedure()
-- Context: Updates author personal information using a stored procedure
-- SQL Server-Specific Elements:
--   - DECLARE variable syntax
--   - EXEC stored procedure syntax
--   - @variable parameter syntax
--   - Return value assignment pattern (@rowsAffected = [dbo].[procedurename])
-- Statement Type: Stored Procedure Call with Return Value
-- Parameters: 
--   @BusinessEntityID (int)
--   @NationalIDNumber (string)
--   @BirthDate (DateTime)
--   @MaritalStatus (string)
--   @Gender (string)

DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Notes:
-- - Multi-statement batch: DECLARE, EXEC, SELECT
-- - Uses SQL Server return value pattern
-- - Stored procedure name: uspUpdateAuthorPersonalInfo
-- - Schema: [dbo]
-- - Requires conversion to PostgreSQL function/procedure syntax (CALL or SELECT function())
-- - PostgreSQL stored procedures may need different return value handling

-- ----------------------------------------------------------------------------
-- STATEMENT #3: Stored Procedure Call - Delete Author
-- ----------------------------------------------------------------------------
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: ~212
-- Method Name: DeleteAuthorEmbeddedSql()
-- Context: Deletes an author using a stored procedure
-- SQL Server-Specific Elements:
--   - DECLARE variable syntax
--   - EXEC stored procedure syntax
--   - @variable parameter syntax
--   - Return value assignment pattern
-- Statement Type: Stored Procedure Call with Return Value
-- Parameters: 
--   @BusinessEntityID (int)

DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Notes:
-- - Multi-statement batch: DECLARE, EXEC, SELECT
-- - Uses SQL Server return value pattern
-- - Stored procedure name: uspDeleteAuthor
-- - Schema: [dbo]
-- - Single parameter for author ID
-- - Requires conversion to PostgreSQL function/procedure syntax

-- ----------------------------------------------------------------------------
-- STATEMENT #4: Complex SELECT with SQL Server Date Functions
-- ----------------------------------------------------------------------------
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: ~230
-- Method Name: SelectAuthorsByHireYear()
-- Context: Retrieves authors hired in a specific year with age calculation
-- SQL Server-Specific Elements:
--   - FORMAT() function for date formatting
--   - DATEDIFF(YEAR, date1, date2) function for age calculation
--   - GETDATE() function for current date
--   - DATEPART(YEAR, date) function for extracting year from date
-- Statement Type: Complex SELECT with Date Functions
-- Parameters: 
--   @HireDate (int) - Year value for filtering

SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Notes:
-- - Multiple SQL Server-specific date functions requiring conversion:
--   * FORMAT() -> TO_CHAR() in PostgreSQL
--   * DATEDIFF(YEAR, date1, date2) -> DATE_PART('year', AGE(date2, date1)) or EXTRACT(YEAR FROM AGE())
--   * GETDATE() -> CURRENT_DATE or NOW() in PostgreSQL
--   * DATEPART(YEAR, date) -> EXTRACT(YEAR FROM date) in PostgreSQL
-- - Schema-qualified table name
-- - Parameter binding for year filter
-- - Returns custom result type (AuthorAgeResult)

-- ============================================================================
-- SUMMARY
-- ============================================================================
-- Total SQL Statements Identified: 4
-- Statements Requiring Conversion: 4 (all must go through DMS tool)
-- Simple SELECT statements: 1
-- Stored Procedure Calls: 2
-- Complex SELECT with Functions: 1
-- 
-- SQL Server-Specific Syntax Elements Found:
-- - DECLARE variable syntax (2 statements)
-- - EXEC stored procedure syntax (2 statements)
-- - FORMAT() function (1 statement)
-- - DATEDIFF() function (1 statement)
-- - GETDATE() function (1 statement)
-- - DATEPART() function (1 statement)
-- - Schema qualification: [dbo], bobsbookstore_dbo
-- 
-- Next Steps:
-- 1. Convert all 4 statements using DMS MCP tool (dms-mcp____statement_conversion_tool)
-- 2. Validate equivalency of all converted pairs using SQL Equivalency tool
-- 3. Re-integrate converted statements back into AuthorsController.cs
-- ============================================================================
