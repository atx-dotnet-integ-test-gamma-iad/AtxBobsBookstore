-- ========================================
-- PostgreSQL Stored Procedures/Functions
-- SQL Server to PostgreSQL Migration
-- BobsBookstore Application
-- Created: 2026-02-11
-- ========================================

-- ========================================
-- FUNCTION: uspUpdateAuthorPersonalInfo
-- ========================================
-- Purpose: Updates author personal information
-- Original SQL Server Procedure: [dbo].[uspUpdateAuthorPersonalInfo]
-- Returns: INTEGER (number of rows affected)
-- Parameters:
--   - p_BusinessEntityID: Author's unique identifier
--   - p_NationalIDNumber: National ID number
--   - p_BirthDate: Author's birth date
--   - p_MaritalStatus: Marital status (single character)
--   - p_Gender: Gender (single character)
-- ========================================

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

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(INTEGER, VARCHAR, TIMESTAMP, VARCHAR, VARCHAR) TO PUBLIC;

COMMENT ON FUNCTION bobsbookstore_dbo.uspUpdateAuthorPersonalInfo IS 'Updates author personal information and returns number of rows affected';

-- ========================================
-- FUNCTION: uspDeleteAuthor
-- ========================================
-- Purpose: Deletes an author record
-- Original SQL Server Procedure: [dbo].[uspDeleteAuthor]
-- Returns: INTEGER (number of rows affected)
-- Parameters:
--   - p_BusinessEntityID: Author's unique identifier to delete
-- ========================================

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

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION bobsbookstore_dbo.uspDeleteAuthor(INTEGER) TO PUBLIC;

COMMENT ON FUNCTION bobsbookstore_dbo.uspDeleteAuthor IS 'Deletes an author record and returns number of rows affected';

-- ========================================
-- FUNCTION: uspGetProductData
-- ========================================
-- Purpose: Retrieves all product data
-- Original SQL Server Procedure: [dbo].[uspGetProductData]
-- Returns: TABLE (all product records)
-- Parameters: None
-- ========================================

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

-- Grant execute permissions
GRANT EXECUTE ON FUNCTION bobsbookstore_dbo.uspGetProductData() TO PUBLIC;

COMMENT ON FUNCTION bobsbookstore_dbo.uspGetProductData IS 'Retrieves all product data as a table result set';

-- ========================================
-- MIGRATION NOTES
-- ========================================
-- 1. All SQL Server stored procedures have been converted to PostgreSQL functions
-- 2. Schema prefix bobsbookstore_dbo maintained for consistency
-- 3. Parameter naming convention changed from @paramName to p_paramName (PostgreSQL standard)
-- 4. Return type INT converted to INTEGER
-- 5. RETURNS INTEGER for scalar return values
-- 6. RETURNS TABLE for result set returns
-- 7. All functions use LANGUAGE plpgsql
-- 8. ROW_COUNT used instead of @@ROWCOUNT
-- 9. CURRENT_TIMESTAMP used instead of GETDATE()
-- 10. All permissions granted to PUBLIC (adjust as needed for production)
--
-- DEPLOYMENT:
-- Execute this script on the target PostgreSQL database after schema migration
-- Ensure schema bobsbookstore_dbo exists before executing
-- Test each function individually after creation
-- ========================================
