-- ============================================================================
-- Converted SQL Statement Catalog - PostgreSQL
-- Migration from SQL Server to PostgreSQL
-- ============================================================================
-- Total Statements Converted: 5
-- Conversion Date: 2024
-- Conversion Method: Manual after DMS MCP tool failure (metadata model errors)
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: Update Author Personal Info (Stored Procedure Call)
-- ============================================================================
-- Original SQL Server Statement:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
--
-- Conversion Notes:
-- - SQL Server DECLARE/EXEC pattern converted to PostgreSQL function call with SELECT
-- - Parameters use PostgreSQL $ notation instead of @
-- - Schema qualifier [dbo] retained for schema consistency
-- - Removed variable assignment since ExecuteSqlRawAsync returns row count directly
-- ============================================================================
SELECT dbo.uspUpdateAuthorPersonalInfo($1, $2, $3, $4, $5);

-- ============================================================================
-- STATEMENT 2: Find All Authors (Simple SELECT)
-- ============================================================================
-- Original SQL Server Statement:
-- SELECT * FROM bobsbookstore_dbo.author
--
-- Conversion Notes:
-- - No changes required - standard SQL compatible with PostgreSQL
-- - Schema name bobsbookstore_dbo retained as-is
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================================
-- STATEMENT 3: Delete Author (Stored Procedure Call)
-- ============================================================================
-- Original SQL Server Statement:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
--
-- Conversion Notes:
-- - SQL Server DECLARE/EXEC pattern converted to PostgreSQL function call with SELECT
-- - Parameter uses PostgreSQL $1 notation instead of @BusinessEntityID
-- - Schema qualifier [dbo] retained for schema consistency
-- - Removed variable assignment since ExecuteSqlRawAsync returns row count directly
-- ============================================================================
SELECT dbo.uspDeleteAuthor($1);

-- ============================================================================
-- STATEMENT 4: Select Authors By Hire Year (Complex SELECT with Date Functions)
-- ============================================================================
-- Original SQL Server Statement:
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
--
-- Conversion Notes:
-- - FORMAT() converted to TO_CHAR() with PostgreSQL format pattern
-- - DATEDIFF(YEAR, x, y) converted to DATE_PART('year', AGE(y, x))
-- - GETDATE() converted to CURRENT_DATE
-- - DATEPART(YEAR, x) converted to EXTRACT(YEAR FROM x)
-- - @ parameter notation converted to $ notation ($1)
-- ============================================================================
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, DATE_PART('year', AGE(CURRENT_DATE, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = $1;

-- ============================================================================
-- STATEMENT 5: Get Product Data (Stored Procedure Call)
-- ============================================================================
-- Original SQL Server Statement:
-- EXEC [dbo].[uspGetProductData];
--
-- Conversion Notes:
-- - SQL Server EXEC statement converted to PostgreSQL SELECT function call
-- - Schema qualifier [dbo] retained for schema consistency
-- - Note: Original stored procedure uses cursor output parameter which is not 
--   directly compatible with ADO.NET. The stored procedure needs to be rewritten
--   as a function returning a table result set in PostgreSQL.
-- - Assuming the PostgreSQL function returns a table/set of records directly
-- ============================================================================
SELECT * FROM dbo.uspGetProductData();

-- ============================================================================
-- CONVERSION SUMMARY
-- ============================================================================
-- Total Statements: 5
-- Successfully Converted: 5
-- Manual Conversions: 5 (all due to DMS metadata model errors)
-- 
-- Key Conversions Applied:
-- - DECLARE/EXEC patterns → SELECT function_name() patterns
-- - @ parameters → $ parameters with positional numbers
-- - FORMAT() → TO_CHAR()
-- - DATEDIFF(YEAR, x, y) → DATE_PART('year', AGE(y, x))
-- - GETDATE() → CURRENT_DATE
-- - DATEPART(YEAR, x) → EXTRACT(YEAR FROM x)
-- - [dbo].[procedure] → dbo.procedure (PostgreSQL schema.function notation)
-- 
-- Important Notes:
-- - All stored procedures must be migrated from SQL Server to PostgreSQL
-- - Stored procedures should be converted to PostgreSQL functions
-- - Schema name 'dbo' retained for consistency with existing migration
-- - Parameter bindings updated from SqlParameter to NpgsqlParameter required in code
-- ============================================================================
