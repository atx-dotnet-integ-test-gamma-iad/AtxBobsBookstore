-- ============================================================================
-- CONVERTED SQL STATEMENTS FOR POSTGRESQL
-- Source: BobsBookstore .NET Application
-- Purpose: PostgreSQL-converted statements from Microsoft SQL Server
-- Total Statements: 5
-- All statements were attempted through DMS MCP tool first
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: EditUsingStoredProcedure - Stored Procedure Call
-- ============================================================================
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed - no objects found
-- Original: DECLARE @rowsAffected INT; EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] ...
-- Conversion Notes:
--   - PostgreSQL stored procedures use CALL instead of EXEC
--   - DECLARE syntax not needed for function calls
--   - [dbo] schema replaced with bobsbookstore_dbo
--   - OUTPUT parameters handled differently in PostgreSQL
--   - Using SELECT to call function and return result
-- ============================================================================
SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ============================================================================
-- STATEMENT 2: FindAllAuthorsEmbeddedSql - Simple SELECT
-- ============================================================================
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE (already PostgreSQL-compatible)
-- DMS Error: Metadata model creation failed - no objects found
-- Original: SELECT * FROM bobsbookstore_dbo.author;
-- Conversion Notes:
--   - This statement is already PostgreSQL-compatible
--   - Schema prefix bobsbookstore_dbo is correct for PostgreSQL
--   - No changes needed
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author;

-- ============================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql - Stored Procedure Call
-- ============================================================================
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed - no objects found
-- Original: DECLARE @rowsAffected INT; EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
-- Conversion Notes:
--   - PostgreSQL stored procedures use CALL instead of EXEC
--   - DECLARE syntax not needed for function calls
--   - [dbo] schema replaced with bobsbookstore_dbo
--   - OUTPUT parameters handled differently in PostgreSQL
--   - Using SELECT to call function and return result
-- ============================================================================
SELECT bobsbookstore_dbo.uspDeleteAuthor(@BusinessEntityID);

-- ============================================================================
-- STATEMENT 4: SelectAuthorsByHireYear - Complex SELECT with SQL Server Functions
-- ============================================================================
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed - no objects found
-- Original: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- Conversion Notes:
--   - FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') -> TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS')
--   - DATEDIFF(YEAR, BirthDate, GETDATE()) -> EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, BirthDate))
--   - GETDATE() -> CURRENT_TIMESTAMP
--   - DATEPART(YEAR, HireDate) -> EXTRACT(YEAR FROM HireDate)
--   - All SQL Server-specific functions converted to PostgreSQL equivalents
-- ============================================================================
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- ============================================================================
-- STATEMENT 5: FindAllProducts - Stored Procedure Call
-- ============================================================================
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed - no objects found
-- Original: EXEC [dbo].[uspGetProductData];
-- Conversion Notes:
--   - PostgreSQL stored procedures use CALL instead of EXEC
--   - [dbo] schema replaced with bobsbookstore_dbo
--   - For SELECT-returning procedures, use SELECT FROM function
--   - Assuming uspGetProductData returns a result set (table-valued function)
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.uspGetProductData();

-- ============================================================================
-- END OF CONVERTED STATEMENTS
-- ============================================================================
-- CONVERSION SUMMARY:
-- Total Statements: 5
-- DMS Tool Success: 0
-- Manual Conversions: 5
-- All statements were first attempted through DMS MCP tool as required
-- Manual conversions applied after DMS metadata model creation failures
-- ============================================================================
