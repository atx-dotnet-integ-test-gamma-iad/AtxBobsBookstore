-- ================================================================================
-- CONVERTED SQL STATEMENTS CATALOG
-- Source: BobsBookstore .NET Application
-- Purpose: Comprehensive catalog of SQL statements converted from MS SQL Server to PostgreSQL
-- ================================================================================

-- ================================================================================
-- STATEMENT 1
-- ================================================================================
-- File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 157
-- Method: EditUsingStoredProcedure
-- Parameters: @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender

-- Original SQL Server Statement:
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- Converted PostgreSQL Statement:
SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Output: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- Conversion Notes: 
-- 1. PostgreSQL stored procedures are called as functions using SELECT
-- 2. Removed DECLARE and EXEC syntax as PostgreSQL functions return values directly
-- 3. Schema reference updated to bobsbookstore_dbo (matching existing schema pattern)
-- 4. Parameter naming convention preserved

-- ================================================================================
-- STATEMENT 2
-- ================================================================================
-- File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 176
-- Method: FindAllAuthorsEmbeddedSql
-- Parameters: None

-- Original SQL Server Statement:
SELECT * FROM bobsbookstore_dbo.author;

-- Converted PostgreSQL Statement:
SELECT * FROM bobsbookstore_dbo.author;

-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Output: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- Conversion Notes: 
-- 1. Simple SELECT statement is compatible with PostgreSQL
-- 2. Schema and table name remain unchanged (bobsbookstore_dbo.author)
-- 3. No syntax changes required

-- ================================================================================
-- STATEMENT 3
-- ================================================================================
-- File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 195
-- Method: DeleteAuthorEmbeddedSql
-- Parameters: @BusinessEntityID

-- Original SQL Server Statement:
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- Converted PostgreSQL Statement:
SELECT bobsbookstore_dbo.uspDeleteAuthor(@BusinessEntityID);

-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Output: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- Conversion Notes: 
-- 1. PostgreSQL stored procedures are called as functions using SELECT
-- 2. Removed DECLARE and EXEC syntax as PostgreSQL functions return values directly
-- 3. Schema reference updated to bobsbookstore_dbo (matching existing schema pattern)
-- 4. Parameter naming convention preserved

-- ================================================================================
-- STATEMENT 4
-- ================================================================================
-- File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 214
-- Method: SelectAuthorsByHireYear
-- Parameters: @HireDate

-- Original SQL Server Statement:
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Converted PostgreSQL Statement:
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Output: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- Conversion Notes: 
-- 1. FORMAT() converted to TO_CHAR() with PostgreSQL format patterns
--    - 'yyyy-MM-dd HH:mm:ss' → 'YYYY-MM-DD HH24:MI:SS'
-- 2. DATEDIFF(YEAR, BirthDate, GETDATE()) converted to EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, BirthDate))
--    - AGE() calculates interval between two dates
--    - EXTRACT() gets the year component
-- 3. GETDATE() converted to CURRENT_TIMESTAMP
-- 4. DATEPART(YEAR, HireDate) converted to EXTRACT(YEAR FROM HireDate)
-- 5. Schema and table name remain unchanged (bobsbookstore_dbo.author)

-- ================================================================================
-- STATEMENT 5
-- ================================================================================
-- File: /QNet/site-packages/atx_dot_net_strands_cli/all_local_test_output/artifact-BobsBookstore/artifact/sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Line: 31
-- Method: FindAllProducts
-- Parameters: None

-- Original SQL Server Statement:
EXEC [dbo].[uspGetProductData];

-- Converted PostgreSQL Statement:
SELECT * FROM bobsbookstore_dbo.uspGetProductData();

-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Output: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"}
-- Conversion Notes: 
-- 1. PostgreSQL stored procedures are called as functions
-- 2. EXEC [dbo].[uspGetProductData] converted to SELECT * FROM bobsbookstore_dbo.uspGetProductData()
-- 3. Schema reference updated to bobsbookstore_dbo (matching existing schema pattern)
-- 4. Function call syntax includes parentheses even with no parameters

-- ================================================================================
-- END OF CONVERTED STATEMENTS
-- Total Statements Converted: 5
-- All conversions: MANUAL_AFTER_DMS_FAILURE (due to DMS metadata model creation errors)
-- ================================================================================
