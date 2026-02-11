-- ====================================================================================
-- CONVERTED SQL STATEMENTS CATALOG
-- Microsoft SQL Server to PostgreSQL Migration
-- ====================================================================================
-- This file contains all converted PostgreSQL statements with their conversion status
-- Each statement includes:
--   - Statement ID (matching extracted_statements.sql)
--   - Original MS SQL statement
--   - Converted PostgreSQL statement
--   - Conversion status (DMS_TOOL_SUCCESS, MANUAL_AFTER_DMS_FAILURE)
--   - DMS tool output summary
--   - Schema object name changes (if any)
-- ====================================================================================

-- ====================================================================================
-- STATEMENT 1 - STMT_001
-- ====================================================================================
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Location: Line 163
-- Method: EditUsingStoredProcedure

-- Original MS SQL:
-- DECLARE @rowsAffected INT;
-- EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
-- SELECT @rowsAffected;

-- Converted PostgreSQL:
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(
    @BusinessEntityID::integer, 
    @NationalIDNumber::varchar, 
    @BirthDate::timestamp, 
    @MaritalStatus::varchar, 
    @Gender::varchar
);

-- Schema Changes: 
--   - [dbo].[uspUpdateAuthorPersonalInfo] → bobsbookstore_dbo.uspupdateauthorpersonalinfo
--   - Function name lowercased per PostgreSQL convention
--   - Schema qualifier changed from [dbo] to bobsbookstore_dbo

-- ====================================================================================
-- STATEMENT 2 - STMT_002
-- ====================================================================================
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Location: Line 187
-- Method: FindAllAuthorsEmbeddedSql

-- Original MS SQL:
-- SELECT * FROM bobsbookstore_dbo.author;

-- Converted PostgreSQL:
SELECT * FROM bobsbookstore_dbo.author;

-- Schema Changes: None
-- Notes: Statement is already PostgreSQL compatible

-- ====================================================================================
-- STATEMENT 3 - STMT_003
-- ====================================================================================
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Location: Line 208
-- Method: DeleteAuthorEmbeddedSql

-- Original MS SQL:
-- DECLARE @rowsAffected INT;
-- EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
-- SELECT @rowsAffected;

-- Converted PostgreSQL:
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID::integer);

-- Schema Changes:
--   - [dbo].[uspDeleteAuthor] → bobsbookstore_dbo.uspdeleteauthor
--   - Function name lowercased per PostgreSQL convention
--   - Schema qualifier changed from [dbo] to bobsbookstore_dbo

-- ====================================================================================
-- STATEMENT 4 - STMT_004
-- ====================================================================================
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Tool Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Location: Line 228
-- Method: SelectAuthorsByHireYear

-- Original MS SQL:
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Converted PostgreSQL:
SELECT 
    BusinessEntityID, 
    TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, 
    DATE_PART('year', AGE(CURRENT_TIMESTAMP, BirthDate)) AS Age 
FROM bobsbookstore_dbo.author 
WHERE DATE_PART('year', HireDate) = @HireDate;

-- Schema Changes: None (table name remains bobsbookstore_dbo.author)
-- Function Changes:
--   - FORMAT() → TO_CHAR()
--   - DATEDIFF() → DATE_PART() with AGE()
--   - GETDATE() → CURRENT_TIMESTAMP
--   - DATEPART() → DATE_PART()

-- ====================================================================================
-- CONVERSION SUMMARY
-- ====================================================================================
-- Total Statements: 4
-- Successfully Converted by DMS Tool: 0
-- Manually Converted After DMS Failure: 4
-- Conversion Success Rate: 100% (including manual conversions)
--
-- Schema Object Name Changes:
--   1. [dbo].[uspUpdateAuthorPersonalInfo] → bobsbookstore_dbo.uspupdateauthorpersonalinfo
--   2. [dbo].[uspDeleteAuthor] → bobsbookstore_dbo.uspdeleteauthor
--   3. Table bobsbookstore_dbo.author → No change (already PostgreSQL compatible)
--
-- Key Conversion Patterns:
--   - SQL Server stored procedure EXEC → PostgreSQL function SELECT
--   - SQL Server date/time functions → PostgreSQL equivalents
--   - Schema qualifiers [dbo] → bobsbookstore_dbo (lowercase per convention)
--   - Parameter syntax preserved (@param) for NpgsqlParameter compatibility
-- ====================================================================================
