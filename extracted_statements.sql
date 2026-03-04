-- ============================================================================
-- Extracted SQL Statements from BobsBookstore Application
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Extraction Date: 2026-03-04
-- ============================================================================

-- Statement 1: FindAllAuthorsEmbeddedSql (Line ~194)
-- Method: FindAllAuthorsEmbeddedSql()
-- Context: Retrieves all authors from the author table
SELECT * FROM author;

-- Statement 2: EditUsingStoredProcedure (Line ~160)
-- Method: EditUsingStoredProcedure()
-- Context: Calls stored procedure to update author personal info
SELECT * FROM uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 3: DeleteAuthorEmbeddedSql (Line ~213)
-- Method: DeleteAuthorEmbeddedSql()
-- Context: Calls stored procedure to delete an author
SELECT * FROM uspdeleteauthor(@BusinessEntityID);

-- Statement 4: SelectAuthorsByHireYear (Line ~228)
-- Method: SelectAuthorsByHireYear()
-- Context: Selects authors with calculated age filtered by hire year
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birthdate) AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- Statement 5: FindAllProducts (Line ~36 in ProductsController.cs)
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Method: FindAllProducts()
-- Context: Calls stored procedure to get all product data
SELECT * FROM uspgetproductdata();
