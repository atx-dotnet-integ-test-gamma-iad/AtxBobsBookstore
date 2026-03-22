-- ============================================================================
-- Extracted SQL Statements from BobsBookstore .NET Application
-- Source: MS SQL Server statements found in C# application code
-- Date: 2026-03-22
-- Purpose: Catalog of all SQL statements requiring conversion to PostgreSQL
-- Total Statements: 5
-- ============================================================================

-- ============================================================================
-- Statement 1
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: 163
-- Description: Stored procedure call to update author personal information
--              using MS SQL DECLARE/EXEC syntax
-- ============================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ============================================================================
-- Statement 2
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: 187
-- Description: Simple SELECT to retrieve all authors from the author table
-- ============================================================================
SELECT * FROM [dbo].[author]

-- ============================================================================
-- Statement 3
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: 208
-- Description: Stored procedure call to delete an author
--              using MS SQL DECLARE/EXEC syntax
-- ============================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ============================================================================
-- Statement 4
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: 228
-- Description: SELECT with date functions filtering by hire year with age calculation
-- ============================================================================
SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[author] WHERE YEAR(HireDate) = @HireDate;

-- ============================================================================
-- Statement 5
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: 34
-- Description: Stored procedure call to get product data
--              using MS SQL EXEC syntax
-- ============================================================================
EXEC [dbo].[uspGetProductData];
