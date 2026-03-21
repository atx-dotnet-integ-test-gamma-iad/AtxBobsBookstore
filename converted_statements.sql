-- ============================================================
-- CONVERTED SQL STATEMENTS CATALOG
-- Converted PostgreSQL statements
-- Migration: SQL Server to PostgreSQL
-- ============================================================

-- ============================================================
-- SOURCE: app/Bookstore.Web/Controllers/AuthorsController.cs
-- ============================================================

-- Statement 1: EditUsingStoredProcedure method - Converted from EXEC to SELECT function call
SELECT dbo.uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);

-- Statement 2: FindAllAuthorsEmbeddedSql method - Already PostgreSQL compatible (lowercase)
SELECT * FROM bobsbookstore_dbo.author

-- Statement 3: DeleteAuthorEmbeddedSql method - Converted from EXEC to SELECT function call
SELECT dbo.uspdeleteauthor(@BusinessEntityID);

-- Statement 4: SelectAuthorsByHireYear method - Column names lowercased
SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;

-- ============================================================
-- SOURCE: app/Bookstore.Web/Controllers/ProductsController.cs
-- ============================================================

-- Statement 5: FindAllProducts method - Converted from EXEC to SELECT from function
SELECT * FROM dbo.uspgetproductdata();

-- ============================================================
-- SOURCE: db/adven.sql - Converted Key Statements
-- ============================================================

