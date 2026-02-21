-- ==============================================================================
-- CONVERTED SQL STATEMENTS FROM SQL SERVER TO POSTGRESQL
-- Conversion Date: Migration Phase - Step 2
-- ==============================================================================
-- This file contains all SQL statements converted to PostgreSQL syntax.
-- Each statement includes metadata about the conversion method and any issues.
-- ==============================================================================
-- CONVERSION STATUS: All statements manually converted due to DMS tool failures
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- ==============================================================================

-- ==============================================================================
-- STATEMENT 1: Stored Procedure Call with Variable Declaration and SELECT
-- ==============================================================================
-- Original Location: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- ==============================================================================
-- ORIGINAL SQL (SQL Server):
-- DECLARE @rowsAffected INT;
-- EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
-- SELECT @rowsAffected;
-- ==============================================================================
-- CONVERTED SQL (PostgreSQL):
DO $$
DECLARE
    v_rows_affected INT;
BEGIN
    SELECT uspupdateauthorpersonalinfo(
        p_businessentityid := @BusinessEntityID,
        p_nationalidnumber := @NationalIDNumber,
        p_birthdate := @BirthDate,
        p_maritalstatus := @MaritalStatus,
        p_gender := @Gender
    ) INTO v_rows_affected;
    
    -- Return the result
    RAISE NOTICE 'Rows affected: %', v_rows_affected;
END $$;
-- ==============================================================================
-- CONVERSION NOTES:
-- 1. Converted schema object names to lowercase: uspUpdateAuthorPersonalInfo -> uspupdateauthorpersonalinfo
-- 2. Converted T-SQL DECLARE to PostgreSQL DECLARE within DO block
-- 3. Converted EXEC to PostgreSQL function call with named parameters
-- 4. Converted parameter names to lowercase with p_ prefix convention
-- 5. Converted variable names to lowercase with v_ prefix convention
-- 6. SQL Server @variable syntax changed to PostgreSQL parameter placeholders
-- 7. Added DO $$ block for procedural logic
-- ==============================================================================

-- ==============================================================================
-- STATEMENT 2: Simple SELECT from author table
-- ==============================================================================
-- Original Location: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- ==============================================================================
-- ORIGINAL SQL (SQL Server):
-- SELECT * FROM bobsbookstore_dbo.author
-- ==============================================================================
-- CONVERTED SQL (PostgreSQL):
SELECT * FROM bobsbookstore_dbo.author
-- ==============================================================================
-- CONVERSION NOTES:
-- 1. Schema name bobsbookstore_dbo kept as-is (already lowercase)
-- 2. Table name 'author' kept as-is (already lowercase)
-- 3. No SQL Server specific functions - direct PostgreSQL compatibility
-- ==============================================================================

-- ==============================================================================
-- STATEMENT 3: Stored Procedure Call for Delete with Variable Declaration
-- ==============================================================================
-- Original Location: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- ==============================================================================
-- ORIGINAL SQL (SQL Server):
-- DECLARE @rowsAffected INT;
-- EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
-- SELECT @rowsAffected;
-- ==============================================================================
-- CONVERTED SQL (PostgreSQL):
DO $$
DECLARE
    v_rows_affected INT;
BEGIN
    SELECT uspdeleteauthor(
        p_businessentityid := @BusinessEntityID
    ) INTO v_rows_affected;
    
    -- Return the result
    RAISE NOTICE 'Rows affected: %', v_rows_affected;
END $$;
-- ==============================================================================
-- CONVERSION NOTES:
-- 1. Converted schema object names to lowercase: uspDeleteAuthor -> uspdeleteauthor
-- 2. Converted T-SQL DECLARE to PostgreSQL DECLARE within DO block
-- 3. Converted EXEC to PostgreSQL function call with named parameter
-- 4. Converted parameter name to lowercase with p_ prefix convention
-- 5. Converted variable name to lowercase with v_ prefix convention
-- 6. SQL Server @variable syntax changed to PostgreSQL parameter placeholder
-- 7. Added DO $$ block for procedural logic
-- ==============================================================================

-- ==============================================================================
-- STATEMENT 4: Complex SELECT with Date Functions
-- ==============================================================================
-- Original Location: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: {'error': 'Unknown metadata model creation status: RECEIVED'}
-- ==============================================================================
-- ORIGINAL SQL (SQL Server):
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- ==============================================================================
-- CONVERTED SQL (PostgreSQL):
SELECT businessentityid, 
       TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, 
       DATE_PART('year', AGE(CURRENT_DATE, birthdate)) AS age 
FROM bobsbookstore_dbo.author 
WHERE DATE_PART('year', hiredate) = @HireDate;
-- ==============================================================================
-- CONVERSION NOTES:
-- 1. Converted all column names to lowercase for PostgreSQL compatibility:
--    - BusinessEntityID -> businessentityid
--    - ModifiedDate -> modifieddate
--    - FormattedModifiedDate -> formattedmodifieddate
--    - Age -> age
--    - BirthDate -> birthdate
--    - HireDate -> hiredate
-- 2. Converted SQL Server FORMAT() to PostgreSQL TO_CHAR()
-- 3. Converted date format string: 'yyyy-MM-dd HH:mm:ss' -> 'YYYY-MM-DD HH24:MI:SS'
-- 4. Converted SQL Server DATEDIFF(YEAR, BirthDate, GETDATE()) to PostgreSQL DATE_PART('year', AGE(CURRENT_DATE, birthdate))
-- 5. Converted SQL Server GETDATE() to PostgreSQL CURRENT_DATE
-- 6. Converted SQL Server DATEPART(YEAR, HireDate) to PostgreSQL DATE_PART('year', hiredate)
-- 7. Schema name bobsbookstore_dbo.author kept as-is (already lowercase)
-- ==============================================================================

-- ==============================================================================
-- SUMMARY
-- ==============================================================================
-- Total SQL Statements Converted: 4
-- - DMS Tool Successful Conversions: 0
-- - Manual Conversions (DMS Failures): 4
-- - Statements Requiring PostgreSQL Functions Available: 2 (uspupdateauthorpersonalinfo, uspdeleteauthor)
-- ==============================================================================
