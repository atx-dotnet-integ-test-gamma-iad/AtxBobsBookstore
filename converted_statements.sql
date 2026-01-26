-- ============================================================================
-- COMPREHENSIVE SQL STATEMENT CONVERSION CATALOG
-- Migration: Microsoft SQL Server to PostgreSQL
-- Project: BobsBookstore ADO.NET Application
-- Date: 2026-01-26
-- ============================================================================
-- This file contains ALL SQL statements converted from SQL Server to
-- PostgreSQL syntax. Each statement was processed through the DMS MCP tool.
-- Due to DMS metadata model failures, manual conversions were applied using
-- PostgreSQL best practices.
-- ============================================================================

-- ============================================================================
-- TOTAL STATEMENTS CONVERTED: 5
-- ============================================================================
-- Conversion Methods:
-- - DMS_TOOL: Successfully converted by DMS MCP tool
-- - MANUAL_AFTER_DMS_FAILURE: DMS tool failed, manual conversion applied
-- ============================================================================

-- ============================================================================
-- SOURCE FILE: AuthorsController.cs
-- FILE PATH: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- ============================================================================

-- ----------------------------------------------------------------------------
-- STATEMENT #1
-- Source File: AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~151-152
-- Type: EXEC (Stored Procedure Call)
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Parameters: @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
-- ----------------------------------------------------------------------------
-- ORIGINAL MS SQL SERVER STATEMENT:
-- DECLARE @rowsAffected INT;
-- EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
-- SELECT @rowsAffected;

-- CONVERTED POSTGRESQL STATEMENT:
SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- CONVERSION NOTES:
-- - SQL Server EXEC with return value converted to PostgreSQL function call in SELECT
-- - DECLARE and SELECT @rowsAffected removed (not needed in PostgreSQL)
-- - Stored procedure migrated to PostgreSQL function in schema bobsbookstore_dbo
-- - PostgreSQL functions are called via SELECT, not EXEC

-- ----------------------------------------------------------------------------
-- STATEMENT #2
-- Source File: AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~183
-- Type: SELECT
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Parameters: None
-- ----------------------------------------------------------------------------
-- ORIGINAL MS SQL SERVER STATEMENT:
-- SELECT * FROM bobsbookstore_dbo.author

-- CONVERTED POSTGRESQL STATEMENT:
SELECT * FROM bobsbookstore_dbo.author

-- CONVERSION NOTES:
-- - Standard SELECT statement compatible with both SQL Server and PostgreSQL
-- - No syntax changes required
-- - Schema qualification retained

-- ----------------------------------------------------------------------------
-- STATEMENT #3
-- Source File: AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~200-201
-- Type: EXEC (Stored Procedure Call)
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Parameters: @BusinessEntityID
-- ----------------------------------------------------------------------------
-- ORIGINAL MS SQL SERVER STATEMENT:
-- DECLARE @rowsAffected INT;
-- EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
-- SELECT @rowsAffected;

-- CONVERTED POSTGRESQL STATEMENT:
SELECT bobsbookstore_dbo.uspDeleteAuthor(@BusinessEntityID);

-- CONVERSION NOTES:
-- - SQL Server EXEC with return value converted to PostgreSQL function call in SELECT
-- - DECLARE and SELECT @rowsAffected removed (not needed in PostgreSQL)
-- - Stored procedure migrated to PostgreSQL function in schema bobsbookstore_dbo
-- - PostgreSQL functions are called via SELECT, not EXEC

-- ----------------------------------------------------------------------------
-- STATEMENT #4
-- Source File: AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~220-221
-- Type: SELECT with complex date functions
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Parameters: @HireDate
-- ----------------------------------------------------------------------------
-- ORIGINAL MS SQL SERVER STATEMENT:
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- CONVERTED POSTGRESQL STATEMENT:
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, DATE_PART('year', AGE(CURRENT_TIMESTAMP, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- CONVERSION NOTES:
-- - FORMAT() → TO_CHAR() with PostgreSQL format pattern
-- - 'yyyy-MM-dd HH:mm:ss' → 'YYYY-MM-DD HH24:MI:SS' (HH24 for 24-hour format)
-- - DATEDIFF(YEAR, BirthDate, GETDATE()) → DATE_PART('year', AGE(CURRENT_TIMESTAMP, BirthDate))
-- - DATEPART(YEAR, HireDate) → EXTRACT(YEAR FROM HireDate)
-- - GETDATE() → CURRENT_TIMESTAMP
-- - Schema qualification retained

-- ============================================================================
-- SOURCE FILE: ProductsController.cs
-- FILE PATH: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- ============================================================================

-- ----------------------------------------------------------------------------
-- STATEMENT #5
-- Source File: ProductsController.cs
-- Method: FindAllProducts
-- Line: ~32
-- Type: EXEC (Stored Procedure Call)
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Parameters: None
-- ----------------------------------------------------------------------------
-- ORIGINAL MS SQL SERVER STATEMENT:
-- EXEC [dbo].[uspGetProductData];

-- CONVERTED POSTGRESQL STATEMENT:
SELECT * FROM bobsbookstore_dbo.uspGetProductData();

-- CONVERSION NOTES:
-- - SQL Server EXEC stored procedure converted to PostgreSQL function call
-- - PostgreSQL functions that return result sets: SELECT * FROM function_name()
-- - Stored procedure migrated to PostgreSQL function in schema bobsbookstore_dbo
-- - Empty parentheses required in PostgreSQL even when no parameters
-- - Function returns a table/record set

-- ============================================================================
-- END OF CONVERSION CATALOG
-- ============================================================================

-- CONVERSION SUMMARY:
-- -------------------
-- Total Statements Converted: 5
-- 
-- By Conversion Method:
-- - DMS_TOOL: 0 (all DMS attempts failed with metadata model errors)
-- - MANUAL_AFTER_DMS_FAILURE: 5
--
-- By Type:
-- - EXEC (Stored Procedure Calls): 3 → SELECT function_name()
-- - SELECT (Simple): 1 → No changes needed
-- - SELECT (Complex with date functions): 1 → Date function conversions
--
-- Key Conversion Patterns:
-- 1. EXEC stored_proc → SELECT schema.function_name()
-- 2. EXEC stored_proc → SELECT * FROM schema.function_name() (for result sets)
-- 3. FORMAT() → TO_CHAR()
-- 4. DATEDIFF() → AGE() + DATE_PART()
-- 5. DATEPART() → EXTRACT()
-- 6. GETDATE() → CURRENT_TIMESTAMP
--
-- All conversions follow PostgreSQL best practices and are based on standard
-- SQL Server to PostgreSQL migration patterns.
--
-- See dms_conversion_failures.log for detailed DMS tool output and conversion
-- rationale for each statement.
-- ============================================================================
