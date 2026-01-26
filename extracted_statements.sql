-- ============================================================================
-- COMPREHENSIVE SQL STATEMENT EXTRACTION CATALOG
-- Migration: Microsoft SQL Server to PostgreSQL
-- Project: BobsBookstore ADO.NET Application
-- Date: 2026-01-26
-- ============================================================================
-- This file contains ALL SQL statements extracted from the codebase for
-- conversion through the DMS MCP tool and validation through the SQL 
-- Equivalency tool.
-- ============================================================================

-- ============================================================================
-- TOTAL STATEMENTS EXTRACTED: 5
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
-- Type: EXEC (Stored Procedure Call with DECLARE and SELECT)
-- Parameters: @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
-- Context: Update author personal information using stored procedure
-- Status: Currently converted in code (needs DMS validation and equivalency check)
-- ----------------------------------------------------------------------------
-- ORIGINAL MS SQL SERVER STATEMENT:
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- ----------------------------------------------------------------------------
-- STATEMENT #2
-- Source File: AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~183
-- Type: SELECT
-- Parameters: None
-- Context: Retrieve all authors from database
-- Status: Currently converted in code (needs DMS validation and equivalency check)
-- ----------------------------------------------------------------------------
-- ORIGINAL MS SQL SERVER STATEMENT:
SELECT * FROM bobsbookstore_dbo.author

-- ----------------------------------------------------------------------------
-- STATEMENT #3
-- Source File: AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~200-201
-- Type: EXEC (Stored Procedure Call with DECLARE and SELECT)
-- Parameters: @BusinessEntityID
-- Context: Delete author using stored procedure
-- Status: Currently converted in code (needs DMS validation and equivalency check)
-- ----------------------------------------------------------------------------
-- ORIGINAL MS SQL SERVER STATEMENT:
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- ----------------------------------------------------------------------------
-- STATEMENT #4
-- Source File: AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~220-221
-- Type: SELECT with date functions
-- Parameters: @HireDate
-- Context: Select authors by hire year with formatted dates and age calculation
-- Uses date functions: FORMAT, DATEDIFF, GETDATE, DATEPART
-- Status: Currently converted in code (needs DMS validation and equivalency check)
-- ----------------------------------------------------------------------------
-- ORIGINAL MS SQL SERVER STATEMENT:
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

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
-- Parameters: None
-- Context: Retrieve all products using stored procedure
-- Status: NOT YET CONVERTED - Still uses SQL Server syntax
-- ----------------------------------------------------------------------------
-- ORIGINAL MS SQL SERVER STATEMENT:
EXEC [dbo].[uspGetProductData];

-- ============================================================================
-- END OF EXTRACTION CATALOG
-- ============================================================================

-- EXTRACTION SUMMARY:
-- -------------------
-- Total Statements Extracted: 5
-- Files Scanned: 2
-- 
-- By Type:
-- - EXEC (Stored Procedure Calls): 3
-- - SELECT (Simple): 1
-- - SELECT (Complex with date functions): 1
--
-- By Status:
-- - Already converted (needs validation): 4
-- - Not yet converted: 1
--
-- CRITICAL NOTES:
-- ---------------
-- 1. ALL statements MUST be processed through DMS MCP tool for conversion
-- 2. ALL statement pairs MUST be validated through SQL Equivalency tool
-- 3. Statements #1-4 are already converted in code but need:
--    - Verification through DMS tool
--    - Equivalency validation
-- 4. Statement #5 requires immediate conversion from SQL Server EXEC syntax
--
-- Schema: bobsbookstore_dbo
-- ============================================================================
