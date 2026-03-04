-- Converted SQL Statements Catalog (PostgreSQL)
-- Source: BobsBookstore .NET Application
-- Conversion Date: 2026-03-04
-- Total Statements: 5
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (all 5 statements)
-- DMS Failure Reason: Metadata model creation failed: The selected objects were not found.
-- DMS Tool was called for ALL 5 statements across TWO separate runs. All 10 calls failed with the same error.
-- Manual conversion applied lowercase schema object names per transformation rules.

-- ============================================================
-- Statement 1: AuthorsController.cs - EditUsingStoredProcedure method (line 163)
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- DMS Status: FAILED - Metadata model creation failed: The selected objects were not found.
-- DMS Run 1 Timestamp: 2026-03-04T01:56:11.488483 / Error: 2026-03-04T01:56:26.336533
-- DMS Run 2 Timestamp: 2026-03-04T02:20:29.514405 / Error: 2026-03-04T02:20:44.569424
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Conversion Notes: EXEC stored procedure with DECLARE/SELECT pattern -> CALL procedure, schema [dbo] -> bobsbookstore_dbo, procedure name -> lowercase
-- ============================================================
CALL bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ============================================================
-- Statement 2: AuthorsController.cs - FindAllAuthorsEmbeddedSql method (line 187)
-- Original: SELECT * FROM [dbo].[Author]
-- DMS Status: FAILED - Metadata model creation failed: The selected objects were not found.
-- DMS Run 1 Timestamp: 2026-03-04T01:56:34.788591 / Error: 2026-03-04T01:56:49.442451
-- DMS Run 2 Timestamp: 2026-03-04T02:20:55.233854 / Error: 2026-03-04T02:21:10.003234
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Conversion Notes: [dbo].[Author] -> bobsbookstore_dbo.author (lowercase)
-- ============================================================
SELECT * FROM bobsbookstore_dbo.author;

-- ============================================================
-- Statement 3: AuthorsController.cs - DeleteAuthorEmbeddedSql method (line 208)
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- DMS Status: FAILED - Metadata model creation failed: The selected objects were not found.
-- DMS Run 1 Timestamp: 2026-03-04T01:56:57.949251 / Error: 2026-03-04T01:57:12.667147
-- DMS Run 2 Timestamp: 2026-03-04T02:21:17.828336 / Error: 2026-03-04T02:21:32.612813
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Conversion Notes: EXEC stored procedure with DECLARE/SELECT pattern -> CALL procedure, schema [dbo] -> bobsbookstore_dbo, procedure name -> lowercase
-- ============================================================
CALL bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- ============================================================
-- Statement 4: AuthorsController.cs - SelectAuthorsByHireYear method (line 228)
-- Original: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM [dbo].[Author] WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- DMS Status: FAILED - Metadata model creation failed: The selected objects were not found.
-- DMS Run 1 Timestamp: 2026-03-04T01:57:22.691978 / Error: 2026-03-04T01:57:37.270893
-- DMS Run 2 Timestamp: 2026-03-04T02:21:42.021098 / Error: 2026-03-04T02:21:56.727056
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Conversion Notes: FORMAT -> TO_CHAR, DATEDIFF -> EXTRACT/AGE, GETDATE -> CURRENT_TIMESTAMP, DATEPART -> EXTRACT, column names to lowercase, [dbo].[Author] -> bobsbookstore_dbo.author
-- ============================================================
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, birthdate))::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- ============================================================
-- Statement 5: ProductsController.cs - FindAllProducts method (line 34)
-- Original: EXEC [dbo].[uspGetProductData];
-- DMS Status: FAILED - Metadata model creation failed: The selected objects were not found.
-- DMS Run 1 Timestamp: 2026-03-04T01:57:45.740681 / Error: 2026-03-04T01:58:00.600926
-- DMS Run 2 Timestamp: 2026-03-04T02:22:05.068255 / Error: 2026-03-04T02:22:19.949855
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Conversion Notes: EXEC procedure -> SELECT * FROM function call, schema [dbo] -> bobsbookstore_dbo, procedure name -> lowercase
-- ============================================================
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
