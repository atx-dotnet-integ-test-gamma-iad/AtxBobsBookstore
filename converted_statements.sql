-- ============================================================================
-- SQL Statement Conversion Catalog
-- Purpose: PostgreSQL equivalents of all SQL Server statements
-- Migration: Microsoft SQL Server to PostgreSQL
-- Date: 2025-01-30
-- Conversion Method: Manual conversion after DMS tool failures (all 5 statements)
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: EditUsingStoredProcedure - Update Author Personal Info
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 162
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE

-- Original SQL Server Statement:
-- DECLARE @rowsAffected INT;
-- EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
-- SELECT @rowsAffected;

-- PostgreSQL Converted Statement:
SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Conversion Notes:
-- - Removed DECLARE statement (not needed in PostgreSQL for function calls)
-- - Changed EXEC syntax to SELECT function() syntax for PostgreSQL
-- - Removed final SELECT of return value as the function call itself returns the value
-- - Preserved schema name: bobsbookstore_dbo
-- - Function should return INTEGER representing rows affected

-- ============================================================================
-- STATEMENT 2: FindAllAuthorsEmbeddedSql - Select All Authors
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 188
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE

-- Original SQL Server Statement:
-- SELECT * FROM bobsbookstore_dbo.author

-- PostgreSQL Converted Statement:
SELECT * FROM bobsbookstore_dbo.author

-- Conversion Notes:
-- - No changes required - this is already PostgreSQL compatible
-- - Schema name bobsbookstore_dbo.author is preserved
-- - Simple SELECT statement works in both databases

-- ============================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql - Delete Author Using Stored Procedure
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 207
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE

-- Original SQL Server Statement:
-- DECLARE @rowsAffected INT;
-- EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
-- SELECT @rowsAffected;

-- PostgreSQL Converted Statement:
SELECT bobsbookstore_dbo.uspDeleteAuthor(@BusinessEntityID);

-- Conversion Notes:
-- - Removed DECLARE statement
-- - Changed EXEC syntax to SELECT function() syntax
-- - Removed final SELECT of return value
-- - Preserved schema name: bobsbookstore_dbo
-- - Function should return INTEGER representing rows affected

-- ============================================================================
-- STATEMENT 4: SelectAuthorsByHireYear - Complex SELECT with Date Functions
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 226
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE

-- Original SQL Server Statement:
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- PostgreSQL Converted Statement:
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, DATE_PART('year', AGE(CURRENT_TIMESTAMP, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- Conversion Notes:
-- - FORMAT(date, format) -> TO_CHAR(date, format)
--   - SQL Server format 'yyyy-MM-dd HH:mm:ss' -> PostgreSQL format 'YYYY-MM-DD HH24:MI:SS'
-- - DATEDIFF(YEAR, BirthDate, GETDATE()) -> DATE_PART('year', AGE(CURRENT_TIMESTAMP, BirthDate))
-- - GETDATE() -> CURRENT_TIMESTAMP (or now())
-- - DATEPART(YEAR, HireDate) -> EXTRACT(YEAR FROM HireDate)
-- - Preserved schema name: bobsbookstore_dbo.author
-- - Parameter @HireDate remains unchanged

-- ============================================================================
-- STATEMENT 5: FindAllProducts - Get Product Data Using Stored Procedure
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Line Number: 31
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE

-- Original SQL Server Statement:
-- EXEC [dbo].[uspGetProductData];

-- PostgreSQL Converted Statement:
SELECT * FROM bobsbookstore_dbo.uspGetProductData();

-- Conversion Notes:
-- - Changed EXEC to SELECT * FROM function() for PostgreSQL
-- - Preserved schema name: bobsbookstore_dbo
-- - Function is assumed to return a set of records (table-valued function)
-- - No parameters required

-- ============================================================================
-- CONVERSION SUMMARY
-- ============================================================================
-- Total SQL Statements Converted: 5
-- DMS Tool Successful Conversions: 0
-- Manual Conversions After DMS Failure: 5
-- Key Conversion Patterns Applied:
--   1. EXEC stored_proc -> SELECT function() or SELECT * FROM function()
--   2. DECLARE @var removed (not needed for direct function calls)
--   3. FORMAT() -> TO_CHAR() with PostgreSQL format codes
--   4. DATEDIFF(YEAR, date1, date2) -> DATE_PART('year', AGE(date2, date1))
--   5. GETDATE() -> CURRENT_TIMESTAMP
--   6. DATEPART(YEAR, date) -> EXTRACT(YEAR FROM date)
--   7. Schema names preserved: bobsbookstore_dbo
-- ============================================================================
