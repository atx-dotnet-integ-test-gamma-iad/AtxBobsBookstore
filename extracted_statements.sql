-- ============================================================================
-- Extracted SQL Statements Catalog
-- Source: BobsBookstore .NET Application
-- Purpose: Original MS SQL Server statements extracted for DMS conversion
-- Date: 2026-03-23
-- Total Statements: 5
-- Files Scanned: All .cs files in app/ (excluding obj/ and bin/)
-- Files with SQL: AuthorsController.cs, ProductsController.cs
-- ============================================================================

-- Statement 1: EditUsingStoredProcedure
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: 163
-- Description: Calls stored procedure to update author personal info
-- Type: Stored Procedure Call
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement 2: FindAllAuthorsEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: 187
-- Description: Selects all records from the Author table
-- Type: Simple SELECT
SELECT * FROM Author

-- Statement 3: DeleteAuthorEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: 208
-- Description: Calls stored procedure to delete an author
-- Type: Stored Procedure Call
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement 4: SelectAuthorsByHireYear
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: 228
-- Description: Selects authors by hire year with formatted date and age calculation
-- Type: Complex SELECT with SQL Server functions (FORMAT, DATEDIFF, DATEPART, GETDATE)
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Statement 5: FindAllProducts
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: 34
-- Description: Calls stored procedure to get product data
-- Type: Stored Procedure Call
EXEC [dbo].[uspGetProductData];
