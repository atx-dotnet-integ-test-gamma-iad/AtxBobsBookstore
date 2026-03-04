-- ============================================================================
-- Converted SQL Statements for PostgreSQL - BobsBookstore Application
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Conversion Date: 2026-03-04
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Failure Reason: AccessDeniedException - User not authorized to perform
--   dms:StartMetadataModelCreation on migration-project resource
-- ============================================================================

-- Statement 1: FindAllAuthorsEmbeddedSql (PostgreSQL)
-- Original: SELECT * FROM author
-- Conversion: No changes needed - already uses lowercase schema object names
SELECT * FROM author;

-- Statement 2: EditUsingStoredProcedure (PostgreSQL)
-- Original: SELECT * FROM uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
-- Conversion: No changes needed - already uses lowercase function name and PostgreSQL syntax
SELECT * FROM uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 3: DeleteAuthorEmbeddedSql (PostgreSQL)
-- Original: SELECT * FROM uspdeleteauthor(@BusinessEntityID);
-- Conversion: No changes needed - already uses lowercase function name and PostgreSQL syntax
SELECT * FROM uspdeleteauthor(@BusinessEntityID);

-- Statement 4: SelectAuthorsByHireYear (PostgreSQL)
-- Original: SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birthdate) AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
-- Conversion: No changes needed - already uses PostgreSQL functions (TO_CHAR, EXTRACT) and lowercase schema object names
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birthdate) AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5: FindAllProducts (PostgreSQL)
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Original: SELECT * FROM uspgetproductdata();
-- Conversion: No changes needed - already uses lowercase function name and PostgreSQL syntax
SELECT * FROM uspgetproductdata();
