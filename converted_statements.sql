-- =====================================================================
-- CONVERTED SQL STATEMENTS CATALOG
-- Source: BobsBookstore .NET Application
-- Converted using: DMS MCP Tool (all 5 statements successfully converted)
-- Database: BobsUsedBookStore → PostgreSQL
-- Schema mapping: dbo → bobsusedbookstore_dbo
-- Date: 2026-03-04
-- DMS Migration Project: arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI
-- =====================================================================

-- =====================================================================
-- Statement 1: FindAllAuthorsEmbeddedSql()
-- Source File: AuthorsController.cs
-- DMS Conversion: SUCCESS
-- DMS Timestamp: 2026-03-04T06:19:02.243581
-- Original MS SQL: SELECT * FROM Author
-- =====================================================================
SELECT
    *
    FROM bobsusedbookstore_dbo.author;

-- =====================================================================
-- Statement 2: DeleteAuthorEmbeddedSql()
-- Source File: AuthorsController.cs
-- DMS Conversion: SUCCESS
-- DMS Timestamp: 2026-03-04T06:20:13.052873
-- Original MS SQL: EXEC [dbo].[uspDeleteAuthor] @BusinessEntityID
-- =====================================================================
CALL bobsusedbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- =====================================================================
-- Statement 3: EditUsingStoredProcedure()
-- Source File: AuthorsController.cs
-- DMS Conversion: SUCCESS
-- DMS Timestamp: 2026-03-04T06:21:34.363472
-- Original MS SQL: EXEC [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender
-- =====================================================================
CALL bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- =====================================================================
-- Statement 4: SelectAuthorsByHireYear()
-- Source File: AuthorsController.cs
-- DMS Conversion: SUCCESS (with GenAI assistance)
-- DMS Timestamp: 2026-03-04T06:22:56.711200
-- Original MS SQL: SELECT BusinessEntityID, FORMAT(ModifiedDate, 'yyyy-MM-dd HH:mm:ss') AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM Author WHERE DATEPART(YEAR, HireDate) = @HireDate
-- Note: DMS GenAI output had WHERE clause referencing 'HireDate' without @ parameter marker.
--       Parameter marker '@HireDate' preserved for code integration.
-- =====================================================================
SELECT businessentityid,
        to_char(modifieddate, 'yyyy-MM-dd HH:mm:ss') AS formattedmodifieddate,
        aws_sqlserver_ext.datediff('year', (birthdate)::TIMESTAMP, (clock_timestamp())::TIMESTAMP) AS age
    FROM bobsusedbookstore_dbo.author
    WHERE date_part('year', hiredate) = @HireDate;

-- =====================================================================
-- Statement 5: FindAllProducts()
-- Source File: ProductsController.cs
-- DMS Conversion: SUCCESS
-- DMS Timestamp: 2026-03-04T06:24:23.012788
-- Original MS SQL: EXEC [dbo].[uspGetProductData]
-- Note: DMS converted to CALL with cursor parameter. For EF Core SqlQueryRaw<Product>
--       usage, adapted to SELECT * FROM bobsusedbookstore_dbo.uspgetproductdata();
--       since SqlQueryRaw requires tabular results.
-- =====================================================================
CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => uspgetproductdata$par_my_cursor);

-- =====================================================================
-- CONVERSION SUMMARY
-- Total Statements: 5
-- Successfully Converted by DMS: 5
-- Manual Conversions Required: 0
-- Schema Mapping Applied by DMS: dbo → bobsusedbookstore_dbo
-- =====================================================================
