-- ================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Microsoft SQL Server to PostgreSQL Migration
-- Generated: Step 1 - Extract and Catalog All SQL Statements
-- ================================================================
-- This file contains ALL SQL statements extracted from the codebase
-- Each statement is documented with its location, context, and purpose
-- ================================================================

-- ================================================================
-- STATEMENT 1: EditUsingStoredProcedure - Update Author Personal Info
-- ================================================================
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~147 (approximate)
-- Purpose: Update author personal information using stored procedure
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- Return Type: Number of rows affected
-- Complexity: Medium - Stored procedure call with DECLARE, EXEC, and SELECT pattern
-- Notes: Uses SQL Server stored procedure uspUpdateAuthorPersonalInfo
-- ----------------------------------------------------------------
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;
-- ================================================================

-- ================================================================
-- STATEMENT 2: FindAllAuthorsEmbeddedSql - Select All Authors
-- ================================================================
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~163 (approximate)
-- Purpose: Retrieve all authors from the database
-- Parameters: None
-- Return Type: List<Author>
-- Complexity: Easy - Simple SELECT statement
-- Notes: Uses PostgreSQL schema notation bobsbookstore_dbo.author
-- ----------------------------------------------------------------
SELECT * FROM bobsbookstore_dbo.author
-- ================================================================

-- ================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql - Delete Author
-- ================================================================
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~179 (approximate)
-- Purpose: Delete an author using stored procedure
-- Parameters: @BusinessEntityID (int)
-- Return Type: Number of rows affected
-- Complexity: Medium - Stored procedure call with DECLARE, EXEC, and SELECT pattern
-- Notes: Uses SQL Server stored procedure uspDeleteAuthor
-- ----------------------------------------------------------------
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;
-- ================================================================

-- ================================================================
-- STATEMENT 4: SelectAuthorsByHireYear - Authors Hired in Specific Year with Age Calculation
-- ================================================================
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~196 (approximate)
-- Purpose: Retrieve authors hired in a specific year with age calculation and formatted date
-- Parameters: @HireDate (int - year)
-- Return Type: List<AuthorAgeResult>
-- Complexity: Hard - Uses SQL Server specific functions: FORMAT, DATEDIFF, GETDATE, DATEPART
-- Notes: 
--   - FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') - SQL Server date formatting
--   - DATEDIFF(YEAR, BirthDate, GETDATE()) - Calculate age in years
--   - GETDATE() - Current date/time
--   - DATEPART(YEAR, HireDate) - Extract year from hire date
-- ----------------------------------------------------------------
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- ================================================================

-- ================================================================
-- STATEMENT 5: FindAllProducts - Get All Products via Stored Procedure
-- ================================================================
-- File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: ~31 (approximate)
-- Purpose: Retrieve all products using stored procedure
-- Parameters: None
-- Return Type: List<Product>
-- Complexity: Easy - Simple stored procedure call
-- Notes: Uses SQL Server stored procedure uspGetProductData
-- ----------------------------------------------------------------
EXEC [dbo].[uspGetProductData];
-- ================================================================

-- ================================================================
-- SUMMARY
-- ================================================================
-- Total SQL Statements Extracted: 5
-- 
-- By Complexity:
--   - Easy: 2 statements (STATEMENT 2, STATEMENT 5)
--   - Medium: 2 statements (STATEMENT 1, STATEMENT 3)
--   - Hard: 1 statement (STATEMENT 4)
-- 
-- By Type:
--   - Stored Procedure Calls: 3 (STATEMENT 1, STATEMENT 3, STATEMENT 5)
--   - Direct SELECT Queries: 2 (STATEMENT 2, STATEMENT 4)
-- 
-- SQL Server Specific Features Used:
--   - Stored Procedures: uspUpdateAuthorPersonalInfo, uspDeleteAuthor, uspGetProductData
--   - Date Functions: GETDATE(), DATEDIFF(), DATEPART(), FORMAT()
--   - DECLARE/EXEC pattern for return values
--   - [dbo] schema references
-- 
-- PostgreSQL Schema Already Used:
--   - bobsbookstore_dbo schema notation (indicates partial migration)
-- ================================================================
