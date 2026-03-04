-- =====================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Source: BobsBookstore .NET Application
-- Purpose: Comprehensive catalog of all original MS SQL Server statements
-- Date: 2026-03-04
-- Total Statements: 5
-- Files containing raw SQL: 2
--   1. AuthorsController.cs (4 SQL statements)
--   2. ProductsController.cs (1 SQL statement)
-- =====================================================================

-- =====================================================================
-- Statement 1
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql()
-- Line: ~187
-- =====================================================================
SELECT * FROM Author

-- =====================================================================
-- Statement 2
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql()
-- Line: ~208
-- =====================================================================
EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID

-- =====================================================================
-- Statement 3
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure()
-- Line: ~163
-- =====================================================================
EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender

-- =====================================================================
-- Statement 4
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear()
-- Line: ~228
-- =====================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate

-- =====================================================================
-- Statement 5
-- Source File: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts()
-- Line: ~34
-- =====================================================================
EXEC [dbo].[uspGetProductData]

-- =====================================================================
-- END OF EXTRACTED STATEMENTS CATALOG
-- TOTAL STATEMENTS: 5
-- =====================================================================
