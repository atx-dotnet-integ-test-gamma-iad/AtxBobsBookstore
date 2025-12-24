-- ====================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Bob's Bookstore - SQL Server to PostgreSQL Migration
-- Total Statements: 5
-- ====================================================================

-- ====================================================================
-- STATEMENT 1
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: ~164
-- Method: EditUsingStoredProcedure
-- Description: Stored procedure call to update author personal information
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- ====================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ====================================================================
-- STATEMENT 2
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: ~187
-- Method: FindAllAuthorsEmbeddedSql
-- Description: Select all authors from the author table
-- Parameters: None
-- ====================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ====================================================================
-- STATEMENT 3
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: ~202
-- Method: DeleteAuthorEmbeddedSql
-- Description: Stored procedure call to delete an author
-- Parameters: @BusinessEntityID (int)
-- ====================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ====================================================================
-- STATEMENT 4
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: ~219
-- Method: SelectAuthorsByHireYear
-- Description: Select authors with formatted dates and calculated age, filtered by hire year
-- Uses SQL Server specific functions: FORMAT, DATEDIFF, GETDATE, DATEPART
-- Parameters: @HireDate (int - year)
-- ====================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ====================================================================
-- STATEMENT 5
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Line Number: ~31
-- Method: FindAllProducts
-- Description: Stored procedure call to get all product data
-- Parameters: None
-- ====================================================================
EXEC [dbo].[uspGetProductData];

-- ====================================================================
-- END OF EXTRACTED STATEMENTS CATALOG
-- ====================================================================
