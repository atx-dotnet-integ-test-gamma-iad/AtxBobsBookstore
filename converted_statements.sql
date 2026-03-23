-- ============================================================================
-- Converted SQL Statements - PostgreSQL Versions
-- Source: BobsBookstore Application
-- Conversion Date: 2026-03-23
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according
--            to the specified selection rules.
-- All 5 statements were attempted through DMS MCP tool (2 attempts each), all failed.
-- Manual conversion applied with lowercase schema object names per transformation rules.
-- DMS Migration Project ARN: arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI
-- DMS Database: BobsBookstore, Schema: dbo, Region: us-east-1
-- ============================================================================

-- Statement 1: FindAllAuthorsEmbeddedSql() in AuthorsController.cs
-- Original: SELECT * FROM [dbo].[Author]
-- DMS Attempt 1: 2026-03-23T16:19:36 - FAILED
-- DMS Attempt 2: 2026-03-23T16:49:21 - FAILED
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Conversion: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Reason: DMS failed, table name lowercased, schema dbo mapped to bobsbookstore_dbo
SELECT * FROM bobsbookstore_dbo.author;

-- Statement 2: DeleteAuthorEmbeddedSql() in AuthorsController.cs
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- DMS Attempt 1: 2026-03-23T16:20:00 - FAILED
-- DMS Attempt 2: 2026-03-23T16:49:49 - FAILED
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Conversion: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Reason: DMS failed, EXEC stored procedure converted to PostgreSQL SELECT function() call, schema dbo mapped to bobsbookstore_dbo, function name lowercased
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 3: EditUsingStoredProcedure() in AuthorsController.cs
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- DMS Attempt 1: 2026-03-23T16:20:24 - FAILED
-- DMS Attempt 2: 2026-03-23T16:50:12 - FAILED
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Conversion: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Reason: DMS failed, EXEC stored procedure converted to PostgreSQL SELECT function() call, schema dbo mapped to bobsbookstore_dbo, function name lowercased
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 4: SelectAuthorsByHireYear() in AuthorsController.cs
-- Original: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- DMS Attempt 1: 2026-03-23T16:20:47 - FAILED
-- DMS Attempt 2: 2026-03-23T16:50:36 - FAILED
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Conversion: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Reason: DMS failed, SQL Server functions converted to PostgreSQL equivalents:
--   FORMAT() -> TO_CHAR()
--   DATEDIFF(YEAR, BirthDate, GETDATE()) -> EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER
--   DATEPART(YEAR, HireDate) -> EXTRACT(YEAR FROM hiredate)
--   Column/table names lowercased, schema dbo mapped to bobsbookstore_dbo
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5: FindAllProducts() in ProductsController.cs
-- Original: EXEC [dbo].[uspGetProductData];
-- DMS Attempt 1: 2026-03-23T16:21:13 - FAILED
-- DMS Attempt 2: 2026-03-23T16:51:02 - FAILED
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Conversion: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Reason: DMS failed, EXEC stored procedure converted to PostgreSQL SELECT * FROM function() call, schema dbo mapped to bobsbookstore_dbo, function name lowercased
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
