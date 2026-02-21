-- ==============================================================================
-- EXTRACTED SQL STATEMENTS FROM BOBS BOOKSTORE APPLICATION
-- Extraction Date: Migration Phase - Step 1
-- ==============================================================================
-- This file contains all SQL statements extracted from the .NET codebase
-- for conversion from Microsoft SQL Server to PostgreSQL syntax.
-- Each statement includes metadata about its location and context.
-- ==============================================================================

-- ==============================================================================
-- STATEMENT 1: Stored Procedure Call with Variable Declaration and SELECT
-- ==============================================================================
-- Location: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: EditUsingStoredProcedure
-- Line: ~162
-- Context: Updates author personal information using stored procedure
-- Type: Stored Procedure Execution with output variable
-- Parameters: @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
-- ==============================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- ==============================================================================
-- STATEMENT 2: Simple SELECT from author table
-- ==============================================================================
-- Location: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: FindAllAuthorsEmbeddedSql
-- Line: ~186
-- Context: Retrieves all authors from database
-- Type: Direct SQL Query
-- Parameters: None
-- ==============================================================================
SELECT * FROM bobsbookstore_dbo.author

-- ==============================================================================
-- STATEMENT 3: Stored Procedure Call for Delete with Variable Declaration
-- ==============================================================================
-- Location: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: DeleteAuthorEmbeddedSql
-- Line: ~206
-- Context: Deletes an author using stored procedure
-- Type: Stored Procedure Execution with output variable
-- Parameters: @BusinessEntityID
-- ==============================================================================
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- ==============================================================================
-- STATEMENT 4: Complex SELECT with Date Functions (FORMAT, DATEDIFF, GETDATE, DATEPART)
-- ==============================================================================
-- Location: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Method: SelectAuthorsByHireYear
-- Line: ~222
-- Context: Selects authors by hire year with formatted date and age calculation
-- Type: Direct SQL Query with SQL Server specific date functions
-- Parameters: @HireDate
-- ==============================================================================
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ==============================================================================
-- CONNECTION STRING CONSTRUCTION (Not SQL, but database-related)
-- ==============================================================================
-- Location: app/Bookstore.Web/Startup/ServicesSetup.cs
-- Method: GetDatabaseConnectionString
-- Line: ~97
-- Context: Builds SQL Server connection string from secrets
-- Type: Connection String Builder
-- Note: Uses SqlConnectionStringBuilder with SQL Server specific parameters
-- SQL Server Format: Server={host},{port}; Initial Catalog=BobsUsedBookStore;MultipleActiveResultSets=true; Integrated Security=false;TrustServerCertificate=True
-- ==============================================================================

-- ==============================================================================
-- SUMMARY
-- ==============================================================================
-- Total SQL Statements Extracted: 4
-- - Stored Procedure Calls: 2 (Statement 1, Statement 3)
-- - Direct SQL Queries: 2 (Statement 2, Statement 4)
-- - SQL Server Specific Functions Used: FORMAT, DATEDIFF, GETDATE, DATEPART
-- - Schema References: bobsbookstore_dbo, [dbo]
-- - Stored Procedures Referenced: uspUpdateAuthorPersonalInfo, uspDeleteAuthor
-- ==============================================================================
