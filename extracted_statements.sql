-- Extracted SQL Statements from BobsBookstore Application
-- Source: Microsoft SQL Server to PostgreSQL Migration
-- Total Statements: 5

-- Statement 1: Edit Author Using Stored Procedure
-- Source: AuthorsController.cs, method EditUsingStoredProcedure, line ~163
SELECT * FROM uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: Find All Authors
-- Source: AuthorsController.cs, method FindAllAuthorsEmbeddedSql, line ~187
SELECT * FROM author;

-- Statement 3: Delete Author Using Stored Procedure
-- Source: AuthorsController.cs, method DeleteAuthorEmbeddedSql, line ~208
SELECT * FROM uspdeleteauthor(@BusinessEntityID);

-- Statement 4: Select Authors By Hire Year with Age Calculation
-- Source: AuthorsController.cs, method SelectAuthorsByHireYear, line ~228
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM NOW())::INT - EXTRACT(YEAR FROM birthdate)::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5: Get All Product Data Using Stored Procedure
-- Source: ProductsController.cs, method FindAllProducts, line ~34
SELECT * FROM uspgetproductdata();
