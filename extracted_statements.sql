-- ============================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Microsoft SQL Server to PostgreSQL Migration
-- Source: AuthorsController.cs
-- Extraction Date: 2026-01-02
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: FindAllAuthorsEmbeddedSql - Simple SELECT Query
-- ============================================================================
-- Method Name: FindAllAuthorsEmbeddedSql()
-- File Location: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: ~189
-- Statement Type: Simple SELECT query
-- Parameters: None
-- Return Type: List<Author>
-- Special Considerations: Uses schema-qualified table name (bobsbookstore_dbo.author)
-- SQL Server Specific Features: None (standard SQL SELECT)
-- 
-- ORIGINAL SQL STATEMENT:
SELECT * FROM bobsbookstore_dbo.author
-- ============================================================================


-- ============================================================================
-- STATEMENT 2: EditUsingStoredProcedure - Stored Procedure Call with Output
-- ============================================================================
-- Method Name: EditUsingStoredProcedure()
-- File Location: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: ~161
-- Statement Type: Stored procedure call with output parameter
-- Parameters:
--   @BusinessEntityID - int - Author's business entity identifier
--   @NationalIDNumber - string - National identification number
--   @BirthDate - DateTime - Date of birth (converted to UTC in code)
--   @MaritalStatus - string - Marital status code
--   @Gender - string - Gender code
-- Return Type: bool (based on rows affected)
-- Special Considerations: 
--   - Uses DECLARE for output variable
--   - EXEC with return value assignment pattern
--   - PostgreSQL will need function call syntax instead of stored procedure
--   - Stored procedure schema: [dbo].[uspUpdateAuthorPersonalInfo]
-- SQL Server Specific Features:
--   - DECLARE @variable syntax
--   - EXEC @returnValue = [schema].[procedure] syntax
--   - OUTPUT parameter handling
--
-- ORIGINAL SQL STATEMENT:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- ============================================================================


-- ============================================================================
-- STATEMENT 3: DeleteAuthorEmbeddedSql - Stored Procedure Call with Output
-- ============================================================================
-- Method Name: DeleteAuthorEmbeddedSql()
-- File Location: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: ~207
-- Statement Type: Stored procedure call with output parameter
-- Parameters:
--   @BusinessEntityID - int - Author's business entity identifier to delete
-- Return Type: bool (based on rows affected)
-- Special Considerations:
--   - Uses DECLARE for output variable
--   - EXEC with return value assignment pattern
--   - PostgreSQL will need function call syntax instead of stored procedure
--   - Stored procedure schema: [dbo].[uspDeleteAuthor]
-- SQL Server Specific Features:
--   - DECLARE @variable syntax
--   - EXEC @returnValue = [schema].[procedure] syntax
--   - OUTPUT parameter handling
--
-- ORIGINAL SQL STATEMENT:
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- ============================================================================


-- ============================================================================
-- STATEMENT 4: SelectAuthorsByHireYear - Complex SELECT with SQL Server Functions
-- ============================================================================
-- Method Name: SelectAuthorsByHireYear()
-- File Location: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: ~226
-- Statement Type: Complex SELECT query with date/time functions
-- Parameters:
--   @HireDate - int - Year value to filter by hire date
-- Return Type: List<AuthorAgeResult>
-- Return Columns:
--   BusinessEntityID - int
--   FormattedModifiedDate - string (formatted date)
--   Age - int (calculated age in years)
-- Special Considerations:
--   - Multiple SQL Server-specific date/time functions need conversion
--   - Result is mapped to AuthorAgeResult model (not Author entity)
--   - Uses schema-qualified table name (bobsbookstore_dbo.author)
-- SQL Server Specific Features:
--   - FORMAT(date, 'format_string') - needs conversion to TO_CHAR() in PostgreSQL
--   - DATEDIFF(YEAR, date1, date2) - needs conversion to DATE_PART or EXTRACT
--   - GETDATE() - needs conversion to CURRENT_DATE or NOW()
--   - DATEPART(YEAR, date) - needs conversion to DATE_PART or EXTRACT
--
-- ORIGINAL SQL STATEMENT:
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;
-- ============================================================================


-- ============================================================================
-- SUMMARY
-- ============================================================================
-- Total SQL Statements Extracted: 4
-- Simple SELECT Queries: 1 (Statement 1)
-- Stored Procedure Calls: 2 (Statements 2, 3)
-- Complex SELECT with Functions: 1 (Statement 4)
--
-- SQL Server Specific Features Requiring Conversion:
-- - Stored procedure EXEC syntax (Statements 2, 3)
-- - DECLARE variable syntax (Statements 2, 3)
-- - FORMAT() function (Statement 4)
-- - DATEDIFF() function (Statement 4)
-- - GETDATE() function (Statement 4)
-- - DATEPART() function (Statement 4)
-- - [schema].[object] bracket notation (Statements 2, 3)
--
-- Schema Objects Referenced:
-- - Table: bobsbookstore_dbo.author (Statements 1, 4)
-- - Stored Procedure: [dbo].[uspUpdateAuthorPersonalInfo] (Statement 2)
-- - Stored Procedure: [dbo].[uspDeleteAuthor] (Statement 3)
-- ============================================================================
