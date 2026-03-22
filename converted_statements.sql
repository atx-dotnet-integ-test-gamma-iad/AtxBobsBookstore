-- ============================================================================
-- Converted SQL Statements Catalog (PostgreSQL)
-- Source: BobsBookstore .NET Application
-- Migration: MS SQL Server to PostgreSQL
-- Date: 2026-03-22
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according
--            to the specified selection rules.
-- ============================================================================

-- Statement 1: AuthorsController.EditUsingStoredProcedure (line 165)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- Conversion: MS SQL DECLARE/EXEC stored procedure call → PostgreSQL SELECT from function
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: AuthorsController.FindAllAuthorsEmbeddedSql (line 189)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Original: SELECT * FROM bobsbookstore_dbo.author
-- Conversion: Already PostgreSQL-compatible with lowercase schema; no changes needed
SELECT * FROM bobsbookstore_dbo.author;

-- Statement 3: AuthorsController.DeleteAuthorEmbeddedSql (line 212)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- Conversion: MS SQL DECLARE/EXEC stored procedure call → PostgreSQL SELECT from function
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: AuthorsController.SelectAuthorsByHireYear (line 232)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Original: SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate))::INTEGER AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;
-- Conversion: Applied lowercase to column names and aliases for PostgreSQL compatibility
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5: ProductsController.FindAllProducts (line 36)
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Original: EXEC [dbo].[uspGetProductData];
-- Conversion: MS SQL EXEC stored procedure call → PostgreSQL SELECT from function
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
