-- ================================================================
-- CONVERTED SQL STATEMENTS CATALOG
-- Microsoft SQL Server to PostgreSQL Migration
-- Bob's Bookstore Application
-- ================================================================
-- This file contains ALL SQL statements converted to PostgreSQL syntax
-- Each statement includes:
--   - Statement ID (matching extracted_statements.sql)
--   - Conversion method (DMS_TOOL or MANUAL_AFTER_DMS_FAILURE)
--   - Original SQL Server statement
--   - Converted PostgreSQL statement
--   - DMS tool output/error (if applicable)
--   - Conversion notes and reasoning
-- ================================================================

-- TOTAL STATEMENTS CONVERTED: 5

-- ================================================================
-- STATEMENT #1 CONVERSION
-- ================================================================
-- Original Statement ID: 1
-- Source File: AuthorsController.cs (line 162)
-- Method: EditUsingStoredProcedure
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Conversion Status: MANUAL
-- ================================================================

-- DMS TOOL OUTPUT:
-- Status: error
-- Error: Metadata model creation failed: {'error': 'Metadata model creation did not complete after 15 attempts'}
-- Timestamp: 2025-12-18T02:19:45.675738
-- Migration Project: arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI

-- ORIGINAL SQL SERVER STATEMENT:
/*
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;
*/

-- CONVERTED POSTGRESQL STATEMENT:
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo($1, $2, $3, $4, $5);

-- CONVERSION NOTES:
-- 1. PostgreSQL uses functions instead of stored procedures for operations that return values
-- 2. The stored procedure uspUpdateAuthorPersonalInfo needs to be converted to a PostgreSQL function
-- 3. DECLARE and EXEC syntax is replaced with direct function call using SELECT
-- 4. Parameters are referenced using positional notation ($1, $2, etc.) instead of named parameters
-- 5. The function should return the number of rows affected (INTEGER)
-- 6. Schema remains bobsbookstore_dbo as per ApplicationDbContext configuration
-- 7. Function name converted to lowercase following PostgreSQL naming conventions
-- 8. Return value is captured directly from the SELECT statement
-- 9. The underlying function definition would be:
--    CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspupdateauthorpersonalinfo(
--        p_businessentityid INTEGER,
--        p_nationalidnumber VARCHAR(15),
--        p_birthdate TIMESTAMP,
--        p_maritalstatus CHAR(1),
--        p_gender CHAR(1)
--    ) RETURNS INTEGER AS $$
--    DECLARE
--        v_rows_affected INTEGER;
--    BEGIN
--        UPDATE bobsbookstore_dbo.author
--        SET nationalidnumber = p_nationalidnumber,
--            birthdate = p_birthdate,
--            maritalstatus = p_maritalstatus,
--            gender = p_gender
--        WHERE businessentityid = p_businessentityid;
--        GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
--        RETURN v_rows_affected;
--    END;
--    $$ LANGUAGE plpgsql;

-- ================================================================
-- STATEMENT #2 CONVERSION
-- ================================================================
-- Original Statement ID: 2
-- Source File: AuthorsController.cs (line 191)
-- Method: FindAllAuthorsEmbeddedSql
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Conversion Status: MANUAL
-- ================================================================

-- DMS TOOL OUTPUT:
-- Status: error
-- Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Timestamp: 2025-12-18T02:20:10.950914

-- ORIGINAL SQL SERVER STATEMENT:
/*
SELECT * FROM bobsbookstore_dbo.author
*/

-- CONVERTED POSTGRESQL STATEMENT:
SELECT * FROM bobsbookstore_dbo.author

-- CONVERSION NOTES:
-- 1. This is a simple SELECT statement that is already PostgreSQL compatible
-- 2. No syntax changes required
-- 3. Schema reference bobsbookstore_dbo.author remains the same
-- 4. PostgreSQL supports the same SELECT * FROM syntax
-- 5. Column names are lowercase in PostgreSQL as configured in ApplicationDbContext
-- 6. No T-SQL specific features used in this statement

-- ================================================================
-- STATEMENT #3 CONVERSION
-- ================================================================
-- Original Statement ID: 3
-- Source File: AuthorsController.cs (line 210)
-- Method: DeleteAuthorEmbeddedSql
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Conversion Status: MANUAL
-- ================================================================

