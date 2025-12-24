-- ====================================================================
-- CONVERTED SQL STATEMENTS CATALOG
-- Bob's Bookstore - SQL Server to PostgreSQL Migration
-- Total Statements: 5
-- All statements processed through DMS MCP Tool
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE (for all 5 statements)
-- ====================================================================

-- ====================================================================
-- STATEMENT 1: Update Author Personal Info via Stored Procedure
-- ====================================================================
-- Original SQL Server Statement:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- DMS Tool Output:
-- Status: error
-- Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Timestamp: 2025-12-24T17:15:42.070930

-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Manual Conversion Rationale:
-- SQL Server stored procedure with return value needs to be converted to PostgreSQL function call
-- The stored procedure performs UPDATE and returns affected rows
-- PostgreSQL equivalent uses direct UPDATE statement since the procedure logic is simple

-- Converted PostgreSQL Statement:
UPDATE bobsbookstore_dbo.author SET nationalidnumber = @NationalIDNumber, birthdate = @BirthDate, maritalstatus = @MaritalStatus, gender = @Gender WHERE businessentityid = @BusinessEntityID;

-- ====================================================================
-- STATEMENT 2: Select All Authors
-- ====================================================================
-- Original SQL Server Statement:
-- SELECT * FROM bobsbookstore_dbo.author

-- DMS Tool Output:
-- Status: error
-- Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Timestamp: 2025-12-24T17:16:04.969845

-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Manual Conversion Rationale:
-- Simple SELECT statement is already PostgreSQL compatible
-- Schema name is already using PostgreSQL convention (bobsbookstore_dbo)
-- No SQL Server specific syntax to convert

-- Converted PostgreSQL Statement:
SELECT * FROM bobsbookstore_dbo.author

-- ====================================================================
-- STATEMENT 3: Delete Author via Stored Procedure
-- ====================================================================
-- Original SQL Server Statement:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- DMS Tool Output:
-- Status: error
-- Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Timestamp: 2025-12-24T17:16:27.183925

-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Manual Conversion Rationale:
-- SQL Server stored procedure with return value needs to be converted
-- The stored procedure performs DELETE and returns affected rows
-- PostgreSQL equivalent uses direct DELETE statement since the procedure logic is simple

-- Converted PostgreSQL Statement:
DELETE FROM bobsbookstore_dbo.author WHERE businessentityid = @BusinessEntityID;

-- ====================================================================
-- STATEMENT 4: Select Authors by Hire Year with Calculated Age
-- ====================================================================
-- Original SQL Server Statement:
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- DMS Tool Output:
-- Status: error
-- Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Timestamp: 2025-12-24T17:16:49.962051

-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Manual Conversion Rationale:
-- SQL Server specific functions need conversion:
-- 1. FORMAT(date, format) → TO_CHAR(date, format) with PostgreSQL format codes
-- 2. DATEDIFF(YEAR, date1, date2) → DATE_PART('year', AGE(date2, date1))
-- 3. GETDATE() → CURRENT_TIMESTAMP or NOW()
-- 4. DATEPART(YEAR, date) → EXTRACT(YEAR FROM date) or DATE_PART('year', date)

-- Converted PostgreSQL Statement:
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, DATE_PART('year', AGE(CURRENT_TIMESTAMP, birthdate)) AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- ====================================================================
-- STATEMENT 5: Get All Products via Stored Procedure
-- ====================================================================
-- Original SQL Server Statement:
-- EXEC [dbo].[uspGetProductData];

-- DMS Tool Output:
-- Status: error
-- Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Timestamp: 2025-12-24T17:17:12.167847

-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- Manual Conversion Rationale:
-- SQL Server stored procedure returns cursor with product data
-- The cursor-based approach is not needed in ADO.NET context
-- PostgreSQL equivalent uses direct SELECT statement to return the same data

-- Converted PostgreSQL Statement:
SELECT productid, name, productnumber, safetystocklevel FROM bobsbookstore_dbo.product;

-- ====================================================================
-- CONVERSION SUMMARY
-- ====================================================================
-- Total Statements Processed: 5
-- DMS Tool Success: 0
-- Manual Conversion After DMS Failure: 5
-- 
-- All statements were attempted through DMS MCP tool first as required.
-- All DMS conversions failed with metadata model creation errors.
-- Manual conversions applied based on standard SQL Server to PostgreSQL syntax rules.
-- ====================================================================
