-- ========================================================================
-- CONVERTED SQL STATEMENTS FOR POSTGRESQL
-- Total Statements: 5
-- Source: Bob's Bookstore .NET Application
-- Target Database: PostgreSQL
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE (all statements)
-- ========================================================================
-- NOTE: All statements were manually converted after DMS MCP tool failed
-- with error: "Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}"
-- See dms_conversion_log.txt for complete DMS tool output and conversion details
-- ========================================================================

-- ========================================================================
-- STATEMENT 1: Update Author Personal Info via Stored Procedure
-- ========================================================================
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Schema: bobsbookstore_dbo
-- ========================================================================
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ========================================================================
-- STATEMENT 2: Delete Author via Stored Procedure
-- ========================================================================
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Schema: bobsbookstore_dbo
-- ========================================================================
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- ========================================================================
-- STATEMENT 3: Select Authors by Hire Year with T-SQL Functions
-- ========================================================================
-- Original MS SQL: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- T-SQL Functions Converted: FORMAT -> TO_CHAR, DATEDIFF -> AGE/EXTRACT, GETDATE -> CURRENT_DATE, DATEPART -> EXTRACT
-- ========================================================================
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- ========================================================================
-- STATEMENT 4: Select All Authors from Table
-- ========================================================================
-- Original MS SQL: SELECT * FROM bobsbookstore_dbo.author
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE (No changes needed - PostgreSQL compatible)
-- Schema: bobsbookstore_dbo
-- ========================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ========================================================================
-- STATEMENT 5: Get Product Data via Stored Procedure
-- ========================================================================
-- Original MS SQL: EXEC [dbo].[uspGetProductData];
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Schema: bobsbookstore_dbo
-- ========================================================================
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- ========================================================================
-- END OF CONVERTED STATEMENTS
-- ========================================================================
-- Summary:
-- - All 5 statements converted manually after DMS tool failure
-- - Stored procedures converted to PostgreSQL function call syntax
-- - T-SQL functions converted to PostgreSQL equivalents
-- - Schema names preserved as bobsbookstore_dbo
-- - Parameter syntax preserved with @ prefix (Npgsql compatible)
-- ========================================================================
