-- ============================================================================
-- Converted SQL Statements for PostgreSQL - BobsBookstore Application
-- Target: PostgreSQL
-- Conversion Date: 2026-03-22
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed - No objects were found according 
--            to the specified selection rules.
-- ============================================================================

-- Statement 1: EditUsingStoredProcedure (DMS FAILED - Manual Conversion)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs (line 165)
-- Method: EditUsingStoredProcedure
-- Conversion: DECLARE/EXEC stored procedure call -> SELECT function call with lowercase names
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: FindAllAuthorsEmbeddedSql (DMS FAILED - Manual Conversion)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs (line 189)
-- Method: FindAllAuthorsEmbeddedSql
-- Conversion: Already uses PostgreSQL schema, lowercase applied
SELECT * FROM bobsbookstore_dbo.author

-- Statement 3: DeleteAuthorEmbeddedSql (DMS FAILED - Manual Conversion)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs (line 212)
-- Method: DeleteAuthorEmbeddedSql
-- Conversion: DECLARE/EXEC stored procedure call -> SELECT function call with lowercase names
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: SelectAuthorsByHireYear (DMS FAILED - Manual Conversion)
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs (line 232)
-- Method: SelectAuthorsByHireYear
-- Conversion: Column names lowercased for PostgreSQL compatibility
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5: FindAllProducts (DMS FAILED - Manual Conversion)
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs (line 36)
-- Method: FindAllProducts
-- Conversion: EXEC stored procedure call -> SELECT function call with lowercase names
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
