-- =====================================================
-- Converted PostgreSQL Statements Catalog
-- Source: Application-level embedded SQL statements converted to PostgreSQL
-- Schema: bobsbookstore_dbo (lowercase column/table names)
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Failure Reason: Metadata model creation failed - No objects were found
--   according to the specified selection rules.
-- DMS Error Details: All 5 statements attempted through DMS MCP tool with:
--   migration_project_identifier: arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI
--   database_name: BobsBookstore
--   schema_name: dbo
-- =====================================================

-- === STATEMENT 1: FindAllAuthorsEmbeddedSql (converted) ===
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs (line ~188)
-- Original MS SQL: SELECT * FROM [dbo].[Author];
-- DMS Status: FAILED - Metadata model creation failed
-- DMS Timestamp: 2026-03-22T00:23:48.603291
-- DMS Error Timestamp: 2026-03-22T00:24:03.546900
-- Conversion: [dbo].[Author] -> bobsbookstore_dbo.author (lowercase schema/table)
-- Equivalency Status: ERROR (tool returned 'uniqueID' error)
-- Equivalency Timestamp: 2026-03-22T00:25:53.773252
SELECT * FROM bobsbookstore_dbo.author;

-- === STATEMENT 2: EditUsingStoredProcedure (converted) ===
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs (line ~164)
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- DMS Status: FAILED - Metadata model creation failed
-- DMS Timestamp: 2026-03-22T00:24:12.032435
-- DMS Error Timestamp: 2026-03-22T00:24:26.863378
-- Conversion: SQL Server EXEC stored procedure -> PostgreSQL SELECT function call
--   [dbo].[uspUpdateAuthorPersonalInfo] -> bobsbookstore_dbo.uspupdateauthorpersonalinfo (lowercase)
--   DECLARE/EXEC/SELECT pattern -> SELECT function() pattern
-- Equivalency Status: ERROR (tool returned 'uniqueID' error)
-- Equivalency Timestamp: 2026-03-22T00:26:03.257818
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- === STATEMENT 3: DeleteAuthorEmbeddedSql (converted) ===
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs (line ~210)
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- DMS Status: FAILED - Metadata model creation failed
-- DMS Timestamp: 2026-03-22T00:24:34.479600
-- DMS Error Timestamp: 2026-03-22T00:24:49.337125
-- Conversion: SQL Server EXEC stored procedure -> PostgreSQL SELECT function call
--   [dbo].[uspDeleteAuthor] -> bobsbookstore_dbo.uspdeleteauthor (lowercase)
--   DECLARE/EXEC/SELECT pattern -> SELECT function() pattern
-- Equivalency Status: ERROR (tool returned 'uniqueID' error)
-- Equivalency Timestamp: 2026-03-22T00:26:14.067096
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- === STATEMENT 4: SelectAuthorsByHireYear (converted) ===
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs (line ~230)
-- Original MS SQL: SELECT BusinessEntityID, CONVERT(VARCHAR(19), ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE YEAR(HireDate) = @HireDate;
-- DMS Status: FAILED - Metadata model creation failed
-- DMS Timestamp: 2026-03-22T00:24:57.718677
-- DMS Error Timestamp: 2026-03-22T00:25:13.087831
-- Conversion: Applied lowercase column/table names + SQL Server functions -> PostgreSQL functions
--   [dbo].[Author] -> bobsbookstore_dbo.author
--   BusinessEntityID -> businessentityid
--   CONVERT(VARCHAR(19), ModifiedDate, 120) -> TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS')
--   DATEDIFF(YEAR, BirthDate, GETDATE()) -> EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER
--   YEAR(HireDate) -> EXTRACT(YEAR FROM hiredate)
--   FormattedModifiedDate -> formattedmodifieddate
--   Age -> age
-- Equivalency Status: ERROR (tool returned 'uniqueID' error)
-- Equivalency Timestamp: 2026-03-22T00:26:24.988630
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- === STATEMENT 5: FindAllProducts (converted) ===
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs (line ~35)
-- Original MS SQL: EXEC [dbo].[uspGetProductData];
-- DMS Status: FAILED - Metadata model creation failed
-- DMS Timestamp: 2026-03-22T00:25:21.183447
-- DMS Error Timestamp: 2026-03-22T00:25:36.182940
-- Conversion: SQL Server EXEC stored procedure -> PostgreSQL SELECT * FROM function call
--   [dbo].[uspGetProductData] -> bobsbookstore_dbo.uspgetproductdata() (lowercase)
--   EXEC -> SELECT * FROM function()
-- Equivalency Status: ERROR (tool returned 'uniqueID' error)
-- Equivalency Timestamp: 2026-03-22T00:26:34.319320
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
