-- ============================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Migration: Microsoft SQL Server to PostgreSQL
-- Date: 2026-01-16
-- Total Statements: 5
-- ============================================================================

-- ============================================================================
-- STATEMENT_ID: STMT_001
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line Number: ~158
-- Type: Stored Procedure Call with DECLARE
-- Description: Update author personal info using stored procedure
-- ============================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT_ID: STMT_002
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line Number: ~176
-- Type: Simple SELECT
-- Description: Retrieve all authors from the author table
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================================
-- STATEMENT_ID: STMT_003
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line Number: ~195
-- Type: Stored Procedure Call with DECLARE
-- Description: Delete author using stored procedure
-- ============================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT_ID: STMT_004
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line Number: ~214
-- Type: Complex SELECT with SQL Server Functions
-- Description: Select authors by hire year with formatted date and age calculation
-- SQL Server Functions Used: FORMAT, DATEDIFF, GETDATE, DATEPART
-- ============================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================================
-- STATEMENT_ID: STMT_005
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line Number: ~32
-- Type: Stored Procedure Call
-- Description: Retrieve all products using stored procedure
-- ============================================================================
EXEC [dbo].[uspGetProductData];

-- ============================================================================
-- END OF EXTRACTED STATEMENTS CATALOG
-- ============================================================================
