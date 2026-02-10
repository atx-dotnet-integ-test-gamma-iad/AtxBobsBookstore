-- ============================================================================
-- SQL Statement Extraction Catalog
-- Microsoft SQL Server to PostgreSQL Migration
-- ============================================================================
-- This file contains all SQL statements extracted from the BobsBookstore 
-- application for conversion through the DMS MCP tool. Each statement is
-- documented with source location, parameters, and SQL Server-specific syntax.
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: Update Author Personal Information (Stored Procedure Call)
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Source Line: ~162
-- Method: EditUsingStoredProcedure
-- Statement Type: Stored procedure call with T-SQL specific syntax
-- 
-- Parameters:
--   @BusinessEntityID (int) - Author identifier
--   @NationalIDNumber (string) - National ID number
--   @BirthDate (DateTime) - Birth date (converted to UTC)
--   @MaritalStatus (string) - Marital status code
--   @Gender (string) - Gender code
--
-- SQL Server-Specific Syntax Elements:
--   - DECLARE: T-SQL variable declaration
--   - EXEC with return value assignment: @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo]
--   - [dbo] schema notation with square brackets
--   - SELECT to return scalar value
--
-- Original SQL Statement:
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- Schema: bobsbookstore_dbo
-- Database Objects Referenced: [dbo].[uspUpdateAuthorPersonalInfo] stored procedure
-- Expected Output: Integer representing number of rows affected
-- ============================================================================


-- ============================================================================
-- STATEMENT 2: Select All Authors
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Source Line: ~191
-- Method: FindAllAuthorsEmbeddedSql
-- Statement Type: Simple SELECT query
--
-- Parameters: None
--
-- SQL Server-Specific Syntax Elements:
--   - Schema notation: bobsbookstore_dbo.author
--
-- Original SQL Statement:
SELECT * FROM bobsbookstore_dbo.author;

-- Schema: bobsbookstore_dbo
-- Database Objects Referenced: bobsbookstore_dbo.author table
-- Expected Output: List of Author entities with all columns
-- ============================================================================


-- ============================================================================
-- STATEMENT 3: Delete Author (Stored Procedure Call)
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Source Line: ~207
-- Method: DeleteAuthorEmbeddedSql
-- Statement Type: Stored procedure call with T-SQL specific syntax
--
-- Parameters:
--   @BusinessEntityID (int) - Author identifier to delete
--
-- SQL Server-Specific Syntax Elements:
--   - DECLARE: T-SQL variable declaration
--   - EXEC with return value assignment: @rowsAffected = [dbo].[uspDeleteAuthor]
--   - [dbo] schema notation with square brackets
--   - SELECT to return scalar value
--
-- Original SQL Statement:
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- Schema: bobsbookstore_dbo
-- Database Objects Referenced: [dbo].[uspDeleteAuthor] stored procedure
-- Expected Output: Integer representing number of rows affected
-- ============================================================================


-- ============================================================================
-- STATEMENT 4: Select Authors by Hire Year with Age Calculation
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Source Line: ~227
-- Method: SelectAuthorsByHireYear
-- Statement Type: Complex SELECT with SQL Server-specific date/time functions
--
-- Parameters:
--   @HireDate (int) - Year to filter by
--
-- SQL Server-Specific Syntax Elements:
--   - FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss'): SQL Server date formatting function
--   - DATEDIFF(YEAR, BirthDate, GETDATE()): SQL Server date difference calculation
--   - GETDATE(): SQL Server current date/time function
--   - DATEPART(YEAR, HireDate): SQL Server date part extraction function
--
-- Original SQL Statement:
SELECT 
    BusinessEntityID, 
    FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, 
    DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age 
FROM 
    bobsbookstore_dbo.author 
WHERE 
    DATEPART(YEAR, HireDate) = @HireDate;

-- Schema: bobsbookstore_dbo
-- Database Objects Referenced: bobsbookstore_dbo.author table
-- Expected Output: List of AuthorAgeResult entities with BusinessEntityID, FormattedModifiedDate, Age
-- Column Aliases: FormattedModifiedDate, Age
-- ============================================================================


-- ============================================================================
-- STATEMENT 5: Get All Product Data (Stored Procedure Call)
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Source Line: ~31
-- Method: FindAllProducts
-- Statement Type: Stored procedure call (cursor-based)
--
-- Parameters: None (stored procedure uses cursor output internally)
--
-- SQL Server-Specific Syntax Elements:
--   - EXEC: Execute stored procedure
--   - [dbo] schema notation with square brackets
--
-- Original SQL Statement:
EXEC [dbo].[uspGetProductData];

-- Schema: bobsbookstore_dbo
-- Database Objects Referenced: [dbo].[uspGetProductData] stored procedure
-- Expected Output: List of Product entities returned via cursor
-- Note: This stored procedure likely uses OUTPUT parameters or cursor-based result sets
-- ============================================================================


-- ============================================================================
-- EXTRACTION SUMMARY
-- ============================================================================
-- Total Statements Extracted: 5
-- 
-- Statement Types:
--   - Stored Procedure Calls: 3 (uspUpdateAuthorPersonalInfo, uspDeleteAuthor, uspGetProductData)
--   - Direct SELECT Queries: 2
--
-- SQL Server-Specific Syntax Identified:
--   - DECLARE statements for variable declaration
--   - EXEC with return value assignment
--   - FORMAT() function for date formatting
--   - DATEDIFF() function for date arithmetic
--   - GETDATE() function for current date/time
--   - DATEPART() function for extracting date components
--   - [dbo] schema notation with square brackets
--   - bobsbookstore_dbo schema references
--
-- Files Containing SQL Statements:
--   1. app/Bookstore.Web/Controllers/AuthorsController.cs (4 statements)
--   2. app/Bookstore.Web/Controllers/ProductsController.cs (1 statement)
--
-- All statements require conversion through DMS MCP tool for PostgreSQL compatibility.
-- ============================================================================
