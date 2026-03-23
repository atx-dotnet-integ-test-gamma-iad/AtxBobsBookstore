-- ============================================================================
-- Converted SQL Statements Catalog
-- Source: BobsBookstore .NET Application
-- Purpose: PostgreSQL equivalents of original MS SQL Server statements
-- Date: 2026-03-23
-- DMS Tool Status: All 5 statements FAILED (metadata model creation error)
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: No objects were found according
--            to the specified selection rules.
-- DMS Attempts: 2 attempts per statement (total 10 DMS calls across 2 runs)
-- ============================================================================

-- Statement 1: EditUsingStoredProcedure
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- DMS Status: FAILED (attempt 1: 2026-03-23T21:24:50, attempt 2 with explicit params: also failed)
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Conversion Notes: MS SQL EXEC stored procedure converted to PostgreSQL SELECT * FROM function() call pattern.
--   Variables @rowsAffected eliminated (PostgreSQL functions return results directly).
--   Schema/object names lowercased per PostgreSQL convention.
-- Original MS SQL:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- Converted PostgreSQL:
SELECT * FROM dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: FindAllAuthorsEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- DMS Status: FAILED (attempt 1: 2026-03-23T21:25:05, attempt 2 with explicit params: also failed)
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Conversion Notes: Simple SELECT statement; table name lowercased (Author -> author).
-- Original MS SQL:
-- SELECT * FROM Author
-- Converted PostgreSQL:
SELECT * FROM author

-- Statement 3: DeleteAuthorEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- DMS Status: FAILED (attempt 1: 2026-03-23T21:25:31, attempt 2: N/A)
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Conversion Notes: MS SQL EXEC stored procedure converted to PostgreSQL SELECT * FROM function() call pattern.
--   Variables @rowsAffected eliminated (PostgreSQL functions return results directly).
--   Schema/object names lowercased per PostgreSQL convention.
-- Original MS SQL:
-- DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- Converted PostgreSQL:
SELECT * FROM dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: SelectAuthorsByHireYear
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- DMS Status: FAILED (attempt 1: 2026-03-23T21:25:45, attempt 2: N/A)
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Conversion Notes: SQL Server functions converted to PostgreSQL equivalents:
--   FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') -> TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS')
--   DATEDIFF(YEAR, BirthDate, GETDATE()) -> EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, birthdate))::INT
--   DATEPART(YEAR, HireDate) -> EXTRACT(YEAR FROM hiredate)
--   GETDATE() -> CURRENT_TIMESTAMP
--   All column/table names lowercased per PostgreSQL convention.
-- Original MS SQL:
-- SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- Converted PostgreSQL:
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, birthdate))::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5: FindAllProducts
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- DMS Status: FAILED (attempt 1: 2026-03-23T21:26:00, attempt 2: N/A)
-- DMS Error: Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'No objects were found according to the specified selection rules. Please review your selection rules and try again.'}}"}
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- Conversion Notes: MS SQL EXEC stored procedure converted to PostgreSQL SELECT * FROM function() call pattern.
--   Schema/object names lowercased per PostgreSQL convention.
-- Original MS SQL:
-- EXEC [dbo].[uspGetProductData];
-- Converted PostgreSQL:
SELECT * FROM dbo.uspgetproductdata();
