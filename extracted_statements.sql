-- ============================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Source: BobsBookstore .NET Application
-- Purpose: Comprehensive catalog of all SQL statements for DMS conversion
-- Date: 2026-03-23
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: EditUsingStoredProcedure - Update Author Personal Info
-- ============================================================================
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 165
-- Method: EditUsingStoredProcedure(int businessEntityId, string nationalIdNumber, DateTime birthDate, string maritalStatus, string gender)
-- Context: Calls stored procedure [dbo].[uspUpdateAuthorPersonalInfo] to update author personal information
-- Execution Method: _context.Database.ExecuteSqlRawAsync(sql, NpgsqlParameter...)
-- Parameters: @BusinessEntityID (int), @NationalIDNumber (string), @BirthDate (DateTime), @MaritalStatus (string), @Gender (string)
-- SQL Server Syntax: DECLARE/EXEC pattern with output variable
--
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 2: FindAllAuthorsEmbeddedSql - Select All Authors
-- ============================================================================
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 189
-- Method: FindAllAuthorsEmbeddedSql()
-- Context: Selects all authors from the author table
-- Execution Method: _context.Database.SqlQueryRaw<Author>(sql).ToListAsync()
-- Parameters: None
-- Note: Already uses PostgreSQL-compatible schema prefix, but MUST still be processed through DMS
--
SELECT * FROM bobsbookstore_dbo.author

-- ============================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql - Delete Author
-- ============================================================================
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 212
-- Method: DeleteAuthorEmbeddedSql(int businessEntityId)
-- Context: Calls stored procedure [dbo].[uspDeleteAuthor] to delete an author
-- Execution Method: _context.Database.ExecuteSqlRawAsync(sql, NpgsqlParameter...)
-- Parameters: @BusinessEntityID (int)
-- SQL Server Syntax: DECLARE/EXEC pattern with output variable
--
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ============================================================================
-- STATEMENT 4: SelectAuthorsByHireYear - Select Authors by Hire Year with Age
-- ============================================================================
-- File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line: 232
-- Method: SelectAuthorsByHireYear(int hireYear)
-- Context: Selects authors filtered by hire year, calculating age from birthdate
-- Execution Method: _context.Database.SqlQueryRaw<AuthorAgeResult>(sql, NpgsqlParameter("p1", hireYear)).ToListAsync()
-- Parameters: $1 (hireYear as int, positional parameter)
-- Note: Already uses PostgreSQL-specific functions (TO_CHAR, EXTRACT, AGE, ::INTEGER cast)
--       but MUST still be processed through DMS for schema name validation
--
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate))::INTEGER AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = $1;

-- ============================================================================
-- STATEMENT 5: FindAllProducts - Get Product Data via Stored Procedure
-- ============================================================================
-- File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Line: 36
-- Method: FindAllProducts()
-- Context: Calls stored procedure [dbo].[uspGetProductData] to retrieve all products
-- Execution Method: _context.Database.SqlQueryRaw<Product>(sql).ToListAsync()
-- Parameters: None
-- SQL Server Syntax: EXEC stored procedure call
--
EXEC [dbo].[uspGetProductData];

-- ============================================================================
-- END OF EXTRACTED STATEMENTS CATALOG
-- Total Statements: 5
-- SQL Server specific (need conversion): 3 (Statements 1, 3, 5)
-- PostgreSQL-compatible (still need DMS validation): 2 (Statements 2, 4)
-- ============================================================================
