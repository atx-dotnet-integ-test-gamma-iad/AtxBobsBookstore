-- =====================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Microsoft SQL Server to PostgreSQL Migration
-- Total Statements: 5
-- =====================================================================

-- =====================================================================
-- STATEMENT 1: Stored Procedure Call - uspUpdateAuthorPersonalInfo
-- =====================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 163
-- Method: EditUsingStoredProcedure
-- Context: Update author personal information using stored procedure
-- Construction Type: Inline SQL string with DECLARE/EXEC pattern
-- Parameters:
--   @BusinessEntityID (int) - Author's business entity identifier
--   @NationalIDNumber (string) - National ID number
--   @BirthDate (DateTime) - Birth date (converted to UTC before passing)
--   @MaritalStatus (string) - Marital status
--   @Gender (string) - Gender
-- Special Handling: birthDate.ToUniversalTime() conversion applied
-- =====================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- =====================================================================
-- STATEMENT 2: Simple SELECT - Find All Authors
-- =====================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 187
-- Method: FindAllAuthorsEmbeddedSql
-- Context: Retrieve all authors from the author table
-- Construction Type: Direct inline SQL string
-- Parameters: None
-- Schema: bobsbookstore_dbo
-- =====================================================================
SELECT * FROM bobsbookstore_dbo.author;

-- =====================================================================
-- STATEMENT 3: Stored Procedure Call - uspDeleteAuthor
-- =====================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 208
-- Method: DeleteAuthorEmbeddedSql
-- Context: Delete author using stored procedure
-- Construction Type: Inline SQL string with DECLARE/EXEC pattern
-- Parameters:
--   @BusinessEntityID (int) - Author's business entity identifier
-- =====================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- =====================================================================
-- STATEMENT 4: Complex SELECT with SQL Server Functions
-- =====================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 228
-- Method: SelectAuthorsByHireYear
-- Context: Select authors by hire year with formatted dates and age calculation
-- Construction Type: Direct inline SQL string
-- Parameters:
--   @HireDate (int) - Hire year to filter by
-- SQL Server Functions Used:
--   FORMAT() - Format date as 'yyyy-MM-dd HH:mm:ss'
--   DATEDIFF() - Calculate years between birth date and current date
--   GETDATE() - Get current date/time
--   DATEPART() - Extract year from hire date
-- Schema: bobsbookstore_dbo
-- =====================================================================
SELECT BusinessEntityID, 
       FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, 
       DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age 
FROM bobsbookstore_dbo.author 
WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- =====================================================================
-- STATEMENT 5: Stored Procedure Call - uspGetProductData
-- =====================================================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Line Number: 33
-- Method: FindAllProducts
-- Context: Retrieve all products using stored procedure
-- Construction Type: Inline SQL string with EXEC statement
-- Parameters: None
-- =====================================================================
EXEC [dbo].[uspGetProductData];

-- =====================================================================
-- END OF CATALOG
-- =====================================================================
-- Summary:
-- - Total SQL Statements: 5
-- - Stored Procedure Calls: 3 (uspUpdateAuthorPersonalInfo, uspDeleteAuthor, uspGetProductData)
-- - Direct SELECT Statements: 2
-- - Statements with Parameters: 3
-- - Statements with SQL Server Specific Functions: 1 (FORMAT, DATEDIFF, GETDATE, DATEPART)
-- - Schemas Referenced: bobsbookstore_dbo, [dbo]
-- =====================================================================
