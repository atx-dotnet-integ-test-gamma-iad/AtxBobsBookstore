-- Extracted SQL Statements from BobsBookstore Application
-- Source: Microsoft SQL Server
-- Extraction Date: 2026-03-22

-- Statement 1: FindAllAuthorsEmbeddedSql (AuthorsController.cs)
-- Location: app/Bookstore.Web/Controllers/AuthorsController.cs, FindAllAuthorsEmbeddedSql method
SELECT * FROM Author;

-- Statement 2: EditUsingStoredProcedure (AuthorsController.cs)
-- Location: app/Bookstore.Web/Controllers/AuthorsController.cs, EditUsingStoredProcedure method
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs)
-- Location: app/Bookstore.Web/Controllers/AuthorsController.cs, DeleteAuthorEmbeddedSql method
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement 4: SelectAuthorsByHireYear (AuthorsController.cs)
-- Location: app/Bookstore.Web/Controllers/AuthorsController.cs, SelectAuthorsByHireYear method
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Statement 5: FindAllProducts (ProductsController.cs)
-- Location: app/Bookstore.Web/Controllers/ProductsController.cs, FindAllProducts method
EXEC [dbo].[uspGetProductData];
