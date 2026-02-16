-- ==============================================================================
-- SQL Statement Extraction Catalog
-- Microsoft SQL Server to PostgreSQL Migration
-- ==============================================================================
-- This file contains all SQL statements extracted from the ADO.NET application
-- Each statement is documented with metadata for DMS MCP tool processing
-- ==============================================================================

-- ==============================================================================
-- STATEMENT 1: EditUsingStoredProcedure - Stored Procedure Call with Output
-- ==============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: 155
-- Description: Updates author personal information using stored procedure uspUpdateAuthorPersonalInfo
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- Returns: @rowsAffected (int)
-- ==============================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- ==============================================================================
-- STATEMENT 2: FindAllAuthorsEmbeddedSql - SELECT All Authors
-- ==============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: 175
-- Description: Retrieves all authors from the bobsbookstore_dbo.author table
-- Parameters: None
-- Returns: List<Author>
-- ==============================================================================
SELECT * FROM bobsbookstore_dbo.author;

-- ==============================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql - Stored Procedure Call with Output
-- ==============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: 195
-- Description: Deletes an author using stored procedure uspDeleteAuthor
-- Parameters: @BusinessEntityID (int)
-- Returns: @rowsAffected (int)
-- ==============================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- ==============================================================================
-- STATEMENT 4: SelectAuthorsByHireYear - SELECT with SQL Server Functions
-- ==============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: 213
-- Description: Retrieves authors by hire year with formatted date and calculated age
-- SQL Server Functions Used: FORMAT, DATEDIFF, DATEPART, GETDATE
-- Parameters: @HireDate (int - hire year)
-- Returns: List<AuthorAgeResult> with BusinessEntityID, FormattedModifiedDate, Age
-- ==============================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ==============================================================================
-- STATEMENT 5: FindAllProducts - Stored Procedure Call
-- ==============================================================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line: 32
-- Description: Retrieves all products using stored procedure uspGetProductData
-- Parameters: None
-- Returns: List<Product>
-- ==============================================================================
EXEC [dbo].[uspGetProductData];

-- ==============================================================================
-- END OF EXTRACTION CATALOG
-- Total Statements Extracted: 5
-- Statements Ready for DMS MCP Tool Conversion: 5
-- ==============================================================================
