-- ============================================================================
-- CONVERTED SQL STATEMENTS FROM SQL SERVER TO POSTGRESQL
-- ============================================================================
-- This file contains all PostgreSQL converted statements
-- Each statement includes:
--   - Original SQL Server statement (as comment)
--   - Converted PostgreSQL statement
--   - Conversion method (DMS_TOOL or MANUAL_AFTER_DMS_FAILURE)
--   - Conversion notes
-- ============================================================================

-- ----------------------------------------------------------------------------
-- STATEMENT 1: Update Author Personal Info Stored Procedure Call
-- ----------------------------------------------------------------------------
-- Original SQL Server:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
--
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
--
-- Conversion Notes:
-- - In PostgreSQL, stored procedures are called as functions
-- - DECLARE/EXEC pattern replaced with SELECT function call
-- - Schema [dbo] converted to bobsbookstore_dbo based on existing schema mapping
-- - Return value captured through function result
-- - Parameters use PostgreSQL syntax
-- ----------------------------------------------------------------------------
SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ----------------------------------------------------------------------------
-- STATEMENT 2: Delete Author Stored Procedure Call
-- ----------------------------------------------------------------------------
-- Original SQL Server:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
--
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
--
-- Conversion Notes:
-- - DECLARE/EXEC pattern replaced with SELECT function call
-- - Schema [dbo] converted to bobsbookstore_dbo
-- - Simplified to direct function call
-- ----------------------------------------------------------------------------
SELECT bobsbookstore_dbo.uspDeleteAuthor(@BusinessEntityID);

-- ----------------------------------------------------------------------------
-- STATEMENT 3: Select All Authors
-- ----------------------------------------------------------------------------
-- Original SQL Server:
-- SELECT * FROM bobsbookstore_dbo.author
--
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
--
-- Conversion Notes:
-- - Statement is already PostgreSQL compatible
-- - Schema name bobsbookstore_dbo remains unchanged
-- - No conversion needed beyond case sensitivity considerations
-- ----------------------------------------------------------------------------
SELECT * FROM bobsbookstore_dbo.author;

-- ----------------------------------------------------------------------------
-- STATEMENT 4: Select Authors by Hire Year with Date Functions
-- ----------------------------------------------------------------------------
-- Original SQL Server:
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
--
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
--
-- Conversion Notes:
-- - FORMAT(date, 'yyyy-MM-dd HH:mm:ss') → TO_CHAR(date, 'YYYY-MM-DD HH24:MI:SS')
-- - DATEDIFF(YEAR, BirthDate, GETDATE()) → EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, BirthDate))
-- - GETDATE() → CURRENT_TIMESTAMP
-- - DATEPART(YEAR, date) → EXTRACT(YEAR FROM date)
-- ----------------------------------------------------------------------------
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- ============================================================================
-- STORED PROCEDURE DEFINITIONS - CONVERTED TO POSTGRESQL FUNCTIONS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- FUNCTION 1: uspUpdateAuthorPersonalInfo
-- ----------------------------------------------------------------------------
-- Original SQL Server Stored Procedure:
-- CREATE PROCEDURE [dbo].[uspUpdateAuthorPersonalInfo]
--     @BusinessEntityID [int], 
--     @NationalIDNumber [nvarchar](15), 
--     @BirthDate [datetime], 
--     @MaritalStatus [nchar](1), 
--     @Gender [nchar](1)
-- WITH EXECUTE AS CALLER
-- AS
-- BEGIN
--     SET NOCOUNT ON;
--     BEGIN TRY
--         UPDATE [dbo].[Author] 
--         SET [NationalIDNumber] = @NationalIDNumber 
--             ,[BirthDate] = @BirthDate 
--             ,[MaritalStatus] = @MaritalStatus 
--             ,[Gender] = @Gender 
--         WHERE [BusinessEntityID] = @BusinessEntityID;
--     END TRY
--     BEGIN CATCH
--         EXECUTE [dbo].[uspLogError];
--     END CATCH;
-- END;
--
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
--
-- Conversion Notes:
-- - CREATE PROCEDURE → CREATE OR REPLACE FUNCTION
-- - Parameters use PostgreSQL syntax (parameter_name parameter_type)
-- - RETURNS INTEGER for row count
-- - Language PL/pgSQL
-- - WITH EXECUTE AS CALLER removed (not applicable in PostgreSQL)
-- - SET NOCOUNT ON removed (not applicable in PostgreSQL)
-- - BEGIN TRY/CATCH → EXCEPTION block in PL/pgSQL
-- - Schema [dbo] → bobsbookstore_dbo
-- - Function returns row count from UPDATE
-- - Error handling uses PostgreSQL EXCEPTION syntax
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(
    p_BusinessEntityID INTEGER, 
    p_NationalIDNumber VARCHAR(15), 
    p_BirthDate TIMESTAMP, 
    p_MaritalStatus CHAR(1), 
    p_Gender CHAR(1)
) RETURNS INTEGER AS $$
DECLARE
    v_rows_affected INTEGER;
