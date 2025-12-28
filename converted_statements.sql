-- ================================================================================
-- SQL Statement Conversion Catalog (PostgreSQL)
-- Migration: Microsoft SQL Server to PostgreSQL
-- Generated: 2024-12-28
-- Total Statements: 5
-- Conversion Method: MANUAL_AFTER_DMS_FAILURE (DMS tool metadata model creation failed)
-- ================================================================================

-- ================================================================================
-- STATEMENT ID: STMT_001_CONVERTED
-- ORIGINAL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- CONVERSION METHOD: Manual (DMS tool failed - metadata model creation error)
-- NOTES: Converted DECLARE/EXEC/SELECT pattern to PostgreSQL function call
--        Stored procedures in PostgreSQL are typically implemented as functions
--        Assuming the stored procedure has been migrated to a function
-- ================================================================================
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ================================================================================
-- STATEMENT ID: STMT_002_CONVERTED
-- ORIGINAL: SELECT * FROM bobsbookstore_dbo.author
-- CONVERSION METHOD: Manual (DMS tool failed - metadata model creation error)
-- NOTES: This statement is already PostgreSQL compatible
--        Schema name bobsbookstore_dbo is used as-is (from schema_mappings.json)
--        Table name converted to lowercase 'author' as per PostgreSQL convention
-- ================================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ================================================================================
-- STATEMENT ID: STMT_003_CONVERTED
-- ORIGINAL: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- CONVERSION METHOD: Manual (DMS tool failed - metadata model creation error)
-- NOTES: Converted DECLARE/EXEC/SELECT pattern to PostgreSQL function call
--        Stored procedures in PostgreSQL are typically implemented as functions
--        Assuming the stored procedure has been migrated to a function
-- ================================================================================
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- ================================================================================
-- STATEMENT ID: STMT_004_CONVERTED
-- ORIGINAL: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- CONVERSION METHOD: Manual (DMS tool failed - metadata model creation error)
-- NOTES: Converted SQL Server-specific functions to PostgreSQL equivalents:
--        - FORMAT(date, format) -> TO_CHAR(date, format) with PostgreSQL format codes
--        - DATEDIFF(YEAR, date1, date2) -> EXTRACT(YEAR FROM AGE(date2, date1))
--        - GETDATE() -> CURRENT_TIMESTAMP
--        - DATEPART(YEAR, date) -> EXTRACT(YEAR FROM date)
--        Column names converted to lowercase as per PostgreSQL convention
-- ================================================================================
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, birthdate)) AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- ================================================================================
-- STATEMENT ID: STMT_005_CONVERTED
-- ORIGINAL: EXEC [dbo].[uspGetProductData];
-- CONVERSION METHOD: Manual (DMS tool failed - metadata model creation error)
-- NOTES: Converted EXEC statement to PostgreSQL function call
--        Stored procedures in PostgreSQL are typically implemented as functions
--        Assuming the stored procedure has been migrated to a function
-- ================================================================================
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- ================================================================================
-- END OF CONVERSION CATALOG
-- ================================================================================
