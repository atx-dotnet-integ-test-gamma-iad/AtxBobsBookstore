-- ============================================================================
-- Extracted SQL Statements Catalog
-- Date: 2025-01-29
-- Source: BobsBookstore ADO.NET Application
-- Purpose: Complete catalog of all MS SQL Server statements for DMS conversion
-- ============================================================================

-- ----------------------------------------------------------------------------
-- STATEMENT 1
-- ----------------------------------------------------------------------------
-- Statement ID: STMT_001
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~160
-- Description: Stored procedure call with DECLARE and OUTPUT parameters
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- ----------------------------------------------------------------------------
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- ----------------------------------------------------------------------------
-- STATEMENT 2
-- ----------------------------------------------------------------------------
-- Statement ID: STMT_002
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~185
-- Description: Simple SELECT query to retrieve all authors
-- Parameters: None
-- ----------------------------------------------------------------------------
SELECT * FROM Author;

-- ----------------------------------------------------------------------------
-- STATEMENT 3
-- ----------------------------------------------------------------------------
-- Statement ID: STMT_003
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~202
-- Description: Stored procedure call to delete author with DECLARE and OUTPUT parameters
-- Parameters: @BusinessEntityID (int)
-- ----------------------------------------------------------------------------
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- ----------------------------------------------------------------------------
-- STATEMENT 4
-- ----------------------------------------------------------------------------
-- Statement ID: STMT_004
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~221
-- Description: Complex query with T-SQL specific functions: FORMAT, DATEDIFF, GETDATE, DATEPART
-- Parameters: @HireDate (int - representing year)
-- ----------------------------------------------------------------------------
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ----------------------------------------------------------------------------
-- STATEMENT 5
-- ----------------------------------------------------------------------------
-- Statement ID: STMT_005
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: ~31
-- Description: Stored procedure call to retrieve product data
-- Parameters: None
-- ----------------------------------------------------------------------------
EXEC [dbo].[uspGetProductData];

-- ============================================================================
-- EXTRACTION SUMMARY
-- ============================================================================
-- Total Statements Extracted: 5
-- Inline SQL Statements: 1 (STMT_002)
-- Stored Procedure Calls: 4 (STMT_001, STMT_003, STMT_005, and complex query STMT_004)
-- Statements with Parameters: 4 (STMT_001, STMT_003, STMT_004, STMT_005)
-- Statements with T-SQL Functions: 1 (STMT_004)
-- ============================================================================
