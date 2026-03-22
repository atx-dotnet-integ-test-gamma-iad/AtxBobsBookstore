-- ============================================================================
-- Converted SQL Statements - PostgreSQL Equivalents
-- Source: Manual conversion with lowercase schema mapping (DMS tool failed)
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Date: 2026-03-22
-- DMS Error: Metadata model creation failed - No objects found for selection rules
-- Total Statements: 5
-- ============================================================================

-- ============================================================================
-- Statement 1 (Converted)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: 163
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- Conversion: MS SQL DECLARE/EXEC pattern -> PostgreSQL SELECT function() pattern
--             Schema [dbo] -> bobsbookstore_dbo (lowercase)
--             Procedure name -> lowercase
-- DMS Status: FAILED (metadata model creation error)
-- DMS Attempt Timestamp: 2026-03-22T16:01:04.288453 -> Error at 2026-03-22T16:01:18.931474
-- ============================================================================
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ============================================================================
-- Statement 2 (Converted)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: 187
-- Original MS SQL: SELECT * FROM [dbo].[author]
-- Conversion: Schema [dbo] -> bobsbookstore_dbo, table name already lowercase
-- DMS Status: FAILED (metadata model creation error)
-- DMS Attempt Timestamp: 2026-03-22T16:01:26.821061 -> Error at 2026-03-22T16:01:41.611451
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================================
-- Statement 3 (Converted)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: 208
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- Conversion: MS SQL DECLARE/EXEC pattern -> PostgreSQL SELECT function() pattern
--             Schema [dbo] -> bobsbookstore_dbo (lowercase)
--             Procedure name -> lowercase
-- DMS Status: FAILED (metadata model creation error)
-- DMS Attempt Timestamp: 2026-03-22T16:01:49.480420 -> Error at 2026-03-22T16:02:04.129094
-- ============================================================================
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- ============================================================================
-- Statement 4 (Converted)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: 228
-- Original MS SQL: SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[author] WHERE YEAR(HireDate) = @HireDate;
-- Conversion: CONVERT(VARCHAR, col, 120) -> TO_CHAR(col, 'YYYY-MM-DD HH24:MI:SS')
--             DATEDIFF(YEAR, col, GETDATE()) -> EXTRACT(YEAR FROM AGE(CURRENT_DATE, col))::INTEGER
--             YEAR(col) -> EXTRACT(YEAR FROM col)
--             Column names -> lowercase for PostgreSQL compatibility
--             Schema [dbo] -> bobsbookstore_dbo
-- DMS Status: FAILED (metadata model creation error)
-- DMS Attempt Timestamp: 2026-03-22T16:02:12.404603 -> Error at 2026-03-22T16:02:27.014265
-- ============================================================================
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- ============================================================================
-- Statement 5 (Converted)
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: 34
-- Original MS SQL: EXEC [dbo].[uspGetProductData];
-- Conversion: MS SQL EXEC -> PostgreSQL SELECT * FROM function()
--             Schema [dbo] -> bobsbookstore_dbo (lowercase)
--             Procedure name -> lowercase
-- DMS Status: FAILED (metadata model creation error)
-- DMS Attempt Timestamp: 2026-03-22T16:02:35.152651 -> Error at 2026-03-22T16:02:49.782075
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
