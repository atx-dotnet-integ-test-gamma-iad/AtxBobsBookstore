-- ============================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Purpose: Comprehensive catalog of all SQL statements extracted from the 
--          .NET codebase for processing through the DMS MCP tool
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: Update Author Personal Info (Stored Procedure Call)
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line Number: ~166
-- Statement Type: Stored Procedure Call with DECLARE and OUTPUT parameter
-- SQL Server Constructs: DECLARE, EXEC with OUTPUT parameter, stored procedure
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- Description: Calls stored procedure uspUpdateAuthorPersonalInfo to update author personal information
-- ============================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 2: Select All Authors (Embedded SQL)
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line Number: ~193
-- Statement Type: Direct SELECT query
-- SQL Server Constructs: Schema reference with dbo prefix
-- Parameters: None
-- Description: Retrieves all author records from the author table
-- ============================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================================
-- STATEMENT 3: Delete Author (Stored Procedure Call)
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line Number: ~211
-- Statement Type: Stored Procedure Call with DECLARE and OUTPUT parameter
-- SQL Server Constructs: DECLARE, EXEC with OUTPUT parameter, stored procedure
-- Parameters: @BusinessEntityID (int)
-- Description: Calls stored procedure uspDeleteAuthor to delete an author record
-- ============================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 4: Select Authors By Hire Year with SQL Server Functions
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line Number: ~231
-- Statement Type: Parameterized SELECT with SQL Server-specific functions
-- SQL Server Constructs: FORMAT, DATEDIFF, DATEPART, GETDATE
-- Parameters: @HireDate (int - representing year)
-- Description: Retrieves authors hired in a specific year with formatted date and calculated age
-- SQL Server Functions Used:
--   - FORMAT: Formats ModifiedDate as 'yyyy-MM-dd HH:mm:ss'
--   - DATEDIFF: Calculates age difference in years between BirthDate and current date
--   - GETDATE: Returns current date/time
--   - DATEPART: Extracts the year part from HireDate
-- ============================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================================
-- STATEMENT 5: Get Product Data (Stored Procedure Call)
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line Number: ~32
-- Statement Type: Stored Procedure Call
-- SQL Server Constructs: EXEC, stored procedure with dbo schema
-- Parameters: None
-- Description: Calls stored procedure uspGetProductData to retrieve all product information
-- ============================================================================
EXEC [dbo].[uspGetProductData];

-- ============================================================================
-- EXTRACTION SUMMARY
-- ============================================================================
-- Total Statements Extracted: 5
-- 
-- Statement Types:
--   - Stored Procedure Calls: 3 (Statements 1, 3, 5)
--   - Direct SELECT Queries: 1 (Statement 2)
--   - Parameterized SELECT with SQL Server Functions: 1 (Statement 4)
-- 
-- SQL Server Specific Constructs Identified:
--   - DECLARE statements for variables
--   - EXEC with OUTPUT parameters (@rowsAffected)
--   - Stored procedures: uspUpdateAuthorPersonalInfo, uspDeleteAuthor, uspGetProductData
--   - FORMAT function for date formatting
--   - DATEDIFF function for date calculations
--   - GETDATE function for current date/time
--   - DATEPART function for extracting date components
--   - Schema references: [dbo].[procedureName]
-- 
-- Files Processed:
--   1. app/Bookstore.Web/Controllers/AuthorsController.cs (4 statements)
--   2. app/Bookstore.Web/Controllers/ProductsController.cs (1 statement)
-- 
-- All SQL statements have been extracted and cataloged for DMS MCP tool conversion.
-- ============================================================================
