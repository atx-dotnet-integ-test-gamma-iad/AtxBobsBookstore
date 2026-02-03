-- =============================================
-- SQL Statement Extraction Report
-- Microsoft SQL Server to PostgreSQL Migration
-- =============================================
-- Total Statements Extracted: 5
-- Date: 2026-02-03
-- =============================================

-- =============================================
-- STATEMENT 1
-- =============================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method Name: EditUsingStoredProcedure
-- Line Numbers: 173
-- Statement Type: EXEC (Stored Procedure Call)
-- Purpose: Update author personal information using stored procedure
-- Parameters: @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
-- T-SQL Specific Features: DECLARE variable, EXEC stored procedure with [dbo] schema, variable assignment
-- =============================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- =============================================


-- =============================================
-- STATEMENT 2
-- =============================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method Name: FindAllAuthorsEmbeddedSql
-- Line Numbers: 193
-- Statement Type: SELECT
-- Purpose: Retrieve all authors from database
-- Parameters: None
-- T-SQL Specific Features: None (standard SELECT)
-- =============================================
SELECT * FROM bobsbookstore_dbo.author
-- =============================================


-- =============================================
-- STATEMENT 3
-- =============================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method Name: DeleteAuthorEmbeddedSql
-- Line Numbers: 213
-- Statement Type: EXEC (Stored Procedure Call)
-- Purpose: Delete an author using stored procedure
-- Parameters: @BusinessEntityID
-- T-SQL Specific Features: DECLARE variable, EXEC stored procedure with [dbo] schema, variable assignment
-- =============================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- =============================================


-- =============================================
-- STATEMENT 4
-- =============================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method Name: SelectAuthorsByHireYear
-- Line Numbers: 234
-- Statement Type: SELECT
-- Purpose: Select authors by hire year with formatted date and calculated age
-- Parameters: @HireDate (year value)
-- T-SQL Specific Features: FORMAT(), DATEDIFF(), GETDATE(), DATEPART()
-- =============================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- =============================================


-- =============================================
-- STATEMENT 5
-- =============================================
-- Source File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method Name: FindAllProducts
-- Line Numbers: 33
-- Statement Type: EXEC (Stored Procedure Call)
-- Purpose: Retrieve all products using stored procedure
-- Parameters: None
-- T-SQL Specific Features: EXEC stored procedure with [dbo] schema
-- =============================================
EXEC [dbo].[uspGetProductData];
-- =============================================


-- =============================================
-- END OF EXTRACTION REPORT
-- =============================================
-- Summary:
-- - Total Statements: 5
-- - Stored Procedure Calls: 3 (uspUpdateAuthorPersonalInfo, uspDeleteAuthor, uspGetProductData)
-- - SELECT Statements: 2
-- - T-SQL Functions to Convert: FORMAT, DATEDIFF, GETDATE, DATEPART
-- - Schema References: [dbo] used in stored procedure calls
-- =============================================
