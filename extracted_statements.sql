-- ============================================================================
-- Extracted SQL Statements - Original MS SQL Server Versions
-- Source: BobsBookstore Application
-- Extraction Date: 2026-03-23
-- Total Statements: 5
-- ============================================================================

-- Statement 1: FindAllAuthorsEmbeddedSql() in AuthorsController.cs
-- Source: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql()
-- Line: ~188
-- Execution: _context.Database.SqlQueryRaw<Author>(sql).ToListAsync()
SELECT * FROM [dbo].[Author];

-- Statement 2: DeleteAuthorEmbeddedSql() in AuthorsController.cs
-- Source: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql(int businessEntityId)
-- Line: ~210
-- Execution: _context.Database.ExecuteSqlRawAsync(sql, ...)
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement 3: EditUsingStoredProcedure() in AuthorsController.cs
-- Source: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure(int businessEntityId, string nationalIdNumber, DateTime birthDate, string maritalStatus, string gender)
-- Line: ~164
-- Execution: _context.Database.ExecuteSqlRawAsync(sql, ...)
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement 4: SelectAuthorsByHireYear() in AuthorsController.cs
-- Source: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear(int hireYear)
-- Line: ~230
-- Execution: _context.Database.SqlQueryRaw<AuthorAgeResult>(sql, ...).ToListAsync()
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Statement 5: FindAllProducts() in ProductsController.cs
-- Source: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts()
-- Line: ~35
-- Execution: _context.Database.SqlQueryRaw<Product>(sql).ToListAsync()
EXEC [dbo].[uspGetProductData];
