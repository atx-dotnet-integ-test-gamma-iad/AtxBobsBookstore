-- Extracted SQL Statements Catalog
-- Generated as part of MS SQL Server to PostgreSQL migration
-- All statements were extracted from source code and DB files, then passed through DMS MCP tool
-- DMS Re-attempt: 2026-03-23 - All statements re-processed with database_name=BobsUsedBookStore
-- 9 of 11 statements successfully converted by DMS; 2 failed (DECLARE/EXEC compound + CREATE PROCEDURE)

-- ====================================================================================
-- SECTION 1: APPLICATION CODE SQL STATEMENTS (5 statements)
-- ====================================================================================

-- ============================================================================
-- Statement 1: AuthorsController.cs, EditUsingStoredProcedure method (line ~165)
-- Type: Stored Procedure Call (DECLARE/EXEC pattern)
-- Original DMS Attempt (compound): FAILED - "Statement definition is not valid"
-- Simplified EXEC Attempt: SUCCESS (Timestamp: 2026-03-23T04:06:09.447081)
-- ============================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- ============================================================================
-- Statement 2: AuthorsController.cs, FindAllAuthorsEmbeddedSql method (line ~189)
-- Type: Simple SELECT
-- DMS Attempt: SUCCESS (Timestamp: 2026-03-23T04:04:11.103013)
-- ============================================================================
SELECT * FROM dbo.Author

-- ============================================================================
-- Statement 3: AuthorsController.cs, DeleteAuthorEmbeddedSql method (line ~212)
-- Type: Stored Procedure Call (DECLARE/EXEC pattern)
-- Original DMS Attempt (compound): FAILED - "Statement definition is not valid"
-- Simplified EXEC Attempt: SUCCESS (Timestamp: 2026-03-23T04:07:43.441412)
-- ============================================================================
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- ============================================================================
-- Statement 4: AuthorsController.cs, SelectAuthorsByHireYear method (line ~232)
-- Type: Complex SELECT with SQL Server functions (CONVERT, DATEDIFF, GETDATE, YEAR)
-- DMS Attempt: SUCCESS (Timestamp: 2026-03-23T04:09:16.305372)
-- ============================================================================
SELECT BusinessEntityID, CONVERT(VARCHAR(20), ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM dbo.Author WHERE YEAR(HireDate) = @HireDate

-- ============================================================================
-- Statement 5: ProductsController.cs, FindAllProducts method (line ~36)
-- Type: Stored Procedure Call (EXEC)
-- DMS Attempt: SUCCESS (Timestamp: 2026-03-23T04:10:49.609329)
-- ============================================================================
EXEC [dbo].[uspGetProductData];

-- ====================================================================================
-- SECTION 2: DATABASE SCHEMA FILE STATEMENTS (Key representative statements)
-- ====================================================================================

-- ============================================================================
-- Statement 6: db/bobsusedbooks.sql - CREATE TABLE Members
-- Type: CREATE TABLE (DDL)
-- DMS Attempt: SUCCESS (Timestamp: 2026-03-23T04:12:23.598038)
-- ============================================================================
CREATE TABLE [dbo].[Members](
	[CustomerID] [int] NOT NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[Email] [nvarchar](100) NULL,
	[Phone] [nvarchar](20) NULL,
	[RegistrationDate] [date] NULL,
	[TotalOrderSum] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED ([CustomerID] ASC)
) ON [PRIMARY]

-- ============================================================================
-- Statement 7: db/bobsusedbooks.sql - CREATE TABLE Author
-- Type: CREATE TABLE (DDL)
-- DMS Attempt: SUCCESS (Timestamp: 2026-03-23T04:13:58.437487)
-- ============================================================================
CREATE TABLE [dbo].[Author](
	[BusinessEntityID] [int] IDENTITY(1,1) NOT NULL,
	[NationalIDNumber] [nvarchar](15) NOT NULL,
	[LoginID] [nvarchar](256) NOT NULL,
	[OrganizationNode] [nvarchar](50) NULL,
	[JobTitle] [nvarchar](50) NOT NULL,
	[BirthDate] [date] NOT NULL,
	[MaritalStatus] [nchar](1) NOT NULL,
	[Gender] [nchar](1) NOT NULL,
	[HireDate] [date] NOT NULL,
	[VacationHours] [smallint] NOT NULL,
	[CurrentFlag] [bit] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Author_BusinessEntityID] PRIMARY KEY CLUSTERED ([BusinessEntityID] ASC)
) ON [PRIMARY]

-- ============================================================================
-- Statement 8: db/adven.sql - CREATE PROCEDURE uspUpdateAuthorPersonalInfo
-- Type: Stored Procedure (DDL)
-- DMS Attempt: FAILED - "Statement definition is not valid" (Timestamp: 2026-03-23T04:15:33.514931)
-- ============================================================================
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

-- ============================================================================
-- Statement 9: db/adven-data.sql - INSERT INTO Author
-- Type: INSERT (DML)
-- DMS Attempt: SUCCESS (Timestamp: 2026-03-23T04:15:59.582564)
-- ============================================================================
INSERT INTO [dbo].[Author] ([BusinessEntityID], [NationalIDNumber], [LoginID], [OrganizationNode], [JobTitle], [BirthDate], [MaritalStatus], [Gender], [HireDate], [VacationHours], [CurrentFlag], [ModifiedDate]) VALUES (1, N'295847284', N'adventure-works\ken0', N'/', N'Chief Executive Officer', CAST(N'1969-01-29' AS Date), N'S', N'M', CAST(N'2009-01-14' AS Date), 99, 1, CAST(N'2014-06-30T00:00:00.000' AS DateTime))

-- ============================================================================
-- Statement 10: db/adven.sql - CREATE VIEW VwTopMembers
-- Type: CREATE VIEW (DDL)
-- DMS Attempt: SUCCESS (Timestamp: 2026-03-23T04:17:32.871488)
-- ============================================================================
CREATE VIEW [dbo].[VwTopMembers] AS SELECT TOP 3 m.CustomerID, m.FirstName, m.LastName, SUM(s.TotalAmount) AS TotalSpent FROM [dbo].[Members] m JOIN [dbo].[Shopping] s ON m.CustomerID = s.CustomerID GROUP BY m.CustomerID, m.FirstName, m.LastName ORDER BY TotalSpent DESC

-- ============================================================================
-- Statement 11: db/adven.sql - SELECT from Product
-- Type: SELECT (DML)
-- DMS Attempt: SUCCESS (Timestamp: 2026-03-23T04:19:04.552005)
-- ============================================================================
SELECT ProductID, Name, ProductNumber, SafetyStockLevel FROM dbo.Product
