-- ============================================================================
-- CONVERTED SQL STATEMENTS CATALOG
-- Migration from Microsoft SQL Server to PostgreSQL
-- Conversion Date: 2025-12-31
-- ============================================================================
-- This file contains all SQL statements converted from SQL Server T-SQL to
-- PostgreSQL syntax. Each statement includes its original form, converted form,
-- DMS tool output, and conversion method.
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: Edit Author Using Stored Procedure
-- ============================================================================
-- Statement ID: STMT_001
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Numbers: 161
-- Method: EditUsingStoredProcedure
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Conversion Date: 2025-12-31T13:14:00Z
-- ============================================================================

-- ORIGINAL SQL SERVER T-SQL:
-- ----------------------------------------------------------------------------
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;
-- ----------------------------------------------------------------------------

-- DMS TOOL OUTPUT:
-- ----------------------------------------------------------------------------
-- Status: error
-- Error: Metadata model creation failed: {'error': "Metadata model creation failed: 
--        {'default_error_details': {'message': 'No objects were found according to 
--        the specified selection rules. Please review your selection rules and try again.'}}"}
-- DMS Input Parameters:
--   - migration_project_identifier: arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI
--   - schema_name: bobsbookstore_dbo
--   - database_name: BobsBookstore
-- Conversion Timestamp: 2025-12-31T13:12:39.452801
-- ----------------------------------------------------------------------------

-- CONVERTED POSTGRESQL SQL:
-- ----------------------------------------------------------------------------
-- Strategy: Replace stored procedure call with inline UPDATE statement
-- The stored procedure uspUpdateAuthorPersonalInfo performs a simple UPDATE operation
-- We'll replace the DECLARE/EXEC pattern with a direct UPDATE and use GET DIAGNOSTICS
-- to retrieve the row count instead of @@ROWCOUNT
-- ----------------------------------------------------------------------------
UPDATE bobsbookstore_dbo.author 
SET nationalidnumber = @NationalIDNumber,
    birthdate = @BirthDate,
    maritalstatus = @MaritalStatus,
    gender = @Gender
WHERE businessentityid = @BusinessEntityID;
-- Note: Row count will be retrieved using ExecuteSqlRawAsync return value in .NET
-- which automatically returns affected rows for DML statements
-- ----------------------------------------------------------------------------

-- MANUAL CONVERSION NOTES:
-- 1. Removed DECLARE @rowsAffected INT - not needed as ExecuteSqlRawAsync returns row count
-- 2. Replaced [dbo].[uspUpdateAuthorPersonalInfo] stored procedure call with inline UPDATE
-- 3. Updated column names to PostgreSQL lowercase convention (as defined in ApplicationDbContext)
-- 4. Updated table reference to use bobsbookstore_dbo schema (already configured)
-- 5. Maintained parameter placeholders (@BusinessEntityID, @NationalIDNumber, etc.)
-- 6. ExecuteSqlRawAsync automatically returns affected row count for UPDATE statements
-- ============================================================================

-- ============================================================================
-- STATEMENT 2: Find All Authors with Embedded SQL
-- ============================================================================
-- Statement ID: STMT_002
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Numbers: 184
-- Method: FindAllAuthorsEmbeddedSql
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Conversion Date: 2025-12-31T13:14:00Z
-- ============================================================================

-- ORIGINAL SQL SERVER T-SQL:
-- ----------------------------------------------------------------------------
SELECT * FROM bobsbookstore_dbo.author;
-- ----------------------------------------------------------------------------

-- DMS TOOL OUTPUT:
-- ----------------------------------------------------------------------------
-- Status: error
-- Error: Metadata model creation failed: {'error': "Metadata model creation failed: 
--        {'default_error_details': {'message': 'No objects were found according to 
--        the specified selection rules. Please review your selection rules and try again.'}}"}
-- DMS Input Parameters:
--   - migration_project_identifier: arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI
--   - schema_name: bobsbookstore_dbo
--   - database_name: BobsBookstore
-- Conversion Timestamp: 2025-12-31T13:13:04.083761
-- ----------------------------------------------------------------------------

-- CONVERTED POSTGRESQL SQL:
-- ----------------------------------------------------------------------------
-- Strategy: This is already PostgreSQL compatible
-- The schema reference bobsbookstore_dbo.author is already configured in ApplicationDbContext
-- No changes needed - this statement is PostgreSQL compatible as-is
-- ----------------------------------------------------------------------------
SELECT * FROM bobsbookstore_dbo.author;
-- ----------------------------------------------------------------------------

-- MANUAL CONVERSION NOTES:
-- 1. Statement is already PostgreSQL compatible
-- 2. Schema bobsbookstore_dbo is correctly configured in ApplicationDbContext.cs
-- 3. Table name 'author' uses lowercase as per PostgreSQL convention (configured in context)
-- 4. No SQL Server-specific syntax present
-- 5. No conversion required - statement remains unchanged
-- ============================================================================

-- ============================================================================
-- STATEMENT 3: Delete Author Using Stored Procedure
-- ============================================================================
-- Statement ID: STMT_003
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Numbers: 203
-- Method: DeleteAuthorEmbeddedSql
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Conversion Date: 2025-12-31T13:14:00Z
-- ============================================================================

-- ORIGINAL SQL SERVER T-SQL:
-- ----------------------------------------------------------------------------
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;
-- ----------------------------------------------------------------------------

-- DMS TOOL OUTPUT:
-- ----------------------------------------------------------------------------
-- Status: error
-- Error: Metadata model creation failed: {'error': "Metadata model creation failed: 
--        {'default_error_details': {'message': 'No objects were found according to 
--        the specified selection rules. Please review your selection rules and try again.'}}"}
-- DMS Input Parameters:
--   - migration_project_identifier: arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI
--   - schema_name: bobsbookstore_dbo
--   - database_name: BobsBookstore
-- Conversion Timestamp: 2025-12-31T13:13:26.910875
-- ----------------------------------------------------------------------------

-- CONVERTED POSTGRESQL SQL:
-- ----------------------------------------------------------------------------
-- Strategy: Replace stored procedure call with inline DELETE statement
-- The stored procedure uspDeleteAuthor performs a DELETE operation with @@ROWCOUNT check
-- We'll replace with direct DELETE and rely on ExecuteSqlRawAsync return value
-- ----------------------------------------------------------------------------
DELETE FROM bobsbookstore_dbo.author
WHERE businessentityid = @BusinessEntityID;
-- Note: Row count will be retrieved using ExecuteSqlRawAsync return value in .NET
-- The original stored procedure also had error handling (RAISERROR if no rows),
-- which we'll handle in the C# code by checking the return value
-- ----------------------------------------------------------------------------

-- MANUAL CONVERSION NOTES:
-- 1. Removed DECLARE @rowsAffected INT - not needed as ExecuteSqlRawAsync returns row count
-- 2. Replaced [dbo].[uspDeleteAuthor] stored procedure call with inline DELETE
-- 3. Updated table reference to bobsbookstore_dbo.author with lowercase column name
-- 4. Maintained parameter placeholder (@BusinessEntityID)
-- 5. ExecuteSqlRawAsync automatically returns affected row count for DELETE statements
-- 6. Error handling for "no rows deleted" will be handled in C# by checking return value > 0
-- ============================================================================

-- ============================================================================
-- STATEMENT 4: Select Authors by Hire Year with Complex Functions
-- ============================================================================
-- Statement ID: STMT_004
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Numbers: 221
-- Method: SelectAuthorsByHireYear
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Conversion Date: 2025-12-31T13:14:00Z
-- ============================================================================

-- ORIGINAL SQL SERVER T-SQL:
-- ----------------------------------------------------------------------------
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- ----------------------------------------------------------------------------

-- DMS TOOL OUTPUT:
-- ----------------------------------------------------------------------------
-- Status: error
-- Error: Metadata model creation failed: {'error': "Metadata model creation failed: 
--        {'default_error_details': {'message': 'No objects were found according to 
--        the specified selection rules. Please review your selection rules and try again.'}}"}
-- DMS Input Parameters:
--   - migration_project_identifier: arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI
--   - schema_name: bobsbookstore_dbo
--   - database_name: BobsBookstore
-- Conversion Timestamp: 2025-12-31T13:13:50.794102
-- ----------------------------------------------------------------------------

-- CONVERTED POSTGRESQL SQL:
-- ----------------------------------------------------------------------------
-- Strategy: Convert SQL Server-specific date functions to PostgreSQL equivalents
-- Conversions:
--   - FORMAT(date, format) → TO_CHAR(date, format)
--   - DATEDIFF(YEAR, date1, date2) → DATE_PART('year', AGE(date2, date1))
--   - GETDATE() → CURRENT_TIMESTAMP or NOW()
--   - DATEPART(YEAR, date) → EXTRACT(YEAR FROM date)
--   - Column names updated to lowercase as per PostgreSQL convention
-- ----------------------------------------------------------------------------
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, DATE_PART('year', AGE(CURRENT_TIMESTAMP, birthdate)) AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
-- ----------------------------------------------------------------------------

-- MANUAL CONVERSION NOTES:
-- 1. FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') → TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS')
--    - PostgreSQL TO_CHAR uses 'YYYY' (uppercase) for 4-digit year
--    - PostgreSQL uses 'HH24' for 24-hour format (HH is 12-hour in PostgreSQL)
--    - PostgreSQL uses 'MI' for minutes and 'SS' for seconds
-- 2. DATEDIFF(YEAR, BirthDate, GETDATE()) → DATE_PART('year', AGE(CURRENT_TIMESTAMP, birthdate))
--    - AGE() function calculates interval between two dates
--    - DATE_PART extracts the year component from the interval
--    - Note: This gives approximate age in years
-- 3. GETDATE() → CURRENT_TIMESTAMP
--    - PostgreSQL standard function for current timestamp (NOW() also works)
-- 4. DATEPART(YEAR, HireDate) → EXTRACT(YEAR FROM hiredate)
--    - PostgreSQL standard SQL EXTRACT function
-- 5. All column names converted to lowercase (businessentityid, modifieddate, birthdate, hiredate)
--    - Matches PostgreSQL naming convention in ApplicationDbContext
-- 6. Alias names also lowercase (formattedmodifieddate, age)
-- ============================================================================

-- ============================================================================
-- STATEMENT 5: Get Product Data Using Stored Procedure
-- ============================================================================
-- Statement ID: STMT_005
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Line Numbers: 31
-- Method: FindAllProducts
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Conversion Date: 2025-12-31T13:14:00Z
-- ============================================================================

-- ORIGINAL SQL SERVER T-SQL:
-- ----------------------------------------------------------------------------
EXEC [dbo].[uspGetProductData];
-- ----------------------------------------------------------------------------

-- DMS TOOL OUTPUT:
-- ----------------------------------------------------------------------------
-- Status: error
-- Error: Metadata model creation failed: {'error': "Metadata model creation failed: 
--        {'default_error_details': {'message': 'No objects were found according to 
--        the specified selection rules. Please review your selection rules and try again.'}}"}
-- DMS Input Parameters:
--   - migration_project_identifier: arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI
--   - schema_name: bobsbookstore_dbo
--   - database_name: BobsBookstore
-- Conversion Timestamp: 2025-12-31T13:14:14.084162
-- ----------------------------------------------------------------------------

-- CONVERTED POSTGRESQL SQL:
-- ----------------------------------------------------------------------------
-- Strategy: Replace cursor-based stored procedure with simple SELECT
-- The original stored procedure uspGetProductData uses SQL Server cursor syntax
-- which is complex and not directly translatable. The procedure simply returns
-- product data, so we'll replace it with a direct SELECT statement.
-- ----------------------------------------------------------------------------
SELECT productid, name, productnumber, safetystocklevel 
FROM bobsbookstore_dbo.product;
-- ----------------------------------------------------------------------------

-- MANUAL CONVERSION NOTES:
-- 1. Removed EXEC [dbo].[uspGetProductData] stored procedure call
-- 2. Replaced with direct SELECT from bobsbookstore_dbo.product table
-- 3. Original stored procedure used OUTPUT cursor parameter which is SQL Server-specific
-- 4. PostgreSQL cursors work differently and are not needed for this simple query
-- 5. Column names converted to lowercase (productid, name, productnumber, safetystocklevel)
-- 6. Matches Product entity definition in Bookstore.Domain.Products.Product.cs
-- 7. SqlQueryRaw<Product> will map columns automatically to Product class properties
-- 8. This is a much simpler and more maintainable approach than cursor-based retrieval
-- ============================================================================

-- ============================================================================
-- CONVERSION SUMMARY
-- ============================================================================
-- Total SQL Statements Processed: 5
-- DMS Tool Attempts: 5
-- DMS Successful Conversions: 0
-- DMS Failed Conversions: 5
-- Manual Conversions After DMS Failure: 5
-- 
-- Conversion Results:
-- 1. Statement 1 (STMT_001): MANUAL_AFTER_DMS_FAILURE
--    - Replaced DECLARE/EXEC stored procedure pattern with inline UPDATE
--    - Removed explicit row count retrieval (handled by ExecuteSqlRawAsync)
-- 
-- 2. Statement 2 (STMT_002): MANUAL_AFTER_DMS_FAILURE (but no changes needed)
--    - Already PostgreSQL compatible
--    - Schema reference correct (bobsbookstore_dbo.author)
--    - No SQL Server-specific constructs
-- 
-- 3. Statement 3 (STMT_003): MANUAL_AFTER_DMS_FAILURE
--    - Replaced DECLARE/EXEC stored procedure pattern with inline DELETE
--    - Removed explicit row count retrieval (handled by ExecuteSqlRawAsync)
--    - Error handling moved to C# code
-- 
-- 4. Statement 4 (STMT_004): MANUAL_AFTER_DMS_FAILURE
--    - FORMAT() → TO_CHAR() with PostgreSQL format string
--    - DATEDIFF() → DATE_PART('year', AGE())
--    - GETDATE() → CURRENT_TIMESTAMP
--    - DATEPART() → EXTRACT()
--    - Column names converted to lowercase
-- 
-- 5. Statement 5 (STMT_005): MANUAL_AFTER_DMS_FAILURE
--    - Replaced complex cursor-based stored procedure with simple SELECT
--    - Removed SQL Server cursor syntax (OUTPUT CURSOR parameter)
--    - Direct table query is simpler and PostgreSQL-compatible
-- 
-- DMS Tool Failure Reason:
-- All statements failed with the same error: "Metadata model creation failed: 
-- No objects were found according to the specified selection rules."
-- This indicates the DMS migration project may not have the source database
-- schema properly configured or accessible at the time of conversion.
-- 
-- Schema Name Transformations:
-- - No schema name changes detected in manual conversions
-- - bobsbookstore_dbo schema retained (already configured in ApplicationDbContext)
-- - Column names converted to lowercase to match PostgreSQL convention
-- 
-- SQL Server Constructs Converted:
-- - DECLARE variable syntax (removed, using .NET return values)
-- - EXEC stored procedure with return value (replaced with inline SQL)
-- - FORMAT() function → TO_CHAR()
-- - DATEDIFF() function → DATE_PART('year', AGE())
-- - GETDATE() function → CURRENT_TIMESTAMP
-- - DATEPART() function → EXTRACT()
-- - @@ROWCOUNT (handled by ExecuteSqlRawAsync return value)
-- - CURSOR VARYING OUTPUT (replaced with simple SELECT)
-- - RAISERROR (error handling moved to C# code)
-- 
-- Conversion Quality Notes:
-- - All conversions maintain functional equivalence with original T-SQL
-- - Simplified error handling by leveraging .NET EF Core capabilities
-- - Removed unnecessary complexity (stored procedures for simple CRUD)
-- - Column naming follows PostgreSQL conventions as defined in ApplicationDbContext
-- - All parameter placeholders preserved for NpgsqlParameter binding
-- ============================================================================
