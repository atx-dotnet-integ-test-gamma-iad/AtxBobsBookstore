-- ============================================================================
-- CONVERTED SQL STATEMENTS CATALOG
-- Project: BobsBookstore - SQL Server to PostgreSQL Migration
-- Date: 2026-03-22
-- Total Statements: 5
-- DMS Tool Results: 0 succeeded, 5 failed (Metadata model creation failed)
-- Conversion Method for all: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: EditUsingStoredProcedure
-- DMS Tool Invocation: 2026-03-22T06:40:49.173367
-- DMS Tool Status: ERROR
-- DMS Tool Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- ============================================================================
-- Original MS SQL:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- Converted PostgreSQL:
SELECT uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
-- Conversion Notes: Stored procedure EXEC syntax converted to PostgreSQL function call syntax.
-- Schema objects converted to lowercase: uspUpdateAuthorPersonalInfo -> uspupdateauthorpersonalinfo

-- ============================================================================
-- STATEMENT 2: FindAllAuthorsEmbeddedSql
-- DMS Tool Invocation: 2026-03-22T06:41:20.008878
-- DMS Tool Status: ERROR
-- DMS Tool Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- ============================================================================
-- Original MS SQL:
-- SELECT * FROM Author
-- Converted PostgreSQL:
SELECT * FROM author
-- Conversion Notes: Table name converted to lowercase: Author -> author

-- ============================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql
-- DMS Tool Invocation: 2026-03-22T06:41:43.403055
-- DMS Tool Status: ERROR
-- DMS Tool Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- ============================================================================
-- Original MS SQL:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- Converted PostgreSQL:
SELECT uspdeleteauthor(@BusinessEntityID);
-- Conversion Notes: Stored procedure EXEC syntax converted to PostgreSQL function call syntax.
-- Schema objects converted to lowercase: uspDeleteAuthor -> uspdeleteauthor

-- ============================================================================
-- STATEMENT 4: SelectAuthorsByHireYear
-- DMS Tool Invocation: 2026-03-22T06:42:07.794308
-- DMS Tool Status: ERROR
-- DMS Tool Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- ============================================================================
-- Original MS SQL:
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- Converted PostgreSQL:
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
-- Conversion Notes: Multiple SQL Server-specific functions converted to PostgreSQL equivalents:
--   FORMAT() -> TO_CHAR()
--   DATEDIFF(YEAR, ..., GETDATE()) -> EXTRACT(YEAR FROM AGE(NOW(), ...))::INT
--   DATEPART(YEAR, ...) -> EXTRACT(YEAR FROM ...)
--   All schema objects converted to lowercase: BusinessEntityID -> businessentityid, 
--     ModifiedDate -> modifieddate, FormattedModifiedDate -> formattedmodifieddate,
--     BirthDate -> birthdate, Age -> age, Author -> author, HireDate -> hiredate

-- ============================================================================
-- STATEMENT 5: FindAllProducts
-- DMS Tool Invocation: 2026-03-22T06:42:30.782535
-- DMS Tool Status: ERROR
-- DMS Tool Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- ============================================================================
-- Original MS SQL:
-- EXEC [dbo].[uspGetProductData];
-- Converted PostgreSQL:
SELECT * FROM uspgetproductdata();
-- Conversion Notes: Stored procedure EXEC syntax converted to PostgreSQL function call syntax.
-- Schema objects converted to lowercase: uspGetProductData -> uspgetproductdata

-- ============================================================================
-- END OF CONVERTED STATEMENTS CATALOG
-- Total: 5 statements converted
-- DMS Tool Success: 0 | DMS Tool Failed: 5
-- Manual Conversions (DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA): 5
-- ============================================================================
