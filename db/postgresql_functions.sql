-- PostgreSQL Functions for Bob's Bookstore Migration
-- This script creates the PostgreSQL functions equivalent to the SQL Server stored procedures
-- Execute this script on your PostgreSQL database before running the application

-- =============================================
-- Function: uspupdateauthorpersonalinfo
-- Description: Updates author personal information
-- Equivalent to SQL Server stored procedure [dbo].[uspUpdateAuthorPersonalInfo]
-- =============================================
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspupdateauthorpersonalinfo(
    p_businessentityid INTEGER,
    p_nationalidnumber VARCHAR(15),
    p_birthdate TIMESTAMP,
    p_maritalstatus CHAR(1),
    p_gender CHAR(1)
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_rows_affected INTEGER;
BEGIN
    -- Update the author record
    UPDATE bobsbookstore_dbo.author
    SET 
        nationalidnumber = p_nationalidnumber,
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
        -- Log error (if you have error logging function)
        -- PERFORM bobsbookstore_dbo.usplogerror();
        RAISE NOTICE 'Error updating author: %', SQLERRM;
        RETURN 0;
END;
$$;

-- =============================================
-- Function: uspdeleteauthor
-- Description: Deletes an author record
-- Equivalent to SQL Server stored procedure [dbo].[uspDeleteAuthor]
-- =============================================
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
        RAISE EXCEPTION 'No author found with the provided BusinessEntityID: %', p_businessentityid;
    END IF;
    
    -- Return the number of rows affected
    RETURN v_rows_affected;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Log error (if you have error logging function)
        -- PERFORM bobsbookstore_dbo.usplogerror();
        RAISE NOTICE 'Error deleting author: %', SQLERRM;
        RETURN 0;
END;
$$;

-- =============================================
-- Function: uspgetproductdata
-- Description: Retrieves all product data
-- Equivalent to SQL Server stored procedure [dbo].[uspGetProductData]
-- Note: SQL Server version used cursor, PostgreSQL version returns table directly
-- =============================================
CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspgetproductdata()
RETURNS TABLE (
    productid INTEGER,
    name VARCHAR(50),
    productnumber VARCHAR(25),
    safetystocklevel SMALLINT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Return all product data
    RETURN QUERY
    SELECT 
        p.productid,
        p.name,
        p.productnumber,
        p.safetystocklevel
    FROM bobsbookstore_dbo.product p;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Log error (if you have error logging function)
        RAISE NOTICE 'Error retrieving product data: %', SQLERRM;
        -- Return empty result set
        RETURN;
END;
$$;

-- =============================================
-- Grant execute permissions (adjust as needed for your security requirements)
-- =============================================
-- GRANT EXECUTE ON FUNCTION bobsbookstore_dbo.uspupdateauthorpersonalinfo TO your_application_user;
-- GRANT EXECUTE ON FUNCTION bobsbookstore_dbo.uspdeleteauthor TO your_application_user;
-- GRANT EXECUTE ON FUNCTION bobsbookstore_dbo.uspgetproductdata TO your_application_user;

-- =============================================
-- Verification queries (run these to test the functions)
-- =============================================
-- Test uspgetproductdata:
-- SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- Test uspupdateauthorpersonalinfo (replace with actual values):
-- SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(1, '12345', '1980-01-01'::TIMESTAMP, 'M', 'M');

-- Test uspdeleteauthor (replace with actual values):
-- SELECT bobsbookstore_dbo.uspdeleteauthor(999);
