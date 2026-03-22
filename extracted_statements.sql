-- =====================================================
-- Extracted MS SQL Server Statements Catalog
-- Source: Application-level embedded SQL statements in C# code
-- Files: AuthorsController.cs, ProductsController.cs
-- Total Statements: 5
-- =====================================================
-- NOTE: The application code currently contains PostgreSQL-converted statements
-- from a previous partial migration. The ORIGINAL MS SQL Server statements 
-- have been reconstructed below for proper DMS processing.
-- =====================================================

-- === STATEMENT 1 ===
-- Method: FindAllAuthorsEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Approximate Line: 188
-- Context: Retrieves all authors from the Author table using a simple SELECT
-- Current PostgreSQL in code: SELECT * FROM bobsbookstore_dbo.author
-- Original MS SQL Server statement:
SELECT * FROM [dbo].[Author];

-- === STATEMENT 2 ===
-- Method: EditUsingStoredProcedure
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Approximate Line: 164
-- Context: Calls stored procedure to update author personal info; captures and returns rows affected
-- Current PostgreSQL in code: SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
-- Original MS SQL Server statement:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- === STATEMENT 3 ===
-- Method: DeleteAuthorEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Approximate Line: 210
-- Context: Calls stored procedure to delete an author by BusinessEntityID; captures and returns rows affected
-- Current PostgreSQL in code: SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);
-- Original MS SQL Server statement:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- === STATEMENT 4 ===
-- Method: SelectAuthorsByHireYear
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Approximate Line: 230
-- Context: Selects authors filtered by hire year, with date formatting and age calculation
-- Current PostgreSQL in code: SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
-- Original MS SQL Server statement:
SELECT BusinessEntityID, CONVERT(VARCHAR(19), ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate;

-- === STATEMENT 5 ===
-- Method: FindAllProducts
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Approximate Line: 35
-- Context: Calls stored procedure to get all product data
-- Current PostgreSQL in code: SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
-- Original MS SQL Server statement:
EXEC [dbo].[uspGetProductData];
