-- ============================================================================
-- Extracted SQL Statements Catalog
-- Source: BobsBookstore .NET Application
-- Migration: MS SQL Server to PostgreSQL
-- Date: 2026-03-22
-- ============================================================================

-- Statement 1: AuthorsController.EditUsingStoredProcedure (line 165)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Type: Stored procedure call with DECLARE/EXEC pattern
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement 2: AuthorsController.FindAllAuthorsEmbeddedSql (line 189)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Type: Simple SELECT query
SELECT * FROM bobsbookstore_dbo.author

-- Statement 3: AuthorsController.DeleteAuthorEmbeddedSql (line 212)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Type: Stored procedure call with DECLARE/EXEC pattern
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement 4: AuthorsController.SelectAuthorsByHireYear (line 232)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Type: Complex SELECT with PostgreSQL-compatible functions
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate))::INTEGER AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- Statement 5: ProductsController.FindAllProducts (line 36)
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Type: Stored procedure EXEC call
EXEC [dbo].[uspGetProductData];
