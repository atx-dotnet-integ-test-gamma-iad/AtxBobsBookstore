-- ========================================================================
-- EXTRACTED SQL STATEMENTS FROM BOBSBOOKSTORE APPLICATION
-- Microsoft SQL Server to PostgreSQL Migration
-- ========================================================================
-- Total Statements: 5
-- Generated: 2024
-- ========================================================================

-- ========================================================================
-- STATEMENT 1: EditUsingStoredProcedure
-- ========================================================================
-- Source File: AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~164
-- Type: Stored Procedure Call with Output Parameter
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- Return Type: int (rows affected)
-- Description: Calls stored procedure to update author personal information
-- ========================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ========================================================================
-- STATEMENT 2: FindAllAuthorsEmbeddedSql
-- ========================================================================
-- Source File: AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~187
-- Type: SELECT Query
-- Parameters: None
-- Return Type: List<Author>
-- Description: Retrieves all authors from the author table
-- ========================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ========================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql
-- ========================================================================
-- Source File: AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~207
-- Type: Stored Procedure Call with Output Parameter
-- Parameters: @BusinessEntityID (int)
-- Return Type: int (rows affected)
-- Description: Calls stored procedure to delete an author
-- ========================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ========================================================================
-- STATEMENT 4: SelectAuthorsByHireYear
-- ========================================================================
-- Source File: AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~227
-- Type: SELECT Query with Date Functions
-- Parameters: @HireDate (int - year)
-- Return Type: List<AuthorAgeResult>
-- Description: Retrieves authors hired in a specific year with formatted date and calculated age
-- Uses T-SQL specific functions: FORMAT, DATEDIFF, DATEPART, GETDATE
-- ========================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ========================================================================
-- STATEMENT 5: FindAllProducts
-- ========================================================================
-- Source File: ProductsController.cs
-- Method: FindAllProducts
-- Line: ~31
-- Type: Stored Procedure Call
-- Parameters: None
-- Return Type: List<Product>
-- Description: Calls stored procedure to retrieve all product data
-- ========================================================================
EXEC [dbo].[uspGetProductData];

-- ========================================================================
-- END OF EXTRACTED STATEMENTS
-- ========================================================================
