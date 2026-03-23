-- Converted SQL Statements Catalog (PostgreSQL)
-- Generated as part of MS SQL Server to PostgreSQL migration
-- DMS Re-attempt: 2026-03-23 - All statements re-processed with database_name=BobsUsedBookStore
-- 9 of 11 statements successfully converted by DMS MCP tool
-- 2 statements failed DMS (compound DECLARE/EXEC + CREATE PROCEDURE) - manually converted
-- DMS maps dbo schema to bobsusedbookstore_dbo

-- ====================================================================================
-- SECTION 1: APPLICATION CODE SQL STATEMENTS (5 statements)
-- ====================================================================================

-- ============================================================================
-- Statement 1: AuthorsController.cs, EditUsingStoredProcedure method
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;
-- DMS Status: SUCCESS (simplified EXEC form) - Timestamp: 2026-03-23T04:06:09.447081
-- Conversion Method: DMS_TOOL (simplified from DECLARE/EXEC to EXEC, then converted)
-- DMS Output: CALL bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);
-- ============================================================================
CALL bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- ============================================================================
-- Statement 2: AuthorsController.cs, FindAllAuthorsEmbeddedSql method
-- Original: SELECT * FROM dbo.Author
-- DMS Status: SUCCESS - Timestamp: 2026-03-23T04:04:11.103013
-- Conversion Method: DMS_TOOL
-- ============================================================================
SELECT * FROM bobsusedbookstore_dbo.author;

-- ============================================================================
-- Statement 3: AuthorsController.cs, DeleteAuthorEmbeddedSql method
-- Original: DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;
-- DMS Status: SUCCESS (simplified EXEC form) - Timestamp: 2026-03-23T04:07:43.441412
-- Conversion Method: DMS_TOOL (simplified from DECLARE/EXEC to EXEC, then converted)
-- DMS Output: CALL bobsusedbookstore_dbo.uspdeleteauthor(@BusinessEntityID);
-- ============================================================================
CALL bobsusedbookstore_dbo.uspdeleteauthor(@BusinessEntityID);

-- ============================================================================
-- Statement 4: AuthorsController.cs, SelectAuthorsByHireYear method
-- Original: SELECT BusinessEntityID, CONVERT(VARCHAR(20), ModifiedDate, 120) AS FormattedModifiedDate, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age FROM dbo.Author WHERE YEAR(HireDate) = @HireDate
-- DMS Status: SUCCESS - Timestamp: 2026-03-23T04:09:16.305372
-- Conversion Method: DMS_TOOL
-- Note: DMS uses aws_sqlserver_ext extension functions for CONVERT and DATEDIFF
-- ============================================================================
SELECT businessentityid, aws_sqlserver_ext.conv_datetime_to_string('VARCHAR(20)', 'DATETIME', modifieddate, 120) AS formattedmodifieddate, aws_sqlserver_ext.datediff('year', birthdate::TIMESTAMP, clock_timestamp()::TIMESTAMP) AS age FROM bobsusedbookstore_dbo.author WHERE date_part('year', hiredate) = @HireDate;

-- ============================================================================
-- Statement 5: ProductsController.cs, FindAllProducts method
-- Original: EXEC [dbo].[uspGetProductData]
-- DMS Status: SUCCESS - Timestamp: 2026-03-23T04:10:49.609329
-- Conversion Method: DMS_TOOL
-- DMS Output: CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => uspgetproductdata$par_my_cursor);
-- ============================================================================
CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => uspgetproductdata$par_my_cursor);

-- ====================================================================================
-- SECTION 2: DATABASE SCHEMA FILE STATEMENTS (Key representative statements)
-- ====================================================================================

-- ============================================================================
-- Statement 6: db/bobsusedbooks.sql - CREATE TABLE Members
-- Original: CREATE TABLE [dbo].[Members](...) ON [PRIMARY]
-- DMS Status: SUCCESS - Timestamp: 2026-03-23T04:12:23.598038
-- Conversion Method: DMS_TOOL
-- ============================================================================
CREATE TABLE bobsusedbookstore_dbo.members
(customerid INTEGER NOT NULL,
    firstname VARCHAR(50) NULL,
    lastname VARCHAR(50) NULL,
    email VARCHAR(100) NULL,
    phone VARCHAR(20) NULL,
    registrationdate DATE NULL,
    totalordersum NUMERIC(10, 2) NULL,
    PRIMARY KEY (customerid
    /* ASC */));

