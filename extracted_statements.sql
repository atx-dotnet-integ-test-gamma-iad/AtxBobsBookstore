-- ===================================================================
-- EXTRACTED SQL STATEMENTS - Original MS SQL Server Statements
-- Source: BobsBookstore .NET Application
-- Date: 2026-03-23
-- Total Application Statements: 5
-- Total Database Script Statements: 11
-- Grand Total: 16
-- ===================================================================
-- DMS Tool Attempted: YES (all 16 statements)
-- DMS Tool Result: ALL FAILED - Metadata model creation failed
-- DMS Error: "No objects were found according to the specified selection rules."
-- Fallback: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- ===================================================================

-- ===================================================================
-- SECTION 1: APPLICATION CODE SQL STATEMENTS (5)
-- ===================================================================

-- Statement 1: AuthorsController.cs - EditUsingStoredProcedure method
-- Type: Stored Procedure Call with DECLARE/EXEC pattern
-- DMS Attempt Timestamp: 2026-03-23T07:31:19
-- DMS Result: ERROR - Metadata model creation failed
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement 2: AuthorsController.cs - FindAllAuthorsEmbeddedSql method
-- Type: SELECT query
-- DMS Attempt Timestamp: 2026-03-23T07:31:43
-- DMS Result: ERROR - Metadata model creation failed
SELECT * FROM bobsbookstore_dbo.author

-- Statement 3: AuthorsController.cs - DeleteAuthorEmbeddedSql method
-- Type: Stored Procedure Call with DECLARE/EXEC pattern
-- DMS Attempt Timestamp: 2026-03-23T07:32:06
-- DMS Result: ERROR - Metadata model creation failed
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement 4: AuthorsController.cs - SelectAuthorsByHireYear method
-- Type: SELECT query with TO_CHAR, EXTRACT, AGE functions
-- DMS Attempt Timestamp: 2026-03-23T07:32:30
-- DMS Result: ERROR - Metadata model creation failed
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate))::INTEGER AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- Statement 5: ProductsController.cs - FindAllProducts method
-- Type: Stored Procedure Call with EXEC
-- DMS Attempt Timestamp: 2026-03-23T07:32:52
-- DMS Result: ERROR - Metadata model creation failed
EXEC [dbo].[uspGetProductData];

-- ===================================================================
-- SECTION 2: DATABASE SCRIPT SQL STATEMENTS (11)
-- ===================================================================

-- Statement 6: db/adven.sql - CREATE TABLE Author
-- DMS Attempt Timestamp: 2026-03-23T07:33:19
-- DMS Result: ERROR - Metadata model creation failed
CREATE TABLE [dbo].[Author]([BusinessEntityID] INT IDENTITY(1, 1) NOT NULL, [NationalIDNumber] nvarchar(15) NOT NULL, [LoginID] nvarchar(256) NOT NULL, [JobTitle] nvarchar(50) NOT NULL, [BirthDate] date NOT NULL, [MaritalStatus] nchar(1) NOT NULL, [Gender] nchar(1) NOT NULL, [HireDate] date NOT NULL, [VacationHours] smallint NOT NULL DEFAULT ((0)), [ModifiedDate] datetime NOT NULL DEFAULT (getdate()));

-- Statement 7: db/adven.sql - CREATE TABLE Product
-- DMS Attempt Timestamp: 2026-03-23T07:33:42
-- DMS Result: ERROR - Metadata model creation failed
CREATE TABLE [dbo].[Product]([ProductID] int IDENTITY(1, 1) NOT NULL, [Name] Name NOT NULL, [ProductNumber] nvarchar(25) NOT NULL, [SafetyStockLevel] smallint NOT NULL, [StandardCost] money NOT NULL, [ListPrice] money NOT NULL);

