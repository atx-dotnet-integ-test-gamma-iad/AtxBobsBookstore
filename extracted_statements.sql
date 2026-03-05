-- Extracted SQL Statements from BobsBookstore .NET Application
-- Source: MS SQL Server to PostgreSQL Migration
-- These are the ORIGINAL MS SQL Server statements before conversion
-- Total Statements: 5

-- =================================================================
-- Statement 1: FindAllAuthorsEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql()
-- Line: ~189
-- Description: Retrieves all authors using a simple SELECT query
-- =================================================================
SELECT * FROM dbo.Author

-- =================================================================
-- Statement 2: EditUsingStoredProcedure
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure()
-- Line: ~162
-- Description: Calls stored procedure to update author personal info
-- =================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- =================================================================
-- Statement 3: DeleteAuthorEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql()
-- Line: ~205
-- Description: Calls stored procedure to delete an author
-- =================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- =================================================================
-- Statement 4: SelectAuthorsByHireYear
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear()
-- Line: ~226
-- Description: Selects authors by hire year with formatted date and age calculation
-- =================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- =================================================================
-- Statement 5: FindAllProducts
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts()
-- Line: ~35
-- Description: Calls stored procedure to get product data
-- =================================================================
EXEC [dbo].[uspGetProductData];
