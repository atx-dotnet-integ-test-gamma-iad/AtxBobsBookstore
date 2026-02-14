-- ============================================================================
-- CONVERTED SQL STATEMENTS - POSTGRESQL VERSION
-- Conversion Date: Migration Phase 2
-- Total Statements: 5
-- Conversion Method: Manual (DMS Tool Failed)
-- ============================================================================

-- ----------------------------------------------------------------------------
-- STATEMENT 1: Update Author Personal Info Using Stored Procedure
-- ----------------------------------------------------------------------------
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- PostgreSQL Conversion Notes: 
--   - Removed DECLARE statement (not needed in this context)
--   - Converted EXEC to SELECT with function call
--   - PostgreSQL stored procedures/functions are called using SELECT
--   - Changed schema reference from [dbo].[procname] to schema.procname format
-- ----------------------------------------------------------------------------
SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ----------------------------------------------------------------------------
-- STATEMENT 2: Select All Authors
-- ----------------------------------------------------------------------------
-- Original MS SQL: SELECT * FROM bobsbookstore_dbo.author
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- PostgreSQL Conversion Notes: 
--   - This statement is already PostgreSQL compatible
--   - No conversion needed - standard SELECT statement
-- ----------------------------------------------------------------------------
SELECT * FROM bobsbookstore_dbo.author

-- ----------------------------------------------------------------------------
-- STATEMENT 3: Delete Author Using Stored Procedure
-- ----------------------------------------------------------------------------
-- Original MS SQL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- PostgreSQL Conversion Notes: 
--   - Removed DECLARE statement
--   - Converted EXEC to SELECT with function call
--   - Changed schema reference to PostgreSQL format
-- ----------------------------------------------------------------------------
SELECT bobsbookstore_dbo.uspDeleteAuthor(@BusinessEntityID);

-- ----------------------------------------------------------------------------
-- STATEMENT 4: Select Authors By Hire Year with Calculated Fields
-- ----------------------------------------------------------------------------
-- Original MS SQL: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- PostgreSQL Conversion Notes: 
--   - FORMAT() replaced with TO_CHAR() for date formatting
--   - DATEDIFF(YEAR, date1, date2) replaced with DATE_PART('year', AGE(date2, date1))
--   - GETDATE() replaced with CURRENT_TIMESTAMP
--   - DATEPART(YEAR, date) replaced with EXTRACT(YEAR FROM date)
-- ----------------------------------------------------------------------------
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, DATE_PART('year', AGE(CURRENT_TIMESTAMP, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- ----------------------------------------------------------------------------
-- STATEMENT 5: Get Product Data Using Stored Procedure
-- ----------------------------------------------------------------------------
-- Original MS SQL: EXEC [dbo].[uspGetProductData];
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- PostgreSQL Conversion Notes: 
--   - Converted EXEC to SELECT * FROM for stored procedure call
--   - Changed schema reference to PostgreSQL format
--   - PostgreSQL requires SELECT * FROM for procedures that return result sets
-- ----------------------------------------------------------------------------
SELECT * FROM bobsbookstore_dbo.uspGetProductData();

-- ============================================================================
-- END OF CONVERTED STATEMENTS
-- ============================================================================
