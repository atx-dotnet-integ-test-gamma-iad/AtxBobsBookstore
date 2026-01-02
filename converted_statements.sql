-- ============================================================================
-- CONVERTED SQL STATEMENTS - PostgreSQL
-- Microsoft SQL Server to PostgreSQL Migration
-- Conversion Date: 2026-01-02
-- ============================================================================
-- NOTE: All statements were attempted through DMS MCP tool first.
-- Due to metadata model errors in DMS, manual conversions were performed
-- following standard SQL Server to PostgreSQL migration patterns.
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: FindAllAuthorsEmbeddedSql - Simple SELECT Query
-- ============================================================================
-- Original SQL Server:
-- SELECT * FROM bobsbookstore_dbo.author
--
-- Converted PostgreSQL:
SELECT * FROM bobsbookstore_dbo.author
-- Conversion Notes: Schema-qualified table name remains unchanged
-- ============================================================================


-- ============================================================================
-- STATEMENT 2: EditUsingStoredProcedure - Stored Procedure to Function Call
-- ============================================================================
-- Original SQL Server:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
--
-- Converted PostgreSQL:
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo($1, $2, $3, $4, $5)
-- Conversion Notes:
-- - SQL Server stored procedure converted to PostgreSQL function call
-- - [dbo].[uspUpdateAuthorPersonalInfo] becomes bobsbookstore_dbo.uspupdateauthorpersonalinfo
-- - Named parameters (@BusinessEntityID, etc.) converted to positional ($1, $2, etc.)
-- - DECLARE/EXEC pattern replaced with direct SELECT function call
-- ============================================================================


-- ============================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql - Stored Procedure to Function Call
-- ============================================================================
-- Original SQL Server:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
--
-- Converted PostgreSQL:
SELECT bobsbookstore_dbo.uspdeleteauthor($1)
-- Conversion Notes:
-- - SQL Server stored procedure converted to PostgreSQL function call
-- - [dbo].[uspDeleteAuthor] becomes bobsbookstore_dbo.uspdeleteauthor
-- - Named parameter (@BusinessEntityID) converted to positional ($1)
-- - DECLARE/EXEC pattern replaced with direct SELECT function call
-- ============================================================================


-- ============================================================================
-- STATEMENT 4: SelectAuthorsByHireYear - Complex SELECT with Date Functions
-- ============================================================================
-- Original SQL Server:
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
--
-- Converted PostgreSQL:
SELECT "businessentityid", TO_CHAR("modifieddate", 'YYYY-MM-DD HH24:MI:SS') AS "formattedmodifieddate", DATE_PART('year', AGE(CURRENT_DATE, "birthdate")) AS "age" FROM bobsbookstore_dbo.author WHERE DATE_PART('year', "hiredate") = $1;
-- Conversion Notes:
-- - FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') → TO_CHAR("modifieddate", 'YYYY-MM-DD HH24:MI:SS')
-- - DATEDIFF(YEAR, BirthDate, GETDATE()) → DATE_PART('year', AGE(CURRENT_DATE, "birthdate"))
-- - GETDATE() → CURRENT_DATE
-- - DATEPART(YEAR, HireDate) → DATE_PART('year', "hiredate")
-- - Column names converted to lowercase with double quotes for PostgreSQL case-sensitivity
-- - Parameter @HireDate converted to $1
-- ============================================================================


-- ============================================================================
-- CONVERSION SUMMARY
-- ============================================================================
-- Total Statements Converted: 4
-- DMS Tool Attempts: 4
-- DMS Tool Successes: 0
-- DMS Tool Failures: 4 (All due to metadata model errors)
-- Manual Conversions: 4
--
-- Key Conversion Patterns Applied:
-- 1. SQL Server stored procedures → PostgreSQL functions with SELECT
-- 2. SQL Server @parameter syntax → PostgreSQL $n positional parameters
-- 3. SQL Server FORMAT() → PostgreSQL TO_CHAR()
-- 4. SQL Server DATEDIFF() → PostgreSQL DATE_PART() with AGE()
-- 5. SQL Server GETDATE() → PostgreSQL CURRENT_DATE
-- 6. SQL Server DATEPART() → PostgreSQL DATE_PART()
-- 7. Mixed-case column names → lowercase with double quotes
-- ============================================================================
