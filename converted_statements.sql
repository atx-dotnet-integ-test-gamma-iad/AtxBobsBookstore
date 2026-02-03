/*******************************************************************************
 * CONVERTED SQL STATEMENTS CATALOG
 * SQL Server to PostgreSQL Migration
 * Date: 2026-02-03
 * 
 * This file contains all SQL statement pairs (original SQL Server and
 * converted PostgreSQL) processed through DMS MCP tool or manually converted
 * when DMS tool failed.
 ******************************************************************************/

/*******************************************************************************
 * STATEMENT PAIR 1: EditUsingStoredProcedure - Update Author Personal Info
 * Location: app/Bookstore.Web/Controllers/AuthorsController.cs
 * Method: EditUsingStoredProcedure()
 * Conversion Method: MANUAL_AFTER_DMS_FAILURE
 * DMS Status: ERROR (Metadata model creation failed)
 ******************************************************************************/

-- ORIGINAL SQL SERVER STATEMENT:
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- CONVERTED POSTGRESQL STATEMENT:
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo($1, $2, $3, $4, $5);

-- PARAMETERS MAPPING:
-- $1 = @BusinessEntityID (int)
-- $2 = @NationalIDNumber (string)
-- $3 = @BirthDate (DateTime)
-- $4 = @MaritalStatus (string)
-- $5 = @Gender (string)

-- CONVERSION DETAILS:
-- 1. Removed DECLARE @rowsAffected INT; (not needed)
-- 2. Changed EXEC to SELECT function_name() syntax
-- 3. Schema: [dbo] -> bobsbookstore_dbo
-- 4. Function: [uspUpdateAuthorPersonalInfo] -> uspupdateauthorpersonalinfo (lowercased)
-- 5. Parameters: @param -> $1, $2, $3, $4, $5 (positional)
-- 6. Removed final SELECT @rowsAffected; (return value is direct)

/*******************************************************************************
 * STATEMENT PAIR 2: FindAllAuthorsEmbeddedSql - Select All Authors
 * Location: app/Bookstore.Web/Controllers/AuthorsController.cs
 * Method: FindAllAuthorsEmbeddedSql()
 * Conversion Method: MANUAL_AFTER_DMS_FAILURE
 * DMS Status: ERROR (Metadata model creation failed)
 ******************************************************************************/

-- ORIGINAL SQL SERVER STATEMENT:
SELECT * FROM bobsbookstore_dbo.author

-- CONVERTED POSTGRESQL STATEMENT:
SELECT * FROM bobsbookstore_dbo.author

-- CONVERSION DETAILS:
-- No changes needed - statement is already PostgreSQL compatible
-- Schema name bobsbookstore_dbo is correct for PostgreSQL

/*******************************************************************************
 * STATEMENT PAIR 3: DeleteAuthorEmbeddedSql - Delete Author
 * Location: app/Bookstore.Web/Controllers/AuthorsController.cs
 * Method: DeleteAuthorEmbeddedSql()
 * Conversion Method: MANUAL_AFTER_DMS_FAILURE
 * DMS Status: ERROR (Metadata model creation failed - same pattern as Statement 1)
 ******************************************************************************/

-- ORIGINAL SQL SERVER STATEMENT:
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- CONVERTED POSTGRESQL STATEMENT:
SELECT bobsbookstore_dbo.uspdeleteauthor($1);

-- PARAMETERS MAPPING:
-- $1 = @BusinessEntityID (int)

-- CONVERSION DETAILS:
-- 1. Removed DECLARE @rowsAffected INT;
-- 2. Changed EXEC to SELECT function_name() syntax
-- 3. Schema: [dbo] -> bobsbookstore_dbo
-- 4. Function: [uspDeleteAuthor] -> uspdeleteauthor (lowercased)
-- 5. Parameters: @BusinessEntityID -> $1 (positional)
-- 6. Removed final SELECT @rowsAffected;

/*******************************************************************************
 * STATEMENT PAIR 4: SelectAuthorsByHireYear - Select Authors with Age Calculation
 * Location: app/Bookstore.Web/Controllers/AuthorsController.cs
 * Method: SelectAuthorsByHireYear()
 * Conversion Method: MANUAL_AFTER_DMS_FAILURE
 * DMS Status: ERROR (Metadata model creation failed - same pattern as Statements 1-3)
 ******************************************************************************/

