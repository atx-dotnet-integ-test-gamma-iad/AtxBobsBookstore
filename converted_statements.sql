-- Converted SQL Statements for PostgreSQL - BobsBookstore .NET Application
-- Source: SQL Server to PostgreSQL Migration
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (all 5 statements)
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- Total Statements: 5

-- ============================================================================
-- Statement 1: EditUsingStoredProcedure
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~163
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- Conversion: Stored procedure EXEC pattern converted to PostgreSQL function call via SELECT * FROM
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ============================================================================
-- Statement 2: FindAllAuthorsEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~187
-- Original MS SQL: SELECT * FROM [dbo].[Author]
-- Conversion: Schema/table names converted to lowercase PostgreSQL format
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================================
-- Statement 3: DeleteAuthorEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~208
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- Conversion: Stored procedure EXEC pattern converted to PostgreSQL function call via SELECT * FROM
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- ============================================================================
-- Statement 4: SelectAuthorsByHireYear
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~228
-- Original MS SQL: SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate;
-- Conversion: CONVERT -> TO_CHAR, DATEDIFF -> EXTRACT/AGE, GETDATE -> CURRENT_DATE, YEAR -> EXTRACT, all names lowercased
-- ============================================================================
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- ============================================================================
-- Statement 5: FindAllProducts
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: ~34
-- Original MS SQL: EXEC [dbo].[uspGetProductData];
-- Conversion: EXEC stored procedure converted to PostgreSQL function call via SELECT * FROM
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
