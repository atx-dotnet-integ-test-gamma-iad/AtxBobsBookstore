-- ============================================================
-- EXTRACTED SQL STATEMENTS CATALOG
-- Original MS SQL Server statements extracted from the codebase
-- Migration: SQL Server to PostgreSQL
-- ============================================================

-- ============================================================
-- SOURCE: app/Bookstore.Web/Controllers/AuthorsController.cs
-- ============================================================

-- Statement 1: EditUsingStoredProcedure method (line 165)
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;

-- Statement 2: FindAllAuthorsEmbeddedSql method (line 189)
SELECT * FROM bobsbookstore_dbo.author

-- Statement 3: DeleteAuthorEmbeddedSql method (line 212)
DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;

-- Statement 4: SelectAuthorsByHireYear method (line 232)
SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, BirthDate))::INTEGER AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = @HireDate;

-- ============================================================
-- SOURCE: app/Bookstore.Web/Controllers/ProductsController.cs
-- ============================================================

-- Statement 5: FindAllProducts method (line 36)
EXEC [dbo].[uspGetProductData];

-- ============================================================
-- SOURCE: db/adven.sql - Representative Key Statements
-- ============================================================

-- Statement 6: CREATE TABLE Author
CREATE TABLE [dbo].[Author](
[BusinessEntityID] INT IDENTITY(1, 1) NOT NULL,
[NationalIDNumber] nvarchar(15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LoginID] nvarchar(256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OrganizationNode] nvarchar(50) NULL,
[JobTitle] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BirthDate] date NOT NULL,
[MaritalStatus] nchar(1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Gender] nchar(1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[HireDate] date NOT NULL,
[VacationHours] smallint NOT NULL DEFAULT ((0)),
[CurrentFlag] Flag NOT NULL DEFAULT ((1)),
[ModifiedDate] datetime NOT NULL DEFAULT (getdate())
)
ON [PRIMARY];

-- Statement 7: CREATE TABLE Product
CREATE TABLE [dbo].[Product](
[ProductID] int IDENTITY(1, 1) NOT NULL,
[Name] Name NOT NULL,
[ProductNumber] nvarchar(25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MakeFlag] Flag NOT NULL DEFAULT ((1)),
[FinishedGoodsFlag] Flag NOT NULL DEFAULT ((1)),
[Color] nvarchar(15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SafetyStockLevel] smallint NOT NULL,
[ReorderPoint] smallint NOT NULL,
[StandardCost] money NOT NULL,
[ListPrice] money NOT NULL,
[Size] nvarchar(5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SizeUnitMeasureCode] nchar(3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WeightUnitMeasureCode] nchar(3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Weight] decimal(8,2) NULL,
[DaysToManufacture] int NOT NULL,
[ProductLine] nchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Class] nchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Style] nchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductSubcategoryID] int NULL,
[ProductModelID] int NULL,
[SellStartDate] datetime NOT NULL,
[SellEndDate] datetime NULL,
[DiscontinuedDate] datetime NULL,
[rowguid] uniqueidentifier ROWGUIDCOL NOT NULL DEFAULT (newid()),
[ModifiedDate] datetime NOT NULL DEFAULT (getdate())
)
ON [PRIMARY];

-- Statement 8: CREATE TABLE Members
CREATE TABLE [dbo].[Members](
    [MemberID] INT IDENTITY(1,1) PRIMARY KEY,
    [FirstName] NVARCHAR(50) NOT NULL,
    [LastName] NVARCHAR(50) NOT NULL,
    [Email] NVARCHAR(100),
    [MembershipLevel] NVARCHAR(20) DEFAULT 'Basic',
    [JoinDate] DATETIME DEFAULT GETDATE(),
    [IsActive] BIT DEFAULT 1,
    [PhoneNumber] NVARCHAR(20),
    [City] NVARCHAR(50),
    [State] NVARCHAR(50)
);

-- Statement 9: CREATE PROCEDURE uspGetProductData
CREATE PROCEDURE [dbo].[uspGetProductData]
AS
SET NOCOUNT ON;
SELECT * FROM [dbo].[Product];

-- Statement 10: CREATE PROCEDURE uspUpdateAuthorPersonalInfo
CREATE PROCEDURE [dbo].[uspUpdateAuthorPersonalInfo]
    @BusinessEntityID [int], 
    @NationalIDNumber [nvarchar](15), 
    @BirthDate [datetime], 
    @MaritalStatus [nchar](1), 
    @Gender [nchar](1)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [dbo].[Author] 
    SET [NationalIDNumber] = @NationalIDNumber, 
        [BirthDate] = @BirthDate, 
        [MaritalStatus] = @MaritalStatus, 
        [Gender] = @Gender, 
        [ModifiedDate] = GETDATE() 
    WHERE [BusinessEntityID] = @BusinessEntityID;
END;

-- Statement 11: CREATE PROCEDURE uspDeleteAuthor
CREATE PROCEDURE [dbo].[uspDeleteAuthor]
    @BusinessEntityID [int]
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM [dbo].[Author] 
    WHERE [BusinessEntityID] = @BusinessEntityID;
END;

-- Statement 12: CREATE FUNCTION ufnGetAccountingEndDate
CREATE FUNCTION [dbo].[ufnGetAccountingEndDate]()
RETURNS [datetime]
AS 
BEGIN
    RETURN DATEADD(month, 13, '20040601');
