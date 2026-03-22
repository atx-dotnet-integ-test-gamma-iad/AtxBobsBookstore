-- ============================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Source: BobsBookstore .NET ADO Application
-- Migration: Microsoft SQL Server to PostgreSQL
-- Date: 2026-03-22
-- Updated: 2026-03-22 (Step 1 re-execution)
-- ============================================================

-- Statement 1
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 163
-- Method: EditUsingStoredProcedure
-- Context: ExecuteSqlRawAsync - Stored procedure call to update author personal info
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- Original MS SQL Server: EXEC dbo.uspUpdateAuthorPersonalInfo @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
-- Current (already PostgreSQL): SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 187
-- Method: FindAllAuthorsEmbeddedSql
-- Context: SqlQueryRaw - Simple SELECT to retrieve all authors
-- Parameters: None
-- Original MS SQL Server: SELECT * FROM dbo.Author;
-- Current (already PostgreSQL): SELECT * FROM bobsbookstore_dbo.author;
SELECT * FROM bobsbookstore_dbo.author;

-- Statement 3
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 208
-- Method: DeleteAuthorEmbeddedSql
-- Context: ExecuteSqlRawAsync - Stored procedure call to delete author
-- Parameters: @BusinessEntityID (int)
-- Original MS SQL Server: EXEC dbo.uspDeleteAuthor @BusinessEntityID;
-- Current (already PostgreSQL): SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);
SELECT * FROM bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 228
-- Method: SelectAuthorsByHireYear
-- Context: SqlQueryRaw - Complex SELECT with date functions and type casting
-- Parameters: @HireDate (int)
-- Original MS SQL Server: SELECT BusinessEntityID, CONVERT(VARCHAR(19), ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM dbo.Author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- Current (already PostgreSQL): SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5
-- File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Line: 34
-- Method: FindAllProducts
-- Context: SqlQueryRaw - Stored procedure call to retrieve product data
-- Parameters: None
-- Original MS SQL Server: EXEC dbo.uspGetProductData;
-- Current (already PostgreSQL): SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();
