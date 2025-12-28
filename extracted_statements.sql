-- ================================================================================
-- SQL Statement Extraction Catalog
-- Migration: Microsoft SQL Server to PostgreSQL
-- Generated: 2024-12-28
-- Total Statements: 5
-- ================================================================================

-- ================================================================================
-- STATEMENT ID: STMT_001
-- SOURCE FILE: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- LINE NUMBER: ~163
-- METHOD NAME: EditUsingStoredProcedure
-- STATEMENT TYPE: Stored Procedure Call with DECLARE/EXEC/SELECT pattern
-- CONTEXT: Called from Edit action to update author personal information
-- ================================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Parameters:
-- @BusinessEntityID (int): businessEntityId
-- @NationalIDNumber (string): nationalIdNumber
-- @BirthDate (DateTime): birthDate.ToUniversalTime()
-- @MaritalStatus (string): maritalStatus
-- @Gender (string): gender

-- ================================================================================
-- STATEMENT ID: STMT_002
-- SOURCE FILE: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- LINE NUMBER: ~187
-- METHOD NAME: FindAllAuthorsEmbeddedSql
-- STATEMENT TYPE: SELECT statement
-- CONTEXT: Retrieves all authors for display in Index view
-- ================================================================================
SELECT * FROM bobsbookstore_dbo.author

-- Parameters: None

-- ================================================================================
-- STATEMENT ID: STMT_003
-- SOURCE FILE: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- LINE NUMBER: ~208
-- METHOD NAME: DeleteAuthorEmbeddedSql
-- STATEMENT TYPE: Stored Procedure Call with DECLARE/EXEC/SELECT pattern
-- CONTEXT: Deletes an author using stored procedure
-- ================================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Parameters:
-- @BusinessEntityID (int): businessEntityId

-- ================================================================================
-- STATEMENT ID: STMT_004
-- SOURCE FILE: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- LINE NUMBER: ~228
-- METHOD NAME: SelectAuthorsByHireYear
-- STATEMENT TYPE: SELECT with SQL Server-specific functions (FORMAT, DATEDIFF, GETDATE, DATEPART)
-- CONTEXT: Retrieves authors by hire year with formatted date and calculated age
-- ================================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Parameters:
-- @HireDate (int): hireYear

-- SQL Server Functions Used:
-- FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') - Formats date to string
-- DATEDIFF(YEAR, BirthDate, GETDATE()) - Calculates age in years
-- GETDATE() - Returns current date/time
-- DATEPART(YEAR, HireDate) - Extracts year from date

-- ================================================================================
-- STATEMENT ID: STMT_005
-- SOURCE FILE: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- LINE NUMBER: ~32
-- METHOD NAME: FindAllProducts
-- STATEMENT TYPE: Stored Procedure Call (EXEC)
-- CONTEXT: Retrieves all products for display in Index view
-- ================================================================================
EXEC [dbo].[uspGetProductData];

-- Parameters: None

-- ================================================================================
-- END OF EXTRACTION CATALOG
-- ================================================================================
