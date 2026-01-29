-- ============================================================================
-- Converted SQL Statements Catalog
-- Date: 2026-01-29
-- Target Database: PostgreSQL
-- Conversion Tool: DMS MCP Tool + Manual Conversion
-- ============================================================================

-- ----------------------------------------------------------------------------
-- STATEMENT 1: STMT_001
-- ----------------------------------------------------------------------------
-- Statement ID: STMT_001
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Status: error - Metadata model creation failed
-- Schema Transformation: [dbo].[uspUpdateAuthorPersonalInfo] → uspUpdateAuthorPersonalInfo
-- ----------------------------------------------------------------------------

-- ORIGINAL MS SQL:
-- DECLARE @rowsAffected INT;
-- EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
-- SELECT @rowsAffected;

-- CONVERTED POSTGRESQL:
SELECT uspUpdateAuthorPersonalInfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Conversion Notes:
-- - Changed EXEC statement to SELECT function call
-- - Removed DECLARE variable declaration
-- - Removed [dbo] schema qualifier
-- - Function parameters preserved with @ prefix for consistency with ADO.NET

-- ----------------------------------------------------------------------------
-- STATEMENT 2: STMT_002
-- ----------------------------------------------------------------------------
-- Statement ID: STMT_002
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Status: error - Metadata model creation failed
-- Schema Transformation: None (table name unchanged)
-- ----------------------------------------------------------------------------

-- ORIGINAL MS SQL:
-- SELECT * FROM Author;

-- CONVERTED POSTGRESQL:
SELECT * FROM Author;

-- Conversion Notes:
-- - No conversion required
-- - Statement is PostgreSQL compatible as-is
-- - No T-SQL specific features used

-- ----------------------------------------------------------------------------
-- STATEMENT 3: STMT_003
-- ----------------------------------------------------------------------------
-- Statement ID: STMT_003
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Status: error - Metadata model creation failed
-- Schema Transformation: [dbo].[uspDeleteAuthor] → uspDeleteAuthor
-- ----------------------------------------------------------------------------

-- ORIGINAL MS SQL:
-- DECLARE @rowsAffected INT;
-- EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
-- SELECT @rowsAffected;

-- CONVERTED POSTGRESQL:
SELECT uspDeleteAuthor(@BusinessEntityID);

-- Conversion Notes:
-- - Changed EXEC statement to SELECT function call
-- - Removed DECLARE variable declaration
-- - Removed [dbo] schema qualifier
-- - Function returns result directly

-- ----------------------------------------------------------------------------
-- STATEMENT 4: STMT_004
-- ----------------------------------------------------------------------------
-- Statement ID: STMT_004
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Status: error - Metadata model creation failed
-- Schema Transformation: None (table name unchanged)
-- ----------------------------------------------------------------------------

-- ORIGINAL MS SQL:
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- CONVERTED POSTGRESQL:
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, DATE_PART('year', AGE(CURRENT_DATE, BirthDate)) AS Age FROM Author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- Conversion Notes:
-- - FORMAT(date, pattern) → TO_CHAR(date, 'YYYY-MM-DD HH24:MI:SS')
-- - DATEDIFF(YEAR, BirthDate, GETDATE()) → DATE_PART('year', AGE(CURRENT_DATE, BirthDate))
-- - GETDATE() → CURRENT_DATE
-- - DATEPART(YEAR, date) → EXTRACT(YEAR FROM date)
-- - All T-SQL date/time functions replaced with PostgreSQL equivalents

-- ----------------------------------------------------------------------------
-- STATEMENT 5: STMT_005
-- ----------------------------------------------------------------------------
-- Statement ID: STMT_005
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Status: error - Metadata model creation failed
-- Schema Transformation: [dbo].[uspGetProductData] → uspGetProductData
-- ----------------------------------------------------------------------------

-- ORIGINAL MS SQL:
-- EXEC [dbo].[uspGetProductData];

-- CONVERTED POSTGRESQL:
SELECT * FROM uspGetProductData();

-- Conversion Notes:
-- - Changed EXEC to SELECT * FROM function()
-- - Removed [dbo] schema qualifier
-- - Added () to indicate function call
-- - Function must return set of records in PostgreSQL

-- ============================================================================
-- CONVERSION SUMMARY
-- ============================================================================
-- Total Statements Converted: 5
-- DMS Tool Successful: 0
-- Manual Conversions After DMS Failure: 5
-- Schema Transformations Applied: 3 (removed [dbo] qualifiers)
-- T-SQL Functions Converted: 4 (FORMAT, DATEDIFF, GETDATE, DATEPART)
-- Stored Procedure Calls Updated: 3 (EXEC to SELECT)
-- ============================================================================
