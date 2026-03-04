-- ============================================================================
-- Converted SQL Statements - BobsBookstore Migration (PostgreSQL Versions)
-- ============================================================================
-- All statements were manually converted due to DMS tool failure.
-- Conversion method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- DMS Error: Metadata model creation failed: The selected objects were not found.
-- ============================================================================

-- ============================================================================
-- Statement 1: EditUsingStoredProcedure
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Conversion: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- ============================================================================

-- Original MS SQL Server:
-- EXEC dbo.uspUpdateAuthorPersonalInfo @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender

-- Converted PostgreSQL:
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ============================================================================
-- Statement 2: FindAllAuthorsEmbeddedSql
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Conversion: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- ============================================================================

-- Original MS SQL Server:
-- SELECT * FROM dbo.Author

-- Converted PostgreSQL:
SELECT * FROM bobsbookstore_dbo.author;

-- ============================================================================
-- Statement 3: DeleteAuthorEmbeddedSql
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Conversion: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- ============================================================================

-- Original MS SQL Server:
-- EXEC dbo.uspDeleteAuthor @BusinessEntityID

-- Converted PostgreSQL:
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- ============================================================================
-- Statement 4: SelectAuthorsByHireYear
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Conversion: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- ============================================================================

-- Original MS SQL Server:
-- SELECT BusinessEntityID, CONVERT(VARCHAR, ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM dbo.Author WHERE DATEPART(YEAR, HireDate) = @HireDate

-- Converted PostgreSQL:
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- ============================================================================
-- Statement 5: FindAllProducts
-- Source File: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts
-- Conversion: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- ============================================================================

-- Original MS SQL Server:
-- EXEC dbo.uspGetProductData

-- Converted PostgreSQL:
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
