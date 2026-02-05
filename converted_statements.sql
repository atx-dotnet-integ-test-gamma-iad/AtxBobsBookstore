-- ============================================================================
-- CONVERTED SQL STATEMENTS CATALOG
-- Microsoft SQL Server to PostgreSQL Migration
-- Bob's Bookstore Application
-- ============================================================================
-- 
-- This file contains ALL SQL statements converted to PostgreSQL syntax
-- 
-- Total Statements: 5
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE (all statements)
-- DMS Tool Status: Failed for all statements - manual conversion applied
-- 
-- CRITICAL: All statements were processed through DMS MCP tool first
-- All failed with: "Metadata model creation failed"
-- Manual conversions applied per transformation definition guidelines
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: Edit Author Using Stored Procedure
-- ============================================================================
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- Source: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Conversion: MANUAL_AFTER_DMS_FAILURE
-- Changes: DECLARE/EXEC pattern → SELECT function, [dbo] → bobsbookstore_dbo
-- ============================================================================

SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(
    @BusinessEntityID, 
    @NationalIDNumber, 
    @BirthDate, 
    @MaritalStatus, 
    @Gender
);

-- ============================================================================
-- STATEMENT 2: Find All Authors Embedded SQL
-- ============================================================================
-- Original: SELECT * FROM bobsbookstore_dbo.author
-- Source: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Conversion: MANUAL_AFTER_DMS_FAILURE
-- Changes: None - already PostgreSQL compatible
-- ============================================================================

SELECT * FROM bobsbookstore_dbo.author

-- ============================================================================
-- STATEMENT 3: Delete Author Embedded SQL
-- ============================================================================
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- Source: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Conversion: MANUAL_AFTER_DMS_FAILURE
-- Changes: DECLARE/EXEC pattern → SELECT function, [dbo] → bobsbookstore_dbo
-- ============================================================================

SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- ============================================================================
-- STATEMENT 4: Select Authors By Hire Year
-- ============================================================================
-- Original: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- Source: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Conversion: MANUAL_AFTER_DMS_FAILURE
-- Changes: FORMAT→TO_CHAR, DATEDIFF→DATE_PART/AGE, GETDATE→CURRENT_TIMESTAMP, DATEPART→EXTRACT, columns lowercase
-- ============================================================================

SELECT businessentityid, 
       TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, 
       DATE_PART('year', AGE(CURRENT_TIMESTAMP, birthdate)) AS age 
FROM bobsbookstore_dbo.author 
WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- ============================================================================
-- STATEMENT 5: Find All Products
-- ============================================================================
-- Original: EXEC [dbo].[uspGetProductData];
-- Source: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Conversion: MANUAL_AFTER_DMS_FAILURE
-- Changes: EXEC → SELECT * FROM function(), [dbo] → bobsbookstore_dbo
-- ============================================================================

SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- ============================================================================
-- CONVERSION STATISTICS
-- ============================================================================
-- Total Statements: 5
-- DMS Tool Attempts: 5 (100%)
-- DMS Tool Successes: 0 (0%)
-- DMS Tool Failures: 5 (100%)
-- Manual Conversions: 5 (100%)
--
-- All statements were processed through DMS MCP tool as required
-- All failed with metadata model creation errors
-- Manual conversions applied per transformation definition
-- ============================================================================

-- END OF CONVERTED STATEMENTS CATALOG
