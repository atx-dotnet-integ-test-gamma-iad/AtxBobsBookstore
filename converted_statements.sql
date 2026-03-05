-- ============================================================================
-- Converted SQL Statements Catalog
-- Source: BobsBookstore .NET Application
-- Purpose: Original MS SQL Server statements and their PostgreSQL conversions
-- ============================================================================

-- ============================================================================
-- Statement 1: EditUsingStoredProcedure
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~163
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: "Metadata model creation failed: Statement definition is not valid."
-- Reason: DMS could not parse DECLARE/EXEC multi-statement block
-- ============================================================================
-- Original MS SQL:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- Converted PostgreSQL:
SELECT * FROM bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ============================================================================
-- Statement 2: FindAllAuthorsEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~189
-- Conversion Method: DMS_TOOL
-- DMS Status: SUCCESS
-- ============================================================================
-- Original MS SQL:
-- SELECT * FROM [dbo].[Author]
-- Converted PostgreSQL (DMS output):
SELECT * FROM bobsusedbookstore_dbo.author;

-- ============================================================================
-- Statement 3: DeleteAuthorEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~209
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: "Metadata model creation failed: Statement definition is not valid."
-- Reason: DMS could not parse DECLARE/EXEC multi-statement block
-- ============================================================================
-- Original MS SQL:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- Converted PostgreSQL:
SELECT * FROM bobsusedbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- ============================================================================
-- Statement 4: SelectAuthorsByHireYear
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~229
-- Conversion Method: DMS_TOOL
-- DMS Status: SUCCESS (GenAI-assisted conversion)
-- ============================================================================
-- Original MS SQL:
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- Converted PostgreSQL (DMS output):
SELECT businessentityid, to_char(modifieddate, 'yyyy-MM-dd HH:mm:ss') AS formattedmodifieddate, aws_sqlserver_ext.datediff('year', (birthdate)::TIMESTAMP, (clock_timestamp())::TIMESTAMP) AS age FROM bobsusedbookstore_dbo.author WHERE date_part('year', hiredate) = HireDate;

-- ============================================================================
-- Statement 5: FindAllProducts
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: ~35
-- Conversion Method: DMS_TOOL
-- DMS Status: SUCCESS
-- ============================================================================
-- Original MS SQL:
-- EXEC [dbo].[uspGetProductData];
-- Converted PostgreSQL (DMS output):
CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => uspgetproductdata$par_my_cursor);