-- ORIGINAL SQL SERVER STATEMENT:
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- CONVERTED POSTGRESQL STATEMENT:
SELECT "BusinessEntityID", TO_CHAR("ModifiedDate", 'YYYY-MM-DD HH24:MI:SS') AS "FormattedModifiedDate", DATE_PART('year', AGE(NOW(), "BirthDate")) AS "Age" FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM "HireDate") = $1;

-- PARAMETERS MAPPING:
-- $1 = @HireDate (int - year value)

-- CONVERSION DETAILS:
-- 1. FORMAT() -> TO_CHAR()
--    - Format string: 'yyyy-MM-dd HH:mm:ss' -> 'YYYY-MM-DD HH24:MI:SS'
-- 2. DATEDIFF(YEAR, BirthDate, GETDATE()) -> DATE_PART('year', AGE(NOW(), "BirthDate"))
--    - GETDATE() -> NOW()
--    - DATEDIFF -> DATE_PART with AGE function
-- 3. DATEPART(YEAR, HireDate) -> EXTRACT(YEAR FROM "HireDate")
-- 4. Parameter: @HireDate -> $1
-- 5. Added double quotes for column names (case sensitivity)
-- 6. Schema and table: bobsbookstore_dbo.author (unchanged)

/*******************************************************************************
 * STATEMENT PAIR 5: FindAllProducts - Get Product Data
 * Location: app/Bookstore.Web/Controllers/ProductsController.cs
 * Method: FindAllProducts()
 * Conversion Method: MANUAL_AFTER_DMS_FAILURE
 * DMS Status: ERROR (Metadata model creation failed - same pattern as Statements 1, 3)
 * Processing Date: 2026-02-03 (Step 2 - Statement 5 processing)
 ******************************************************************************/

-- ORIGINAL SQL SERVER STATEMENT:
EXEC [dbo].[uspGetProductData];

-- CONVERTED POSTGRESQL STATEMENT:
SELECT bobsbookstore_dbo.uspgetproductdata();

-- PARAMETERS MAPPING:
-- No parameters (stored procedure takes no input parameters)

-- CONVERSION DETAILS:
-- 1. Changed EXEC to SELECT function_name() syntax
-- 2. Schema: [dbo] -> bobsbookstore_dbo
-- 3. Function: [uspGetProductData] -> uspgetproductdata (lowercased)
-- 4. No parameters needed
-- 5. Added parentheses for function call syntax
-- 6. PostgreSQL function should return TABLE (product records)

-- CONSISTENCY WITH OTHER CONVERSIONS:
-- This conversion follows the exact same pattern as Statements 1 and 3
-- All EXEC [dbo].[procedureName] converted to SELECT bobsbookstore_dbo.functionname()

/*******************************************************************************
 * SUMMARY
 * 
 * Total Statement Pairs: 5 (UPDATED - Statement 5 added in Step 2)
 * DMS Tool Successful Conversions: 0
 * DMS Tool Failed Conversions: 5
 * Manual Conversions Applied: 5
 * 
 * DMS FAILURE REASON:
 * All statements failed with DMS error: "Metadata model creation failed: 
 * The selected objects were not found."
 * 
 * CONVERSION APPROACH:
 * - Stored Procedure Calls (Statements 1, 3, 5): Converted from SQL Server EXEC 
 *   syntax to PostgreSQL SELECT function() syntax with positional parameters
 * - Simple SELECT (Statement 2): Already PostgreSQL compatible, no changes
 * - Complex SELECT (Statement 4): Converted SQL Server date functions to 
 *   PostgreSQL equivalents (FORMAT->TO_CHAR, DATEDIFF->DATE_PART+AGE, 
 *   GETDATE->NOW, DATEPART->EXTRACT)
 * 
 * SCHEMA OBJECT NAMES:
 * All conversions preserved the schema name 'bobsbookstore_dbo' as required.
 * Function names were lowercased following PostgreSQL conventions:
 * - uspUpdateAuthorPersonalInfo -> uspupdateauthorpersonalinfo
 * - uspDeleteAuthor -> uspdeleteauthor
 * - uspGetProductData -> uspgetproductdata
 * 
 * COMPLIANCE:
 * ✓ All 5 statements attempted through DMS MCP tool
 * ✓ All DMS failures documented in dms_conversion_log.txt
 * ✓ All statements manually converted with detailed rationale
 * ✓ Schema names preserved as per DMS conversion requirements
 * ✓ Statement 5 processed in Step 2 as required for full compliance
 ******************************************************************************/
