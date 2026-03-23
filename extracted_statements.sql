-- Extracted SQL Statements Catalog
-- Source: BobsBookstore .NET Application
-- Purpose: Catalog of all original MS SQL Server statements extracted for migration
-- Date: 2026-03-23

-- ============================================================
-- Statement 1: EditUsingStoredProcedure
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~143 (string sql = @"...")
-- Description: Calls stored procedure to update author personal info
-- ============================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ============================================================
-- Statement 2: FindAllAuthorsEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~161 (string sql = @"...")
-- Description: Selects all authors from the Author table
-- ============================================================
SELECT * FROM [dbo].[Author]

-- ============================================================
-- Statement 3: DeleteAuthorEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~178 (string sql = @"...")
-- Description: Calls stored procedure to delete an author
-- ============================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ============================================================
-- Statement 4: SelectAuthorsByHireYear
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~195 (string sql = @"...")
-- Description: Selects authors by hire year with date formatting and age calculation
-- ============================================================
SELECT BusinessEntityID, CONVERT(VARCHAR(10), ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate

-- ============================================================
-- Statement 5: FindAllProducts
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: ~33 (string sql = @"...")
-- Description: Calls stored procedure to get all product data
-- ============================================================
EXEC [dbo].[uspGetProductData];
