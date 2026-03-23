-- ============================================================================
-- CONVERTED SQL STATEMENTS CATALOG
-- Source: BobsBookstore .NET Application
-- Purpose: Original and converted SQL statement pairs for SQL Server to PostgreSQL migration
-- Date: 2026-03-23
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (all 5 statements)
-- DMS Error: Metadata model creation failed - No objects were found according to the specified selection rules
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: EditUsingStoredProcedure - Update Author Personal Info
-- ============================================================================
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 165
-- Method: EditUsingStoredProcedure
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA

-- ORIGINAL (MS SQL):
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- CONVERTED (PostgreSQL):
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo($1, $2, $3, $4, $5);

-- ============================================================================
-- STATEMENT 2: FindAllAuthorsEmbeddedSql - Select All Authors
-- ============================================================================
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 189
-- Method: FindAllAuthorsEmbeddedSql
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA

-- ORIGINAL (MS SQL):
SELECT * FROM bobsbookstore_dbo.author

-- CONVERTED (PostgreSQL):
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql - Delete Author
-- ============================================================================
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 212
-- Method: DeleteAuthorEmbeddedSql
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA

-- ORIGINAL (MS SQL):
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- CONVERTED (PostgreSQL):
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor($1);

-- ============================================================================
-- STATEMENT 4: SelectAuthorsByHireYear - Select Authors by Hire Year with Age
-- ============================================================================
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 232
-- Method: SelectAuthorsByHireYear
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA

-- ORIGINAL (MS SQL):
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate))::INTEGER AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = $1;

-- CONVERTED (PostgreSQL):
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = $1;

-- ============================================================================
-- STATEMENT 5: FindAllProducts - Get Product Data via Stored Procedure
-- ============================================================================
-- File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Line: 36
-- Method: FindAllProducts
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA

-- ORIGINAL (MS SQL):
EXEC [dbo].[uspGetProductData];

-- CONVERTED (PostgreSQL):
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- ============================================================================
-- END OF CONVERTED STATEMENTS CATALOG
-- Total Statements: 5
-- DMS Converted: 0 (all failed)
-- Manually Converted: 5 (with lowercase schema mapping)
-- ============================================================================
