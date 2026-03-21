-- ============================================================
-- Extracted Original MS SQL Server Statements
-- Source: BobsBookstore Application
-- ============================================================

-- Statement 1: EditUsingStoredProcedure (AuthorsController.cs, line ~163)
-- Original MS SQL Server:
EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;

-- Statement 2: FindAllAuthorsEmbeddedSql (AuthorsController.cs, line ~187)
-- Original MS SQL Server:
SELECT * FROM [dbo].[Author];

-- Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs, line ~207)
-- Original MS SQL Server:
EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID;

-- Statement 4: SelectAuthorsByHireYear (AuthorsController.cs, line ~227)
-- Original MS SQL Server:
SELECT BusinessEntityID, CONVERT(VARCHAR(20), ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate;

-- Statement 5: FindAllProducts (ProductsController.cs, line ~34)
-- Original MS SQL Server:
EXEC [dbo].[uspGetProductData];
