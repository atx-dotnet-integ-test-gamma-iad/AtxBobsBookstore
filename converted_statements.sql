/*
================================================================================
CONVERTED SQL STATEMENTS - PostgreSQL
================================================================================
Source Project: BobsBookstore
Date: 2026-01-30
Purpose: PostgreSQL versions of all SQL statements converted from SQL Server

CONVERSION METHOD: MANUAL (DMS Tool Unavailable - Metadata errors)
TOTAL STATEMENTS: 5
ALL STATEMENTS CONVERTED: YES
DMS TOOL SUCCESS RATE: 0/5 (0%)
MANUAL CONVERSION RATE: 5/5 (100%)
================================================================================
*/

-- ============================================================================
-- IMPORTANT NOTE: DMS Tool Failures
-- ============================================================================
-- The DMS MCP tool (dms-mcp____statement_conversion_tool) failed for all
-- statements with error: "Metadata model creation failed: The selected 
-- objects were not found."
--
-- Per the transformation definition: "Whenever the DMS tool is unable to 
-- convert and returns info or actions, use your best judgement to convert 
-- the transformation, but document the statement + DMS output + your 
-- conversion to a summary file."
--
-- All conversions below are MANUAL, performed after DMS tool failure.
-- All conversion reasoning is documented in dms_conversion_log.json
-- All statement pairs will be validated using SQL Equivalency tool in Step 4
-- ============================================================================


-- ============================================================================
-- FILE: app/Bookstore.Web/Controllers/AuthorsController.cs
-- ============================================================================

-- ----------------------------------------------------------------------------
-- STATEMENT 1: Update Author Personal Info (Stored Procedure Call)
-- ----------------------------------------------------------------------------
-- Original SQL (SQL Server):
-- DECLARE @rowsAffected INT;
-- EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
-- SELECT @rowsAffected;
--
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Error: Metadata model creation failed
--
-- Conversion Changes:
-- 1. Removed DECLARE statement (not needed in PostgreSQL function call)
-- 2. Changed EXEC @var = [dbo].[proc] to SELECT function()
-- 3. Removed [dbo] schema qualification
-- 4. Kept @param syntax (Npgsql supports this)
-- 5. Return value is captured directly from SELECT result
--
-- PostgreSQL Function Call Assumptions:
-- - uspUpdateAuthorPersonalInfo exists as a PostgreSQL function
-- - Function returns integer (number of rows affected)
-- - Function is in the default search_path
-- ----------------------------------------------------------------------------
SELECT uspUpdateAuthorPersonalInfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);


-- ----------------------------------------------------------------------------
-- STATEMENT 2: Select All Authors (Simple SELECT)
-- ----------------------------------------------------------------------------
-- Original SQL (SQL Server):
-- SELECT * FROM bobsbookstore_dbo.author;
--
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Error: Metadata model creation failed
--
-- Conversion Changes:
-- 1. No changes - statement is PostgreSQL compatible as-is
-- 2. Schema name bobsbookstore_dbo.author preserved
-- 3. May need adjustment if PostgreSQL schema differs from SQL Server
--
-- Notes:
-- - Simple SELECT * is identical in both databases
-- - Schema qualification maintained pending actual schema verification
-- ----------------------------------------------------------------------------
SELECT * FROM bobsbookstore_dbo.author;


-- ----------------------------------------------------------------------------
-- STATEMENT 3: Delete Author (Stored Procedure Call)
-- ----------------------------------------------------------------------------
-- Original SQL (SQL Server):
-- DECLARE @rowsAffected INT;
-- EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
-- SELECT @rowsAffected;
--
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Error: Metadata model creation failed
--
-- Conversion Changes:
-- 1. Removed DECLARE statement
-- 2. Changed EXEC @var = [dbo].[proc] to SELECT function()
-- 3. Removed [dbo] schema qualification
-- 4. Kept @param syntax (Npgsql supports this)
--
-- PostgreSQL Function Call Assumptions:
-- - uspDeleteAuthor exists as a PostgreSQL function
-- - Function returns integer (number of rows affected)
-- - Function is in the default search_path
-- ----------------------------------------------------------------------------
SELECT uspDeleteAuthor(@BusinessEntityID);


