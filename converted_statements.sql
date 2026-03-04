-- ============================================================================
-- Converted SQL Statements for PostgreSQL
-- Target Database: PostgreSQL 13
-- Conversion Date: 2026-03-04
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA (all 5 statements)
-- DMS Error: Metadata model creation failed: The selected objects were not found.
-- DMS Retry Timestamps: 2026-03-04T12:12:20 through 2026-03-04T12:13:30
-- ============================================================================

-- Statement 1: EditUsingStoredProcedure (AuthorsController.cs)
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- DMS Status: FAILED (Metadata model creation failed: The selected objects were not found.)
-- DMS Attempt Timestamp: 2026-03-04T12:12:20.047270
-- Manual Conversion Applied: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Converted:
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: FindAllAuthorsEmbeddedSql (AuthorsController.cs)
-- Original: SELECT * FROM bobsbookstore_dbo.author
-- DMS Status: FAILED (Metadata model creation failed: The selected objects were not found.)
-- DMS Attempt Timestamp: 2026-03-04T12:12:34.388930
-- Manual Conversion Applied: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Converted:
SELECT * FROM bobsbookstore_dbo.author

-- Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs)
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- DMS Status: FAILED (Metadata model creation failed: The selected objects were not found.)
-- DMS Attempt Timestamp: 2026-03-04T12:12:48.514573
-- Manual Conversion Applied: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Converted:
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: SelectAuthorsByHireYear (AuthorsController.cs)
-- Original: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- DMS Status: FAILED (Metadata model creation failed: The selected objects were not found.)
-- DMS Attempt Timestamp: 2026-03-04T12:13:02.618771
-- Manual Conversion Applied: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Converted:
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, birthdate))::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5: FindAllProducts (ProductsController.cs)
-- Original: EXEC [dbo].[uspGetProductData];
-- DMS Status: FAILED (Metadata model creation failed: The selected objects were not found.)
-- DMS Attempt Timestamp: 2026-03-04T12:13:16.744177
-- Manual Conversion Applied: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Converted:
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
