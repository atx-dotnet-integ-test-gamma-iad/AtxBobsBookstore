-- ======================================================================
-- CONVERTED SQL STATEMENTS - PostgreSQL
-- Microsoft SQL Server to PostgreSQL Migration
-- ======================================================================
-- This file contains all SQL statements converted from SQL Server syntax 
-- to PostgreSQL syntax
-- Total Statements: 5
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- ======================================================================

-- ----------------------------------------------------------------------
-- Statement 1: Edit author using stored procedure (MANUALLY CONVERTED)
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- PostgreSQL Conversion: Convert stored procedure call to function call
-- ----------------------------------------------------------------------
SELECT dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ----------------------------------------------------------------------
-- Statement 2: Find all authors (MANUALLY CONVERTED)
-- Original: SELECT * FROM bobsbookstore_dbo.author
-- PostgreSQL Conversion: Use lowercase schema and table name
-- ----------------------------------------------------------------------
SELECT * FROM bobsbookstore_dbo.author

-- ----------------------------------------------------------------------
-- Statement 3: Delete author using stored procedure (MANUALLY CONVERTED)
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- PostgreSQL Conversion: Convert stored procedure call to function call
-- ----------------------------------------------------------------------
SELECT dbo.uspdeleteauthor(@BusinessEntityID);

-- ----------------------------------------------------------------------
-- Statement 4: Select authors by hire year with PostgreSQL functions (MANUALLY CONVERTED)
-- Original: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- PostgreSQL Conversion: Replace FORMAT with TO_CHAR, DATEDIFF with date_part and age calculation, GETDATE with NOW(), DATEPART with EXTRACT
-- ----------------------------------------------------------------------
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, DATE_PART('year', AGE(NOW(), birthdate)) AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- ----------------------------------------------------------------------
-- Statement 5: Get product data using stored procedure (MANUALLY CONVERTED)
-- Original: EXEC [dbo].[uspGetProductData];
-- PostgreSQL Conversion: Convert stored procedure call to function call or SELECT statement
-- ----------------------------------------------------------------------
SELECT * FROM dbo.uspgetproductdata();