END;

-- Statement 13: CREATE VIEW VwTopMembers
CREATE VIEW [dbo].[VwTopMembers] AS
SELECT 
    m.MemberID,
    m.FirstName,
    m.LastName,
    m.Email,
    m.MembershipLevel,
    m.JoinDate,
    ISNULL(SUM(s.TotalAmount), 0) AS TotalSpent
FROM [dbo].[Members] m
LEFT JOIN [dbo].[Shopping] s ON m.MemberID = s.MemberID
GROUP BY m.MemberID, m.FirstName, m.LastName, m.Email, m.MembershipLevel, m.JoinDate
HAVING ISNULL(SUM(s.TotalAmount), 0) > 100;

-- ============================================================
-- SOURCE: db/adven-data.sql - Representative Key Statements
-- ============================================================

-- Statement 14: INSERT INTO Author (representative sample)
INSERT INTO [dbo].[Author] (
    [NationalIDNumber], [LoginID], [OrganizationNode],
    [JobTitle], [BirthDate], [MaritalStatus], [Gender],
    [HireDate], [VacationHours], [CurrentFlag],
    [ModifiedDate]    
) VALUES
    (N'295847284', N'adventure-works\ken0', NULL, N'Chief Executive Officer', '1969-01-29', N'S', N'M', '2009-01-14',99,1, '2014-06-30');

-- Statement 15: INSERT INTO Product (with SET IDENTITY_INSERT)
SET IDENTITY_INSERT [dbo].[Product] ON;
INSERT INTO [dbo].[Product] ([ProductID], [Name], [ProductNumber], [MakeFlag], [FinishedGoodsFlag], [Color], [SafetyStockLevel], [ReorderPoint], [StandardCost], [ListPrice], [Size], [SizeUnitMeasureCode], [WeightUnitMeasureCode], [Weight], [DaysToManufacture], [ProductLine], [Class], [Style], [ProductSubcategoryID], [ProductModelID], [SellStartDate], [SellEndDate], [DiscontinuedDate], [rowguid], [ModifiedDate])
VALUES (1, N'Adjustable Race', N'AR-5381', 0, 0, NULL, 1000, 750, 0.00, 0.00, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '2008-04-30 00:00:00.000', NULL, NULL, '694215B7-08F7-4C0D-ACB1-D734BA44C0C8', '2014-02-08 10:01:36.827');

-- ============================================================
-- SOURCE: db/bobsusedbooks.sql - Representative Key Statements
-- ============================================================

-- Statement 16: CREATE TABLE Coupons (from bobsusedbooks.sql)
CREATE TABLE [dbo].[Coupons](
    [CouponID] INT IDENTITY(1,1) PRIMARY KEY,
    [CouponCode] NVARCHAR(20) NOT NULL,
    [DiscountPercent] DECIMAL(5,2) NOT NULL,
    [StartDate] DATETIME NOT NULL,
    [EndDate] DATETIME NOT NULL,
    [MaxUsageCount] INT DEFAULT 100,
    [CurrentUsageCount] INT DEFAULT 0,
    [MinimumPurchaseAmount] DECIMAL(10,2) DEFAULT 0,
    [IsActive] BIT DEFAULT 1,
    [Description] NVARCHAR(200),
    [CreatedDate] DATETIME DEFAULT GETDATE()
);

-- Statement 17: CREATE VIEW VwOpenCoupons
CREATE VIEW [dbo].[VwOpenCoupons] AS
SELECT 
    c.CouponID,
    c.CouponCode,
    c.DiscountPercent,
    c.StartDate,
    c.EndDate,
    c.MaxUsageCount,
    c.CurrentUsageCount,
    (c.MaxUsageCount - c.CurrentUsageCount) AS RemainingUses,
    c.MinimumPurchaseAmount,
    c.Description
FROM [dbo].[Coupons] c
WHERE c.IsActive = 1 
AND c.EndDate >= GETDATE() 
AND c.CurrentUsageCount < c.MaxUsageCount;

-- Statement 18: CREATE PROCEDURE uspGetTopRegion
CREATE PROCEDURE [dbo].[uspGetTopRegion]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1 
        RegionName, 
        SUM(SaleAmount) AS TotalSales 
    FROM [dbo].[ProductSales] ps
    JOIN [dbo].[ProductSaleRegions] psr ON ps.RegionID = psr.RegionID
    GROUP BY RegionName
    ORDER BY TotalSales DESC;
END;

-- Statement 19: CREATE FUNCTION ufnCalculateCustomerLifetimeValue
CREATE FUNCTION [dbo].[ufnCalculateCustomerLifetimeValue](@MemberID INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @LifetimeValue DECIMAL(18,2);
    SELECT @LifetimeValue = ISNULL(SUM(TotalAmount), 0)
    FROM [dbo].[Shopping]
    WHERE MemberID = @MemberID;
    RETURN @LifetimeValue;
END;

-- Statement 20: CREATE VIEW VwRegionalSales
CREATE VIEW [dbo].[VwRegionalSales] ([RegionName], [RegionSalesSum]) AS
SELECT 
    psr.RegionName,
    SUM(ps.SaleAmount) AS RegionSalesSum
FROM [dbo].[ProductSales] ps
JOIN [dbo].[ProductSaleRegions] psr ON ps.RegionID = psr.RegionID
GROUP BY psr.RegionName;
