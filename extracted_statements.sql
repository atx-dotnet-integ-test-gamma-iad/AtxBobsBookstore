-- ============================================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Migration from Microsoft SQL Server to PostgreSQL
-- Extraction Date: 2025-12-31
-- ============================================================================
-- This file contains all SQL statements extracted from the Bob's Bookstore
-- .NET application codebase. Each statement is documented with its source
-- location, context, and metadata for conversion tracking.
-- ============================================================================

-- ============================================================================
-- STATEMENT 1: Edit Author Using Stored Procedure
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Numbers: 161
-- Method: EditUsingStoredProcedure
-- Statement Type: DECLARE/EXEC Stored Procedure Call
-- Description: Calls uspUpdateAuthorPersonalInfo stored procedure to update
--              author personal information and returns rows affected
-- Parameters:
--   @BusinessEntityID (int) - The business entity ID of the author
--   @NationalIDNumber (nvarchar(15)) - National ID number
--   @BirthDate (datetime) - Birth date (converted to UTC)
--   @MaritalStatus (nchar(1)) - Marital status code
--   @Gender (nchar(1)) - Gender code
-- Return: Row count of affected records
-- ============================================================================

DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- Stored Procedure Definition (uspUpdateAuthorPersonalInfo):
-- ----------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[uspUpdateAuthorPersonalInfo]
    @BusinessEntityID [int], 
    @NationalIDNumber [nvarchar](15), 
    @BirthDate [datetime], 
    @MaritalStatus [nchar](1), 
    @Gender [nchar](1)
WITH EXECUTE AS CALLER
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        UPDATE [dbo].[Author] 
        SET [NationalIDNumber] = @NationalIDNumber 
            ,[BirthDate] = @BirthDate 
            ,[MaritalStatus] = @MaritalStatus 
            ,[Gender] = @Gender 
        WHERE [BusinessEntityID] = @BusinessEntityID;
    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;
-- ----------------------------------------------------------------------------

-- ============================================================================
-- STATEMENT 2: Find All Authors with Embedded SQL
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Numbers: 184
-- Method: FindAllAuthorsEmbeddedSql
-- Statement Type: SELECT Query
-- Description: Retrieves all authors from the author table with schema reference
-- Parameters: None
-- Return: List<Author> - All author records
-- Table Schema: bobsbookstore_dbo.author
-- ============================================================================

SELECT * FROM bobsbookstore_dbo.author;

-- ============================================================================
-- STATEMENT 3: Delete Author Using Stored Procedure
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Numbers: 203
-- Method: DeleteAuthorEmbeddedSql
-- Statement Type: DECLARE/EXEC Stored Procedure Call
-- Description: Calls uspDeleteAuthor stored procedure to delete an author
--              and returns rows affected
-- Parameters:
--   @BusinessEntityID (int) - The business entity ID of the author to delete
-- Return: Row count of affected records
-- ============================================================================

DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- Stored Procedure Definition (uspDeleteAuthor):
-- ----------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[uspDeleteAuthor]
    @BusinessEntityID [int]
WITH EXECUTE AS CALLER
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DELETE FROM [dbo].[Author]
        WHERE [BusinessEntityID] = @BusinessEntityID;

        -- Check if the delete was successful
        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('No author found with the provided BusinessEntityID.', 16, 1);
            RETURN;
        END
    END TRY
    BEGIN CATCH
        -- Log the error and re-throw
        EXECUTE [dbo].[uspLogError];
        THROW;
    END CATCH;
END;
-- ----------------------------------------------------------------------------

-- ============================================================================
-- STATEMENT 4: Select Authors by Hire Year with Complex Functions
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Numbers: 221
-- Method: SelectAuthorsByHireYear
-- Statement Type: SELECT Query with SQL Server-specific functions
-- Description: Selects authors hired in a specific year with formatted dates
--              and calculated age. Uses FORMAT, DATEDIFF, GETDATE, DATEPART
-- Parameters:
--   @HireDate (int) - The hire year to filter by
-- Return: List<AuthorAgeResult> - Business ID, formatted modified date, and age
-- SQL Server Specific Functions:
--   - FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') - Formats date as string
--   - DATEDIFF(YEAR, BirthDate, GETDATE()) - Calculates age in years
--   - GETDATE() - Returns current date/time
--   - DATEPART(YEAR, HireDate) - Extracts year from HireDate
-- Table Schema: bobsbookstore_dbo.author
-- ============================================================================

SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- ============================================================================
-- STATEMENT 5: Get Product Data Using Stored Procedure
-- ============================================================================
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Line Numbers: 31
-- Method: FindAllProducts
-- Statement Type: EXEC Stored Procedure Call
-- Description: Calls uspGetProductData stored procedure to retrieve product data
-- Parameters: None (stored procedure uses OUTPUT cursor parameter)
-- Return: List<Product> - All product records
-- Note: This stored procedure uses SQL Server cursor syntax which needs
--       significant conversion for PostgreSQL
-- ============================================================================

EXEC [dbo].[uspGetProductData];

-- Stored Procedure Definition (uspGetProductData):
-- ----------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[uspGetProductData]
    @my_cursor CURSOR VARYING OUTPUT
AS
BEGIN
    -- Open a cursor for the SELECT query
    SET @my_cursor = CURSOR FOR
    SELECT
        ProductID,
        Name,
        ProductNumber,
        SafetyStockLevel
    FROM dbo.Product;
    -- Open the cursor to make it available to the caller
    OPEN @my_cursor;
END;
-- ----------------------------------------------------------------------------

-- ============================================================================
-- EXTRACTION SUMMARY
-- ============================================================================
-- Total SQL Statements Identified: 5
-- Files with SQL Statements: 2
--   1. app/Bookstore.Web/Controllers/AuthorsController.cs (4 statements)
--   2. app/Bookstore.Web/Controllers/ProductsController.cs (1 statement)
-- 
-- Stored Procedures Referenced: 3
--   1. uspUpdateAuthorPersonalInfo (UPDATE operation)
--   2. uspDeleteAuthor (DELETE operation)
--   3. uspGetProductData (SELECT with cursor - complex conversion needed)
--
-- SQL Server Specific Constructs to Convert:
--   - DECLARE variable syntax
--   - EXEC stored procedure with return value assignment
--   - FORMAT() function
--   - DATEDIFF() function
--   - GETDATE() function
--   - DATEPART() function
--   - @@ROWCOUNT system variable
--   - CURSOR syntax (OUTPUT parameter)
--   - RAISERROR statement
--   - BEGIN TRY...END TRY / BEGIN CATCH...END CATCH blocks
--   - SET NOCOUNT ON
--   - THROW statement
--
-- Schema References:
--   - [dbo] schema (SQL Server) -> bobsbookstore_dbo schema (PostgreSQL)
--   - Note: ApplicationDbContext already configured for bobsbookstore_dbo schema
-- ============================================================================
