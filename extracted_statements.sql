-- ============================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Source: BobsBookstore .NET Application
-- Purpose: Comprehensive catalog of all original MS SQL statements for DMS conversion
-- Date: 2026-03-21
-- Total Statements: 5
-- ============================================================================

-- ============================================================================
-- Statement 1 of 5
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~163
-- Usage Pattern: ExecuteSqlRawAsync with NpgsqlParameters ($1-$5)
-- Context: Stored procedure call for updating author personal info
-- ============================================================================
EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;

-- ============================================================================
-- Statement 2 of 5
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~187
-- Usage Pattern: SqlQueryRaw<Author>
-- Context: Direct table query to fetch all authors
-- ============================================================================
SELECT * FROM [dbo].[Author];

-- ============================================================================
-- Statement 3 of 5
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~207
-- Usage Pattern: ExecuteSqlRawAsync with NpgsqlParameter ($1)
-- Context: Stored procedure call for deleting an author
-- ============================================================================
EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID;

-- ============================================================================
-- Statement 4 of 5
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~227
-- Usage Pattern: SqlQueryRaw<AuthorAgeResult> with NpgsqlParameter ($1)
-- Context: Complex query with SQL Server functions (CONVERT, DATEDIFF, GETDATE, YEAR)
-- ============================================================================
SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireYear;

-- ============================================================================
-- Statement 5 of 5
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: ~34
-- Usage Pattern: SqlQueryRaw<Product>
-- Context: Stored procedure call for getting product data
-- ============================================================================
EXEC [dbo].[uspGetProductData];
