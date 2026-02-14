-- ================================================================================
-- Converted SQL Statements for PostgreSQL
-- ================================================================================
-- This file contains all SQL statements converted from Microsoft SQL Server 
-- syntax to PostgreSQL syntax for Bob's Bookstore .NET Application.
-- Each statement is annotated with its source location and conversion method.
-- ================================================================================

-- ================================================================================
-- STATEMENT 1: Update Author Personal Info using Stored Procedure
-- ================================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure()
-- Line: ~153
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- Changes Applied:
--   - Converted DECLARE/EXEC pattern to PostgreSQL SELECT function call
--   - Changed [dbo].uspUpdateAuthorPersonalInfo to bobsbookstore_dbo.uspUpdateAuthorPersonalInfo
--   - Removed DECLARE and variable assignment; PostgreSQL functions return directly
-- ================================================================================
SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ================================================================================
-- STATEMENT 2: Select All Authors
-- ================================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql()
-- Line: ~174
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Original: SELECT * FROM bobsbookstore_dbo.author
-- Changes Applied:
--   - No changes required; statement is PostgreSQL compatible
--   - Schema reference bobsbookstore_dbo is correct for PostgreSQL
-- ================================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ================================================================================
-- STATEMENT 3: Delete Author using Stored Procedure
-- ================================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql()
-- Line: ~195
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- Changes Applied:
--   - Converted DECLARE/EXEC pattern to PostgreSQL SELECT function call
--   - Changed [dbo].uspDeleteAuthor to bobsbookstore_dbo.uspDeleteAuthor
--   - Removed DECLARE and variable assignment; PostgreSQL functions return directly
-- ================================================================================
SELECT bobsbookstore_dbo.uspDeleteAuthor(@BusinessEntityID);

-- ================================================================================
-- STATEMENT 4: Select Authors by Hire Year with Age Calculation
-- ================================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear()
-- Line: ~213
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Original: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- Changes Applied:
--   - FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') -> TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS')
--   - DATEDIFF(YEAR, BirthDate, GETDATE()) -> DATE_PART('year', AGE(CURRENT_TIMESTAMP, BirthDate))
--   - GETDATE() -> CURRENT_TIMESTAMP
--   - DATEPART(YEAR, HireDate) -> EXTRACT(YEAR FROM HireDate)
-- ================================================================================
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, DATE_PART('year', AGE(CURRENT_TIMESTAMP, BirthDate)) AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- ================================================================================
-- STATEMENT 5: Get All Products using Stored Procedure
-- ================================================================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts()
-- Line: ~31
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Original: EXEC [dbo].[uspGetProductData];
-- Changes Applied:
--   - Converted EXEC stored procedure call to PostgreSQL SELECT function call
--   - Changed [dbo].uspGetProductData to bobsbookstore_dbo.uspGetProductData
--   - Added SELECT * FROM for table-returning function
-- ================================================================================
SELECT * FROM bobsbookstore_dbo.uspGetProductData();

-- ================================================================================
-- END OF CONVERTED STATEMENTS
-- Total Statements Converted: 5
-- DMS Tool Successful Conversions: 0
-- Manual Conversions After DMS Failure: 5
-- ================================================================================
