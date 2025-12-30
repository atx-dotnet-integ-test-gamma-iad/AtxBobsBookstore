-- ============================================================================
-- EXTRACTED SQL STATEMENTS FOR DMS CONVERSION
-- Source: BobsBookstore .NET Application
-- Purpose: Catalog all SQL statements for Microsoft SQL Server to PostgreSQL migration
-- Total Statements: 5
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: EditUsingStoredProcedure - Stored Procedure Call
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: ~157
-- Method: EditUsingStoredProcedure
-- Statement Type: Stored Procedure Call with DECLARE and OUTPUT parameter
-- Uses Dynamic SQL: No
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- SQL Server Specific Syntax: DECLARE, EXEC with OUTPUT parameter, [dbo]. schema prefix
-- ============================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 2: FindAllAuthorsEmbeddedSql - Simple SELECT
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: ~177
-- Method: FindAllAuthorsEmbeddedSql
-- Statement Type: Simple SELECT query
-- Uses Dynamic SQL: No
-- Parameters: None
-- SQL Server Specific Syntax: Schema prefix bobsbookstore_dbo already PostgreSQL-compatible
-- Note: This statement already uses PostgreSQL schema format
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author;

-- ============================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql - Stored Procedure Call
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: ~196
-- Method: DeleteAuthorEmbeddedSql
-- Statement Type: Stored Procedure Call with DECLARE and OUTPUT parameter
-- Uses Dynamic SQL: No
-- Parameters: @BusinessEntityID (int)
-- SQL Server Specific Syntax: DECLARE, EXEC with OUTPUT parameter, [dbo]. schema prefix
-- ============================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 4: SelectAuthorsByHireYear - Complex SELECT with SQL Server Functions
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: ~215
-- Method: SelectAuthorsByHireYear
-- Statement Type: SELECT with SQL Server-specific functions
-- Uses Dynamic SQL: No
-- Parameters: @HireDate (int - hire year)
-- SQL Server Specific Syntax: FORMAT(), DATEDIFF(), GETDATE(), DATEPART()
-- Critical Conversion Notes:
--   - FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') -> TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS')
--   - DATEDIFF(YEAR, BirthDate, GETDATE()) -> EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, BirthDate))
--   - GETDATE() -> CURRENT_TIMESTAMP
--   - DATEPART(YEAR, HireDate) -> EXTRACT(YEAR FROM HireDate)
-- ============================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================================
-- STATEMENT 5: FindAllProducts - Stored Procedure Call
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Line Number: ~32
-- Method: FindAllProducts
-- Statement Type: Stored Procedure Call
-- Uses Dynamic SQL: No
-- Parameters: None
-- SQL Server Specific Syntax: EXEC, [dbo]. schema prefix
-- ============================================================================
EXEC [dbo].[uspGetProductData];

-- ============================================================================
-- END OF EXTRACTED STATEMENTS
-- ============================================================================
