-- ============================================================================
-- Converted SQL Statements - PostgreSQL Version
-- Microsoft SQL Server to PostgreSQL Migration
-- ============================================================================
-- This file contains all SQL statements converted from SQL Server syntax to
-- PostgreSQL syntax. All statements were passed through the DMS MCP tool, but
-- due to DMS service errors, manual conversions were applied after DMS failure.
-- See dms_conversion_log.md for detailed conversion rationale.
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: Update Author Personal Information (PostgreSQL Function Call)
-- ============================================================================
-- Original Source: AuthorsController.cs, line 162, EditUsingStoredProcedure method
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- 
-- Parameters:
--   @BusinessEntityID (int) - Author identifier
--   @NationalIDNumber (varchar) - National ID number
--   @BirthDate (timestamp) - Birth date
--   @MaritalStatus (varchar) - Marital status code
--   @Gender (varchar) - Gender code
--
-- Returns: Integer representing rows affected
--
-- Converted PostgreSQL Statement:
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Conversion Notes:
-- - EXEC replaced with SELECT for PostgreSQL function call
-- - DECLARE statement removed (not needed)
-- - Function name converted to lowercase
-- - Schema notation preserved as bobsbookstore_dbo
-- - Function expected to return rows affected count
-- ============================================================================


-- ============================================================================
-- STATEMENT 2: Select All Authors (No Changes Required)
-- ============================================================================
-- Original Source: AuthorsController.cs, line 191, FindAllAuthorsEmbeddedSql method
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
--
-- Parameters: None
--
-- Returns: All author records
--
-- Converted PostgreSQL Statement:
SELECT * FROM bobsbookstore_dbo.author;

-- Conversion Notes:
-- - Statement is already PostgreSQL compatible
-- - No SQL Server-specific syntax present
-- - Schema and table names unchanged
-- ============================================================================


-- ============================================================================
-- STATEMENT 3: Delete Author (PostgreSQL Function Call)
-- ============================================================================
-- Original Source: AuthorsController.cs, line 207, DeleteAuthorEmbeddedSql method
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
--
-- Parameters:
--   @BusinessEntityID (int) - Author identifier to delete
--
-- Returns: Integer representing rows affected
--
-- Converted PostgreSQL Statement:
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Conversion Notes:
-- - EXEC replaced with SELECT for PostgreSQL function call
-- - DECLARE statement removed (not needed)
-- - Function name converted to lowercase
-- - Schema notation preserved as bobsbookstore_dbo
-- - Function expected to return rows affected count
-- ============================================================================


-- ============================================================================
-- STATEMENT 4: Select Authors by Hire Year with Age Calculation
-- ============================================================================
-- Original Source: AuthorsController.cs, line 227, SelectAuthorsByHireYear method
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
--
-- Parameters:
--   @HireDate (int) - Year to filter by
--
-- Returns: BusinessEntityID, FormattedModifiedDate, Age for matching authors
--
-- Converted PostgreSQL Statement:
SELECT 
    businessentityid, 
    TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, 
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate)) AS age 
FROM 
    bobsbookstore_dbo.author 
WHERE 
    EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Conversion Notes:
-- - FORMAT() replaced with TO_CHAR() for date formatting
-- - DATEDIFF(YEAR, BirthDate, GETDATE()) replaced with EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))
-- - DATEPART(YEAR, HireDate) replaced with EXTRACT(YEAR FROM hiredate)
-- - GETDATE() replaced with CURRENT_DATE
-- - Column names converted to lowercase per PostgreSQL schema
-- - Format string adjusted for PostgreSQL: HH24:MI:SS instead of HH:mm:ss
-- ============================================================================


-- ============================================================================
-- STATEMENT 5: Get All Product Data (PostgreSQL Function Call)
-- ============================================================================
-- Original Source: ProductsController.cs, line 31, FindAllProducts method
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
--
-- Parameters: None
--
-- Returns: All product records
--
-- Converted PostgreSQL Statement:
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- Conversion Notes:
-- - EXEC replaced with SELECT * FROM for table-returning function
-- - Function name converted to lowercase
-- - Schema notation preserved as bobsbookstore_dbo
-- - Added parentheses () to indicate function call
-- - Function expected to return result set (table)
-- ============================================================================


-- ============================================================================
-- CONVERSION SUMMARY
-- ============================================================================
-- Total Statements Converted: 5
-- DMS Tool Success: 0 (all failed due to metadata model creation error)
-- Manual Conversions: 5
--
-- Conversion Patterns Applied:
-- 1. Stored procedure calls: EXEC → SELECT function_name()
-- 2. Date formatting: FORMAT() → TO_CHAR()
-- 3. Date arithmetic: DATEDIFF() → AGE() with EXTRACT()
-- 4. Current date: GETDATE() → CURRENT_DATE
-- 5. Date part extraction: DATEPART() → EXTRACT()
-- 6. Column/function names: Converted to lowercase per PostgreSQL conventions
-- 7. Schema preserved: bobsbookstore_dbo
--
-- All converted statements require:
-- - Validation through SQL Equivalency tool
-- - Corresponding PostgreSQL functions in the database
-- - Testing with actual data
-- ============================================================================
