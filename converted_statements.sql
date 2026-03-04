-- Converted SQL Statements for PostgreSQL - BobsBookstore Application
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (all 5 statements)
-- DMS Error: Metadata model creation failed: The selected objects were not found.
-- Manual Conversion Rule: Convert all schema object names to lowercase for PostgreSQL compatibility
-- Total Statements: 5

-- Statement 1: Edit Author Using Stored Procedure (PostgreSQL)
-- Original: SELECT * FROM uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
-- Conversion: Already lowercase, PostgreSQL function call syntax preserved
SELECT * FROM uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: Find All Authors (PostgreSQL)
-- Original: SELECT * FROM author
-- Conversion: Already lowercase, no changes needed
SELECT * FROM author;

-- Statement 3: Delete Author Using Stored Procedure (PostgreSQL)
-- Original: SELECT * FROM uspdeleteauthor(@BusinessEntityID);
-- Conversion: Already lowercase, PostgreSQL function call syntax preserved
SELECT * FROM uspdeleteauthor(@BusinessEntityID);

-- Statement 4: Select Authors By Hire Year with Age Calculation (PostgreSQL)
-- Original: SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM NOW())::INT - EXTRACT(YEAR FROM birthdate)::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
-- Conversion: Already uses PostgreSQL functions (TO_CHAR, EXTRACT, NOW(), ::INT casting), all lowercase
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM NOW())::INT - EXTRACT(YEAR FROM birthdate)::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5: Get All Product Data Using Stored Procedure (PostgreSQL)
-- Original: SELECT * FROM uspgetproductdata();
-- Conversion: Already lowercase, PostgreSQL function call syntax preserved
SELECT * FROM uspgetproductdata();
