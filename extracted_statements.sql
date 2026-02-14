-- ================================================================================
-- Extracted SQL Statements from Bob's Bookstore .NET Application
-- ================================================================================
-- This file contains all SQL statements extracted from the codebase for 
-- conversion from Microsoft SQL Server syntax to PostgreSQL syntax.
-- Each statement is annotated with its source location and context.
-- ================================================================================

-- ================================================================================
-- STATEMENT 1: Update Author Personal Info using Stored Procedure
-- ================================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure()
-- Line: ~153
-- Context: Called when editing author personal information (NationalIDNumber, BirthDate, MaritalStatus, Gender)
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- ================================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ================================================================================
-- STATEMENT 2: Select All Authors
-- ================================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql()
-- Line: ~174
-- Context: Retrieves all authors from the database for display in the Index view
-- Parameters: None
-- ================================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ================================================================================
-- STATEMENT 3: Delete Author using Stored Procedure
-- ================================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql()
-- Line: ~195
-- Context: Called when deleting an author from the database
-- Parameters: @BusinessEntityID (int)
-- ================================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ================================================================================
-- STATEMENT 4: Select Authors by Hire Year with Age Calculation
-- ================================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear()
-- Line: ~213
-- Context: Retrieves authors hired in a specific year with formatted modified date and calculated age
-- Parameters: @HireDate (int - year value)
-- SQL Server Functions Used: FORMAT(), DATEDIFF(), GETDATE(), DATEPART()
-- ================================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ================================================================================
-- STATEMENT 5: Get All Products using Stored Procedure
-- ================================================================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts()
-- Line: ~31
-- Context: Retrieves all products from the database for display in the Index view
-- Parameters: None
-- ================================================================================
EXEC [dbo].[uspGetProductData];

-- ================================================================================
-- END OF EXTRACTED STATEMENTS
-- Total Statements Extracted: 5
-- ================================================================================
