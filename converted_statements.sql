-- ==============================================================================
-- Converted SQL Statements - SQL Server to PostgreSQL
-- ==============================================================================
-- This file contains all SQL statements converted from SQL Server to PostgreSQL
-- Each statement pair is documented with conversion details
-- ==============================================================================

-- ==============================================================================
-- STATEMENT 1: EditUsingStoredProcedure - Stored Procedure Call with Output
-- ==============================================================================
-- ORIGINAL SQL SERVER STATEMENT:
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- CONVERTED POSTGRESQL STATEMENT:
-- Note: PostgreSQL stored procedures converted to functions. Return value handling differs.
-- Functions in PostgreSQL use SELECT function_name() syntax
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(
    @BusinessEntityID, 
    @NationalIDNumber, 
    @BirthDate, 
    @MaritalStatus, 
    @Gender
) AS rowsAffected;

-- Conversion Notes:
-- - SQL Server EXEC @var = procedure becomes SELECT function() in PostgreSQL
-- - Schema dbo converted to bobsbookstore_dbo (matching existing schema pattern)
-- - Function names typically lowercased in PostgreSQL
-- - Return value captured via SELECT AS rowsAffected

-- ==============================================================================
-- STATEMENT 2: FindAllAuthorsEmbeddedSql - SELECT All Authors
-- ==============================================================================
-- ORIGINAL SQL SERVER STATEMENT:
SELECT * FROM bobsbookstore_dbo.author;

-- CONVERTED POSTGRESQL STATEMENT:
SELECT * FROM bobsbookstore_dbo.author;

-- Conversion Notes:
-- - No changes required - standard SELECT syntax compatible with PostgreSQL
-- - Schema name bobsbookstore_dbo already in PostgreSQL format

-- ==============================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql - Stored Procedure Call with Output
-- ==============================================================================
-- ORIGINAL SQL SERVER STATEMENT:
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- CONVERTED POSTGRESQL STATEMENT:
-- Note: PostgreSQL stored procedures converted to functions
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID) AS rowsAffected;

-- Conversion Notes:
-- - SQL Server EXEC @var = procedure becomes SELECT function() in PostgreSQL
-- - Schema dbo converted to bobsbookstore_dbo
-- - Function name lowercased: uspDeleteAuthor -> uspdeleteauthor
-- - Return value captured via SELECT AS rowsAffected

-- ==============================================================================
-- STATEMENT 4: SelectAuthorsByHireYear - SELECT with SQL Server Functions
-- ==============================================================================
-- ORIGINAL SQL SERVER STATEMENT:
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- CONVERTED POSTGRESQL STATEMENT:
SELECT 
    BusinessEntityID, 
    TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, 
    DATE_PART('year', AGE(CURRENT_DATE, BirthDate)) AS Age 
FROM bobsbookstore_dbo.author 
WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- Conversion Notes:
-- - FORMAT() -> TO_CHAR() with adjusted format string
--   * 'yyyy-MM-dd HH:mm:ss' -> 'YYYY-MM-DD HH24:MI:SS' (PostgreSQL format codes)
-- - DATEDIFF(YEAR, BirthDate, GETDATE()) -> DATE_PART('year', AGE(CURRENT_DATE, BirthDate))
--   * PostgreSQL uses AGE() function to calculate intervals
-- - GETDATE() -> CURRENT_DATE (standard SQL function)
-- - DATEPART(YEAR, HireDate) -> EXTRACT(YEAR FROM HireDate) (standard SQL)

-- ==============================================================================
-- STATEMENT 5: FindAllProducts - Stored Procedure Call
-- ==============================================================================
-- ORIGINAL SQL SERVER STATEMENT:
EXEC [dbo].[uspGetProductData];

-- CONVERTED POSTGRESQL STATEMENT:
-- Note: PostgreSQL stored procedures converted to functions that return tables
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- Conversion Notes:
-- - SQL Server EXEC procedure becomes SELECT * FROM function() in PostgreSQL
-- - Schema dbo converted to bobsbookstore_dbo
-- - Function name lowercased: uspGetProductData -> uspgetproductdata
-- - Empty parentheses required for function call syntax

-- ==============================================================================
-- END OF CONVERSION CATALOG
-- Total Statements Converted: 5
-- Conversion Method: Manual (after DMS tool failure)
-- ==============================================================================
