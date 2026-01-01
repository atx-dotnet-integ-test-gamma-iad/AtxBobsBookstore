/*
================================================================================
CONVERTED SQL STATEMENTS CATALOG
================================================================================
Purpose: Complete catalog of all SQL statements converted from MS SQL Server 
         to PostgreSQL, including conversion methods and results
Date: 2026-01-01
Total Statements: 5
DMS Tool Successful Conversions: 0
Manual Conversions After DMS Failure: 5
================================================================================
*/

-- ==============================================================================
-- STATEMENT 1: Update Author Using Stored Procedure
-- ==============================================================================
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed - no objects found
-- ==============================================================================

-- ORIGINAL (MS SQL Server):
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- CONVERTED (PostgreSQL):
SELECT bobsbookstore_dbo.uspUpdateAuthorPersonalInfo(
    @BusinessEntityID::integer,
    @NationalIDNumber::text,
    @BirthDate::timestamp,
    @MaritalStatus::text,
    @Gender::text
);

-- Schema Object Changes: [dbo] → bobsbookstore_dbo
-- Notes: T-SQL DECLARE/EXEC pattern converted to direct function call

-- ==============================================================================
-- STATEMENT 2: Select All Authors
-- ==============================================================================
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed - no objects found
-- ==============================================================================

-- ORIGINAL (MS SQL Server):
-- SELECT * FROM bobsbookstore_dbo.author

-- CONVERTED (PostgreSQL):
SELECT * FROM bobsbookstore_dbo.author

-- Schema Object Changes: None
-- Notes: Already PostgreSQL compatible

-- ==============================================================================
-- STATEMENT 3: Delete Author Using Stored Procedure
-- ==============================================================================
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed - no objects found
-- ==============================================================================

-- ORIGINAL (MS SQL Server):
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- CONVERTED (PostgreSQL):
SELECT bobsbookstore_dbo.uspDeleteAuthor(@BusinessEntityID::integer);

-- Schema Object Changes: [dbo] → bobsbookstore_dbo
-- Notes: T-SQL DECLARE/EXEC pattern converted to direct function call

-- ==============================================================================
-- STATEMENT 4: Select Authors by Hire Year with Calculated Fields
-- ==============================================================================
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed - no objects found
-- ==============================================================================

-- ORIGINAL (MS SQL Server):
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- CONVERTED (PostgreSQL):
SELECT 
    BusinessEntityID, 
    TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, 
    EXTRACT(YEAR FROM AGE(NOW(), BirthDate)) AS Age 
FROM bobsbookstore_dbo.author 
WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- Schema Object Changes: None
-- Notes: FORMAT→TO_CHAR, DATEDIFF→AGE/EXTRACT, GETDATE→NOW, DATEPART→EXTRACT

-- ==============================================================================
-- STATEMENT 5: Get All Products Using Stored Procedure
-- ==============================================================================
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE
-- DMS Error: Metadata model creation failed - no objects found
-- ==============================================================================

-- ORIGINAL (MS SQL Server):
-- EXEC [dbo].[uspGetProductData];

-- CONVERTED (PostgreSQL):
SELECT * FROM bobsbookstore_dbo.uspGetProductData();

-- Schema Object Changes: [dbo] → bobsbookstore_dbo
-- Notes: T-SQL EXEC pattern converted to SELECT FROM function call

-- ==============================================================================
-- END OF CONVERTED STATEMENTS
-- ==============================================================================
