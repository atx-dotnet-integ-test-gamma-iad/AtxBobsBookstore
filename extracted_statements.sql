-- Extracted SQL Statements Catalog
-- Source: BobsBookstore .NET Application
-- Extraction Date: 2026-03-04
-- Total Statements: 5

-- ============================================================
-- Statement 1: AuthorsController.cs - EditUsingStoredProcedure method (line 163)
-- Description: Stored procedure call to update author personal info
-- ============================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ============================================================
-- Statement 2: AuthorsController.cs - FindAllAuthorsEmbeddedSql method (line 187)
-- Description: Select all authors
-- ============================================================
SELECT * FROM [dbo].[Author]

-- ============================================================
-- Statement 3: AuthorsController.cs - DeleteAuthorEmbeddedSql method (line 208)
-- Description: Stored procedure call to delete an author
-- ============================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ============================================================
-- Statement 4: AuthorsController.cs - SelectAuthorsByHireYear method (line 228)
-- Description: Complex SELECT with SQL Server functions (FORMAT, DATEDIFF, DATEPART, GETDATE)
-- ============================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================
-- Statement 5: ProductsController.cs - FindAllProducts method (line 34)
-- Description: Stored procedure call to get product data
-- ============================================================
EXEC [dbo].[uspGetProductData];
