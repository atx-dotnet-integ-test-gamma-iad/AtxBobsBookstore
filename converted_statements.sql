-- ================================================================
-- SQL Server to PostgreSQL Migration - Converted SQL Statements
-- ================================================================
-- Total Statements: 5
-- Conversion Date: 2026-02-13
-- Conversion Method: Manual (after DMS tool failures)
-- ================================================================

-- ================================================================
-- CONVERTED STATEMENT 1
-- ================================================================
-- Original Source: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- ================================================================
-- ORIGINAL (MS SQL Server):
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
--
-- CONVERTED (PostgreSQL):
SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo($1, $2, $3, $4, $5);
-- ================================================================


-- ================================================================
-- CONVERTED STATEMENT 2
-- ================================================================
-- Original Source: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- ================================================================
-- ORIGINAL (MS SQL Server):
-- SELECT * FROM bobsbookstore_dbo.author
--
-- CONVERTED (PostgreSQL):
SELECT * FROM bobsbookstore_dbo.author
-- ================================================================


-- ================================================================
-- CONVERTED STATEMENT 3
-- ================================================================
-- Original Source: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- ================================================================
-- ORIGINAL (MS SQL Server):
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
--
-- CONVERTED (PostgreSQL):
SELECT bobsbookstore_dbo.uspDeleteAuthor($1);
-- ================================================================


-- ================================================================
-- CONVERTED STATEMENT 4
-- ================================================================
-- Original Source: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- ================================================================
-- ORIGINAL (MS SQL Server):
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
--
-- CONVERTED (PostgreSQL):
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, DATE_PART('YEAR', AGE(CURRENT_DATE, BirthDate)) AS Age FROM Author WHERE EXTRACT(YEAR FROM HireDate) = $1;
-- ================================================================


-- ================================================================
-- CONVERTED STATEMENT 5
-- ================================================================
-- Original Source: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- ================================================================
-- ORIGINAL (MS SQL Server):
-- EXEC [dbo].[uspGetProductData];
--
-- CONVERTED (PostgreSQL):
SELECT * FROM bobsbookstore_dbo.uspGetProductData();
-- ================================================================


-- ================================================================
-- CONVERSION SUMMARY
-- ================================================================
-- Total Statements Converted: 5
-- DMS Tool Conversions: 0
-- Manual Conversions: 5
--
-- Key Conversion Patterns Applied:
-- 1. SQL Server EXEC stored_proc converted to PostgreSQL SELECT function()
-- 2. SQL Server @parameter converted to PostgreSQL $n positional parameters
-- 3. SQL Server FORMAT() converted to PostgreSQL TO_CHAR()
-- 4. SQL Server DATEDIFF() converted to PostgreSQL DATE_PART() with AGE()
-- 5. SQL Server GETDATE() converted to PostgreSQL CURRENT_DATE
-- 6. SQL Server DATEPART() converted to PostgreSQL EXTRACT()
-- 7. Schema prefix [dbo] converted to bobsbookstore_dbo for consistency
-- ================================================================
