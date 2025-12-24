-- ============================================================================
-- SQL Statement Extraction Catalog
-- Migration from SQL Server to PostgreSQL
-- ============================================================================
-- Total Statements Extracted: 5
-- Extraction Date: 2024
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: Update Author Personal Info (Stored Procedure Call)
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line Number: ~160
-- Context: Stored procedure call with DECLARE and EXEC statements
-- Parameters: @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
-- SQL Server Features Used: DECLARE, EXEC, stored procedure, variable assignment
-- ============================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 2: Find All Authors (Simple SELECT)
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line Number: ~185
-- Context: Simple SELECT statement to retrieve all authors
-- Parameters: None
-- SQL Server Features Used: None (standard SQL)
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================================
-- STATEMENT 3: Delete Author (Stored Procedure Call)
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line Number: ~203
-- Context: Stored procedure call with DECLARE and EXEC statements
-- Parameters: @BusinessEntityID
-- SQL Server Features Used: DECLARE, EXEC, stored procedure, variable assignment
-- ============================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 4: Select Authors By Hire Year (Complex SELECT with SQL Server Functions)
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line Number: ~220
-- Context: Complex SELECT with date formatting and date functions
-- Parameters: @HireDate
-- SQL Server Features Used: FORMAT, DATEDIFF, DATEPART, GETDATE
-- ============================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================================
-- STATEMENT 5: Get Product Data (Stored Procedure Call)
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line Number: ~32
-- Context: Simple stored procedure execution
-- Parameters: None
-- SQL Server Features Used: EXEC, stored procedure
-- ============================================================================
EXEC [dbo].[uspGetProductData];

-- ============================================================================
-- EXTRACTION SUMMARY
-- ============================================================================
-- Total Statements: 5
-- Stored Procedure Calls: 3 (Statements 1, 3, 5)
-- Simple SELECT Statements: 1 (Statement 2)
-- Complex SELECT Statements: 1 (Statement 4)
-- Statements with Parameters: 3 (Statements 1, 3, 4)
-- Statements without Parameters: 2 (Statements 2, 5)
-- 
-- SQL Server Specific Features:
-- - DECLARE statements: 2
-- - EXEC statements: 3
-- - FORMAT function: 1
-- - DATEDIFF function: 1
-- - DATEPART function: 1
-- - GETDATE function: 1
-- ============================================================================
