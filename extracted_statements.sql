-- ============================================================================
-- EXTRACTED SQL STATEMENTS FROM BOBS BOOKSTORE APPLICATION
-- Extraction Date: Migration Phase 1
-- Total Statements: 5
-- ============================================================================

-- ----------------------------------------------------------------------------
-- STATEMENT 1: Update Author Personal Info Using Stored Procedure
-- ----------------------------------------------------------------------------
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line Numbers: 157
-- Statement Type: Stored Procedure Call with Output Parameter
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- Conversion Notes: This is a stored procedure call with DECLARE statement and return value capture. Need to convert EXEC syntax and output parameter handling to PostgreSQL function call syntax.
-- ----------------------------------------------------------------------------
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ----------------------------------------------------------------------------
-- STATEMENT 2: Select All Authors
-- ----------------------------------------------------------------------------
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line Numbers: 182
-- Statement Type: Inline SQL - Simple SELECT
-- Parameters: None
-- Conversion Notes: Schema name bobsbookstore_dbo may need to be adjusted based on PostgreSQL schema structure after DMS conversion.
-- ----------------------------------------------------------------------------
SELECT * FROM bobsbookstore_dbo.author

-- ----------------------------------------------------------------------------
-- STATEMENT 3: Delete Author Using Stored Procedure
-- ----------------------------------------------------------------------------
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line Numbers: 199
-- Statement Type: Stored Procedure Call with Output Parameter
-- Parameters: @BusinessEntityID (int)
-- Conversion Notes: Similar to Statement 1, requires conversion of DECLARE, EXEC, and output parameter syntax to PostgreSQL function call.
-- ----------------------------------------------------------------------------
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ----------------------------------------------------------------------------
-- STATEMENT 4: Select Authors By Hire Year with Calculated Fields
-- ----------------------------------------------------------------------------
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line Numbers: 218
-- Statement Type: Inline SQL - Complex SELECT with SQL Server Functions
-- Parameters: @HireDate (int - represents year)
-- Conversion Notes: Contains SQL Server specific functions that require conversion:
--   - FORMAT() function for date formatting
--   - DATEDIFF() for date difference calculation
--   - GETDATE() for current date
--   - DATEPART() for extracting year from date
-- Schema name bobsbookstore_dbo may need adjustment.
-- ----------------------------------------------------------------------------
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ----------------------------------------------------------------------------
-- STATEMENT 5: Get Product Data Using Stored Procedure
-- ----------------------------------------------------------------------------
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line Numbers: 31
-- Statement Type: Stored Procedure Call - Simple EXEC
-- Parameters: None
-- Conversion Notes: Convert EXEC [dbo].[procedureName] syntax to PostgreSQL function call syntax (SELECT * FROM or CALL).
-- ----------------------------------------------------------------------------
EXEC [dbo].[uspGetProductData];

-- ============================================================================
-- END OF EXTRACTED STATEMENTS
-- ============================================================================