-- ----------------------------------------------------------------------------
-- STATEMENT 4: Select Authors by Hire Year with Age Calculation
-- ----------------------------------------------------------------------------
-- Original SQL (SQL Server):
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, 
--        DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age 
-- FROM bobsbookstore_dbo.author 
-- WHERE DATEPART(YEAR, HireDate) = @HireDate;
--
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Error: Metadata model creation failed
--
-- Conversion Changes:
-- 1. FORMAT(date, 'yyyy-MM-dd HH:mm:ss') -> TO_CHAR(date, 'YYYY-MM-DD HH24:MI:SS')
--    - PostgreSQL uses different format codes
--    - HH24 for 24-hour format instead of HH
-- 2. DATEDIFF(YEAR, BirthDate, GETDATE()) -> DATE_PART('year', AGE(NOW(), BirthDate))
--    - PostgreSQL uses AGE() function to calculate interval
--    - DATE_PART() extracts the year component
-- 3. GETDATE() -> NOW()
--    - PostgreSQL standard function for current timestamp
-- 4. DATEPART(YEAR, HireDate) -> EXTRACT(YEAR FROM HireDate)
--    - EXTRACT is the PostgreSQL/ANSI SQL standard
--
-- Notes:
-- - This is the most complex conversion with multiple function changes
-- - All date/time functions converted to PostgreSQL equivalents
-- ----------------------------------------------------------------------------
SELECT BusinessEntityID, 
       TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, 
       DATE_PART('year', AGE(NOW(), BirthDate)) AS Age 
FROM bobsbookstore_dbo.author 
WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;


-- ============================================================================
-- FILE: app/Bookstore.Web/Controllers/ProductsController.cs
-- ============================================================================

-- ----------------------------------------------------------------------------
-- STATEMENT 5: Get All Products (Stored Procedure Call)
-- ----------------------------------------------------------------------------
-- Original SQL (SQL Server):
-- EXEC [dbo].[uspGetProductData];
--
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Error: Metadata model creation failed
--
-- Conversion Changes:
-- 1. Changed EXEC [dbo].[proc] to SELECT * FROM function()
-- 2. Removed [dbo] schema qualification
-- 3. Added () for function call syntax
--
-- PostgreSQL Function Call Assumptions:
-- - uspGetProductData exists as a PostgreSQL function
-- - Function returns a table/result set
-- - SELECT * FROM function() pattern retrieves the result set
-- - Function is in the default search_path
-- ----------------------------------------------------------------------------
SELECT * FROM uspGetProductData();


-- ============================================================================
-- CONVERSION SUMMARY
-- ============================================================================
/*
Statements Converted: 5/5 (100%)

Conversion Methods:
- DMS Tool Success: 0
- Manual After DMS Failure: 5

SQL Server Features Converted to PostgreSQL:
1. Stored Procedure EXEC syntax -> Function call with SELECT
2. DECLARE/EXEC/SELECT pattern -> SELECT function() 
3. [dbo] schema references -> Removed (rely on search_path)
4. FORMAT() function -> TO_CHAR() with PostgreSQL format codes
5. DATEDIFF() function -> DATE_PART('year', AGE())
6. GETDATE() function -> NOW()
7. DATEPART() function -> EXTRACT()

Schema Handling:
- bobsbookstore_dbo.author: Kept as-is (pending schema verification)
- [dbo] references: Removed (PostgreSQL uses search_path)

Parameter Syntax:
- @param notation: Kept (Npgsql supports this syntax)

Stored Procedures -> Functions:
- uspUpdateAuthorPersonalInfo: Now called as SELECT function()
- uspDeleteAuthor: Now called as SELECT function()
- uspGetProductData: Now called as SELECT * FROM function()

CRITICAL NOTES:
1. All conversions are MANUAL due to DMS tool metadata errors
2. All statement pairs MUST be validated in Step 4 with SQL Equivalency tool
3. Stored procedure conversions assume corresponding PostgreSQL functions exist
4. Schema names may need adjustment based on actual PostgreSQL schema
5. Function names preserved from SQL Server (may need adjustment)

Next Steps:
- Validate ALL statement pairs with SQL Equivalency tool (Step 4)
- Verify PostgreSQL functions exist for stored procedure calls
- Confirm schema names match actual PostgreSQL database
- Test all converted statements against PostgreSQL database
*/

-- ============================================================================
-- END OF CONVERSIONS
-- ============================================================================
