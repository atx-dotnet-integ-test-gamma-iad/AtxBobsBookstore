-- ============================================================================
-- CONVERTED SQL STATEMENTS CATALOG
-- Migration: Microsoft SQL Server to PostgreSQL
-- Date: 2026-01-16
-- Total Statements: 5
-- Conversion Method: MANUAL (DMS tool metadata model creation failed)
-- ============================================================================

-- ============================================================================
-- STATEMENT_ID: STMT_001
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line Number: ~158
-- Type: Stored Procedure Call with DECLARE
-- Conversion: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: The selected objects were not found
-- Manual Conversion Reasoning: 
--   - DECLARE @variable syntax not supported in PostgreSQL
--   - Stored procedure calls use SELECT function_name() syntax in PostgreSQL
--   - Return value captured inline rather than separate variable
-- ============================================================================
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender) AS rows_affected;

-- ============================================================================
-- STATEMENT_ID: STMT_002
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line Number: ~176
-- Type: Simple SELECT
-- Conversion: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: The selected objects were not found
-- Manual Conversion Reasoning:
--   - Schema name bobsbookstore_dbo.author is PostgreSQL compatible
--   - SELECT * syntax is identical in both databases
--   - No conversion needed for this statement
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================================
-- STATEMENT_ID: STMT_003
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line Number: ~195
-- Type: Stored Procedure Call with DECLARE
-- Conversion: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: The selected objects were not found
-- Manual Conversion Reasoning:
--   - DECLARE @variable syntax not supported in PostgreSQL
--   - Stored procedure calls use SELECT function_name() syntax in PostgreSQL
--   - Return value captured inline rather than separate variable
-- ============================================================================
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID) AS rows_affected;

-- ============================================================================
-- STATEMENT_ID: STMT_004
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line Number: ~214
-- Type: Complex SELECT with SQL Server Functions
-- Conversion: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: The selected objects were not found
-- Manual Conversion Reasoning:
--   - FORMAT(date, 'format') → TO_CHAR(date, 'format') with adjusted format string
--   - DATEDIFF(YEAR, date1, date2) → EXTRACT(YEAR FROM AGE(date2, date1))
--   - GETDATE() → CURRENT_DATE or CURRENT_TIMESTAMP
--   - DATEPART(YEAR, date) → EXTRACT(YEAR FROM date)
--   - SQL Server format 'yyyy-MM-dd HH:mm:ss' → PostgreSQL 'YYYY-MM-DD HH24:MI:SS'
-- ============================================================================
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- ============================================================================
-- STATEMENT_ID: STMT_005
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line Number: ~32
-- Type: Stored Procedure Call
-- Conversion: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: The selected objects were not found
-- Manual Conversion Reasoning:
--   - EXEC stored_procedure in SQL Server → SELECT function_name() in PostgreSQL
--   - PostgreSQL functions return result sets directly
--   - Stored procedures become functions in PostgreSQL
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- ============================================================================
-- END OF CONVERTED STATEMENTS CATALOG
-- ============================================================================
