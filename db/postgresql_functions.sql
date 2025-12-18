-- PostgreSQL Function Definitions for Bob's Bookstore Migration
-- Migration Date: December 18, 2025
-- Source: Microsoft SQL Server Stored Procedures
-- Target: PostgreSQL Database Functions
-- Schema: bobsbookstore_dbo

-- =============================================================================
-- FUNCTION 1: uspupdateauthorpersonalinfo
-- =============================================================================
-- Description: Updates author personal information in the author table
-- Returns: Number of rows affected (INTEGER)
-- Parameters:
--   - p_businessentityid: Author's business entity ID
--   - p_nationalidnumber: National ID number (15 characters max)
--   - p_birthdate: Birth date timestamp
--   - p_maritalstatus: Marital status (single character)
--   - p_gender: Gender (single character)
-- 
-- Original SQL Server Stored Procedure: [dbo].[uspUpdateAuthorPersonalInfo]
-- =============================================================================

CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspupdateauthorpersonalinfo(
    p_businessentityid INTEGER,
    p_nationalidnumber VARCHAR(15),
    p_birthdate TIMESTAMP,
    p_maritalstatus CHAR(1),
    p_gender CHAR(1)
) RETURNS INTEGER AS $$
DECLARE
    v_rows_affected INTEGER;
BEGIN
    -- Update author record with new personal information
    UPDATE bobsbookstore_dbo.author
    SET nationalidnumber = p_nationalidnumber,
        birthdate = p_birthdate,
        maritalstatus = p_maritalstatus,
        gender = p_gender,
        modifieddate = CURRENT_TIMESTAMP
    WHERE businessentityid = p_businessentityid;
    
    -- Get the number of rows affected by the UPDATE
    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
    
    -- Return the count of affected rows
    RETURN v_rows_affected;
END;
$$ LANGUAGE plpgsql;

-- =============================================================================
-- FUNCTION 2: uspdeleteauthor
-- =============================================================================
-- Description: Deletes an author from the author table
-- Returns: Number of rows affected (INTEGER)
-- Parameters:
--   - p_businessentityid: Author's business entity ID to delete
-- 
-- Error Handling: Raises exception if no author found with given ID
-- Original SQL Server Stored Procedure: [dbo].[uspDeleteAuthor]
-- =============================================================================

CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspdeleteauthor(
    p_businessentityid INTEGER
) RETURNS INTEGER AS $$
DECLARE
    v_rows_affected INTEGER;
BEGIN
    -- Delete author record
    DELETE FROM bobsbookstore_dbo.author
    WHERE businessentityid = p_businessentityid;
    
    -- Get the number of rows affected by the DELETE
    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
    
    -- Check if any rows were deleted
    IF v_rows_affected = 0 THEN
        -- Raise exception if no author found with the provided ID
        RAISE EXCEPTION 'No author found with the provided BusinessEntityID: %', p_businessentityid;
    END IF;
    
    -- Return the count of affected rows
    RETURN v_rows_affected;
END;
$$ LANGUAGE plpgsql;

-- =============================================================================
-- DEPLOYMENT VERIFICATION QUERIES
-- =============================================================================
-- Use these queries to verify functions were created successfully

-- Verify function 1 exists
SELECT 
    proname AS function_name,
    pg_get_function_arguments(oid) AS arguments,
    pg_get_function_result(oid) AS return_type
FROM pg_proc 
WHERE proname = 'uspupdateauthorpersonalinfo'
  AND pronamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'bobsbookstore_dbo');

-- Verify function 2 exists
SELECT 
    proname AS function_name,
    pg_get_function_arguments(oid) AS arguments,
    pg_get_function_result(oid) AS return_type
FROM pg_proc 
WHERE proname = 'uspdeleteauthor'
  AND pronamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'bobsbookstore_dbo');

-- =============================================================================
-- EXAMPLE USAGE (For Testing)
-- =============================================================================

-- Example 1: Update author personal information
-- SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(1, '123456789', '1980-01-01', 'M', 'M');

-- Example 2: Delete author
-- SELECT bobsbookstore_dbo.uspdeleteauthor(1);

-- =============================================================================
-- NOTES FOR DEPLOYMENT
-- =============================================================================
-- 1. Ensure schema 'bobsbookstore_dbo' exists before running this script
-- 2. Ensure table 'bobsbookstore_dbo.author' exists with required columns
-- 3. Required columns in author table:
--    - businessentityid (INTEGER, PRIMARY KEY)
--    - nationalidnumber (VARCHAR(15))
--    - birthdate (TIMESTAMP)
--    - maritalstatus (CHAR(1))
--    - gender (CHAR(1))
--    - modifieddate (TIMESTAMP)
-- 4. Functions use PL/pgSQL language - ensure it's enabled in your database
-- 5. Functions return INTEGER representing the number of rows affected
-- 6. Error handling in uspdeleteauthor will raise exception if author not found

-- =============================================================================
-- MIGRATION MAPPING REFERENCE
-- =============================================================================
-- SQL Server Pattern:
--   DECLARE @rowsAffected INT;
--   EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @param1, @param2, ...;
--   SELECT @rowsAffected;
--
-- PostgreSQL Pattern:
--   SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo($1, $2, ...);
--
-- The PostgreSQL function directly returns the row count, eliminating the need
-- for DECLARE and EXEC statements.
-- =============================================================================
