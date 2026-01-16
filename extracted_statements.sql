-- ========================================
-- Extracted SQL Statements Catalog
-- Bob's Bookstore Migration: MS SQL Server to PostgreSQL
-- Total Statements: 5
-- ========================================

-- ========================================
-- STATEMENT 1
-- ========================================
-- Source File: AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~164
-- Type: Stored Procedure Execution with DECLARE
-- Description: Updates author personal information using stored procedure uspUpdateAuthorPersonalInfo
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- ========================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ========================================
-- STATEMENT 2
-- ========================================
-- Source File: AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~192
-- Type: SELECT Query
-- Description: Retrieves all authors from the author table
-- Parameters: None
-- ========================================
SELECT * FROM bobsbookstore_dbo.author

-- ========================================
-- STATEMENT 3
-- ========================================
-- Source File: AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~211
-- Type: Stored Procedure Execution with DECLARE
-- Description: Deletes an author using stored procedure uspDeleteAuthor
-- Parameters: @BusinessEntityID (int)
-- ========================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ========================================
-- STATEMENT 4
-- ========================================
-- Source File: AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~231
-- Type: SELECT Query with SQL Server Functions
-- Description: Retrieves authors by hire year with formatted date and calculated age
-- Functions Used: FORMAT, DATEDIFF, GETDATE, DATEPART
-- Parameters: @HireDate (int representing year)
-- ========================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ========================================
-- STATEMENT 5
-- ========================================
-- Source File: ProductsController.cs
-- Method: FindAllProducts
-- Line: ~32
-- Type: Stored Procedure Execution
-- Description: Retrieves all product data using stored procedure uspGetProductData
-- Parameters: None
-- ========================================
EXEC [dbo].[uspGetProductData];

-- ========================================
-- End of Extracted Statements Catalog
-- ========================================