-- DMS TOOL OUTPUT:
-- Status: error (same as Statement #1)

-- ORIGINAL SQL SERVER STATEMENT:
/*
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;
*/

-- CONVERTED POSTGRESQL STATEMENT:
SELECT bobsbookstore_dbo.uspdeleteauthor($1);

-- CONVERSION NOTES:
-- 1. Similar to Statement #1, converting stored procedure call to function call
-- 2. DECLARE and EXEC replaced with SELECT function call
-- 3. Parameter $1 represents @BusinessEntityID
-- 4. Function name converted to lowercase: uspdeleteauthor
-- 5. Schema: bobsbookstore_dbo
-- 6. Function returns INTEGER (rows affected)
-- 7. The underlying function definition would be:
--    CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspdeleteauthor(
--        p_businessentityid INTEGER
--    ) RETURNS INTEGER AS $$
--    DECLARE
--        v_rows_affected INTEGER;
--    BEGIN
--        DELETE FROM bobsbookstore_dbo.author
--        WHERE businessentityid = p_businessentityid;
--        GET DIAGNOSTICS v_rows_affected = ROW_COUNT;
--        IF v_rows_affected = 0 THEN
--            RAISE EXCEPTION 'No author found with the provided BusinessEntityID.';
--        END IF;
--        RETURN v_rows_affected;
--    END;
--    $$ LANGUAGE plpgsql;

-- ================================================================
-- STATEMENT #4 CONVERSION
-- ================================================================
-- Original Statement ID: 4
-- Source File: AuthorsController.cs (line 230)
-- Method: SelectAuthorsByHireYear
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Conversion Status: MANUAL
-- ================================================================

-- DMS TOOL OUTPUT:
-- Status: error (same as previous)

-- ORIGINAL SQL SERVER STATEMENT:
/*
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
*/

-- CONVERTED POSTGRESQL STATEMENT:
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, DATE_PART('year', AGE(CURRENT_DATE, birthdate)) AS age FROM bobsbookstore_dbo.author WHERE DATE_PART('year', hiredate) = $1;

-- CONVERSION NOTES:
-- T-SQL to PostgreSQL Function Conversions:
-- 1. FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') → TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS')
--    - FORMAT is T-SQL specific, TO_CHAR is PostgreSQL equivalent
--    - Date format pattern adjusted: yyyy→YYYY, HH:mm:ss→HH24:MI:SS
-- 2. DATEDIFF(YEAR, BirthDate, GETDATE()) → DATE_PART('year', AGE(CURRENT_DATE, birthdate))
--    - DATEDIFF calculates difference in specified unit
--    - AGE function returns interval between two dates
--    - DATE_PART extracts year from the interval
-- 3. GETDATE() → CURRENT_DATE
--    - GETDATE() returns current timestamp in SQL Server
--    - CURRENT_DATE returns current date in PostgreSQL
--    - For timestamp use CURRENT_TIMESTAMP or NOW()
-- 4. DATEPART(YEAR, HireDate) → DATE_PART('year', hiredate)
--    - DATEPART is T-SQL function
--    - DATE_PART is PostgreSQL equivalent with same functionality
-- 5. @HireDate → $1
--    - Named parameter converted to positional parameter
-- 6. Column names converted to lowercase (businessentityid, modifieddate, birthdate, hiredate)
--    - Matches PostgreSQL ApplicationDbContext configuration
-- 7. Schema reference remains: bobsbookstore_dbo.author

-- ================================================================
-- STATEMENT #5 CONVERSION
-- ================================================================
-- Original Statement ID: 5
-- Source File: ProductsController.cs (line 32)
-- Method: FindAllProducts
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Conversion Status: MANUAL
-- ================================================================

-- DMS TOOL OUTPUT:
-- Status: error (same as previous)

-- ORIGINAL SQL SERVER STATEMENT:
/*
EXEC [dbo].[uspGetProductData];
*/

-- CONVERTED POSTGRESQL STATEMENT:
SELECT productid, name, productnumber, safetystocklevel FROM bobsbookstore_dbo.product;

-- CONVERSION NOTES:
-- 1. The original stored procedure uspGetProductData returns a cursor with product data
-- 2. SQL Server stored procedure with cursor output pattern is incompatible with PostgreSQL/Entity Framework
-- 3. Simplified to direct SELECT query returning the same columns
-- 4. Columns from stored procedure: ProductID, Name, ProductNumber, SafetyStockLevel
-- 5. PostgreSQL column names (lowercase): productid, name, productnumber, safetystocklevel
-- 6. Schema: bobsbookstore_dbo.product
-- 7. This is the most straightforward and EF Core compatible approach
-- 8. Alternative: Could create a PostgreSQL function returning SETOF product or TABLE
--    CREATE OR REPLACE FUNCTION bobsbookstore_dbo.uspgetproductdata()
--    RETURNS TABLE(productid INTEGER, name VARCHAR, productnumber VARCHAR, safetystocklevel INTEGER) AS $$
--    BEGIN
--        RETURN QUERY SELECT p.productid, p.name, p.productnumber, p.safetystocklevel 
--                     FROM bobsbookstore_dbo.product p;
--    END;
--    $$ LANGUAGE plpgsql;
-- 9. Direct SELECT is preferred for simplicity and performance with EF Core SqlQueryRaw

-- ================================================================
-- CONVERSION SUMMARY
-- ================================================================
-- Total Statements: 5
-- DMS Tool Successful: 0
-- Manual Conversions After DMS Failure: 5
--
-- Conversion Methods:
--   - DMS_TOOL: 0 statements
--   - MANUAL_AFTER_DMS_FAILURE: 5 statements
--
-- DMS Tool Issues:
--   - All 5 statements failed with metadata model creation errors
--   - Error 1: "Metadata model creation did not complete after 15 attempts"
--   - Error 2: "No objects were found according to the specified selection rules"
--   - Migration Project ARN: arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI
--
-- PostgreSQL Conversion Patterns Applied:
--   - Stored procedure EXEC → Function SELECT: 3 statements
--   - T-SQL Functions → PostgreSQL Functions: 1 statement
--   - Direct compatible SQL: 1 statement
--   - Named parameters (@param) → Positional parameters ($1): 4 statements
--   - Schema preserved: bobsbookstore_dbo
--   - Column names: converted to lowercase per PostgreSQL configuration
--
-- T-SQL to PostgreSQL Function Mappings:
--   - FORMAT() → TO_CHAR()
--   - DATEDIFF() → DATE_PART() + AGE()
--   - GETDATE() → CURRENT_DATE / CURRENT_TIMESTAMP
--   - DATEPART() → DATE_PART()
--   - EXEC procedure → SELECT function()
--   - DECLARE variables → Function direct return
--
-- Additional Requirements:
--   - PostgreSQL functions need to be created for uspupdateauthorpersonalinfo and uspdeleteauthor
--   - These functions should be added to database migration scripts
--   - Functions implement the same logic as original SQL Server stored procedures
--   - Error handling using PostgreSQL RAISE EXCEPTION
--   - Row count using GET DIAGNOSTICS ... = ROW_COUNT
--
-- ================================================================
-- END OF CONVERSION CATALOG
-- ================================================================
