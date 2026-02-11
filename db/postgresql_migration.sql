-- ========================================
-- PostgreSQL Migration Script
-- SQL Server to PostgreSQL Migration
-- BobsBookstore Application
-- Created: 2026-02-11
-- ========================================
--
-- DESCRIPTION:
-- This script migrates SQL Server stored procedures to PostgreSQL functions
-- for the BobsBookstore application. Execute this script after the database
-- schema has been migrated using Entity Framework migrations.
--
-- PREREQUISITES:
-- 1. PostgreSQL database created
-- 2. Schema 'bobsbookstore_dbo' exists
-- 3. All tables migrated (author, product, etc.)
-- 4. User has CREATE FUNCTION privileges
--
-- EXECUTION:
-- psql -h <host> -U <username> -d BobsBookstore -f postgresql_migration.sql
--
-- ========================================

\echo 'Starting PostgreSQL Migration for BobsBookstore...'
\echo ''

-- Set client encoding
SET client_encoding = 'UTF8';

-- Begin transaction for atomic migration
BEGIN;

\echo 'Step 1: Creating schema if not exists...'
CREATE SCHEMA IF NOT EXISTS bobsbookstore_dbo;

\echo 'Step 2: Dropping existing functions if they exist...'

DROP FUNCTION IF EXISTS bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(INTEGER, VARCHAR, TIMESTAMP, VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS bobsbookstore_dbo.uspDeleteAuthor(INTEGER);
DROP FUNCTION IF EXISTS bobsbookstore_dbo.uspGetProductData();

\echo 'Step 3: Creating function uspUpdateAuthorPersonalInfo...'

CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(
    p_BusinessEntityID INTEGER,
    p_NationalIDNumber VARCHAR(15),
    p_BirthDate TIMESTAMP,
    p_MaritalStatus VARCHAR(1),
    p_Gender VARCHAR(1)
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_rows_affected INTEGER;
BEGIN
    -- Update author personal information
    UPDATE bobsbookstore_dbo.author
    SET 
        nationalidnumber = p_NationalIDNumber,
        birthdate = p_BirthDate,
        maritalstatus = p_MaritalStatus,
        gender = p_Gender,
        modifieddate = CURRENT_TIMESTAMP
    WHERE 
        businessentityid = p_BusinessEntityID;
    
    -- Get number of rows affected
    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
    
    -- Return number of rows affected
    RETURN v_rows_affected;
END;
$$;

GRANT EXECUTE ON FUNCTION bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(INTEGER, VARCHAR, TIMESTAMP, VARCHAR, VARCHAR) TO PUBLIC;
COMMENT ON FUNCTION bobsbookstore_dbo.uspUpdateAuthorPersonalInfo IS 'Updates author personal information and returns number of rows affected';

\echo 'Step 4: Creating function uspDeleteAuthor...'

CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspDeleteAuthor(
    p_BusinessEntityID INTEGER
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_rows_affected INTEGER;
BEGIN
    -- Delete author record
    DELETE FROM bobsbookstore_dbo.author
    WHERE businessentityid = p_BusinessEntityID;
    
    -- Get number of rows affected
    GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
    
    -- Return number of rows affected
    RETURN v_rows_affected;
END;
$$;

GRANT EXECUTE ON FUNCTION bobsbookstore_dbo.uspDeleteAuthor(INTEGER) TO PUBLIC;
COMMENT ON FUNCTION bobsbookstore_dbo.uspDeleteAuthor IS 'Deletes an author record and returns number of rows affected';

\echo 'Step 5: Creating function uspGetProductData...'

CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspGetProductData()
RETURNS TABLE (
    productid INTEGER,
    productname VARCHAR(100),
    productdescription TEXT,
    price NUMERIC(10, 2),
    stockquantity INTEGER,
    categoryid INTEGER,
    modifieddate TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Return all product data
    RETURN QUERY
    SELECT 
        p.productid,
        p.productname,
        p.productdescription,
        p.price,
        p.stockquantity,
        p.categoryid,
        p.modifieddate
    FROM bobsbookstore_dbo.product p
    ORDER BY p.productid;
END;
$$;

GRANT EXECUTE ON FUNCTION bobsbookstore_dbo.uspGetProductData() TO PUBLIC;
COMMENT ON FUNCTION bobsbookstore_dbo.uspGetProductData IS 'Retrieves all product data as a table result set';

\echo 'Step 6: Verifying function creation...'

-- Verify functions exist
DO $$
DECLARE
    func_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO func_count
    FROM pg_proc p
    JOIN pg_namespace n ON p.pronamespace = n.oid
    WHERE n.nspname = 'bobsbookstore_dbo'
    AND p.proname IN ('uspupdateauthorpersonalinfo', 'uspdeleteauthor', 'uspgetproductdata');
    
    IF func_count = 3 THEN
        RAISE NOTICE 'SUCCESS: All 3 functions created successfully';
    ELSE
        RAISE EXCEPTION 'ERROR: Expected 3 functions but found %', func_count;
    END IF;
END $$;

-- Commit transaction
COMMIT;

\echo ''
\echo '========================================='
\echo 'Migration completed successfully!'
\echo '========================================='
\echo ''
\echo 'Functions created:'
\echo '  1. bobsbookstore_dbo.uspUpdateAuthorPersonalInfo'
\echo '  2. bobsbookstore_dbo.uspDeleteAuthor'
\echo '  3. bobsbookstore_dbo.uspGetProductData'
\echo ''
\echo 'Next steps:'
\echo '  1. Test each function with sample data'
\echo '  2. Update application connection strings'
\echo '  3. Deploy updated application code'
\echo '  4. Run integration tests'
\echo ''
\echo 'Rollback instructions:'
\echo '  If rollback needed, execute:'
\echo '  DROP FUNCTION bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(INTEGER, VARCHAR, TIMESTAMP, VARCHAR, VARCHAR);'
\echo '  DROP FUNCTION bobsbookstore_dbo.uspDeleteAuthor(INTEGER);'
\echo '  DROP FUNCTION bobsbookstore_dbo.uspGetProductData();'
\echo ''

-- ========================================
-- END OF MIGRATION SCRIPT
-- ========================================
