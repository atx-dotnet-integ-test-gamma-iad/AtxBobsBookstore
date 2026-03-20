-- ============================================================
-- Extracted SQL Statements from BobsBookstore Application
-- Source: Microsoft SQL Server (MS SQL)
-- Date: 2026-03-20 (Re-extraction attempt)
-- Total Statements Found: 5
-- ============================================================
-- Exhaustive search performed across all .cs files in:
--   - sourceCode/app/Bookstore.Web/Controllers/*.cs
--   - sourceCode/app/Bookstore.Web/Areas/Admin/Controllers/*.cs
--   - sourceCode/app/Bookstore.Data/Repositories/*.cs
--   - sourceCode/app/Bookstore.Web/Startup/*.cs
--   - sourceCode/app/Bookstore.Data/*.cs
-- Search patterns: FromSqlRaw, ExecuteSqlRaw, SqlQueryRaw, ExecuteSqlRawAsync,
--                  inline SQL strings (SELECT, INSERT, UPDATE, DELETE, EXEC, DECLARE)
-- Result: Only 5 raw SQL statements found. All other data access uses EF Core LINQ.
-- ============================================================

-- Statement 1: AuthorsController.cs - EditUsingStoredProcedure method
-- Location: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- EF API: ExecuteSqlRawAsync
-- Description: Calls stored procedure to update author personal info
EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender

-- Statement 2: AuthorsController.cs - FindAllAuthorsEmbeddedSql method
-- Location: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- EF API: SqlQueryRaw<Author>
-- Description: Retrieves all authors
SELECT * FROM Author

-- Statement 3: AuthorsController.cs - DeleteAuthorEmbeddedSql method
-- Location: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- EF API: ExecuteSqlRawAsync
-- Description: Calls stored procedure to delete an author
EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID

-- Statement 4: AuthorsController.cs - SelectAuthorsByHireYear method
-- Location: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- EF API: SqlQueryRaw<AuthorAgeResult>
-- Description: Selects authors by hire year with formatted date and calculated age
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Statement 5: ProductsController.cs - FindAllProducts method
-- Location: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- EF API: SqlQueryRaw<Product>
-- Description: Calls stored procedure to get product data
EXEC [dbo].[uspGetProductData];
