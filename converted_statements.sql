-- ========================================================================================================
-- CONVERTED SQL STATEMENTS CATALOG
-- Purpose: Comprehensive catalog of all PostgreSQL converted statements from BobsBookstore application
-- Created: Step 2 - SQL Statement Conversion Phase
-- Total Statements: 4
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE (all statements)
-- ========================================================================================================

-- ========================================================================================================
-- STATEMENT 1: UPDATE Author Personal Info via Function Call
-- ========================================================================================================
-- Original File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line Number: 159
-- Type: PostgreSQL Function Call (converted from SQL Server Stored Procedure)
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Status: ERROR - Metadata model creation failed
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- Description: Calls PostgreSQL function usp_update_author_personal_info to update author personal information
-- Conversion Notes:
--   - SQL Server DECLARE/EXEC/SELECT pattern converted to direct function call
--   - Schema changed from [dbo] to bobsbookstore_dbo
--   - Function name converted to PostgreSQL naming convention (lowercase with underscores)
-- ========================================================================================================

SELECT bobsbookstore_dbo.usp_update_author_personal_info(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ========================================================================================================
-- STATEMENT 2: SELECT All Authors
-- ========================================================================================================
-- Original File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line Number: 183
-- Type: SELECT statement (unchanged - already PostgreSQL compatible)
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE (no changes needed)
-- DMS Status: ERROR - Metadata model creation failed
-- Parameters: None
-- Description: Simple SELECT to retrieve all author records from bobsbookstore_dbo.author table
-- Conversion Notes:
--   - Statement was already PostgreSQL-compatible
--   - No SQL Server-specific syntax present
--   - Schema name bobsbookstore_dbo already in PostgreSQL format
--   - No conversion needed
-- ========================================================================================================

SELECT * FROM bobsbookstore_dbo.author

-- ========================================================================================================
-- STATEMENT 3: DELETE Author via Function Call
-- ========================================================================================================
-- Original File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line Number: 207
-- Type: PostgreSQL Function Call (converted from SQL Server Stored Procedure)
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Status: ERROR - Metadata model creation failed
-- Parameters: @BusinessEntityID (int)
-- Description: Calls PostgreSQL function usp_delete_author to delete author
-- Conversion Notes:
--   - SQL Server DECLARE/EXEC/SELECT pattern converted to direct function call
--   - Schema changed from [dbo] to bobsbookstore_dbo
--   - Function name converted to PostgreSQL naming convention (lowercase with underscores)
-- ========================================================================================================

SELECT bobsbookstore_dbo.usp_delete_author(@BusinessEntityID);

-- ========================================================================================================
-- STATEMENT 4: SELECT Authors by Hire Year with PostgreSQL Date Functions
-- ========================================================================================================
-- Original File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line Number: 227
-- Type: SELECT with PostgreSQL date functions (converted from SQL Server functions)
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Status: ERROR - Metadata model creation failed
-- Parameters: @HireDate (int - year value)
-- Description: Complex SELECT with PostgreSQL date functions to format dates, calculate age, and filter by hire year
-- Conversion Notes:
--   - FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') -> TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS')
--   - DATEDIFF(YEAR, BirthDate, GETDATE()) -> EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate))
--   - GETDATE() -> CURRENT_DATE
--   - DATEPART(YEAR, HireDate) -> EXTRACT(YEAR FROM HireDate)
--   - Schema name bobsbookstore_dbo already in PostgreSQL format
-- PostgreSQL Functions Used:
--   - TO_CHAR(date, format): Formats date to specific string format
--   - EXTRACT(YEAR FROM AGE(date1, date2)): Calculates age in years between two dates
--   - CURRENT_DATE: Returns current date
--   - EXTRACT(YEAR FROM date): Extracts year part from date
-- ========================================================================================================

SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- ========================================================================================================
-- CONVERSION MAPPING SUMMARY
-- ========================================================================================================
-- Statement 1: SQL Server DECLARE/EXEC stored procedure -> PostgreSQL function call
-- Statement 2: SQL Server SELECT -> PostgreSQL SELECT (no changes needed)
-- Statement 3: SQL Server DECLARE/EXEC stored procedure -> PostgreSQL function call
-- Statement 4: SQL Server date functions -> PostgreSQL date functions
-- ========================================================================================================

-- ========================================================================================================
-- END OF CONVERTED STATEMENTS CATALOG
-- Total Statements Converted: 4
-- DMS Tool Success: 0
-- Manual Conversions: 4 (3 actual conversions, 1 unchanged)
-- Next Step: Validate equivalency using SQL Equivalency MCP tool (sql-equivalency___validate_sql_equivalence)
-- ========================================================================================================