-- ============================================================================
-- Statement 7: db/bobsusedbooks.sql - CREATE TABLE Author
-- Original: CREATE TABLE [dbo].[Author](...) ON [PRIMARY]
-- DMS Status: SUCCESS - Timestamp: 2026-03-23T04:13:58.437487
-- Conversion Method: DMS_TOOL
-- ============================================================================
CREATE TABLE bobsusedbookstore_dbo.author
(businessentityid BIGINT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
    nationalidnumber VARCHAR(15) NOT NULL,
    loginid VARCHAR(256) NOT NULL,
    organizationnode VARCHAR(50) NULL,
    jobtitle VARCHAR(50) NOT NULL,
    birthdate DATE NOT NULL,
    maritalstatus CHAR(1) NOT NULL,
    gender CHAR(1) NOT NULL,
    hiredate DATE NOT NULL,
    vacationhours SMALLINT NOT NULL,
    currentflag NUMERIC(1, 0) NOT NULL,
    modifieddate TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    CONSTRAINT PK_Author_BusinessEntityID PRIMARY KEY (businessentityid
    /* ASC */));

-- ============================================================================
-- Statement 8: db/adven.sql - CREATE PROCEDURE uspUpdateAuthorPersonalInfo
-- Original: CREATE PROCEDURE [dbo].[uspUpdateAuthorPersonalInfo]...
-- DMS Status: FAILED - "Statement definition is not valid" (Timestamp: 2026-03-23T04:15:33.514931)
-- Conversion Method: DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
-- ============================================================================
CREATE OR REPLACE FUNCTION bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(
    IN par_businessentityid integer,
    IN par_nationalidnumber varchar(15),
    IN par_birthdate timestamp,
    IN par_maritalstatus char(1),
    IN par_gender char(1)
)
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE bobsusedbookstore_dbo.author
    SET nationalidnumber = par_nationalidnumber,
        birthdate = par_birthdate,
        maritalstatus = par_maritalstatus,
        gender = par_gender
    WHERE businessentityid = par_businessentityid;
EXCEPTION
    WHEN OTHERS THEN
        PERFORM bobsusedbookstore_dbo.usplogerror();
END;
$$;

-- ============================================================================
-- Statement 9: db/adven-data.sql - INSERT INTO Author
-- Original: INSERT INTO [dbo].[Author] (...) VALUES (1, N'295847284', ...)
-- DMS Status: SUCCESS - Timestamp: 2026-03-23T04:15:59.582564
-- Conversion Method: DMS_TOOL
-- ============================================================================
INSERT INTO bobsusedbookstore_dbo.author (businessentityid, nationalidnumber, loginid, organizationnode, jobtitle, birthdate, maritalstatus, gender, hiredate, vacationhours, currentflag, modifieddate)
VALUES (1, '295847284', E'adventure-works\\ken0', '/', 'Chief Executive Officer', CAST ('1969-01-29' AS DATE), 'S', 'M', CAST ('2009-01-14' AS DATE), 99, 1, CAST ('2014-06-30T00:00:00.000' AS TIMESTAMP WITHOUT TIME ZONE));

-- ============================================================================
-- Statement 10: db/adven.sql - CREATE VIEW VwTopMembers
-- Original: CREATE VIEW [dbo].[VwTopMembers] AS SELECT TOP 3...
-- DMS Status: SUCCESS - Timestamp: 2026-03-23T04:17:32.871488
-- Conversion Method: DMS_TOOL
-- ============================================================================
CREATE VIEW bobsusedbookstore_dbo.vwtopmembers
AS
SELECT
    m.customerid, m.firstname, m.lastname, SUM(s.totalamount) AS totalspent
    FROM bobsusedbookstore_dbo.members AS m
    JOIN bobsusedbookstore_dbo.shopping AS s
        ON m.customerid = s.customerid
    GROUP BY m.customerid, m.firstname, m.lastname
    ORDER BY totalspent DESC NULLS LAST
    LIMIT 3;

-- ============================================================================
-- Statement 11: db/adven.sql - SELECT from Product
-- Original: SELECT ProductID, Name, ProductNumber, SafetyStockLevel FROM dbo.Product
-- DMS Status: SUCCESS - Timestamp: 2026-03-23T04:19:04.552005
-- Conversion Method: DMS_TOOL
-- ============================================================================
SELECT productid, name, productnumber, safetystocklevel FROM bobsusedbookstore_dbo.product;
