-- ============================================================
-- Converted SQL Statements for PostgreSQL
-- Target: PostgreSQL
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Date: 2026-03-20 (Re-conversion attempt)
-- ============================================================
-- Note: All 5 statements were passed through the DMS MCP tool (dms-mcp___statement_conversion_tool).
-- All 5 failed with error: "Metadata model creation failed: No objects were found according
-- to the specified selection rules."
-- Manual conversion applied with lowercase schema object names per migration rules.
-- DMS Migration Project: arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI
-- ============================================================

-- Statement 1: AuthorsController.cs - EditUsingStoredProcedure method
-- Original (MS SQL): EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
-- DMS Status: ERROR (Metadata model creation failed)
-- DMS Timestamp: 2026-03-20T23:28:08.214948
-- DMS Error Timestamp: 2026-03-20T23:28:22.827410
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Converted (PostgreSQL):
SELECT uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: AuthorsController.cs - FindAllAuthorsEmbeddedSql method
-- Original (MS SQL): SELECT * FROM Author
-- DMS Status: ERROR (Metadata model creation failed)
-- DMS Timestamp: 2026-03-20T23:28:31.326762
-- DMS Error Timestamp: 2026-03-20T23:28:45.987223
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Converted (PostgreSQL):
SELECT * FROM author

-- Statement 3: AuthorsController.cs - DeleteAuthorEmbeddedSql method
-- Original (MS SQL): EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID
-- DMS Status: ERROR (Metadata model creation failed)
-- DMS Timestamp: 2026-03-20T23:28:56.210894
-- DMS Error Timestamp: 2026-03-20T23:29:10.841828
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Converted (PostgreSQL):
SELECT uspdeleteauthor(@BusinessEntityID);

-- Statement 4: AuthorsController.cs - SelectAuthorsByHireYear method
-- Original (MS SQL): SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- DMS Status: ERROR (Metadata model creation failed)
-- DMS Timestamp: 2026-03-20T23:29:19.445228
-- DMS Error Timestamp: 2026-03-20T23:29:34.136526
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Converted (PostgreSQL):
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5: ProductsController.cs - FindAllProducts method
-- Original (MS SQL): EXEC [dbo].[uspGetProductData];
-- DMS Status: ERROR (Metadata model creation failed)
-- DMS Timestamp: 2026-03-20T23:29:42.213906
-- DMS Error Timestamp: 2026-03-20T23:29:56.767852
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Converted (PostgreSQL):
SELECT * FROM uspgetproductdata();
