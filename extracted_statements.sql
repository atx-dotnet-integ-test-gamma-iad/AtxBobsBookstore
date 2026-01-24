-- ================================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Source: BobsBookstore .NET Application
-- Purpose: Comprehensive catalog of all SQL statements for migration from MS SQL Server to PostgreSQL
-- ================================================================================

-- ================================================================================
-- STATEMENT 1
-- ================================================================================
-- File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 157
-- Method: EditUsingStoredProcedure
-- Variable: sql
-- Parameters: @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- ================================================================================
-- STATEMENT 2
-- ================================================================================
-- File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 176
-- Method: FindAllAuthorsEmbeddedSql
-- Variable: sql
-- Parameters: None
SELECT * FROM bobsbookstore_dbo.author;

-- ================================================================================
-- STATEMENT 3
-- ================================================================================
-- File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 195
-- Method: DeleteAuthorEmbeddedSql
-- Variable: sql
-- Parameters: @BusinessEntityID
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- ================================================================================
-- STATEMENT 4
-- ================================================================================
-- File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 214
-- Method: SelectAuthorsByHireYear
-- Variable: sql
-- Parameters: @HireDate
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ================================================================================
-- STATEMENT 5
-- ================================================================================
-- File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Line: 31
-- Method: FindAllProducts
-- Variable: sql
-- Parameters: None
EXEC [dbo].[uspGetProductData];

-- ================================================================================
-- END OF EXTRACTED STATEMENTS
-- Total Statements Extracted: 5
-- ================================================================================
