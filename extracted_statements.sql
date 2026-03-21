-- ============================================================
-- Extracted SQL Statements from BobsBookstore .NET Application
-- Source: Microsoft SQL Server to PostgreSQL Migration
-- ============================================================

-- Statement 1: ProductsController.cs line 34 (FindAllProducts method)
-- Source File: sourceCode/app/Bookstore.Web/Controllers/ProductsController.cs
SELECT * FROM bobsbookstore_dbo.uspgetproductdata();

-- Statement 2: AuthorsController.cs line 163 (EditUsingStoredProcedure method)
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
SELECT bobsbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 3: AuthorsController.cs line 187 (FindAllAuthorsEmbeddedSql method)
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
SELECT * FROM bobsbookstore_dbo."author"

-- Statement 4: AuthorsController.cs line 208 (DeleteAuthorEmbeddedSql method)
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
SELECT bobsbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 5: AuthorsController.cs line 228 (SelectAuthorsByHireYear method)
-- Source File: sourceCode/app/Bookstore.Web/Controllers/AuthorsController.cs
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo."author" WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;
