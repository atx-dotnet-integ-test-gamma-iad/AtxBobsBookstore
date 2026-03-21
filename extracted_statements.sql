-- ============================================================================
-- Extracted SQL Statements Catalog
-- Project: BobsBookstore - MS SQL Server to PostgreSQL Migration
-- Source Database: BobsBookstore (MS SQL Server 2019)
-- Target Database: PostgreSQL 13
-- Total Statements: 5
-- Extraction Date: 2026-03-21
-- ============================================================================

-- ============================================================================
-- Statement 1
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~163
-- Type: Stored Procedure Call (parameterized)
-- Description: Calls uspUpdateAuthorPersonalInfo stored procedure with 5 parameters
--              to update author personal information
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string),
--             @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- ============================================================================
-- Original MS SQL:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ============================================================================
-- Statement 2
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~187
-- Type: Simple SELECT (no parameters)
-- Description: Retrieves all authors from the Author table
-- ============================================================================
-- Original MS SQL:
SELECT * FROM Author

-- ============================================================================
-- Statement 3
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~208
-- Type: Stored Procedure Call (parameterized)
-- Description: Calls uspDeleteAuthor stored procedure with 1 parameter
--              to delete an author by BusinessEntityID
-- Parameters: @BusinessEntityID (int)
-- ============================================================================
-- Original MS SQL:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ============================================================================
-- Statement 4
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~228
-- Type: Complex SELECT with SQL Server functions (parameterized)
-- Description: Selects authors by hire year with calculated age and formatted date
--              Uses SQL Server-specific functions: FORMAT, DATEDIFF, GETDATE, DATEPART
-- Parameters: @HireDate (int)
-- ============================================================================
-- Original MS SQL:
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================================
-- Statement 5
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: ~34
-- Type: Stored Procedure Call (no parameters)
-- Description: Calls uspGetProductData stored procedure to retrieve all products
-- ============================================================================
-- Original MS SQL:
EXEC [dbo].[uspGetProductData];
