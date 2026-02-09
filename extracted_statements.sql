-- ========================================================================
-- EXTRACTED SQL STATEMENTS FOR DMS CONVERSION
-- Total Statements: 5
-- Source: Bob's Bookstore .NET Application
-- Target Database: PostgreSQL
-- ========================================================================

-- ========================================================================
-- STATEMENT 1: Update Author Personal Info via Stored Procedure
-- ========================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~166
-- Description: Calls stored procedure to update author personal information
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), 
--            @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- Pattern: DECLARE/EXEC with output parameter
-- Context: Used in POST Edit action to update author records
-- ========================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ========================================================================
-- STATEMENT 2: Delete Author via Stored Procedure
-- ========================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~203
-- Description: Calls stored procedure to delete an author
-- Parameters: @BusinessEntityID (int)
-- Pattern: DECLARE/EXEC with output parameter
-- Context: Used in POST Delete action to remove author records
-- ========================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ========================================================================
-- STATEMENT 3: Select Authors by Hire Year with T-SQL Functions
-- ========================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~222
-- Description: Selects authors hired in a specific year with calculated age
-- Parameters: @HireDate (int - year value)
-- T-SQL Functions: FORMAT, DATEDIFF, GETDATE, DATEPART
-- Return Type: List<AuthorAgeResult> with BusinessEntityID, FormattedModifiedDate, Age
-- Context: Used in OtherAuthors action to display authors by hire year
-- ========================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ========================================================================
-- STATEMENT 4: Select All Authors from Table
-- ========================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~185
-- Description: Simple select to retrieve all author records
-- Parameters: None
-- Schema: bobsbookstore_dbo.author
-- Return Type: List<Author>
-- Context: Used in Index action to display all authors
-- ========================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ========================================================================
-- STATEMENT 5: Get Product Data via Stored Procedure
-- ========================================================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: ~32
-- Description: Calls stored procedure to retrieve all product data
-- Parameters: None
-- Pattern: EXEC stored procedure without parameters
-- Return Type: List<Product>
-- Context: Used in Index action to display all products
-- ========================================================================
EXEC [dbo].[uspGetProductData];

-- ========================================================================
-- END OF EXTRACTED STATEMENTS
-- ========================================================================
-- Summary:
-- - Stored Procedure Calls: 3 (uspUpdateAuthorPersonalInfo, uspDeleteAuthor, uspGetProductData)
-- - Direct SQL Queries: 2 (Select all authors, Select authors by hire year)
-- - T-SQL Functions Used: FORMAT, DATEDIFF, GETDATE, DATEPART
-- - Schema: bobsbookstore_dbo
-- ========================================================================
