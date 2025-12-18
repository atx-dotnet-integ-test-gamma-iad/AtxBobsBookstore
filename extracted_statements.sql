-- ================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Microsoft SQL Server to PostgreSQL Migration
-- Bob's Bookstore Application
-- ================================================================
-- This file contains ALL SQL statements extracted from the codebase
-- Each statement includes:
--   - Statement ID
--   - Source file location
--   - Line numbers
--   - Method/function name
--   - Statement type (Inline SQL, Stored Procedure Call, Dynamic SQL)
--   - Original SQL statement text
-- ================================================================

-- TOTAL STATEMENTS FOUND: 5

-- ================================================================
-- STATEMENT #1
-- ================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 162
-- Method: EditUsingStoredProcedure
-- Statement Type: Stored Procedure Call with DECLARE and Output Parameter
-- Description: Calls uspUpdateAuthorPersonalInfo stored procedure to update author personal information
-- Uses DECLARE for output parameter and EXEC syntax with return value capture
-- Parameters: @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
-- ================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- ================================================================
-- STATEMENT #2
-- ================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 191
-- Method: FindAllAuthorsEmbeddedSql
-- Statement Type: Inline SQL SELECT
-- Description: Simple SELECT statement to retrieve all authors from the author table
-- Schema: bobsbookstore_dbo
-- No parameters
-- ================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ================================================================
-- STATEMENT #3
-- ================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 210
-- Method: DeleteAuthorEmbeddedSql
-- Statement Type: Stored Procedure Call with DECLARE and Output Parameter
-- Description: Calls uspDeleteAuthor stored procedure to delete an author
-- Uses DECLARE for output parameter and EXEC syntax with return value capture
-- Parameters: @BusinessEntityID
-- ================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- ================================================================
-- STATEMENT #4
-- ================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 230
-- Method: SelectAuthorsByHireYear
-- Statement Type: Inline SQL SELECT with T-SQL Functions
-- Description: Complex SELECT query using T-SQL specific functions
-- T-SQL Functions Used:
--   - FORMAT: Formats ModifiedDate as 'yyyy-MM-dd HH:mm:ss'
--   - DATEDIFF: Calculates age in years from BirthDate to current date
--   - GETDATE: Returns current server date/time
--   - DATEPART: Extracts year from HireDate for filtering
-- Schema: bobsbookstore_dbo
-- Parameters: @HireDate (year value)
-- ================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ================================================================
-- STATEMENT #5
-- ================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Line Number: 32
-- Method: FindAllProducts
-- Statement Type: Stored Procedure Call
-- Description: Calls uspGetProductData stored procedure to retrieve all products
-- This stored procedure uses a cursor output parameter pattern
-- No input parameters
-- ================================================================
EXEC [dbo].[uspGetProductData];

-- ================================================================
-- SUMMARY STATISTICS
-- ================================================================
-- Total SQL Statements: 5
-- 
-- By Type:
--   - Inline SQL SELECT: 2 (Statements #2, #4)
--   - Stored Procedure Calls: 3 (Statements #1, #3, #5)
--   - Dynamic SQL: 0
--
-- By File:
--   - AuthorsController.cs: 4 statements
--   - ProductsController.cs: 1 statement
--
-- T-SQL Specific Features:
--   - DECLARE statements: 2 (Statements #1, #3)
--   - EXEC with return value: 2 (Statements #1, #3)
--   - FORMAT function: 1 (Statement #4)
--   - DATEDIFF function: 1 (Statement #4)
--   - GETDATE function: 1 (Statement #4)
--   - DATEPART function: 1 (Statement #4)
--   - Output parameters: 2 (Statements #1, #3)
--   - Cursor output: 1 (Statement #5)
--
-- Schema References:
--   - bobsbookstore_dbo.author: 3 statements
--   - bobsbookstore_dbo.product: 1 statement (via stored procedure)
--   - [dbo] prefix: 3 statements
--
-- Parameters Used:
--   - @BusinessEntityID: 2 statements
--   - @NationalIDNumber: 1 statement
--   - @BirthDate: 1 statement
--   - @MaritalStatus: 1 statement
--   - @Gender: 1 statement
--   - @HireDate: 1 statement
--   - @rowsAffected: 2 statements (output)
--
-- ================================================================
-- STORED PROCEDURE DETAILS (for reference)
-- ================================================================
-- These stored procedures are defined in the database:
--
-- 1. uspUpdateAuthorPersonalInfo
--    - Parameters: @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
--    - Action: UPDATE Author table
--    - Returns: implicit rowcount
--
-- 2. uspDeleteAuthor
--    - Parameters: @BusinessEntityID
--    - Action: DELETE from Author table
--    - Returns: implicit rowcount
--    - Error handling: RAISERROR if no rows found
--
-- 3. uspGetProductData
--    - Parameters: @my_cursor (OUTPUT)
--    - Action: Returns cursor with Product data
--    - Returns: cursor with ProductID, Name, ProductNumber, SafetyStockLevel
--
-- ================================================================
-- END OF EXTRACTION CATALOG
-- ================================================================
