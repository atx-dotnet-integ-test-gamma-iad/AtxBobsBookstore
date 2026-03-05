-- Converted SQL Statements for PostgreSQL - BobsBookstore .NET Application
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (all 5 statements)
-- DMS Error: Metadata model creation failed: The selected objects were not found.
-- Total Statements: 5

-- =================================================================
-- Statement 1: FindAllAuthorsEmbeddedSql (CONVERTED)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql()
-- Original MS SQL: SELECT * FROM dbo.Author
-- DMS Status: FAILED - Metadata model creation failed: The selected objects were not found.
-- DMS Timestamp: 2026-03-05T00:48:34.279626
-- Conversion: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- =================================================================
SELECT * FROM bobsbookstore_dbo.author

-- =================================================================
-- Statement 2: EditUsingStoredProcedure (CONVERTED)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure()
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- DMS Status: FAILED - Metadata model creation failed: The selected objects were not found.
-- DMS Timestamp: 2026-03-05T00:48:57.570223
-- Conversion: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- =================================================================
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- =================================================================
-- Statement 3: DeleteAuthorEmbeddedSql (CONVERTED)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql()
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- DMS Status: FAILED - Metadata model creation failed: The selected objects were not found.
-- DMS Timestamp: 2026-03-05T00:49:19.935347
-- Conversion: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- =================================================================
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- =================================================================
-- Statement 4: SelectAuthorsByHireYear (CONVERTED)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear()
-- Original MS SQL: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- DMS Status: FAILED - Metadata model creation failed: The selected objects were not found.
-- DMS Timestamp: 2026-03-05T00:49:43.754048
-- Conversion: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- =================================================================
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- =================================================================
-- Statement 5: FindAllProducts (CONVERTED)
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts()
-- Original MS SQL: EXEC [dbo].[uspGetProductData];
-- DMS Status: FAILED - Metadata model creation failed: The selected objects were not found.
-- DMS Timestamp: 2026-03-05T00:50:09.733710
-- Conversion: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- =================================================================
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
