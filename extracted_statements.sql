-- ============================================================================
-- Extracted SQL Statements - BobsBookstore Migration (MS SQL Server Originals)
-- ============================================================================
-- This file catalogs all SQL statements extracted from the codebase.
-- Each statement includes the original MS SQL Server version and the current
-- PostgreSQL version found in the code.
-- ============================================================================

-- ============================================================================
-- Statement 1: EditUsingStoredProcedure
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Description: Calls stored procedure to update author personal information
-- ============================================================================

-- Original MS SQL Server Version:
EXEC dbo.uspUpdateAuthorPersonalInfo @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;

-- Current PostgreSQL Version in Code:
-- SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ============================================================================
-- Statement 2: FindAllAuthorsEmbeddedSql
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Description: Selects all authors from the Author table
-- ============================================================================

-- Original MS SQL Server Version:
SELECT * FROM dbo.Author;

-- Current PostgreSQL Version in Code:
-- SELECT * FROM bobsbookstore_dbo.author

-- ============================================================================
-- Statement 3: DeleteAuthorEmbeddedSql
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Description: Calls stored procedure to delete an author
-- ============================================================================

-- Original MS SQL Server Version:
EXEC dbo.uspDeleteAuthor @BusinessEntityID;

-- Current PostgreSQL Version in Code:
-- SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- ============================================================================
-- Statement 4: SelectAuthorsByHireYear
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Description: Selects authors by hire year with age calculation and date formatting
-- ============================================================================

-- Original MS SQL Server Version:
SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM dbo.Author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Current PostgreSQL Version in Code:
-- SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- ============================================================================
-- Statement 5: FindAllProducts
-- Source File: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Description: Calls stored procedure to get all product data
-- ============================================================================

-- Original MS SQL Server Version:
EXEC dbo.uspGetProductData;

-- Current PostgreSQL Version in Code:
-- SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