-- Statement 8: db/adven.sql - CREATE PROCEDURE uspUpdateAuthorPersonalInfo
-- DMS Attempt Timestamp: 2026-03-23T07:34:06
-- DMS Result: ERROR - Metadata model creation failed
CREATE PROCEDURE [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID [int], @NationalIDNumber [nvarchar](15), @BirthDate [datetime], @MaritalStatus [nchar](1), @Gender [nchar](1) WITH EXECUTE AS CALLER AS BEGIN SET NOCOUNT ON; UPDATE [dbo].[Author] SET [NationalIDNumber] = @NationalIDNumber, [BirthDate] = @BirthDate, [MaritalStatus] = @MaritalStatus, [Gender] = @Gender WHERE [BusinessEntityID] = @BusinessEntityID; END;

-- Statement 9: db/adven.sql - CREATE PROCEDURE uspDeleteAuthor
-- DMS Attempt Timestamp: 2026-03-23T07:34:29
-- DMS Result: ERROR - Metadata model creation failed
CREATE PROCEDURE [dbo].[uspDeleteAuthor] @BusinessEntityID [int] WITH EXECUTE AS CALLER AS BEGIN SET NOCOUNT ON; DELETE FROM [dbo].[Author] WHERE [BusinessEntityID] = @BusinessEntityID; IF @@ROWCOUNT = 0 BEGIN RAISERROR('No author found', 16, 1); RETURN; END END;

-- Statement 10: db/adven.sql - CREATE PROCEDURE uspGetProductData
-- DMS Attempt Timestamp: 2026-03-23T07:34:54
-- DMS Result: ERROR - Metadata model creation failed
CREATE PROCEDURE [dbo].[uspGetProductData] @my_cursor CURSOR VARYING OUTPUT AS BEGIN SET @my_cursor = CURSOR FOR SELECT ProductID, Name, ProductNumber, SafetyStockLevel FROM dbo.Product; OPEN @my_cursor; END;

-- Statement 11: db/adven.sql - CREATE VIEW VwTopMembers
-- DMS Attempt Timestamp: 2026-03-23T07:35:20
-- DMS Result: ERROR - Metadata model creation failed
CREATE VIEW [dbo].[VwTopMembers] AS SELECT * FROM (SELECT TOP 50 PERCENT c.[CustomerID], c.[FirstName], c.[LastName], SUM(o.[TotalAmount]) AS [TotalSpent] FROM [dbo].[Members] c JOIN [dbo].[Shopping] o ON c.[CustomerID] = o.[CustomerID] GROUP BY c.[CustomerID], c.[FirstName], c.[LastName] ORDER BY [TotalSpent] DESC) sub;

-- Statement 12: db/adven.sql - CREATE FUNCTION ufnGetAccountingEndDate
-- DMS Attempt Timestamp: 2026-03-23T07:35:43
-- DMS Result: ERROR - Metadata model creation failed
CREATE FUNCTION [dbo].[ufnGetAccountingEndDate]() RETURNS [datetime] AS BEGIN RETURN DATEADD(millisecond, -2, CONVERT(datetime, '20040701', 112)); END;

-- Statement 13: db/adven.sql - CREATE PROCEDURE uspGetBillOfMaterials
-- DMS Attempt Timestamp: 2026-03-23T07:36:09
-- DMS Result: ERROR - Metadata model creation failed
CREATE PROCEDURE [dbo].[uspGetBillOfMaterials] @StartProductID [int], @CheckDate [datetime] AS BEGIN SET NOCOUNT ON; WITH [BOM_cte]([ProductAssemblyID], [ComponentID], [ComponentDesc], [PerAssemblyQty], [StandardCost], [ListPrice], [BOMLevel], [RecursionLevel]) AS (SELECT b.[ProductAssemblyID], b.[ComponentID], p.[Name], b.[PerAssemblyQty], p.[StandardCost], p.[ListPrice], b.[BOMLevel], 0 FROM [dbo].[BillOfMaterials] b INNER JOIN [dbo].[Product] p ON b.[ComponentID] = p.[ProductID] WHERE b.[ProductAssemblyID] = @StartProductID AND @CheckDate >= b.[StartDate] AND @CheckDate <= ISNULL(b.[EndDate], @CheckDate)) SELECT b.[ProductAssemblyID], b.[ComponentID], b.[ComponentDesc], SUM(b.[PerAssemblyQty]) AS [TotalQuantity], b.[StandardCost], b.[ListPrice], b.[BOMLevel], b.[RecursionLevel] FROM [BOM_cte] b GROUP BY b.[ComponentID], b.[ComponentDesc], b.[ProductAssemblyID], b.[BOMLevel], b.[RecursionLevel], b.[StandardCost], b.[ListPrice] ORDER BY b.[BOMLevel], b.[ProductAssemblyID], b.[ComponentID]; END;

-- Statement 14: db/adven-data.sql - INSERT INTO Author (sample row)
-- DMS Attempt Timestamp: 2026-03-23T07:36:34
-- DMS Result: ERROR - Metadata model creation failed
INSERT INTO [dbo].[Author] ([NationalIDNumber], [LoginID], [OrganizationNode], [JobTitle], [BirthDate], [MaritalStatus], [Gender], [HireDate], [VacationHours], [CurrentFlag], [ModifiedDate]) VALUES (N'295847284', N'adventure-works\ken0', NULL, N'Chief Executive Officer', '1969-01-29', N'S', N'M', '2009-01-14', 99, 1, '2014-06-30');

-- Statement 15: db/bobsusedbooks.sql - Full database script
-- Note: Full script too large for individual DMS call; representative statements attempted
-- DMS Result: ERROR - Metadata model creation failed (all individual attempts)
db/bobsusedbooks.sql - Full database script with CREATE TABLE, INSERT, stored procedure definitions embedded in DatabaseLog inserts

-- Statement 16: db/adven-data.sql - All INSERT data statements
-- Note: Full data script too large for individual DMS call; representative INSERT attempted
-- DMS Result: ERROR - Metadata model creation failed
db/adven-data.sql - INSERT data statements for Author, Person, BillOfMaterials, Product, Members, Shopping, Coupons, ProductSaleRegions, ProductSales tables