BEGIN
    UPDATE bobsbookstore_dbo.author 
    SET nationalnidnumber = p_NationalIDNumber,
        birthdate = p_BirthDate,
        maritalstatus = p_MaritalStatus,
        gender = p_Gender
    WHERE businessentityid = p_BusinessEntityID;
    
    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
    RETURN v_rows_affected;
EXCEPTION
    WHEN OTHERS THEN
        PERFORM bobsbookstore_dbo.uspLogError();
        RAISE;
END;
$$ LANGUAGE plpgsql;

-- ----------------------------------------------------------------------------
-- FUNCTION 2: uspDeleteAuthor
-- ----------------------------------------------------------------------------
-- Original SQL Server Stored Procedure:
-- CREATE PROCEDURE [dbo].[uspDeleteAuthor]
--     @BusinessEntityID [int]
-- WITH EXECUTE AS CALLER
-- AS
-- BEGIN
--     SET NOCOUNT ON;
--     BEGIN TRY
--         DELETE FROM [dbo].[Author]
--         WHERE [BusinessEntityID] = @BusinessEntityID;
--         IF @@ROWCOUNT = 0
--         BEGIN
--             RAISERROR('No author found with the provided BusinessEntityID.', 16, 1);
--             RETURN;
--         END
--     END TRY
--     BEGIN CATCH
--         EXECUTE [dbo].[uspLogError];
--         THROW;
--     END CATCH;
-- END;
--
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
--
-- Conversion Notes:
-- - CREATE PROCEDURE → CREATE OR REPLACE FUNCTION
-- - RETURNS INTEGER for row count
-- - @@ROWCOUNT → GET DIAGNOSTICS ... ROW_COUNT
-- - RAISERROR → RAISE EXCEPTION
-- - THROW → RAISE (re-raises current exception)
-- - Error handling uses PostgreSQL EXCEPTION syntax
-- - Schema [dbo] → bobsbookstore_dbo
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspDeleteAuthor(
    p_BusinessEntityID INTEGER
) RETURNS INTEGER AS $$
DECLARE
    v_rows_affected INTEGER;
BEGIN
    DELETE FROM bobsbookstore_dbo.author
    WHERE businessentityid = p_BusinessEntityID;
    
    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
    
    IF v_rows_affected = 0 THEN
        RAISE EXCEPTION 'No author found with the provided BusinessEntityID.';
    END IF;
    
    RETURN v_rows_affected;
EXCEPTION
    WHEN OTHERS THEN
        PERFORM bobsbookstore_dbo.uspLogError();
        RAISE;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- CONVERSION SUMMARY
-- ============================================================================
-- Total Statements Converted: 6
--   - Inline Queries: 2
--   - Stored Procedure Calls: 2
--   - Stored Procedure Definitions: 2
--
-- Conversion Methods:
--   - Successfully converted by DMS Tool: 0
--   - Manually converted after DMS failure: 6
--
-- Key Conversions Applied:
--   - DECLARE @var; EXEC @var = proc → SELECT schema.function()
--   - FORMAT() → TO_CHAR()
--   - DATEDIFF(YEAR, d1, d2) → EXTRACT(YEAR FROM AGE(d2, d1))
--   - DATEPART(YEAR, date) → EXTRACT(YEAR FROM date)
--   - GETDATE() → CURRENT_TIMESTAMP
--   - CREATE PROCEDURE → CREATE OR REPLACE FUNCTION
--   - BEGIN TRY/CATCH/END → EXCEPTION WHEN OTHERS
--   - @@ROWCOUNT → GET DIAGNOSTICS ... ROW_COUNT
--   - RAISERROR → RAISE EXCEPTION
--   - [schema].[object] → schema.object
--   - Parameter @name → p_name
--   - Variable naming conventions updated for PostgreSQL
-- ============================================================================
