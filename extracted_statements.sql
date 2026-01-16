-- ============================================================================
-- SQL Statement Extraction Catalog for Bob's Bookstore Migration
-- Extracted: 2025-01-16
-- Purpose: Comprehensive catalog of all SQL statements for DMS conversion
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: Update Author Personal Info (Stored Procedure Call)
-- ============================================================================
-- Source File: /app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 164
-- Method: EditUsingStoredProcedure
-- Statement Type: Stored Procedure Execution with Output Variable
-- SQL Server Features: DECLARE, EXEC with output parameter, SELECT
-- Schema References: [dbo].[uspUpdateAuthorPersonalInfo]
-- Parameters: @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
-- Context: Updates author personal information using stored procedure
-- ============================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 2: Select All Authors
-- ============================================================================
-- Source File: /app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 184
-- Method: FindAllAuthorsEmbeddedSql
-- Statement Type: Inline SQL Query
-- SQL Server Features: None (already PostgreSQL-compatible schema reference)
-- Schema References: bobsbookstore_dbo.author
-- Parameters: None
-- Context: Retrieves all authors from the author table
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author;

-- ============================================================================
-- STATEMENT 3: Delete Author (Stored Procedure Call)
-- ============================================================================
-- Source File: /app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 205
-- Method: DeleteAuthorEmbeddedSql
-- Statement Type: Stored Procedure Execution with Output Variable
-- SQL Server Features: DECLARE, EXEC with output parameter, SELECT
-- Schema References: [dbo].[uspDeleteAuthor]
-- Parameters: @BusinessEntityID
-- Context: Deletes an author using stored procedure
-- ============================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 4: Select Authors by Hire Year with Age Calculation
-- ============================================================================
-- Source File: /app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 224
-- Method: SelectAuthorsByHireYear
-- Statement Type: Complex Inline SQL Query
-- SQL Server Features: FORMAT(), GETDATE(), DATEDIFF(), DATEPART()
-- Schema References: bobsbookstore_dbo.author
-- Parameters: @HireDate (integer year value)
-- Context: Selects authors hired in specific year with formatted date and calculated age
-- SQL Server Specific Functions:
--   - FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') - date formatting
--   - GETDATE() - current date/time function
--   - DATEDIFF(YEAR, BirthDate, GETDATE()) - date difference calculation
--   - DATEPART(YEAR, HireDate) - extract year from date
-- ============================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================================
-- STATEMENT 5: Get Product Data (Stored Procedure Call)
-- ============================================================================
-- Source File: /app/Bookstore.Web/Controllers/ProductsController.cs
-- Line Number: 31
-- Method: FindAllProducts
-- Statement Type: Stored Procedure Execution
-- SQL Server Features: EXEC
-- Schema References: [dbo].[uspGetProductData]
-- Parameters: None
-- Context: Retrieves all product data using stored procedure
-- ============================================================================
EXEC [dbo].[uspGetProductData];

-- ============================================================================
-- EXTRACTION SUMMARY
-- ============================================================================
-- Total Statements Extracted: 5
-- 
-- Statement Types:
--   - Stored Procedure Calls with Output: 2 (Statement 1, 3)
--   - Stored Procedure Calls: 1 (Statement 5)
--   - Simple SELECT Queries: 1 (Statement 2)
--   - Complex SELECT Queries: 1 (Statement 4)
--
-- SQL Server Specific Features to Convert:
--   - DECLARE statements for variables
--   - EXEC statements for stored procedures
--   - FORMAT() function
--   - GETDATE() function
--   - DATEDIFF() function
--   - DATEPART() function
--   - [dbo]. schema references with brackets
--   - Output parameter assignment (@rowsAffected = )
--
-- Files Containing SQL Statements:
--   1. AuthorsController.cs - 4 statements
--   2. ProductsController.cs - 1 statement
--
-- Notes:
-- - Statement 2 already uses PostgreSQL-compatible schema: bobsbookstore_dbo.author
-- - Statements 1, 3, 5 use [dbo]. which needs conversion to bobsbookstore_dbo
-- - Statement 4 requires multiple SQL Server function conversions
-- ============================================================================
