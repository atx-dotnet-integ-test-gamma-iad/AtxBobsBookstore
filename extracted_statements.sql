-- ======================================================================
-- SQL STATEMENTS EXTRACTION CATALOG
-- Microsoft SQL Server to PostgreSQL Migration
-- ======================================================================
-- This file contains all SQL statements extracted from the codebase
-- for conversion from SQL Server syntax to PostgreSQL syntax.
-- Total Statements: 5
-- ======================================================================

-- ----------------------------------------------------------------------
-- Statement 1: Edit author using stored procedure
-- Source File: AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line Number: 161
-- Description: Calls stored procedure uspUpdateAuthorPersonalInfo to update author personal information
-- ----------------------------------------------------------------------
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ----------------------------------------------------------------------
-- Statement 2: Find all authors
-- Source File: AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line Number: 180
-- Description: Retrieves all authors from the author table
-- ----------------------------------------------------------------------
SELECT * FROM bobsbookstore_dbo.author

-- ----------------------------------------------------------------------
-- Statement 3: Delete author using stored procedure
-- Source File: AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line Number: 198
-- Description: Calls stored procedure uspDeleteAuthor to delete an author by BusinessEntityID
-- ----------------------------------------------------------------------
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ----------------------------------------------------------------------
-- Statement 4: Select authors by hire year with SQL Server-specific functions
-- Source File: AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line Number: 218
-- Description: Uses FORMAT, DATEDIFF, DATEPART, and GETDATE functions to select authors by hire year
-- ----------------------------------------------------------------------
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ----------------------------------------------------------------------
-- Statement 5: Get product data using stored procedure
-- Source File: ProductsController.cs
-- Method: FindAllProducts
-- Line Number: 31
-- Description: Calls stored procedure uspGetProductData to retrieve all product data
-- ----------------------------------------------------------------------
EXEC [dbo].[uspGetProductData];