-- Statement 6: CREATE TABLE author (converted from Author)
CREATE TABLE dbo.author(
businessentityid INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
nationalidnumber varchar(15) NOT NULL,
loginid varchar(256) NOT NULL,
organizationnode varchar(50) NULL,
jobtitle varchar(50) NOT NULL,
birthdate date NOT NULL,
maritalstatus char(1) NOT NULL,
gender char(1) NOT NULL,
hiredate date NOT NULL,
vacationhours smallint NOT NULL DEFAULT ((0)),
currentflag boolean NOT NULL DEFAULT ((1)),
modifieddate timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Statement 7: CREATE TABLE product (converted from Product)
CREATE TABLE dbo.product(
productid int GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL,
name varchar(100) NOT NULL,
productnumber varchar(25) NOT NULL,
makeflag boolean NOT NULL DEFAULT ((1)),
finishedgoodsflag boolean NOT NULL DEFAULT ((1)),
color varchar(15) NULL,
safetystocklevel smallint NOT NULL,
reorderpoint smallint NOT NULL,
standardcost numeric(19,4) NOT NULL,
listprice numeric(19,4) NOT NULL,
size varchar(5) NULL,
sizeunitmeasurecode char(3) NULL,
weightunitmeasurecode char(3) NULL,
weight decimal(8,2) NULL,
daystomanufacture int NOT NULL,
productline char(2) NULL,
class char(2) NULL,
style char(2) NULL,
productsubcategoryid int NULL,
productmodelid int NULL,
sellstartdate timestamp NOT NULL,
sellenddate timestamp NULL,
discontinueddate timestamp NULL,
rowguid uuid NOT NULL DEFAULT gen_random_uuid(),
modifieddate timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Statement 8: CREATE TABLE members (converted from Members)
CREATE TABLE dbo.members(
    memberid INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    membershiplevel VARCHAR(20) DEFAULT 'Basic',
    joindate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    isactive BOOLEAN DEFAULT 1,
    phonenumber VARCHAR(20),
    city VARCHAR(50),
    state VARCHAR(50)
);

-- Statement 9: CREATE OR REPLACE FUNCTION uspgetproductdata (converted from CREATE PROCEDURE)
CREATE OR REPLACE FUNCTION dbo.uspgetproductdata()
RETURNS SETOF dbo.product AS $$
BEGIN
    RETURN QUERY SELECT * FROM dbo.product;
END;
$$ LANGUAGE plpgsql;

-- Statement 10: CREATE OR REPLACE FUNCTION uspupdateauthorpersonalinfo (converted from CREATE PROCEDURE)
CREATE OR REPLACE FUNCTION dbo.uspupdateauthorpersonalinfo(
    p_businessentityid int, 
    p_nationalidnumber varchar(15), 
    p_birthdate timestamp, 
    p_maritalstatus char(1), 
    p_gender char(1)
) RETURNS void AS $$
BEGIN
    UPDATE dbo.author 
    SET nationalidnumber = p_nationalidnumber, 
        birthdate = p_birthdate, 
        maritalstatus = p_maritalstatus, 
        gender = p_gender, 
        modifieddate = CURRENT_TIMESTAMP 
    WHERE businessentityid = p_businessentityid;
END;
$$ LANGUAGE plpgsql;

-- Statement 11: CREATE OR REPLACE FUNCTION uspdeleteauthor (converted from CREATE PROCEDURE)
CREATE OR REPLACE FUNCTION dbo.uspdeleteauthor(
    p_businessentityid int
) RETURNS void AS $$
BEGIN
    DELETE FROM dbo.author 
    WHERE businessentityid = p_businessentityid;
END;
$$ LANGUAGE plpgsql;

-- Statement 12: CREATE OR REPLACE FUNCTION ufngetaccountingenddate (converted from CREATE FUNCTION)
CREATE OR REPLACE FUNCTION dbo.ufngetaccountingenddate()
RETURNS timestamp AS $$
BEGIN
    RETURN '20040601'::timestamp + INTERVAL '13 months';
END;
$$ LANGUAGE plpgsql;

-- Statement 13: CREATE VIEW vwtopmembers (converted from VwTopMembers)
CREATE VIEW dbo.vwtopmembers AS
SELECT 
    m.memberid,
    m.firstname,
    m.lastname,
    m.email,
    m.membershiplevel,
    m.joindate,
    COALESCE(SUM(s.totalamount), 0) AS totalspent
FROM dbo.members m
LEFT JOIN dbo.shopping s ON m.memberid = s.memberid
GROUP BY m.memberid, m.firstname, m.lastname, m.email, m.membershiplevel, m.joindate
HAVING COALESCE(SUM(s.totalamount), 0) > 100;

-- ============================================================
-- SOURCE: db/adven-data.sql - Converted Key Statements
-- ============================================================

-- Statement 14: INSERT INTO author (converted - removed N'' prefix, lowercase identifiers)
INSERT INTO dbo.author (
    nationalidnumber, loginid, organizationnode,
    jobtitle, birthdate, maritalstatus, gender,
    hiredate, vacationhours, currentflag,
    modifieddate    
) VALUES
    ('295847284', 'adventure-works\ken0', NULL, 'Chief Executive Officer', '1969-01-29', 'S', 'M', '2009-01-14',99,1, '2014-06-30');

-- Statement 15: INSERT INTO product (converted - removed SET IDENTITY_INSERT, lowercase)
INSERT INTO dbo.product (productid, name, productnumber, makeflag, finishedgoodsflag, color, safetystocklevel, reorderpoint, standardcost, listprice, size, sizeunitmeasurecode, weightunitmeasurecode, weight, daystomanufacture, productline, class, style, productsubcategoryid, productmodelid, sellstartdate, sellenddate, discontinueddate, rowguid, modifieddate)
VALUES (1, 'Adjustable Race', 'AR-5381', 0, 0, NULL, 1000, 750, 0.00, 0.00, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '2008-04-30 00:00:00.000', NULL, NULL, '694215B7-08F7-4C0D-ACB1-D734BA44C0C8', '2014-02-08 10:01:36.827');

-- ============================================================
-- SOURCE: db/bobsusedbooks.sql - Converted Key Statements
-- ============================================================

-- Statement 16: CREATE TABLE coupons (converted from Coupons)
CREATE TABLE dbo.coupons(
    couponid INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    couponcode VARCHAR(20) NOT NULL,
    discountpercent DECIMAL(5,2) NOT NULL,
    startdate TIMESTAMP NOT NULL,
    enddate TIMESTAMP NOT NULL,
    maxusagecount INT DEFAULT 100,
    currentusagecount INT DEFAULT 0,
    minimumpurchaseamount DECIMAL(10,2) DEFAULT 0,
    isactive BOOLEAN DEFAULT 1,
    description VARCHAR(200),
    createddate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Statement 17: CREATE VIEW vwopencoupons (converted from VwOpenCoupons)
CREATE VIEW dbo.vwopencoupons AS
SELECT 
    c.couponid,
    c.couponcode,
    c.discountpercent,
    c.startdate,
    c.enddate,
    c.maxusagecount,
    c.currentusagecount,
    (c.maxusagecount - c.currentusagecount) AS remaininguses,
    c.minimumpurchaseamount,
    c.description
FROM dbo.coupons c
WHERE c.isactive = true 
AND c.enddate >= CURRENT_TIMESTAMP 
AND c.currentusagecount < c.maxusagecount;

-- Statement 18: CREATE OR REPLACE FUNCTION uspgettopregion (converted from CREATE PROCEDURE)
CREATE OR REPLACE FUNCTION dbo.uspgettopregion()
RETURNS TABLE(regionname VARCHAR, totalsales NUMERIC) AS $$
BEGIN
    RETURN QUERY 
    SELECT 
        psr.regionname, 
        SUM(ps.saleamount) AS totalsales 
    FROM dbo.productsales ps
    JOIN dbo.productsaleregions psr ON ps.regionid = psr.regionid
    GROUP BY psr.regionname
    ORDER BY totalsales DESC
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;

-- Statement 19: CREATE OR REPLACE FUNCTION ufncalculatecustomerlifetimevalue (converted from scalar function)
CREATE OR REPLACE FUNCTION dbo.ufncalculatecustomerlifetimevalue(p_memberid INT)
RETURNS DECIMAL(18,2) AS $$
DECLARE
    lifetimevalue DECIMAL(18,2);
BEGIN
    SELECT COALESCE(SUM(totalamount), 0) INTO lifetimevalue
    FROM dbo.shopping
    WHERE memberid = p_memberid;
    RETURN lifetimevalue;
END;
$$ LANGUAGE plpgsql;

-- Statement 20: CREATE VIEW vwregionalsales (converted from VwRegionalSales)
CREATE VIEW dbo.vwregionalsales (regionname, regionsalessum) AS
SELECT 
    psr.regionname,
    SUM(ps.saleamount) AS regionsalessum
FROM dbo.productsales ps
JOIN dbo.productsaleregions psr ON ps.regionid = psr.regionid
GROUP BY psr.regionname;
