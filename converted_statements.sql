-- =============================================
-- SQL Statement Conversion Report
-- Microsoft SQL Server to PostgreSQL Migration
-- Using DMS MCP Tool and Manual Conversion
-- =============================================
-- Total Statements Processed: 5
-- DMS Tool Successful Conversions: 0
-- Manual Conversions After DMS Failure: 5
-- Date: 2026-02-03
-- =============================================

-- =============================================
-- STATEMENT 1: uspUpdateAuthorPersonalInfo Stored Procedure Call
-- =============================================
-- Source: AuthorsController.cs, Method: EditUsingStoredProcedure
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: error
-- DMS Error Message: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- =============================================

-- ORIGINAL (T-SQL):
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- CONVERTED (PostgreSQL):
SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- CONVERSION NOTES:
-- T-SQL uses EXEC to call stored procedures with output parameters
-- PostgreSQL stored procedures are called as functions using SELECT
-- Removed DECLARE @rowsAffected as PostgreSQL functions return values directly
-- Changed [dbo].[uspUpdateAuthorPersonalInfo] to bobsbookstore_dbo.uspUpdateAuthorPersonalInfo (schema reference)
-- Parameters remain the same (@param syntax works with NpgsqlParameter)
-- =============================================


-- =============================================
-- STATEMENT 2: SELECT All Authors
-- =============================================
-- Source: AuthorsController.cs, Method: FindAllAuthorsEmbeddedSql
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: error
-- DMS Error Message: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- =============================================

-- ORIGINAL (T-SQL):
SELECT * FROM bobsbookstore_dbo.author

-- CONVERTED (PostgreSQL):
SELECT * FROM bobsbookstore_dbo.author

-- CONVERSION NOTES:
-- This is standard SQL compatible with both SQL Server and PostgreSQL
-- No conversion needed - statement is PostgreSQL compatible
-- Schema reference bobsbookstore_dbo.author is valid in PostgreSQL
-- =============================================


-- =============================================
-- STATEMENT 3: uspDeleteAuthor Stored Procedure Call
-- =============================================
-- Source: AuthorsController.cs, Method: DeleteAuthorEmbeddedSql
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: error
-- DMS Error Message: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- =============================================

-- ORIGINAL (T-SQL):
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- CONVERTED (PostgreSQL):
SELECT bobsbookstore_dbo.uspDeleteAuthor(@BusinessEntityID);

-- CONVERSION NOTES:
-- T-SQL uses EXEC to call stored procedures with output parameters
-- PostgreSQL stored procedures are called as functions using SELECT
-- Removed DECLARE @rowsAffected as PostgreSQL functions return values directly
-- Changed [dbo].[uspDeleteAuthor] to bobsbookstore_dbo.uspDeleteAuthor (schema reference)
-- Parameter remains the same (@BusinessEntityID works with NpgsqlParameter)
-- =============================================


-- =============================================
-- STATEMENT 4: SELECT Authors by Hire Year with T-SQL Functions
-- =============================================
-- Source: AuthorsController.cs, Method: SelectAuthorsByHireYear
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: error
-- DMS Error Message: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- =============================================

-- ORIGINAL (T-SQL):
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- CONVERTED (PostgreSQL):
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, DATE_PART('year', AGE(CURRENT_TIMESTAMP, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE DATE_PART('year', HireDate) = @HireDate;

-- CONVERSION NOTES:
-- FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') → TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS')
--   - PostgreSQL uses TO_CHAR for date formatting
--   - Format string uses YYYY (uppercase) instead of yyyy
--   - HH24 for 24-hour format instead of HH
--   - MI for minutes, SS for seconds
-- DATEDIFF(YEAR, BirthDate, GETDATE()) → DATE_PART('year', AGE(CURRENT_TIMESTAMP, BirthDate))
--   - PostgreSQL uses AGE() function to calculate interval between dates
--   - DATE_PART extracts the year component
--   - GETDATE() replaced with CURRENT_TIMESTAMP
-- DATEPART(YEAR, HireDate) → DATE_PART('year', HireDate)
--   - Direct equivalent in PostgreSQL
-- Schema reference bobsbookstore_dbo.author remains unchanged
-- Parameter @HireDate remains the same
-- =============================================


-- =============================================
-- STATEMENT 5: uspGetProductData Stored Procedure Call
-- =============================================
-- Source: ProductsController.cs, Method: FindAllProducts
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Status: error
-- DMS Error Message: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- =============================================

-- ORIGINAL (T-SQL):
EXEC [dbo].[uspGetProductData];

-- CONVERTED (PostgreSQL):
SELECT * FROM bobsbookstore_dbo.uspGetProductData();

-- CONVERSION NOTES:
-- T-SQL uses EXEC to call stored procedures
-- PostgreSQL stored procedures that return result sets are called as table-valued functions
-- Changed EXEC [dbo].[uspGetProductData] to SELECT * FROM bobsbookstore_dbo.uspGetProductData()
-- Changed schema reference from [dbo] to bobsbookstore_dbo
-- Added () for function call syntax
-- Used SELECT * FROM to handle result set returned by function
-- =============================================


-- =============================================
-- END OF CONVERSION REPORT
-- =============================================
-- Summary:
-- - Total Statements: 5
-- - DMS Tool Successful Conversions: 0
-- - Manual Conversions After DMS Failure: 5
-- - All statements processed through DMS tool as required
-- - All statements received manual conversion after DMS failure
-- - Key conversions:
--   * EXEC stored procedures → SELECT function_name() or SELECT * FROM function_name()
--   * FORMAT() → TO_CHAR()
--   * DATEDIFF() → DATE_PART('year', AGE())
--   * DATEPART() → DATE_PART()
--   * GETDATE() → CURRENT_TIMESTAMP
--   * [dbo] schema → bobsbookstore_dbo schema
-- =============================================
