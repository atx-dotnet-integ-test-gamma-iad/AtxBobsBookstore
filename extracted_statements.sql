-- ========================================================================================================
-- EXTRACTED SQL STATEMENTS FOR DMS CONVERSION
-- Migration: Microsoft SQL Server to PostgreSQL
-- Date: 2026-02-10
-- Total Statements: 5
-- ========================================================================================================

-- ========================================================================================================
-- STATEMENT 1: EditUsingStoredProcedure - Stored Procedure Call with Output Parameter
-- ========================================================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line Number: ~164
-- Statement Type: Stored Procedure Call (EXEC)
-- Parameters: 
--   @BusinessEntityID (int)
--   @NationalIDNumber (string)
--   @BirthDate (DateTime)
--   @MaritalStatus (string)
--   @Gender (string)
-- Description: Calls uspUpdateAuthorPersonalInfo stored procedure to update author personal information
-- ========================================================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ========================================================================================================
-- STATEMENT 2: FindAllAuthorsEmbeddedSql - Simple SELECT
-- ========================================================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line Number: ~187
-- Statement Type: SELECT
-- Parameters: None
-- Description: Retrieves all authors from the author table
-- ========================================================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ========================================================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql - Stored Procedure Call with Output Parameter
-- ========================================================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line Number: ~204
-- Statement Type: Stored Procedure Call (EXEC)
-- Parameters:
--   @BusinessEntityID (int)
-- Description: Calls uspDeleteAuthor stored procedure to delete an author record
-- ========================================================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ========================================================================================================
-- STATEMENT 4: SelectAuthorsByHireYear - Complex SELECT with Date Functions
-- ========================================================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line Number: ~222
-- Statement Type: SELECT
-- Parameters:
--   @HireDate (int) - Year value
-- Description: Retrieves authors hired in a specific year with formatted date and age calculation
-- SQL Server Functions Used:
--   - FORMAT(): Formats ModifiedDate as 'yyyy-MM-dd HH:mm:ss'
--   - DATEDIFF(): Calculates age in years between BirthDate and current date
--   - GETDATE(): Returns current date/time
--   - DATEPART(): Extracts year from HireDate
-- ========================================================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ========================================================================================================
-- STATEMENT 5: FindAllProducts - Stored Procedure Call
-- ========================================================================================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line Number: ~31
-- Statement Type: Stored Procedure Call (EXEC)
-- Parameters: None
-- Description: Calls uspGetProductData stored procedure to retrieve all product data
-- ========================================================================================================
EXEC [dbo].[uspGetProductData];

-- ========================================================================================================
-- END OF EXTRACTED STATEMENTS
-- ========================================================================================================
