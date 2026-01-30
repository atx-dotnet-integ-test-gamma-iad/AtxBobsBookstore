-- ========================================================================
-- CONVERTED SQL STATEMENTS - POSTGRESQL
-- Microsoft SQL Server to PostgreSQL Migration
-- ========================================================================
-- Total Statements: 5
-- Conversion Method: Manual after DMS tool metadata model errors
-- Generated: 2024
-- ========================================================================

-- ========================================================================
-- STATEMENT 1: EditUsingStoredProcedure
-- ========================================================================
-- Original (SQL Server):
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
--
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: The selected objects were not found
-- PostgreSQL Conversion:
-- Note: Stored procedure call converted to PostgreSQL function call
-- Assumes function uspUpdateAuthorPersonalInfo exists in bobsbookstore_dbo schema
-- ========================================================================
SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo($1, $2, $3, $4, $5);

-- ========================================================================
-- STATEMENT 2: FindAllAuthorsEmbeddedSql
-- ========================================================================
-- Original (SQL Server):
-- SELECT * FROM bobsbookstore_dbo.author
--
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: The selected objects were not found
-- PostgreSQL Conversion:
-- Note: This is already PostgreSQL-compatible syntax
-- ========================================================================
SELECT * FROM bobsbookstore_dbo.author;

-- ========================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql
-- ========================================================================
-- Original (SQL Server):
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
--
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: The selected objects were not found
-- PostgreSQL Conversion:
-- Note: Stored procedure call converted to PostgreSQL function call
-- Assumes function uspDeleteAuthor exists in bobsbookstore_dbo schema
-- ========================================================================
SELECT bobsbookstore_dbo.uspDeleteAuthor($1);

-- ========================================================================
-- STATEMENT 4: SelectAuthorsByHireYear
-- ========================================================================
-- Original (SQL Server):
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
--
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: The selected objects were not found
-- PostgreSQL Conversion Notes:
-- - FORMAT -> TO_CHAR
-- - DATEDIFF(YEAR, BirthDate, GETDATE()) -> EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate))
-- - DATEPART(YEAR, HireDate) -> EXTRACT(YEAR FROM HireDate)
-- - GETDATE() -> CURRENT_DATE
-- - @HireDate -> $1
-- ========================================================================
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = $1;

-- ========================================================================
-- STATEMENT 5: FindAllProducts
-- ========================================================================
-- Original (SQL Server):
-- EXEC [dbo].[uspGetProductData];
--
-- Conversion Status: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: The selected objects were not found
-- PostgreSQL Conversion:
-- Note: Stored procedure call converted to PostgreSQL function call
-- Assumes function uspGetProductData exists in bobsbookstore_dbo schema
-- ========================================================================
SELECT * FROM bobsbookstore_dbo.uspGetProductData();

-- ========================================================================
-- END OF CONVERTED STATEMENTS
-- ========================================================================

-- ========================================================================
-- CONVERSION SUMMARY
-- ========================================================================
-- Total Statements Processed: 5
-- Successfully Converted by DMS: 0
-- Manual Conversions After DMS Failure: 5
-- 
-- Key Conversions Applied:
-- 1. T-SQL EXEC stored_proc -> PostgreSQL SELECT function()
-- 2. T-SQL DECLARE/EXEC with output -> PostgreSQL SELECT function()
-- 3. T-SQL FORMAT() -> PostgreSQL TO_CHAR()
-- 4. T-SQL DATEDIFF() -> PostgreSQL EXTRACT(YEAR FROM AGE())
-- 5. T-SQL DATEPART() -> PostgreSQL EXTRACT()
-- 6. T-SQL GETDATE() -> PostgreSQL CURRENT_DATE
-- 7. SQL Server parameters @param -> PostgreSQL parameters $1, $2, etc.
-- 8. SQL Server [dbo] schema -> PostgreSQL bobsbookstore_dbo schema
-- ========================================================================
