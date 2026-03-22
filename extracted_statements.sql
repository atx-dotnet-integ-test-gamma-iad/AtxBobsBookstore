-- ============================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Project: BobsBookstore - SQL Server to PostgreSQL Migration
-- Date: 2026-03-22
-- Total Statements: 5
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: EditUsingStoredProcedure
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: ~163
-- Method: EditUsingStoredProcedure
-- Execution Method: _context.Database.ExecuteSqlRawAsync
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- Referenced Objects: [dbo].[uspUpdateAuthorPersonalInfo] (stored procedure)
-- ============================================================================
-- Original MS SQL Statement:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Current PostgreSQL Statement (in code):
-- SELECT uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ============================================================================
-- STATEMENT 2: FindAllAuthorsEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: ~187
-- Method: FindAllAuthorsEmbeddedSql
-- Execution Method: _context.Database.SqlQueryRaw<Author>
-- Parameters: None
-- Referenced Objects: Author (table)
-- ============================================================================
-- Original MS SQL Statement:
SELECT * FROM Author

-- Current PostgreSQL Statement (in code):
-- SELECT * FROM author

-- ============================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: ~208
-- Method: DeleteAuthorEmbeddedSql
-- Execution Method: _context.Database.ExecuteSqlRawAsync
-- Parameters: @BusinessEntityID (int)
-- Referenced Objects: [dbo].[uspDeleteAuthor] (stored procedure)
-- ============================================================================
-- Original MS SQL Statement:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Current PostgreSQL Statement (in code):
-- SELECT uspdeleteauthor(@BusinessEntityID);

-- ============================================================================
-- STATEMENT 4: SelectAuthorsByHireYear
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: ~228
-- Method: SelectAuthorsByHireYear
-- Execution Method: _context.Database.SqlQueryRaw<AuthorAgeResult>
-- Parameters: @HireDate (int)
-- Referenced Objects: Author (table) - columns: BusinessEntityID, ModifiedDate, BirthDate, HireDate
-- ============================================================================
-- Original MS SQL Statement:
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Current PostgreSQL Statement (in code):
-- SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(NOW(), birthdate))::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- ============================================================================
-- STATEMENT 5: FindAllProducts
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Line Number: ~34
-- Method: FindAllProducts
-- Execution Method: _context.Database.SqlQueryRaw<Product>
-- Parameters: None
-- Referenced Objects: [dbo].[uspGetProductData] (stored procedure)
-- ============================================================================
-- Original MS SQL Statement:
EXEC [dbo].[uspGetProductData];

-- Current PostgreSQL Statement (in code):
-- SELECT * FROM uspgetproductdata();

-- ============================================================================
-- END OF EXTRACTED STATEMENTS CATALOG
-- Total: 5 statements extracted from 2 files
-- Files: AuthorsController.cs (4 statements), ProductsController.cs (1 statement)
-- ============================================================================
