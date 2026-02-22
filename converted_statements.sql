-- =====================================================================
-- CONVERTED SQL STATEMENTS - PostgreSQL
-- Microsoft SQL Server to PostgreSQL Migration
-- Total Statements: 5
-- Conversion Method: MANUAL (DMS tool failure - all statements)
-- =====================================================================

-- =====================================================================
-- STATEMENT 1: uspUpdateAuthorPersonalInfo Function Call
-- =====================================================================
-- Original (MS SQL):
-- DECLARE @rowsAffected INT;
-- EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
-- SELECT @rowsAffected;
--
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Changes Applied:
--   - DECLARE/EXEC pattern replaced with SELECT function call
--   - Schema [dbo] -> bobsbookstore_dbo
--   - Function name: uspUpdateAuthorPersonalInfo -> uspupdateauthorpersonalinfo (lowercase)
--   - Parameters: @param -> $1, $2, $3, $4, $5 (positional)
-- =====================================================================
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo($1, $2, $3, $4, $5);

-- =====================================================================
-- STATEMENT 2: Simple SELECT - Find All Authors
-- =====================================================================
-- Original (MS SQL):
-- SELECT * FROM bobsbookstore_dbo.author;
--
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Changes Applied:
--   - No changes needed (schema and table already lowercase)
-- =====================================================================
SELECT * FROM bobsbookstore_dbo.author;

-- =====================================================================
-- STATEMENT 3: uspDeleteAuthor Function Call
-- =====================================================================
-- Original (MS SQL):
-- DECLARE @rowsAffected INT;
-- EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
-- SELECT @rowsAffected;
--
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Changes Applied:
--   - DECLARE/EXEC pattern replaced with SELECT function call
--   - Schema [dbo] -> bobsbookstore_dbo
--   - Function name: uspDeleteAuthor -> uspdeleteauthor (lowercase)
--   - Parameters: @BusinessEntityID -> $1 (positional)
-- =====================================================================
SELECT bobsbookstore_dbo.uspdeleteauthor($1);

-- =====================================================================
-- STATEMENT 4: Complex SELECT with PostgreSQL Functions
-- =====================================================================
-- Original (MS SQL):
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, 
--        DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age 
-- FROM bobsbookstore_dbo.author 
-- WHERE DATEPART(YEAR, HireDate) = @HireDate;
--
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Changes Applied:
--   - Column names: BusinessEntityID -> businessentityid (lowercase)
--   - FORMAT() -> TO_CHAR() with PostgreSQL format pattern
--   - DATEDIFF(YEAR, ...) -> DATE_PART('year', AGE(...))
--   - GETDATE() -> CURRENT_TIMESTAMP
--   - DATEPART(YEAR, ...) -> EXTRACT(YEAR FROM ...)
--   - Parameters: @HireDate -> $1
--   - All column references lowercase
-- =====================================================================
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, DATE_PART('year', AGE(CURRENT_TIMESTAMP, birthdate)) AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = $1;

-- =====================================================================
-- STATEMENT 5: uspGetProductData Function Call
-- =====================================================================
-- Original (MS SQL):
-- EXEC [dbo].[uspGetProductData];
--
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Changes Applied:
--   - EXEC replaced with SELECT * FROM function call
--   - Schema [dbo] -> bobsbookstore_dbo
--   - Function name: uspGetProductData -> uspgetproductdata (lowercase)
--   - Function call with () to return set
-- =====================================================================
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- =====================================================================
-- END OF CONVERTED STATEMENTS
-- =====================================================================
-- Summary:
-- - Total Converted Statements: 5
-- - DMS Successful Conversions: 0
-- - Manual Conversions: 5
-- - All conversions used lowercase schema mapping for PostgreSQL compatibility
-- =====================================================================
