-- ============================================================================
-- PostgreSQL Function Definitions
-- Converted from SQL Server Stored Procedures
-- Migration Date: 2026-01-02
-- ============================================================================
-- This file contains PostgreSQL function equivalents for SQL Server stored
-- procedures used by the BobsBookstore application. These functions must be
-- created in the PostgreSQL database before running the migrated application.
-- ============================================================================

-- ============================================================================
-- FUNCTION: bobsbookstore_dbo.uspupdateauthorpersonalinfo
-- Original SQL Server Stored Procedure: [dbo].[uspUpdateAuthorPersonalInfo]
-- ============================================================================
-- Purpose: Updates personal information for an author
-- Parameters:
--   p_businessentityid - Author's business entity identifier
--   p_nationalidnumber - National identification number
--   p_birthdate - Date of birth
--   p_maritalstatus - Marital status code (single character)
--   p_gender - Gender code (single character)
-- Returns: Number of rows affected
-- ============================================================================

CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspupdateauthorpersonalinfo(
    p_businessentityid INTEGER,
    p_nationalidnumber TEXT,
    p_birthdate TIMESTAMP,
    p_maritalstatus TEXT,
    p_gender TEXT
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_rows_affected INTEGER;
BEGIN
    -- Update the author record
    UPDATE bobsbookstore_dbo.author
    SET nationalidnumber = p_nationalidnumber,
        birthdate = p_birthdate,
        maritalstatus = p_maritalstatus,
        gender = p_gender,
        modifieddate = CURRENT_TIMESTAMP
    WHERE businessentityid = p_businessentityid;
    
    -- Get the number of rows affected
    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
    
    -- Return the number of rows affected
    RETURN v_rows_affected;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Log error details
        RAISE NOTICE 'Error in uspupdateauthorpersonalinfo: % %', SQLERRM, SQLSTATE;
        -- Re-raise the exception
        RAISE;
END;
$$;

-- Grant execute permission (adjust schema and role as needed)
-- GRANT EXECUTE ON FUNCTION bobsbookstore_dbo.uspupdateauthorpersonalinfo TO your_app_role;

-- ============================================================================
-- FUNCTION: bobsbookstore_dbo.uspdeleteauthor
-- Original SQL Server Stored Procedure: [dbo].[uspDeleteAuthor]
-- ============================================================================
-- Purpose: Deletes an author record by business entity ID
-- Parameters:
--   p_businessentityid - Author's business entity identifier to delete
-- Returns: Number of rows affected (1 if successful, 0 if not found)
-- Exceptions: Raises error if author not found
-- ============================================================================

CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspdeleteauthor(
    p_businessentityid INTEGER
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_rows_affected INTEGER;
BEGIN
    -- Delete the author record
    DELETE FROM bobsbookstore_dbo.author
    WHERE businessentityid = p_businessentityid;
    
    -- Get the number of rows affected
    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
    
    -- Check if the delete was successful
    IF v_rows_affected = 0 THEN
        RAISE EXCEPTION 'No author found with the provided BusinessEntityID: %', p_businessentityid
            USING ERRCODE = 'P0001'; -- Custom error code
    END IF;
    
    -- Return the number of rows affected
    RETURN v_rows_affected;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Log error details
        RAISE NOTICE 'Error in uspdeleteauthor: % %', SQLERRM, SQLSTATE;
        -- Re-raise the exception
        RAISE;
END;
$$;

-- Grant execute permission (adjust schema and role as needed)
-- GRANT EXECUTE ON FUNCTION bobsbookstore_dbo.uspdeleteauthor TO your_app_role;

-- ============================================================================
-- CONVERSION NOTES
-- ============================================================================
-- 1. SQL Server stored procedures → PostgreSQL functions
--    - SQL Server: CREATE PROCEDURE
--    - PostgreSQL: CREATE OR REPLACE FUNCTION
--
-- 2. Parameter naming conventions
--    - SQL Server: @ParameterName
--    - PostgreSQL: p_parametername (prefixed with p_, lowercase)
--
-- 3. Variable naming conventions
--    - SQL Server: @variableName
--    - PostgreSQL: v_variablename (prefixed with v_, lowercase)
--
-- 4. Return values
--    - SQL Server: Uses OUTPUT parameters or RETURN statement
--    - PostgreSQL: Functions explicitly RETURN a value with defined type
--
-- 5. Row count handling
--    - SQL Server: @@ROWCOUNT
--    - PostgreSQL: GET DIAGNOSTICS v_variable = ROW_COUNT
--
-- 6. Error handling
--    - SQL Server: BEGIN TRY...END TRY, BEGIN CATCH...END CATCH
--    - PostgreSQL: EXCEPTION WHEN...THEN
--
-- 7. Error raising
--    - SQL Server: RAISERROR('message', severity, state)
--    - PostgreSQL: RAISE EXCEPTION 'message' USING ERRCODE = 'code'
--
-- 8. Function invocation from application code
--    - SQL Server: EXEC @returnValue = [dbo].[uspProcedureName] @param1, @param2
--    - PostgreSQL: SELECT bobsbookstore_dbo.functionname($1, $2)
--
-- 9. Schema handling
--    - Both SQL Server [dbo] and PostgreSQL functions use bobsbookstore_dbo schema
--    - Ensure the schema exists before creating functions:
--      CREATE SCHEMA IF NOT EXISTS bobsbookstore_dbo;
--
-- 10. Column name case sensitivity
--    - PostgreSQL column names are case-insensitive unless quoted
--    - The functions assume lowercase column names (PostgreSQL default)
--    - If your schema uses mixed-case quoted column names, adjust accordingly
-- ============================================================================

-- ============================================================================
-- DEPLOYMENT INSTRUCTIONS
-- ============================================================================
-- 1. Ensure the schema exists:
--    CREATE SCHEMA IF NOT EXISTS bobsbookstore_dbo;
--
-- 2. Execute this script against your PostgreSQL database:
--    psql -U your_user -d your_database -f postgresql_functions.sql
--
-- 3. Verify function creation:
--    SELECT proname, pronargs 
--    FROM pg_proc p
--    JOIN pg_namespace n ON p.pronamespace = n.oid
--    WHERE n.nspname = 'bobsbookstore_dbo'
--    ORDER BY proname;
--
-- 4. Test the functions:
--    -- Test uspupdateauthorpersonalinfo
--    SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(
--        1,                          -- businessentityid
--        '123456789',                -- nationalidnumber
--        '1980-01-01'::TIMESTAMP,    -- birthdate
--        'M',                        -- maritalstatus
--        'M'                         -- gender
--    );
--
--    -- Test uspdeleteauthor
--    SELECT bobsbookstore_dbo.uspdeleteauthor(9999);
--
-- 5. Grant appropriate permissions to application database user
-- ============================================================================

-- ============================================================================
-- SCHEMA DEPENDENCY VERIFICATION
-- ============================================================================
-- Before running this script, verify that:
-- 1. Schema 'bobsbookstore_dbo' exists
-- 2. Table 'bobsbookstore_dbo.author' exists with columns:
--    - businessentityid (INTEGER, PRIMARY KEY)
--    - nationalidnumber (TEXT or VARCHAR)
--    - birthdate (TIMESTAMP or DATE)
--    - maritalstatus (TEXT, VARCHAR, or CHAR)
--    - gender (TEXT, VARCHAR, or CHAR)
--    - modifieddate (TIMESTAMP)
-- ============================================================================
