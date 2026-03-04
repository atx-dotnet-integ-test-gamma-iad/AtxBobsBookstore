-- ============================================================================
-- Extracted SQL Statements from BobsBookstore Application
-- Source Database: Microsoft SQL Server
-- Extraction Date: 2026-03-04
-- ============================================================================

-- Statement 1: EditUsingStoredProcedure (AuthorsController.cs, Line 163)
-- Method: EditUsingStoredProcedure
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement 2: FindAllAuthorsEmbeddedSql (AuthorsController.cs, Line 187)
-- Method: FindAllAuthorsEmbeddedSql
SELECT * FROM bobsbookstore_dbo.author

-- Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs, Line 208)
-- Method: DeleteAuthorEmbeddedSql
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement 4: SelectAuthorsByHireYear (AuthorsController.cs, Line 228)
-- Method: SelectAuthorsByHireYear
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Statement 5: FindAllProducts (ProductsController.cs, Line 34)
-- Method: FindAllProducts
EXEC [dbo].[uspGetProductData];
