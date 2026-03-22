-- ============================================================
-- CONVERTED SQL STATEMENTS CATALOG
-- Source: BobsBookstore .NET ADO Application
-- Migration: Microsoft SQL Server to PostgreSQL
-- Date: 2026-03-22
-- Updated: 2026-03-22 (Step 1 re-execution with fresh DMS attempts)
-- ============================================================
-- DMS Tool Status: All 5 statements passed to DMS tool; all failed with metadata model error.
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed - No objects were found according to the specified selection rules
-- Manual Conversion: Applied lowercase schema object names per transformation definition rules.
-- Note: Codebase was already partially migrated to PostgreSQL syntax prior to this step.
-- ============================================================

-- Statement 1 (Converted)
-- Original File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 163
-- Method: EditUsingStoredProcedure
-- Conversion: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Attempt Timestamp: 2026-03-22T14:13:28.865631
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- Original MS SQL: EXEC dbo.uspUpdateAuthorPersonalInfo @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
-- Manual Conversion: Converted EXEC to SELECT * FROM function call syntax, lowercase schema/object names, bobsbookstore_dbo schema prefix
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2 (Converted)
-- Original File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 187
-- Method: FindAllAuthorsEmbeddedSql
-- Conversion: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Attempt Timestamp: 2026-03-22T14:14:19.411001
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- Original MS SQL: SELECT * FROM dbo.Author;
-- Manual Conversion: Lowercase table name, bobsbookstore_dbo schema prefix
SELECT * FROM bobsbookstore_dbo.author;

-- Statement 3 (Converted)
-- Original File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 208
-- Method: DeleteAuthorEmbeddedSql
-- Conversion: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Attempt Timestamp: 2026-03-22T14:14:41.786194
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- Original MS SQL: EXEC dbo.uspDeleteAuthor @BusinessEntityID;
-- Manual Conversion: Converted EXEC to SELECT * FROM function call syntax, lowercase schema/object names, bobsbookstore_dbo schema prefix
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4 (Converted)
-- Original File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 228
-- Method: SelectAuthorsByHireYear
-- Conversion: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Attempt Timestamp: 2026-03-22T14:15:05.926229
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- Original MS SQL: SELECT BusinessEntityID, CONVERT(VARCHAR(19), ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM dbo.Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- Manual Conversion: Converted CONVERT to TO_CHAR, DATEDIFF/GETDATE to EXTRACT/AGE/CURRENT_DATE, DATEPART to EXTRACT, ::INTEGER cast, lowercase names, bobsbookstore_dbo schema
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5 (Converted)
-- Original File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Line: 34
-- Method: FindAllProducts
-- Conversion: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Attempt Timestamp: 2026-03-22T14:15:28.556414
-- DMS Error: Metadata model creation failed: No objects were found according to the specified selection rules.
-- Original MS SQL: EXEC dbo.uspGetProductData;
-- Manual Conversion: Converted EXEC to SELECT * FROM function call syntax with (), lowercase schema/object names, bobsbookstore_dbo schema prefix
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
