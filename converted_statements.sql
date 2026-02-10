-- ========================================================================================================
-- CONVERTED SQL STATEMENTS FOR POSTGRESQL
-- Migration: Microsoft SQL Server to PostgreSQL
-- Date: 2026-02-10
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE (all statements)
-- Total Statements: 5
-- ========================================================================================================

-- ========================================================================================================
-- STATEMENT 1: EditUsingStoredProcedure - Stored Procedure Call Converted to Function
-- ========================================================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- 
-- ORIGINAL (SQL Server):
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- 
-- CONVERTED (PostgreSQL):
-- ========================================================================================================
SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(
    @BusinessEntityID,
    @NationalIDNumber,
    @BirthDate,
    @MaritalStatus,
    @Gender
);

-- ========================================================================================================
-- STATEMENT 2: FindAllAuthorsEmbeddedSql - Simple SELECT (PostgreSQL Compatible)
-- ========================================================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- 
-- ORIGINAL (SQL Server):
-- SELECT * FROM bobsbookstore_dbo.author
-- 
-- CONVERTED (PostgreSQL):
-- ========================================================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ========================================================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql - Stored Procedure Call Converted to Function
-- ========================================================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- 
-- ORIGINAL (SQL Server):
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- 
-- CONVERTED (PostgreSQL):
-- ========================================================================================================
SELECT bobsbookstore_dbo.uspDeleteAuthor(@BusinessEntityID);

-- ========================================================================================================
-- STATEMENT 4: SelectAuthorsByHireYear - Complex SELECT with Date Function Conversions
-- ========================================================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- 
-- ORIGINAL (SQL Server):
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- 
-- CONVERTED (PostgreSQL):
-- Conversion Notes:
--   FORMAT() → TO_CHAR() with 'YYYY-MM-DD HH24:MI:SS' pattern
--   DATEDIFF(YEAR, BirthDate, GETDATE()) → DATE_PART('year', AGE(CURRENT_DATE, BirthDate))
--   DATEPART(YEAR, HireDate) → DATE_PART('year', HireDate)
--   GETDATE() → CURRENT_DATE
-- ========================================================================================================
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, DATE_PART('year', AGE(CURRENT_DATE, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE DATE_PART('year', HireDate) = @HireDate;

-- ========================================================================================================
-- STATEMENT 5: FindAllProducts - Stored Procedure Call Converted to Function
-- ========================================================================================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- 
-- ORIGINAL (SQL Server):
-- EXEC [dbo].[uspGetProductData];
-- 
-- CONVERTED (PostgreSQL):
-- ========================================================================================================
SELECT * FROM bobsbookstore_dbo.uspGetProductData();

-- ========================================================================================================
-- CONVERSION SUMMARY
-- ========================================================================================================
-- Total Statements Processed: 5
-- DMS Successful Conversions: 0
-- Manual Conversions After DMS Failure: 5
-- 
-- All statements were submitted to DMS MCP tool but encountered metadata model creation errors.
-- Manual conversions applied following PostgreSQL best practices.
-- All conversions ready for equivalency validation in Step 3.
-- ========================================================================================================
