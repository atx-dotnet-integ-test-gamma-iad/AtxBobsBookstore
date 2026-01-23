-- ================================================================
-- CONVERTED SQL STATEMENTS CATALOG - PostgreSQL
-- Microsoft SQL Server to PostgreSQL Migration
-- Generated: Step 2 - Convert All SQL Statements Using DMS MCP Tool
-- ================================================================
-- This file contains ALL SQL statements converted to PostgreSQL syntax
-- Each statement corresponds to the extracted statements from Step 1
-- Conversion method documented for each statement
-- ================================================================

-- ================================================================
-- STATEMENT 1: EditUsingStoredProcedure - Update Author Personal Info
-- ================================================================
-- Original MS SQL:
-- DECLARE @rowsAffected INT;
-- EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
-- SELECT @rowsAffected;
--
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: The selected objects were not found
-- Manual Conversion Rationale:
--   - Stored procedure uspUpdateAuthorPersonalInfo performs an UPDATE on Author table
--   - Original SQL Server proc updates NationalIDNumber, BirthDate, MaritalStatus, Gender
--   - PostgreSQL equivalent: Direct UPDATE statement (no DECLARE/EXEC pattern needed)
--   - Schema: bobsbookstore_dbo (as already used in codebase)
--   - ExecuteSqlRawAsync returns rows affected directly in EF Core
-- ----------------------------------------------------------------
UPDATE bobsbookstore_dbo.author 
SET nationalidnumber = @NationalIDNumber,
    birthdate = @BirthDate,
    maritalstatus = @MaritalStatus,
    gender = @Gender
WHERE businessentityid = @BusinessEntityID;
-- ================================================================

-- ================================================================
-- STATEMENT 2: FindAllAuthorsEmbeddedSql - Select All Authors
-- ================================================================
-- Original MS SQL:
-- SELECT * FROM bobsbookstore_dbo.author
--
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: The selected objects were not found
-- Manual Conversion Rationale:
--   - Simple SELECT statement, already compatible with PostgreSQL
--   - Schema notation bobsbookstore_dbo is correct for PostgreSQL
--   - Column names should be lowercase per PostgreSQL convention (handled by EF Core mapping)
--   - No changes needed to SQL syntax itself
-- ----------------------------------------------------------------
SELECT * FROM bobsbookstore_dbo.author
-- ================================================================

-- ================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql - Delete Author
-- ================================================================
-- Original MS SQL:
-- DECLARE @rowsAffected INT;
-- EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
-- SELECT @rowsAffected;
--
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: The selected objects were not found
-- Manual Conversion Rationale:
--   - Stored procedure uspDeleteAuthor performs a DELETE on Author table
--   - Original SQL Server proc deletes by BusinessEntityID
--   - PostgreSQL equivalent: Direct DELETE statement (no DECLARE/EXEC pattern needed)
--   - Schema: bobsbookstore_dbo (as already used in codebase)
--   - ExecuteSqlRawAsync returns rows affected directly in EF Core
-- ----------------------------------------------------------------
DELETE FROM bobsbookstore_dbo.author 
WHERE businessentityid = @BusinessEntityID;
-- ================================================================

-- ================================================================
-- STATEMENT 4: SelectAuthorsByHireYear - Authors Hired in Specific Year with Age Calculation
-- ================================================================
-- Original MS SQL:
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, 
--        DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age 
-- FROM bobsbookstore_dbo.author 
-- WHERE DATEPART(YEAR, HireDate) = @HireDate;
--
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: The selected objects were not found
-- Manual Conversion Rationale:
--   - FORMAT(date, pattern) → TO_CHAR(date, pattern) with PostgreSQL pattern
--     'yyyy-MM-dd HH:mm:ss' → 'YYYY-MM-DD HH24:MI:SS'
--   - DATEDIFF(YEAR, BirthDate, GETDATE()) → EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, BirthDate))
--   - GETDATE() → CURRENT_TIMESTAMP or NOW()
--   - DATEPART(YEAR, HireDate) → EXTRACT(YEAR FROM HireDate)
--   - Column names lowercase per EF Core mapping: businessentityid, modifieddate, birthdate, hiredate
-- ----------------------------------------------------------------
SELECT businessentityid, 
       TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, 
       EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, birthdate)) AS age 
FROM bobsbookstore_dbo.author 
WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
-- ================================================================

-- ================================================================
-- STATEMENT 5: FindAllProducts - Get All Products via Stored Procedure
-- ================================================================
-- Original MS SQL:
-- EXEC [dbo].[uspGetProductData];
--
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed: The selected objects were not found
-- Manual Conversion Rationale:
--   - Stored procedure uspGetProductData returns a cursor with ProductID, Name, ProductNumber, SafetyStockLevel
--   - PostgreSQL equivalent: Direct SELECT statement (no EXEC needed)
--   - Schema: bobsbookstore_dbo (as already used in codebase)
--   - Column names lowercase per EF Core mapping: productid, name, productnumber, safetystocklevel
-- ----------------------------------------------------------------
SELECT productid, name, productnumber, safetystocklevel 
FROM bobsbookstore_dbo.product;
-- ================================================================

-- ================================================================
-- SUMMARY
-- ================================================================
-- Total SQL Statements Converted: 5
-- 
-- Conversion Methods:
--   - DMS_TOOL: 0 statements
--   - MANUAL_AFTER_DMS_FAILURE: 5 statements
-- 
-- All statements attempted conversion through DMS MCP tool first
-- DMS tool returned error: Metadata model creation failed for all statements
-- 
-- PostgreSQL Conversions Applied:
--   - Stored procedure calls → Direct SQL statements (UPDATE, DELETE, SELECT)
--   - DECLARE/EXEC pattern → Direct SQL (EF Core returns rows affected)
--   - FORMAT(date, pattern) → TO_CHAR(date, pattern) with PostgreSQL format
--   - DATEDIFF(YEAR, d1, d2) → EXTRACT(YEAR FROM AGE(d2, d1))
--   - GETDATE() → CURRENT_TIMESTAMP
--   - DATEPART(YEAR, date) → EXTRACT(YEAR FROM date)
--   - Schema notation preserved: bobsbookstore_dbo
--   - Column names lowercase per PostgreSQL/EF Core conventions
--   - Parameter syntax @param preserved (compatible with NpgsqlParameter)
-- ================================================================
