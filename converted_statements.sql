-- Converted SQL Statements Catalog
-- Source: BobsBookstore .NET Application
-- Target: PostgreSQL
-- Purpose: Catalog of all converted PostgreSQL statements
-- Date: 2026-03-23
-- Note: All DMS conversions failed. Manual conversions applied with lowercase schema mapping.

-- ============================================================
-- Statement 1: EditUsingStoredProcedure
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed - No objects found according to specified selection rules
-- Manual Conversion Notes:
--   - Converted EXEC stored procedure to PostgreSQL function call syntax: SELECT * FROM schema.function(params)
--   - [dbo].[uspUpdateAuthorPersonalInfo] -> bobsbookstore_dbo.uspupdateauthorpersonalinfo
--   - Removed DECLARE @rowsAffected / SELECT @rowsAffected wrapper (not needed in PostgreSQL function call)
-- ============================================================
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ============================================================
-- Statement 2: FindAllAuthorsEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed - No objects found according to specified selection rules
-- Manual Conversion Notes:
--   - [dbo].[Author] -> bobsbookstore_dbo."author" (lowercase, quoted to preserve case in PostgreSQL)
-- ============================================================
SELECT * FROM bobsbookstore_dbo."author"

-- ============================================================
-- Statement 3: DeleteAuthorEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed - No objects found according to specified selection rules
-- Manual Conversion Notes:
--   - Converted EXEC stored procedure to PostgreSQL function call syntax: SELECT * FROM schema.function(params)
--   - [dbo].[uspDeleteAuthor] -> bobsbookstore_dbo.uspdeleteauthor
--   - Removed DECLARE @rowsAffected / SELECT @rowsAffected wrapper
-- ============================================================
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- ============================================================
-- Statement 4: SelectAuthorsByHireYear
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed - No objects found according to specified selection rules
-- Manual Conversion Notes:
--   - CONVERT(VARCHAR(10), ModifiedDate, 120) -> TO_CHAR(modifieddate, 'YYYY-MM-DD')
--   - DATEDIFF(YEAR, BirthDate, GETDATE()) -> EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER
--   - YEAR(HireDate) -> EXTRACT(YEAR FROM hiredate)
--   - All column names and aliases converted to lowercase
--   - [dbo].[Author] -> bobsbookstore_dbo."author"
-- ============================================================
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo."author" WHERE EXTRACT(YEAR FROM hiredate) = @HireDate

-- ============================================================
-- Statement 5: FindAllProducts
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed - No objects found according to specified selection rules
-- Manual Conversion Notes:
--   - Converted EXEC stored procedure to PostgreSQL function call syntax: SELECT * FROM schema.function()
--   - [dbo].[uspGetProductData] -> bobsbookstore_dbo.uspgetproductdata()
-- ============================================================
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
