-- ============================================================================
-- SQL Statement Extraction Catalog
-- Purpose: Comprehensive catalog of all SQL statements extracted from codebase
-- Migration: Microsoft SQL Server to PostgreSQL
-- Date: 2025-01-30
-- ============================================================================

-- Statement 1: EditUsingStoredProcedure - Update Author Personal Info
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 162
-- Statement Type: Stored Procedure Call (Dynamic with DECLARE)
-- Context: Updates author personal information using stored procedure
-- Original SQL:
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;
SELECT @rowsAffected;

-- Parameters:
-- @BusinessEntityID (int)
-- @NationalIDNumber (string)
-- @BirthDate (DateTime)
-- @MaritalStatus (string)
-- @Gender (string)

-- ============================================================================

-- Statement 2: FindAllAuthorsEmbeddedSql - Select All Authors
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 188
-- Statement Type: Inline SQL (Simple SELECT)
-- Context: Retrieves all authors from the author table
-- Original SQL:
SELECT * FROM bobsbookstore_dbo.author

-- Parameters: None

-- ============================================================================

-- Statement 3: DeleteAuthorEmbeddedSql - Delete Author Using Stored Procedure
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 207
-- Statement Type: Stored Procedure Call (Dynamic with DECLARE)
-- Context: Deletes an author using stored procedure
-- Original SQL:
DECLARE @rowsAffected INT;
EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;
SELECT @rowsAffected;

-- Parameters:
-- @BusinessEntityID (int)

-- ============================================================================

-- Statement 4: SelectAuthorsByHireYear - Complex SELECT with Date Functions
-- Source File: app/Bookstore.Web/Controllers/AuthorsController.cs
-- Line Number: 226
-- Statement Type: Inline SQL (Complex SELECT with SQL Server functions)
-- Context: Selects authors by hire year with formatted dates and age calculation
-- SQL Server Specific Functions: FORMAT, DATEDIFF, DATEPART, GETDATE
-- Original SQL:
SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM bobsbookstore_dbo.author WHERE DATEPART(YEAR, HireDate) = @HireDate;

-- Parameters:
-- @HireDate (int) - year value

-- ============================================================================

-- Statement 5: FindAllProducts - Get Product Data Using Stored Procedure
-- Source File: app/Bookstore.Web/Controllers/ProductsController.cs
-- Line Number: 31
-- Statement Type: Stored Procedure Call (Direct EXEC)
-- Context: Retrieves all product data using stored procedure
-- Original SQL:
EXEC [dbo].[uspGetProductData];

-- Parameters: None

-- ============================================================================
-- EXTRACTION SUMMARY
-- ============================================================================
-- Total SQL Statements Identified: 5
-- Stored Procedure Calls: 3 (uspUpdateAuthorPersonalInfo, uspDeleteAuthor, uspGetProductData)
-- Simple SELECT Statements: 1 (SELECT * FROM bobsbookstore_dbo.author)
-- Complex SELECT Statements: 1 (SELECT with FORMAT, DATEDIFF, DATEPART, GETDATE)
-- Statements with Parameters: 4
-- Statements without Parameters: 1
-- ============================================================================
