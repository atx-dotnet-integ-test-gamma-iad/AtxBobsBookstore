-- ============================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Microsoft SQL Server to PostgreSQL Migration
-- Bob's Bookstore Application
-- ============================================================================
-- 
-- This file contains ALL SQL statements extracted from the codebase
-- for conversion through the DMS MCP tool.
--
-- Total Statements Identified: 5
-- Stored Procedure Calls: 3
-- Direct SQL Queries: 2
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: Edit Author Using Stored Procedure
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line Number: ~156
-- Statement Type: Stored Procedure Call with DECLARE and EXEC
-- Parameters: @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
-- Description: Updates author personal information using stored procedure
-- ============================================================================

DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 2: Find All Authors Embedded SQL
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line Number: ~178
-- Statement Type: SELECT query
-- Parameters: None
-- Description: Retrieves all authors from the author table
-- Schema: bobsbookstore_dbo.author (PostgreSQL schema already applied)
-- ============================================================================

SELECT * FROM bobsbookstore_dbo.author

-- ============================================================================
-- STATEMENT 3: Delete Author Embedded SQL
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line Number: ~196
-- Statement Type: Stored Procedure Call with DECLARE and EXEC
-- Parameters: @BusinessEntityID
-- Description: Deletes an author using stored procedure
-- ============================================================================

DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 4: Select Authors By Hire Year
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line Number: ~216
-- Statement Type: SELECT query with SQL Server-specific functions
-- Parameters: @HireDate (actually hireYear parameter)
-- Description: Selects authors with formatted date and age calculation
-- SQL Server Functions Used:
--   - FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss')
--   - DATEDIFF(YEAR, BirthDate, GETDATE())
--   - DATEPART(YEAR, HireDate)
--   - GETDATE()
-- ============================================================================

SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================================
-- STATEMENT 5: Find All Products
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Line Number: ~32
-- Statement Type: Stored Procedure Call
-- Parameters: None
-- Description: Retrieves all products using stored procedure
-- ============================================================================

EXEC [dbo].[uspGetProductData];

-- ============================================================================
-- SQLPARAMETER USAGE SUMMARY
-- ============================================================================
-- 
-- The following SqlParameter usages need to be converted to NpgsqlParameter:
--
-- 1. AuthorsController.EditUsingStoredProcedure (Line ~158):
--    - new SqlParameter("@BusinessEntityID", businessEntityId)
--    - new SqlParameter("@NationalIDNumber", nationalIdNumber)
--    - new SqlParameter("@BirthDate", birthDate.ToUniversalTime())
--    - new SqlParameter("@MaritalStatus", maritalStatus)
--    - new SqlParameter("@Gender", gender)
--
-- 2. AuthorsController.DeleteAuthorEmbeddedSql (Line ~200):
--    - new SqlParameter("@BusinessEntityID", businessEntityId)
--
-- 3. AuthorsController.SelectAuthorsByHireYear (Line ~220):
--    - new SqlParameter("@HireDate", hireYear)
--
-- All SqlParameter instances must be changed to NpgsqlParameter
-- ============================================================================

-- ============================================================================
-- SCHEMA CONTEXT
-- ============================================================================
-- 
-- Target Schema: bobsbookstore_dbo
-- 
-- Relevant Tables:
-- - bobsbookstore_dbo.author (columns: businessentityid, nationalidnumber, 
--   loginid, jobtitle, birthdate, maritalstatus, gender, hiredate, 
--   vacationhours, modifieddate)
-- - bobsbookstore_dbo.product (columns: productid, name, productnumber, 
--   safetystocklevel)
--
-- Stored Procedures to Convert:
-- - [dbo].[uspUpdateAuthorPersonalInfo] → bobsbookstore_dbo.uspupdateauthorpersonalinfo()
-- - [dbo].[uspDeleteAuthor] → bobsbookstore_dbo.uspdeleteauthor()
-- - [dbo].[uspGetProductData] → bobsbookstore_dbo.uspgetproductdata()
--
-- ============================================================================

-- ============================================================================
-- EXTRACTION VERIFICATION CHECKLIST
-- ============================================================================
-- [✓] AuthorsController.cs - All SQL statements extracted (4 statements)
-- [✓] ProductsController.cs - All SQL statements extracted (1 statement)
-- [✓] Repositories/* - No raw SQL found (uses EF Core only)
-- [✓] Total statements extracted: 5
-- [✓] All SqlParameter usages documented
-- [✓] Schema context documented
-- [✓] File locations and line numbers recorded
-- ============================================================================

-- END OF EXTRACTION CATALOG
