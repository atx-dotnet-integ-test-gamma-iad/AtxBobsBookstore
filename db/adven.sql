/*============================================================================
  File:     adven.sql
  Summary:  Creates additional tables and objects for the workshop mnsg. It comes from Microsoft AdventureWorks sample database. Run this on any version of SQL Server (2008R2 or later) to get AdventureWorks for your
  current version.  
  Date:     October 26, 2017
  Updated:  October 26, 2017
------------------------------------------------------------------------------
  This file is part of the Microsoft SQL Server Code Samples.
  Copyright (C) Microsoft Corporation.  All rights reserved.
  This source code is intended only as a supplement to Microsoft
  Development Tools and/or on-line documentation.  See these other
  materials for detailed information regarding Microsoft code samples.
  All data in this database is ficticious.
============================================================================*/
-- ------------ Write DROP-ROUTINE-stage scripts -----------
DROP FUNCTION IF EXISTS bobsusedbookstore_dbo.uspupdateauthorlogin CASCADE;
DROP FUNCTION IF EXISTS bobsusedbookstore_dbo.uspupdateauthorpersonalinfo CASCADE;
DROP FUNCTION IF EXISTS bobsusedbookstore_dbo.uspgetbillofmaterials CASCADE;
DROP FUNCTION IF EXISTS bobsusedbookstore_dbo.uspgetauthormanagers CASCADE;
DROP FUNCTION IF EXISTS bobsusedbookstore_dbo.uspgetmanagerauthors CASCADE;
DROP FUNCTION IF EXISTS bobsusedbookstore_dbo.uspgetwhereusedproductid CASCADE;
DROP FUNCTION IF EXISTS bobsusedbookstore_dbo.usplogerror CASCADE;
DROP FUNCTION IF EXISTS bobsusedbookstore_dbo.uspprinterror CASCADE;
DROP FUNCTION IF EXISTS bobsusedbookstore_dbo.uspsearchcandidateresumes CASCADE;
DROP FUNCTION IF EXISTS bobsusedbookstore_dbo.uspdeleteauthor CASCADE;
DROP FUNCTION IF EXISTS bobsusedbookstore_dbo.uspgetproductdata CASCADE;
DROP FUNCTION IF EXISTS bobsusedbookstore_dbo.ufngetaccountingenddate CASCADE;
DROP FUNCTION IF EXISTS bobsusedbookstore_dbo.ufngetaccountingstartdate CASCADE;
DROP FUNCTION IF EXISTS bobsusedbookstore_dbo.ufngetdocumentstatustext CASCADE;
DROP FUNCTION IF EXISTS bobsusedbookstore_dbo.ufngetproductdealerprice CASCADE;
DROP FUNCTION IF EXISTS bobsusedbookstore_dbo.ufngetproductlistprice CASCADE;
DROP FUNCTION IF EXISTS bobsusedbookstore_dbo.ufngetproductstandardcost CASCADE;
DROP FUNCTION IF EXISTS bobsusedbookstore_dbo.ufngetpurchaseorderstatustext CASCADE;
DROP FUNCTION IF EXISTS bobsusedbookstore_dbo.ufngetsalesorderstatustext CASCADE;
DROP FUNCTION IF EXISTS bobsusedbookstore_dbo.ufngetstock CASCADE;
DROP FUNCTION IF EXISTS bobsusedbookstore_dbo.ufnleadingzeros CASCADE;
DROP FUNCTION IF EXISTS bobsusedbookstore_dbo.ufngetcontactinformation CASCADE;
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'ddlDatabaseTriggerLog' AND parent_class_desc = 'DATABASE')
BEGIN
    DROP TRIGGER ddldatabasetriggerlog ON DATABASE;
END
-- Drop CONSTRAINT if exists      
-- IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID('bobsusedbookstore_dbo.fk_book_referencedata_booktypeid'))
BEGIN
     ALTER TABLE bobsusedbookstore_dbo.book DROP CONSTRAINT fk_book_referencedata_booktypeid
END;
-- IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID('bobsusedbookstore_dbo.fk_book_referencedata_conditionid'))
BEGIN
    ALTER TABLE bobsusedbookstore_dbo.book DROP CONSTRAINT fk_book_referencedata_conditionid
END;
-- IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID('bobsusedbookstore_dbo.fk_book_referencedata_genreid'))
BEGIN
    ALTER TABLE bobsusedbookstore_dbo.book DROP CONSTRAINT fk_book_referencedata_genreid
END;
-- IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE object_id = OBJECT_ID('bobsusedbookstore_dbo.fk_book_referencedata_publisherid'))
BEGIN
    ALTER TABLE bobsusedbookstore_dbo.book DROP CONSTRAINT fk_book_referencedata_publisherid
END;
-- IF EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CK_Product_DaysToManufacture' AND parent_object_id = OBJECT_ID('dbo.Product'))
BEGIN
    ALTER TABLE bobsusedbookstore_dbo.product DROP CONSTRAINT ck_product_daystomanufacture;
END;
-- IF EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CK_Product_ListPrice' AND parent_object_id = OBJECT_ID('dbo.Product'))
BEGIN
    ALTER TABLE bobsusedbookstore_dbo.product DROP CONSTRAINT ck_product_listprice;
END;
-- IF EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CK_Product_ReorderPoint' AND parent_object_id = OBJECT_ID('dbo.Product'))
BEGIN
    ALTER TABLE bobsusedbookstore_dbo.product DROP CONSTRAINT ck_product_reorderpoint;
END;
-- IF EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CK_Product_SafetyStockLevel' AND parent_object_id = OBJECT_ID('dbo.Product'))
BEGIN
    ALTER TABLE bobsusedbookstore_dbo.product DROP CONSTRAINT ck_product_safetystocklevel;
END;
-- IF EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CK_Product_SellEndDate' AND parent_object_id = OBJECT_ID('dbo.Product'))
BEGIN
    ALTER TABLE bobsusedbookstore_dbo.product DROP CONSTRAINT ck_product_sellenddate;
END;
-- IF EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CK_Product_StandardCost' AND parent_object_id = OBJECT_ID('dbo.Product'))
BEGIN
    ALTER TABLE bobsusedbookstore_dbo.product DROP CONSTRAINT ck_product_standardcost;
END;
-- IF EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CK_Product_Weight' AND parent_object_id = OBJECT_ID('dbo.Product'))
BEGIN
    ALTER TABLE bobsusedbookstore_dbo.product DROP CONSTRAINT ck_product_weight;
END;
-- IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'PK_Product_ProductID' AND object_id = OBJECT_ID('dbo.Product'))
BEGIN
    ALTER TABLE bobsusedbookstore_dbo.product DROP CONSTRAINT pk_product_productid;
END;
-- IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'PK_BillOfMaterials_BillOfMaterialsID' AND object_id = OBJECT_ID('dbo.BillOfMaterials'))
BEGIN
    ALTER TABLE bobsusedbookstore_dbo.billofmaterials DROP CONSTRAINT pk_billofmaterials_billofmaterialsid;
END;
-- ------------ Write DROP-TABLE-stage scripts -----------
-- DROP TABLE bobsusedbookstore_dbo.author;
-- DROP TABLE bobsusedbookstore_dbo.person;
-- DROP TABLE bobsusedbookstore_dbo.billofmaterials;
-- DROP TABLE bobsusedbookstore_dbo.product;
-- DROP TABLE bobsusedbookstore_dbo.databaselog;
-- DROP TABLE bobsusedbookstore_dbo.errorlog;
-- ------------ Write DROP-TYPE-stage scripts -----------
SELECT * FROM sys.types WHERE user_type_id = TYPE_ID('bobsusedbookstore_dbo.accountnumber') AND  is_user_defined = 1)
DROP TYPE bobsusedbookstore_dbo.accountnumber;
SELECT * FROM sys.types WHERE user_type_id = TYPE_ID('bobsusedbookstore_dbo.flag') AND  is_user_defined = 1)
DROP TYPE bobsusedbookstore_dbo.flag;
SELECT * FROM sys.types WHERE user_type_id = TYPE_ID('bobsusedbookstore_dbo.name') AND  is_user_defined = 1)
DROP TYPE bobsusedbookstore_dbo.name;
SELECT * FROM sys.types WHERE user_type_id = TYPE_ID('bobsusedbookstore_dbo.namestyle') AND  is_user_defined = 1)
DROP TYPE bobsusedbookstore_dbo.namestyle;
SELECT * FROM sys.types WHERE user_type_id = TYPE_ID('bobsusedbookstore_dbo.ordernumber') AND  is_user_defined = 1)
DROP TYPE bobsusedbookstore_dbo.ordernumber;
SELECT * FROM sys.types WHERE user_type_id = TYPE_ID('bobsusedbookstore_dbo.phone') AND  is_user_defined = 1)
DROP TYPE bobsusedbookstore_dbo.phone;
--     DROP TABLE bobsusedbookstore_dbo.members;
--     DROP TABLE bobsusedbookstore_dbo.shopping;
--     DROP TABLE bobsusedbookstore_dbo.coupons;
--     DROP TABLE bobsusedbookstore_dbo.productsaleregions;
--     DROP TABLE bobsusedbookstore_dbo.productsales;
--     DROP VIEW bobsusedbookstore_dbo.vwtopmembers;
--     DROP VIEW bobsusedbookstore_dbo.vwopencoupons;
--     DROP VIEW bobsusedbookstore_dbo.vwcustomershopping;
--     DROP VIEW bobsusedbookstore_dbo.vwregionalsales;
-- Drop stored procedure if it exists
-- sys.objects check removed for PostgreSQL
DROP FUNCTION IF EXISTS bobsusedbookstore_dbo.uspdeleteoldcoupons;
-- sys.objects check removed for PostgreSQL
DROP FUNCTION IF EXISTS bobsusedbookstore_dbo.uspprocessrefunds;
-- sys.objects check removed for PostgreSQL
DROP FUNCTION IF EXISTS bobsusedbookstore_dbo.uspshoppinglevelamount;
-- sys.objects check removed for PostgreSQL
DROP FUNCTION IF EXISTS bobsusedbookstore_dbo.uspgettopregion;
-- Drop function if it exists
-- sys.objects check removed for PostgreSQL
DROP FUNCTION bobsusedbookstore_dbo.ufncalculatecustomerlifetimevalue;
-- ------------ Write CREATE-TYPE-stage scripts -----------
FROM varchar(30) NULL;
FROM boolean NOT NULL;
FROM varchar(100) NULL;
FROM boolean NOT NULL;
FROM varchar(50) NULL;
FROM varchar(50) NULL;
-- ------------ Write CREATE-TABLE-stage scripts -----------
CREATE TABLE bobsusedbookstore_dbo.author(
businessentityid INT GENERATED ALWAYS AS IDENTITY NOT NULL,
nationalidnumber varchar(15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
loginid varchar(256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
organizationnode varchar(50) NULL,
jobtitle varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
birthdate date NOT NULL,
maritalstatus char(1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
gender char(1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
hiredate date NOT NULL,
vacationhours smallint NOT NULL DEFAULT ((0)),
currentflag Flag NOT NULL DEFAULT ((1)),
modifieddate timestamp NOT NULL DEFAULT (clock_timestamp())
);
CREATE TABLE bobsusedbookstore_dbo.person(
businessentityid int NOT NULL,
persontype char(2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
namestyle NameStyle NOT NULL DEFAULT ((0)),
title varchar(8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
firstname Name NOT NULL,
middlename Name NULL,
lastname Name NOT NULL,
suffix varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
emailpromotion int NOT NULL DEFAULT ((0)),
additionalcontactinfo text NULL,
demographics text NULL,
rowguid uuid NOT NULL DEFAULT (newid()),
modifieddate timestamp NOT NULL DEFAULT (clock_timestamp())
);
CREATE TABLE bobsusedbookstore_dbo.billofmaterials(
billofmaterialsid int GENERATED ALWAYS AS IDENTITY NOT NULL,
productassemblyid int NULL,
componentid int NOT NULL,
startdate timestamp NOT NULL DEFAULT (clock_timestamp()),
enddate timestamp NULL,
unitmeasurecode char(3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
bomlevel smallint NOT NULL,
perassemblyqty decimal(8,2) NOT NULL DEFAULT ((1.00)),
modifieddate timestamp NOT NULL DEFAULT (clock_timestamp())
);
CREATE TABLE bobsusedbookstore_dbo.product(
productid int GENERATED ALWAYS AS IDENTITY NOT NULL,
name Name NOT NULL,
productnumber varchar(25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
makeflag Flag NOT NULL DEFAULT ((1)),
finishedgoodsflag Flag NOT NULL DEFAULT ((1)),
color varchar(15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
safetystocklevel smallint NOT NULL,
reorderpoint smallint NOT NULL,
standardcost numeric(19,4) NOT NULL,
listprice numeric(19,4) NOT NULL,
size varchar(5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
sizeunitmeasurecode char(3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
weightunitmeasurecode char(3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
weight decimal(8,2) NULL,
daystomanufacture int NOT NULL,
productline char(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
class char(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
style char(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
productsubcategoryid int NULL,
productmodelid int NULL,
sellstartdate timestamp NOT NULL,
sellenddate timestamp NULL,
discontinueddate timestamp NULL,
rowguid uuid NOT NULL DEFAULT (newid()),
modifieddate timestamp NOT NULL DEFAULT (clock_timestamp())
);
CREATE TABLE bobsusedbookstore_dbo.errorlog(
errorlogid int GENERATED ALWAYS AS IDENTITY NOT NULL,
errortime timestamp NOT NULL DEFAULT (clock_timestamp()),
username varchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
errornumber int NOT NULL,
errorseverity int NULL,
errorstate int NULL,
errorprocedure varchar(126) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
errorline int NULL,
errormessage varchar(4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
);
CREATE TABLE bobsusedbookstore_dbo.databaselog(
databaselogid int GENERATED ALWAYS AS IDENTITY NOT NULL,
posttime timestamp NOT NULL,
databaseuser varchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
event varchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
schema varchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
object varchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
tsql varchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
xmlevent text NOT NULL
);
-- ------------ Write CREATE-CONSTRAINT-stage scripts -----------
ALTER TABLE bobsusedbookstore_dbo.author
ADD CONSTRAINT ck_author_birthdate CHECK ((birthdate>='1930-01-01' AND birthdate<=clock_timestamp( + interval '-18 years')));
ALTER TABLE bobsusedbookstore_dbo.author
ADD CONSTRAINT ck_author_hiredate CHECK ((hiredate>='1996-07-01' AND hiredate<=clock_timestamp( + interval '1 days')));
ALTER TABLE bobsusedbookstore_dbo.author
ADD CONSTRAINT ck_author_vacationhours CHECK ((vacationhours>=(-40) AND vacationhours<=(240)));
ALTER TABLE bobsusedbookstore_dbo.author
ADD CONSTRAINT pk_author_businessentityid PRIMARY KEY CLUSTERED (businessentityid);
ALTER TABLE bobsusedbookstore_dbo.billofmaterials
ADD CONSTRAINT ck_billofmaterials_enddate CHECK ((enddate>startdate OR enddate IS NULL));
ALTER TABLE bobsusedbookstore_dbo.billofmaterials
ADD CONSTRAINT ck_billofmaterials_perassemblyqty CHECK ((perassemblyqty>=(1.00)));
ALTER TABLE bobsusedbookstore_dbo.billofmaterials
ADD CONSTRAINT ck_billofmaterials_productassemblyid CHECK ((productassemblyid<>componentid));
ALTER TABLE bobsusedbookstore_dbo.billofmaterials
ADD CONSTRAINT pk_billofmaterials_billofmaterialsid PRIMARY KEY (billofmaterialsid);
ALTER TABLE bobsusedbookstore_dbo.product
ADD CONSTRAINT ck_product_daystomanufacture CHECK ((daystomanufacture>=(0)));
ALTER TABLE bobsusedbookstore_dbo.product
ADD CONSTRAINT ck_product_listprice CHECK ((listprice>=(0.00)));
ALTER TABLE bobsusedbookstore_dbo.product
ADD CONSTRAINT ck_product_reorderpoint CHECK ((reorderpoint>(0)));
ALTER TABLE bobsusedbookstore_dbo.product
ADD CONSTRAINT ck_product_safetystocklevel CHECK ((safetystocklevel>(0)));
ALTER TABLE bobsusedbookstore_dbo.product
ADD CONSTRAINT ck_product_sellenddate CHECK ((sellenddate>=sellstartdate OR sellenddate IS NULL));
ALTER TABLE bobsusedbookstore_dbo.product
ADD CONSTRAINT ck_product_standardcost CHECK ((standardcost>=(0.00)));
ALTER TABLE bobsusedbookstore_dbo.product
ADD CONSTRAINT ck_product_weight CHECK ((weight>(0.00)));
ALTER TABLE bobsusedbookstore_dbo.product
ADD CONSTRAINT pk_product_productid PRIMARY KEY CLUSTERED (productid);
ALTER TABLE bobsusedbookstore_dbo.databaselog
ADD CONSTRAINT pk_databaselog_databaselogid PRIMARY KEY (databaselogid);
ALTER TABLE bobsusedbookstore_dbo.errorlog
ADD CONSTRAINT pk_errorlog_errorlogid PRIMARY KEY CLUSTERED (errorlogid);
-- ------------ Write CREATE-INDEX-stage scripts -----------
CREATE UNIQUE NONCLUSTERED INDEX ak_author_loginid
    ON bobsusedbookstore_dbo.author (loginid ASC);
CREATE UNIQUE NONCLUSTERED INDEX ak_author_nationalidnumber
    ON bobsusedbookstore_dbo.author (nationalidnumber ASC);
CREATE UNIQUE NONCLUSTERED INDEX ak_person_rowguid
    ON bobsusedbookstore_dbo.person (rowguid ASC);
CREATE NONCLUSTERED INDEX ix_person_lastname_firstname_middlename
    ON bobsusedbookstore_dbo.person (lastname ASC, firstname ASC, middlename ASC);
CREATE NONCLUSTERED INDEX ix_author_organizationnode
    ON bobsusedbookstore_dbo.author (organizationnode ASC);
CREATE UNIQUE NONCLUSTERED INDEX ak_billofmaterials_productassemblyid_componentid_startdate
    ON bobsusedbookstore_dbo.billofmaterials (productassemblyid ASC, componentid ASC, startdate ASC);
CREATE NONCLUSTERED INDEX ix_billofmaterials_unitmeasurecode
    ON bobsusedbookstore_dbo.billofmaterials (unitmeasurecode ASC);
CREATE UNIQUE NONCLUSTERED INDEX ak_product_name
    ON bobsusedbookstore_dbo.product (name ASC);
CREATE UNIQUE NONCLUSTERED INDEX ak_product_productnumber
    ON bobsusedbookstore_dbo.product (productnumber ASC);
CREATE UNIQUE NONCLUSTERED INDEX ak_product_rowguid
    ON bobsusedbookstore_dbo.product (rowguid ASC);
-- ------------ Write CREATE-DATABASE-TRIGGER-stage scripts -----------
-- DDL Trigger not supported in PostgreSQL
-- CREATE TRIGGER ddldatabasetriggerlog ON DATABASE 
-- FOR DDL_DATABASE_LEVEL_EVENTS AS 
-- BEGIN
--     SET NOCOUNT ON;
-- 
--     DECLARE @data text;
--     DECLARE @schema sysname;
--     DECLARE @object sysname;
--     DECLARE @eventType sysname;
-- 
--     SET @data = EVENTDATA();
--     SET @eventType = @data.value('(/EVENT_INSTANCE/EventType)1', 'sysname');
--     SET @schema = @data.value('(/EVENT_INSTANCE/SchemaName)1', 'sysname');
--     SET @object = @data.value('(/EVENT_INSTANCE/ObjectName)1', 'sysname') 
-- 
--     IF @object IS NOT NULL
--         PRINT '  ' + @eventType + ' - ' + @schema + '.' + @object;
--     ELSE
--         PRINT '  ' + @eventType + ' - ' + @schema;
-- 
--     IF @eventType IS NULL
--         PRINT CAST(@data AS text);
-- 
--     INSERT bobsusedbookstore_dbo.databaselog 
--         (
--         posttime, 
--         databaseuser, 
--         event, 
--         schema, 
--         object, 
--         tsql, 
--         xmlevent
--         ) 
--     VALUES 
--         (
--         clock_timestamp(), 
--         CAST(CURRENT_USER AS varchar), 
--         @eventType, 
--         CAST(@schema AS varchar), 
--         CAST(@object AS varchar), 
--         @data.value('(/EVENT_INSTANCE/TSQLCommand)1', 'varchar(max)'), 
--         @data
--         );
-- END;
-- ------------ Write CREATE-ROUTINE-stage scripts -----------
CREATE OR REPLACE FUNCTION bobsusedbookstore_dbo.uspgetbillofmaterials
    v_StartProductID int,
    v_CheckDate timestamp
RETURNS void AS $$
BEGIN
    SET NOCOUNT ON;
    WITH bom_cte(productassemblyid, componentid, componentdesc, perassemblyqty, standardcost, listprice, bomlevel, recursionlevel) 
    AS (
        SELECT b.productassemblyid, b.componentid, p.name, b.perassemblyqty, p.standardcost, p.listprice, b.bomlevel, 0 
        FROM bobsusedbookstore_dbo.billofmaterials b
            INNER JOIN bobsusedbookstore_dbo.product p 
            ON b.componentid = p.productid 
        WHERE b.productassemblyid = v_StartProductID 
            AND v_CheckDate >= b.startdate 
            AND v_CheckDate <= COALESCE(b.enddate, v_CheckDate)
        UNION ALL
        SELECT b.productassemblyid, b.componentid, p.name, b.perassemblyqty, p.standardcost, p.listprice, b.bomlevel, recursionlevel + 1 
        FROM bom_cte cte
            INNER JOIN bobsusedbookstore_dbo.billofmaterials b 
            ON b.productassemblyid = cte.componentid
            INNER JOIN bobsusedbookstore_dbo.product p 
            ON b.componentid = p.productid 
        WHERE v_CheckDate >= b.startdate 
            AND v_CheckDate <= COALESCE(b.enddate, v_CheckDate)
        )
    SELECT b.productassemblyid, b.componentid, b.componentdesc, SUM(b.perassemblyqty) AS totalquantity , b.standardcost, b.listprice, b.bomlevel, b.recursionlevel
    FROM bom_cte b
    GROUP BY b.componentid, b.componentdesc, b.productassemblyid, b.bomlevel, b.recursionlevel, b.standardcost, b.listprice
    ORDER BY b.bomlevel, b.productassemblyid, b.componentid
     
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION bobsusedbookstore_dbo.uspgetauthormanagers
    v_BusinessEntityID int
RETURNS void AS $$
BEGIN
    SET NOCOUNT ON;
    WITH emp_cte(businessentityid, organizationnode, firstname, lastname, jobtitle, recursionlevel) 
    AS (
        SELECT e.businessentityid, e.organizationnode, p.firstname, p.lastname, e.jobtitle, 0 
        FROM bobsusedbookstore_dbo.author e 
            INNER JOIN bobsusedbookstore_dbo.person as p
            ON p.businessentityid = e.businessentityid
        WHERE e.businessentityid = v_BusinessEntityID
        UNION ALL
        SELECT e.businessentityid, e.organizationnode, p.firstname, p.lastname, e.jobtitle, recursionlevel + 1 
        FROM bobsusedbookstore_dbo.author e 
            INNER JOIN emp_cte
            ON LEFT(e.organizationnode, LEN(e.organizationnode) - 1) = emp_cte.organizationnode
            INNER JOIN bobsusedbookstore_dbo.person p 
            ON p.businessentityid = e.businessentityid
    )
    SELECT emp_cte.recursionlevel, emp_cte.businessentityid, emp_cte.firstname, emp_cte.lastname, 
        emp_cte.organizationnode AS organizationnode, p.firstname AS 'ManagerFirstName', p.lastname AS 'ManagerLastName'  
    FROM emp_cte 
        INNER JOIN bobsusedbookstore_dbo.author e 
        ON LEFT(emp_cte.organizationnode, LEN(emp_cte.organizationnode) - 1) = e.organizationnode
        INNER JOIN bobsusedbookstore_dbo.person p 
        ON p.businessentityid = e.businessentityid
    ORDER BY recursionlevel, emp_cte.organizationnode
     
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION bobsusedbookstore_dbo.uspgetmanagerauthors
    v_BusinessEntityID int
RETURNS void AS $$
BEGIN
    SET NOCOUNT ON;

    WITH emp_cte(businessentityid, organizationnode, firstname, lastname, recursionlevel) 
    AS (
        SELECT e.businessentityid, e.organizationnode, p.firstname, p.lastname, 0 
        FROM bobsusedbookstore_dbo.author e 
            INNER JOIN bobsusedbookstore_dbo.person p 
            ON p.businessentityid = e.businessentityid
        WHERE e.businessentityid = v_BusinessEntityID
        UNION ALL
        SELECT e.businessentityid, e.organizationnode, p.firstname, p.lastname, recursionlevel + 1
        FROM bobsusedbookstore_dbo.author e 
            INNER JOIN emp_cte
            ON e.organizationnode = LEFT(emp_cte.organizationnode, LEN(emp_cte.organizationnode) - 1)
            INNER JOIN bobsusedbookstore_dbo.person p 
            ON p.businessentityid = e.businessentityid
        )
    SELECT emp_cte.recursionlevel, emp_cte.organizationnode as organizationnode, 
           p.firstname AS 'ManagerFirstName', p.lastname AS 'ManagerLastName',
           emp_cte.businessentityid, emp_cte.firstname, emp_cte.lastname 
    FROM emp_cte 
        INNER JOIN bobsusedbookstore_dbo.author e 
        ON e.organizationnode = LEFT(emp_cte.organizationnode, LEN(emp_cte.organizationnode) - 1)
        INNER JOIN bobsusedbookstore_dbo.person p 
        ON p.businessentityid = e.businessentityid
    ORDER BY recursionlevel, emp_cte.organizationnode
     
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION bobsusedbookstore_dbo.uspgetwhereusedproductid
    v_StartProductID int,
    v_CheckDate timestamp
RETURNS void AS $$
BEGIN
    SET NOCOUNT ON;
    WITH bom_cte(productassemblyid, componentid, componentdesc, perassemblyqty, standardcost, listprice, bomlevel, recursionlevel) 
    AS (
        SELECT b.productassemblyid, b.componentid, p.name, b.perassemblyqty, p.standardcost, p.listprice, b.bomlevel, 0 
        FROM bobsusedbookstore_dbo.billofmaterials b
            INNER JOIN bobsusedbookstore_dbo.product p 
            ON b.productassemblyid = p.productid 
        WHERE b.componentid = v_StartProductID 
            AND v_CheckDate >= b.startdate 
            AND v_CheckDate <= COALESCE(b.enddate, v_CheckDate)
        UNION ALL
        SELECT b.productassemblyid, b.componentid, p.name, b.perassemblyqty, p.standardcost, p.listprice, b.bomlevel, recursionlevel + 1 
        FROM bom_cte cte
            INNER JOIN bobsusedbookstore_dbo.billofmaterials b 
            ON cte.productassemblyid = b.componentid
            INNER JOIN bobsusedbookstore_dbo.product p 
            ON b.productassemblyid = p.productid 
        WHERE v_CheckDate >= b.startdate 
            AND v_CheckDate <= COALESCE(b.enddate, v_CheckDate)
        )
    SELECT b.productassemblyid, b.componentid, b.componentdesc, SUM(b.perassemblyqty) AS totalquantity , b.standardcost, b.listprice, b.bomlevel, b.recursionlevel
    FROM bom_cte b
    GROUP BY b.componentid, b.componentdesc, b.productassemblyid, b.bomlevel, b.recursionlevel, b.standardcost, b.listprice
    ORDER BY b.bomlevel, b.productassemblyid, b.componentid
     
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION bobsusedbookstore_dbo.uspprinterror 
RETURNS void AS $$
BEGIN
    SET NOCOUNT ON;

    -- Print error information. 
    RAISE NOTICE 'Error ' || CAST(ERROR_NUMBER( AS varchar(50))) || ', Severity ' || CAST(ERROR_SEVERITY( AS varchar(5))) || ', State ' || CAST(ERROR_STATE( AS varchar(5))) || ', Procedure ' || COALESCE(NULL, '-') || ', Line ' || CAST(ERROR_LINE( AS varchar(5)));
    PRINT SQLERRM;
END;
$$ LANGUAGE plpgsql;
CREATE OR ALTER PROCEDURE bobsusedbookstore_dbo.usplogerror 
    @ErrorLogID int = 0 OUTPUT 
AS
BEGIN
    SET NOCOUNT ON;
    SET @ErrorLogID = 0;
    BEGIN TRY
        IF ERROR_NUMBER() IS NULL
            RETURN;
        INSERT INTO bobsusedbookstore_dbo.errorlog;
            (
            username, 
            errornumber, 
            errorseverity, 
            errorstate, 
            errorprocedure, 
            errorline, 
            errormessage
            ) 
        VALUES 
            (
            SUSER_SNAME(), 
            ERROR_NUMBER(),
            ERROR_SEVERITY(),
            ERROR_STATE(),
            ERROR_PROCEDURE(),
            ERROR_LINE(),
            ERROR_MESSAGE()
            );
        SET @ErrorLogID = SCOPE_IDENTITY();
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred in stored procedure uspLogError: ';
        EXECUTE bobsusedbookstore_dbo.uspprinterror;
        RETURN -1;
    END CATCH
END;
CREATE OR REPLACE FUNCTION bobsusedbookstore_dbo.uspupdateauthorlogin
    v_BusinessEntityID int, 
    v_OrganizationNode varchar(4000), 
    v_LoginID varchar(256),
    v_JobTitle varchar(50),
    v_HireDate timestamp,
    v_CurrentFlag boolean
WITH PERFORM AS CALLER
RETURNS void AS $$
BEGIN
    SET NOCOUNT ON;

    BEGIN
        UPDATE bobsusedbookstore_dbo.author 
        SET organizationnode = v_OrganizationNode 
            ,loginid = v_LoginID 
            ,jobtitle = v_JobTitle 
            ,hiredate = v_HireDate 
            ,currentflag = v_CurrentFlag 
        WHERE businessentityid = v_BusinessEntityID;
    
    EXCEPTION WHEN OTHERS THEN
        PERFORM bobsusedbookstore_dbo.usplogerror;
    ;
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION bobsusedbookstore_dbo.uspupdateauthorpersonalinfo
    v_BusinessEntityID int, 
    v_NationalIDNumber varchar(15), 
    v_BirthDate timestamp, 
    v_MaritalStatus char(1), 
    v_Gender char(1)
WITH PERFORM AS CALLER
RETURNS void AS $$
BEGIN
    SET NOCOUNT ON;

    BEGIN
        UPDATE bobsusedbookstore_dbo.author 
        SET nationalidnumber = v_NationalIDNumber 
            ,birthdate = v_BirthDate 
            ,maritalstatus = v_MaritalStatus 
            ,gender = v_Gender 
        WHERE businessentityid = v_BusinessEntityID;
    
    EXCEPTION WHEN OTHERS THEN
        PERFORM bobsusedbookstore_dbo.usplogerror;
    ;
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION bobsusedbookstore_dbo.uspdeleteauthor
    v_BusinessEntityID int
WITH PERFORM AS CALLER
RETURNS void AS $$
BEGIN
    SET NOCOUNT ON;

    BEGIN
        DELETE FROM bobsusedbookstore_dbo.author
        WHERE businessentityid = v_BusinessEntityID;

        -- Check if the delete was successful
        IF @v_ROWCOUNT = 0
        BEGIN
            RAISE EXCEPTION('No author found with the provided BusinessEntityID.', 16, 1);
            RETURN;
        END
    
    EXCEPTION WHEN OTHERS THEN
        -- Log the error and re-throw
        PERFORM bobsusedbookstore_dbo.usplogerror;
        THROW;
    ;
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION bobsusedbookstore_dbo.uspgetproductdata
    v_my_cursor CURSOR VARYING OUTPUT
RETURNS void AS $$
BEGIN
    -- Open a cursor for the SELECT query
    v_my_cursor := CURSOR FOR
    SELECT
        ProductID,
        Name,
        ProductNumber,
        SafetyStockLevel
    FROM dbo.Product;
    -- Open the cursor to make it available to the caller
    OPEN v_my_cursor;
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION bobsusedbookstore_dbo.ufngetaccountingenddate()
RETURNS timestamp 
AS $$
BEGIN
    RETURN TO_TIMESTAMP('20040701', 'YYYYMMDD') + interval '-2 milliseconds';
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION bobsusedbookstore_dbo.ufngetaccountingstartdate()
RETURNS timestamp 
AS $$
BEGIN
    RETURN TO_TIMESTAMP('20030701', 'YYYYMMDD');
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION bobsusedbookstore_dbo.ufngetdocumentstatustext(v_Status smallint)
RETURNS varchar(16) 
AS $$
BEGIN
    DECLARE v_ret varchar(16);

    v_ret := 
        CASE v_Status
            WHEN 1 THEN 'Pending approval'
            WHEN 2 THEN 'Approved'
            WHEN 3 THEN 'Obsolete'
            ELSE '** Invalid **'
        END;
    
    RETURN v_ret
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION bobsusedbookstore_dbo.ufngetpurchaseorderstatustext(v_Status smallint)
RETURNS varchar(15) 
AS $$
BEGIN
    DECLARE v_ret varchar(15);

    v_ret := 
        CASE v_Status
            WHEN 1 THEN 'Pending'
            WHEN 2 THEN 'Approved'
            WHEN 3 THEN 'Rejected'
            WHEN 4 THEN 'Complete'
            ELSE '** Invalid **'
        END;
    
    RETURN v_ret
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION bobsusedbookstore_dbo.ufngetsalesorderstatustext(v_Status smallint)
RETURNS varchar(15) 
AS $$
BEGIN
    DECLARE v_ret varchar(15);

    v_ret := 
        CASE v_Status
            WHEN 1 THEN 'In process'
            WHEN 2 THEN 'Approved'
            WHEN 3 THEN 'Backordered'
            WHEN 4 THEN 'Rejected'
            WHEN 5 THEN 'Shipped'
            WHEN 6 THEN 'Cancelled'
            ELSE '** Invalid **'
        END;
    
    RETURN v_ret
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION bobsusedbookstore_dbo.ufnleadingzeros(
    v_Value int
) 
RETURNS varchar(8) AS $$
BEGIN
    DECLARE v_ReturnValue varchar(8);

    v_ReturnValue := CAST(v_Value AS varchar(8));
    v_ReturnValue := REPLICATE('0', 8 - LENGTH(v_ReturnValue)) + v_ReturnValue;

    RETURN v_ReturnValue;
END;
$$ LANGUAGE plpgsql;
-- ------------ Write CREATE-OTHER-stage scripts -----------
CREATE TABLE bobsusedbookstore_dbo.members(
    customerid INT PRIMARY KEY,
    firstname varchar(50),
    lastname varchar(50),
    email varchar(100),
    phone varchar(20),
    registrationdate DATE,
    totalordersum DECIMAL(10,2)
);
CREATE TABLE bobsusedbookstore_dbo.shopping(
    orderid INT PRIMARY KEY,
    customerid INT,
    orderdate timestamp,
    totalamount DECIMAL(10,2),
    status varchar(20)
);
CREATE TABLE bobsusedbookstore_dbo.coupons(
    ticketid INT PRIMARY KEY,
    customerid INT,
    orderid INT,
    issuedescription varchar(MAX),
    createddate timestamp,
    resolveddate timestamp,
    status varchar(20),
    osuser VARCHAR(10)
);
CREATE TABLE bobsusedbookstore_dbo.productsaleregions(
    regionid INT NOT NULL,
    regionname VARCHAR(50) NOT NULL
);
CREATE TABLE bobsusedbookstore_dbo.productsales(
    saleid NUMERIC NOT NULL,
    productid INT NOT NULL,
    saledate DATE NOT NULL,
    quantity NUMERIC(10,0) NOT NULL,
    unitprice NUMERIC(9,2) NOT NULL,
    totalamount NUMERIC(11,2) NOT NULL,
    customerid INT NOT NULL,
    saleprice NUMERIC(9,2),
    regionid NUMERIC(10,0)
);
-- Create views
CREATE VIEW bobsusedbookstore_dbo.vwtopmembers AS
SELECT * 
FROM (
    SELECT /* TOP 50 PERCENT */ 
        c.customerid, 
        c.firstname, 
        c.lastname, 
        SUM(o.totalamount) AS totalspent
    FROM bobsusedbookstore_dbo.members c
    JOIN bobsusedbookstore_dbo.shopping o ON c.customerid = o.customerid
    GROUP BY c.customerid, c.firstname, c.lastname
    ORDER BY totalspent DESC
) sub;
CREATE VIEW bobsusedbookstore_dbo.vwopencoupons AS
SELECT 
    t.ticketid, 
    c.firstname, 
    c.lastname, 
    t.issuedescription, 
    t.createddate, 
    (DATE_PART('day', clock_timestamp(::timestamp - t.createddate::timestamp))::integer) AS daysopen
FROM bobsusedbookstore_dbo.coupons t
JOIN bobsusedbookstore_dbo.members c ON t.customerid = c.customerid
WHERE t.status = 'Open' AND t.osuser = CURRENT_USER;
CREATE VIEW bobsusedbookstore_dbo.vwcustomershopping AS
SELECT 
    o.orderid,
    c.firstname || ' ' || c.lastname AS customername,
    o.orderdate,
    o.totalamount,
    o.status,
    format(
        'Hi, %s! Your order #%s for $%s will be shipped shortly. Thank you!',
        c.firstname,
        CAST(o.orderid AS VARCHAR),
        CAST(o.totalamount AS VARCHAR)
    ) AS greetingmessage
FROM bobsusedbookstore_dbo.shopping o
JOIN bobsusedbookstore_dbo.members c ON c.customerid = o.customerid;
CREATE VIEW bobsusedbookstore_dbo.vwregionalsales (regionname, regionsalessum) AS
SELECT 
    CASE regionid WHEN 1 THEN 'North America' WHEN 2 THEN 'Europe' WHEN 3 THEN 'Asia' WHEN 4 THEN 'South America' WHEN 5 THEN 'Africa' WHEN 6 THEN 'Australia' WHEN 7 THEN 'Middle East' WHEN 8 THEN 'Central America' WHEN 9 THEN 'Eastern Europe' WHEN 10 THEN 'Western Europe' END AS regionname,
    SUM(quantity * saleprice) AS regionsalessum
FROM bobsusedbookstore_dbo.productsales
GROUP BY CASE regionid WHEN 1 THEN 'North America' WHEN 2 THEN 'Europe' WHEN 3 THEN 'Asia' WHEN 4 THEN 'South America' WHEN 5 THEN 'Africa' WHEN 6 THEN 'Australia' WHEN 7 THEN 'Middle East' WHEN 8 THEN 'Central America' WHEN 9 THEN 'Eastern Europe' WHEN 10 THEN 'Western Europe' END;
-- Create procedures
CREATE OR REPLACE FUNCTION bobsusedbookstore_dbo.uspgettopregion
    v_Percent INT
RETURNS void AS $$
BEGIN
    WITH halfyearsales AS (
        SELECT 
            psr.regionid,
            psr.regionname,
            COUNT(ps.saleid) AS numberofsales,
            SUM(ps.totalamount) AS totalsalesamount,
            COUNT(DISTINCT ps.customerid) AS numberofmembers
        FROM 
            bobsusedbookstore_dbo.productsaleregions psr
        LEFT JOIN 
            bobsusedbookstore_dbo.productsales ps ON psr.regionid = ps.regionid
        WHERE 
            ps.saledate >= clock_timestamp( + interval '-6 months')
        GROUP BY 
            psr.regionid, psr.regionname
    )
    SELECT * FROM (
        SELECT TOP 10 PERCENT * FROM halfyearsales WHERE v_Percent = 10 ORDER BY numberofsales DESC
        UNION ALL 
        SELECT TOP 20 PERCENT * FROM halfyearsales WHERE v_Percent = 20 ORDER BY numberofsales DESC
        UNION ALL 
        SELECT TOP 30 PERCENT * FROM halfyearsales WHERE v_Percent = 30 ORDER BY numberofsales DESC
        UNION ALL 
        SELECT TOP 40 PERCENT * FROM halfyearsales WHERE v_Percent = 40 ORDER BY numberofsales DESC
        UNION ALL 
        SELECT TOP 50 PERCENT * FROM halfyearsales WHERE v_Percent = 50 ORDER BY numberofsales DESC
    ) q
    ORDER BY numberofsales DESC, totalsalesamount DESC;
END;
$$ LANGUAGE plpgsql;
CREATE OR ALTER PROCEDURE bobsusedbookstore_dbo.uspdeleteoldcoupons
    @DaysOld INT
AS
BEGIN
    DECLARE @DeletedCount INT = 0;
    SELECT ticketid, createddate
    INTO #CouponsToDelete
    FROM bobsusedbookstore_dbo.coupons
    WHERE TRIM(status) = 'Closed' AND resolveddate <= DATEADD(DAY, -@DaysOld, clock_timestamp());
    DECLARE @CouponsCount INT;
    SELECT @CouponsCount = COUNT(*) FROM #CouponsToDelete;
    IF @CouponsCount > 0
    BEGIN
        DELETE t
        FROM bobsusedbookstore_dbo.coupons t
        INNER JOIN #CouponsToDelete d ON t.ticketid = d.ticketid;
        SET @DeletedCount = @@ROWCOUNT;
        PRINT 'Deleted ' + CAST(@DeletedCount AS varchar(10)) + ' coupons.';
    END
    ELSE
    BEGIN
        PRINT 'No coupons found matching the criteria.';
    END
END;
CREATE OR ALTER PROCEDURE bobsusedbookstore_dbo.uspprocessrefunds
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @RefundCount INT = 0;
    DECLARE @MaxID INT;
    SELECT @MaxID = MAX(ticketid) FROM bobsusedbookstore_dbo.coupons;
    SELECT orderid, customerid, totalamount
    INTO #RefundRequests
    FROM bobsusedbookstore_dbo.shopping
    WHERE TRIM(status) = 'Refund Requested';
    UPDATE o
    SET status = 'Refunded'
    FROM bobsusedbookstore_dbo.shopping o
    INNER JOIN #RefundRequests r ON o.orderid = r.orderid;
    INSERT INTO bobsusedbookstore_dbo.coupons (ticketid, customerid, orderid, issuedescription, createddate, status);
    SELECT 
        @MaxID + ROW_NUMBER() OVER (ORDER BY orderid),
        customerid,
        orderid,
        'Refund processed for $' + CAST(totalamount AS varchar(20)),
        clock_timestamp(),
        'Closed'
    FROM #RefundRequests;
    SET @RefundCount = @@ROWCOUNT;
    PRINT 'Processed ' + CAST(@RefundCount AS varchar(10)) + ' refunds.';
    DROP TABLE #RefundRequests;
END;
CREATE OR ALTER PROCEDURE bobsusedbookstore_dbo.uspshoppinglevelamount
    @Percent INT,
    @Amount NUMERIC
AS
BEGIN
    SELECT 
        orderid,
        '|' + CASE 
                WHEN @Percent > 100 THEN
                    CASE 
                        WHEN totalamount > @Amount THEN 'more than'
                        ELSE 'less than'
                    END
              END + '|' AS amountlevel
    FROM bobsusedbookstore_dbo.shopping;
END;
CREATE OR ALTER FUNCTION bobsusedbookstore_dbo.ufncalculatecustomerlifetimevalue
(
    @CustomerID INT
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TotalSpent DECIMAL(10, 2);
    DECLARE @FirstOrderDate DATE;
    DECLARE @DaysSinceFirstOrder INT;
    DECLARE @LifetimeValue DECIMAL(10, 2);
    SELECT 
        @TotalSpent = SUM(totalamount),
        @FirstOrderDate = MIN(orderdate)
    FROM bobsusedbookstore_dbo.shopping
    WHERE customerid = @CustomerID AND TRIM(status) != 'Refund Requested';
    SET @DaysSinceFirstOrder = DATEDIFF(DAY, @FirstOrderDate, clock_timestamp());
    IF @DaysSinceFirstOrder = 0
        SET @LifetimeValue = @TotalSpent;
    ELSE
        SET @LifetimeValue = (@TotalSpent / @DaysSinceFirstOrder) * 365.25;
    RETURN @LifetimeValue;
END;
-- ============================================================================
-- APPENDING DATA FROM adven-data.sql
-- ============================================================================
/*============================================================================
  File:     mnsg-adven-data.sql
  Summary:  Insert sample data for the workshop mnsg. It comes from Microsoft AdventureWorks sample database. 
  Date:     October 26, 2017
  Updated:  October 26, 2017
------------------------------------------------------------------------------
  This file is part of the Microsoft SQL Server Code Samples.
  Copyright (C) Microsoft Corporation.  All rights reserved.
  This source code is intended only as a supplement to Microsoft
  Development Tools and/or on-line documentation.  See these other
  materials for detailed information regarding Microsoft code samples.
  All data in this database is ficticious.
  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
  KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
  PARTICULAR PURPOSE.
============================================================================*/
-- ******************************************************
-- Load data
-- ******************************************************
INSERT INTO bobsusedbookstore_dbo.author (;
    nationalidnumber, loginid, organizationnode,
    jobtitle, birthdate, maritalstatus, gender,
    hiredate, vacationhours, currentflag,
    modifieddate    
) VALUES
    ('295847284', 'adventure-works\ken0', NULL, 'Chief Executive Officer', '1969-01-29', 'S', 'M', '2009-01-14',99,1, '2014-06-30'),
    ('245797967', 'adventure-works\terri0', '58', 'Vice President of Engineering', '1971-08-01', 'S', 'F', '2008-01-31',1,1, '2014-06-30'),
    ('509647174', 'adventure-works\roberto0', '5AC0', 'Engineering Manager', '1974-11-12', 'M', 'M', '2007-11-11',2,1, '2014-06-30'),
    ('112457891', 'adventure-works\rob0', '5AD6', 'Senior Tool Designer', '1974-12-23', 'S', 'M', '2007-12-05',48,1, '2014-06-30'),
    ('695256908', 'adventure-works\gail0', '5ADA', 'Design Engineer', '1952-09-27', 'M', 'F', '2008-01-06',5,1, '2014-06-30'),
    ('998320692', 'adventure-works\jossef0', '5ADE', 'Design Engineer', '1959-03-11', 'M', 'M', '2008-01-24',6,1, '2014-06-30'),
    ('134969118', 'adventure-works\dylan0', '5AE1', 'Research and Development Manager', '1987-02-24', 'M', 'M', '2009-02-08',61,1, '2014-06-30'),
    ('811994146', 'adventure-works\diane1', '5AE158', 'Research and Development Engineer', '1986-06-05', 'S', 'F', '2008-12-29',62,1, '2014-06-30'),
    ('658797903', 'adventure-works\gigi0', '5AE168', 'Research and Development Engineer', '1979-01-21', 'M', 'F', '2009-01-16',63,1, '2014-06-30'),
    ('879342154', 'adventure-works\michael6', '5AE178', 'Research and Development Manager', '1984-11-30', 'M', 'M', '2009-05-03',16,1, '2014-06-30'),
    ('974026903', 'adventure-works\ovidiu0', '5AE3', 'Senior Tool Designer', '1978-01-17', 'S', 'M', '2010-12-05',7,1, '2014-06-30'),
    ('480168528', 'adventure-works\thierry0', '5AE358', 'Tool Designer', '1959-07-29', 'M', 'M', '2007-12-11',9,1, '2014-06-30'),
    ('486228782', 'adventure-works\janice0', '5AE368', 'Tool Designer', '1989-05-28', 'M', 'F', '2010-12-23',8,1, '2014-06-30'),
    ('42487730', 'adventure-works\michael8', '5AE5', 'Senior Design Engineer', '1979-06-16', 'S', 'M', '2010-12-30',3,1, '2014-06-30'),
    ('56920285', 'adventure-works\sharon0', '5AE7', 'Design Engineer', '1961-05-02', 'M', 'F', '2011-01-18',4,1, '2014-06-30'),
    ('24756624', 'adventure-works\david0', '68', 'Marketing Manager', '1975-03-19', 'S', 'M', '2007-12-20',40,1, '2014-06-30'),
    ('253022876', 'adventure-works\kevin0', '6AC0', 'Marketing Assistant', '1987-05-03', 'S', 'M', '2007-01-26',42,1, '2014-06-30'),
    ('222969461', 'adventure-works\john5', '6B40', 'Marketing Specialist', '1978-03-06', 'S', 'M', '2011-02-07',48,1, '2014-06-30'),
    ('52541318', 'adventure-works\mary2', '6BC0', 'Marketing Assistant', '1978-01-29', 'S', 'F', '2011-02-14',43,1, '2014-06-30'),
    ('323403273', 'adventure-works\wanida0', '6C20', 'Marketing Assistant', '1975-03-17', 'M', 'F', '2011-01-07',41,1, '2014-06-30'),
    ('243322160', 'adventure-works\terry0', '6C60', 'Marketing Specialist', '1986-02-04', 'M', 'M', '2009-03-02',44,1, '2014-06-30'),
    ('95958330', 'adventure-works\sariya0', '6CA0', 'Marketing Specialist', '1987-05-21', 'S', 'M', '2008-12-12',45,1, '2014-06-30'),
    ('767955365', 'adventure-works\mary0', '6CE0', 'Marketing Specialist', '1962-09-13', 'M', 'F', '2009-01-12',46,1, '2014-06-30'),
    ('72636981', 'adventure-works\jill0', '6D10', 'Marketing Specialist', '1979-06-18', 'M', 'F', '2009-01-18',47,1, '2014-06-30'),
    ('519899904', 'adventure-works\james1', '78', 'Vice President of Production', '1983-01-07', 'S', 'M', '2009-02-03',64,1, '2014-06-30'),
    ('277173473', 'adventure-works\peter0', '7AC0', 'Production Control Manager', '1982-11-03', 'M', 'M', '2008-12-01',43,1, '2014-12-26'),
    ('446466105', 'adventure-works\jo0', '7AD6', 'Production Supervisor - WC60', '1956-10-08', 'S', 'F', '2008-02-27',80,1, '2014-06-30'),
    ('14417807', 'adventure-works\guy1', '7AD6B0', 'Production Technician - WC60', '1988-03-13', 'M', 'M', '2006-06-30',21,1, '2014-06-30'),
    ('948320468', 'adventure-works\mark1', '7AD6D0', 'Production Technician - WC60', '1979-09-25', 'S', 'M', '2009-01-23',19,1, '2014-06-30'),
    ('410742000', 'adventure-works\britta0', '7AD6F0', 'Production Technician - WC60', '1989-09-28', 'M', 'F', '2009-01-29',14,1, '2014-06-30'),
    ('750246141', 'adventure-works\margie0', '7AD708', 'Production Technician - WC60', '1986-05-20', 'M', 'F', '2009-01-04',18,1, '2014-06-30'),
    ('330211482', 'adventure-works\rebecca0', '7AD718', 'Production Technician - WC60', '1977-07-10', 'M', 'F', '2008-12-29',23,1, '2014-06-30'),
    ('801758002', 'adventure-works\annik0', '7AD728', 'Production Technician - WC60', '1976-12-26', 'M', 'M', '2008-12-17',17,1, '2014-06-30'),
    ('754372876', 'adventure-works\suchitra0', '7AD738', 'Production Technician - WC60', '1987-06-10', 'M', 'F', '2009-02-16',15,1, '2014-06-30'),
    ('999440576', 'adventure-works\brandon0', '7AD744', 'Production Technician - WC60', '1977-01-10', 'M', 'M', '2009-02-08',22,1, '2014-06-30'),
    ('788456780', 'adventure-works\jose0', '7AD74C', 'Production Technician - WC60', '1984-07-31', 'M', 'M', '2009-02-10',20,1, '2014-06-30'),
    ('442121106', 'adventure-works\chris2', '7AD754', 'Production Technician - WC60', '1986-08-07', 'S', 'M', '2009-03-07',16,1, '2014-06-30'),
    ('6298838', 'adventure-works\kim1', '7AD75C', 'Production Technician - WC60', '1966-12-14', 'M', 'F', '2010-01-16',24,1, '2014-06-30'),
    ('461786517', 'adventure-works\ed0', '7AD764', 'Production Technician - WC60', '1971-09-11', 'S', 'M', '2010-02-05',25,1, '2014-06-30'),
    ('309738752', 'adventure-works\jolynn0', '7ADA', 'Production Supervisor - WC60', '1956-01-16', 'S', 'F', '2007-12-26',82,1, '2014-06-30'),
    ('458159238', 'adventure-works\bryan0', '7ADAB0', 'Production Technician - WC60', '1973-08-27', 'S', 'M', '2009-01-21',35,1, '2014-06-30'),
    ('339712426', 'adventure-works\james0', '7ADAD0', 'Production Technician - WC60', '1984-07-25', 'M', 'M', '2008-12-27',39,1, '2014-06-30'),
    ('693325305', 'adventure-works\nancy0', '7ADAF0', 'Production Technician - WC60', '1988-11-19', 'M', 'F', '2009-01-02',34,1, '2014-06-30'),
    ('276751903', 'adventure-works\simon0', '7ADB08', 'Production Technician - WC60', '1990-05-17', 'S', 'M', '2008-12-08',38,1, '2014-06-30'),
    ('500412746', 'adventure-works\thomas0', '7ADB18', 'Production Technician - WC60', '1986-01-10', 'M', 'M', '2009-02-26',37,1, '2014-06-30'),
    ('66073987', 'adventure-works\eugene1', '7ADB28', 'Production Technician - WC60', '1976-02-10', 'S', 'M', '2009-02-08',36,1, '2014-06-30'),
    ('33237992', 'adventure-works\andrew0', '7ADE', 'Production Supervisor - WC10', '1988-09-06', 'S', 'M', '2009-02-22',65,1, '2014-06-30'),
    ('690627818', 'adventure-works\ruth0', '7ADEB0', 'Production Technician - WC10', '1956-06-04', 'M', 'F', '2008-01-06',83,1, '2014-06-30'),
    ('912265825', 'adventure-works\barry0', '7ADED0', 'Production Technician - WC10', '1956-03-26', 'S', 'M', '2008-01-07',88,1, '2014-06-30'),
    ('844973625', 'adventure-works\sidney0', '7ADEF0', 'Production Technician - WC10', '1956-08-30', 'M', 'M', '2008-02-02',84,1, '2014-06-30'),
    ('132674823', 'adventure-works\jeffrey0', '7ADF08', 'Production Technician - WC10', '1956-07-11', 'S', 'M', '2008-02-20',85,1, '2014-06-30'),
    ('565090917', 'adventure-works\doris0', '7ADF18', 'Production Technician - WC10', '1956-04-04', 'M', 'F', '2008-03-10',86,1, '2014-06-30'),
    ('9659517', 'adventure-works\diane0', '7ADF28', 'Production Technician - WC10', '1956-03-29', 'M', 'F', '2008-03-28',87,1, '2014-06-30'),
    ('109272464', 'adventure-works\bonnie0', '7ADF38', 'Production Technician - WC10', '1986-09-10', 'M', 'F', '2010-01-01',89,1, '2014-06-30'),
    ('233069302', 'adventure-works\taylor0', '7AE1', 'Production Supervisor - WC50', '1956-04-01', 'M', 'M', '2008-02-08',79,1, '2014-06-30'),
    ('652535724', 'adventure-works\denise0', '7AE158', 'Production Technician - WC50', '1988-07-06', 'M', 'F', '2009-02-05',9,1, '2014-06-30'),
    ('10708100', 'adventure-works\frank1', '7AE168', 'Production Technician - WC50', '1971-07-24', 'S', 'M', '2009-02-23',10,1, '2014-06-30'),
    ('571658797', 'adventure-works\kendall0', '7AE178', 'Production Technician - WC50', '1986-05-30', 'M', 'M', '2008-12-05',11,1, '2014-06-30'),
    ('843479922', 'adventure-works\bob0', '7AE184', 'Production Technician - WC50', '1979-08-16', 'S', 'M', '2008-12-24',12,1, '2014-06-30'),
    ('827686041', 'adventure-works\pete0', '7AE18C', 'Production Technician - WC50', '1977-02-03', 'S', 'M', '2009-01-11',13,1, '2014-06-30'),
    ('92096924', 'adventure-works\diane2', '7AE194', 'Production Technician - WC50', '1989-08-09', 'S', 'F', '2009-01-18',8,1, '2014-06-30'),
    ('494170342', 'adventure-works\john0', '7AE3', 'Production Supervisor - WC60', '1956-08-07', 'M', 'M', '2008-03-17',81,1, '2014-06-30'),
    ('414476027', 'adventure-works\maciej0', '7AE358', 'Production Technician - WC60', '1955-01-30', 'S', 'M', '2010-01-29',30,1, '2014-06-30'),
    ('582347317', 'adventure-works\michael7', '7AE368', 'Production Technician - WC60', '1973-09-05', 'S', 'M', '2010-02-23',26,1, '2014-06-30'),
    ('8066363', 'adventure-works\randy0', '7AE378', 'Production Technician - WC60', '1970-04-28', 'M', 'M', '2010-02-23',29,1, '2014-06-30'),
    ('834186596', 'adventure-works\karan0', '7AE384', 'Production Technician - WC60', '1970-03-07', 'S', 'M', '2009-12-22',28,1, '2014-06-30'),
    ('63179277', 'adventure-works\jay0', '7AE38C', 'Production Technician - WC60', '1976-02-11', 'S', 'M', '2009-03-05',32,1, '2014-06-30'),
    ('537092325', 'adventure-works\charles0', '7AE394', 'Production Technician - WC60', '1971-09-02', 'S', 'M', '2009-12-03',27,1, '2014-06-30'),
    ('752513276', 'adventure-works\steve0', '7AE39C', 'Production Technician - WC60', '1991-04-06', 'S', 'M', '2009-02-15',31,1, '2014-06-30'),
    ('36151748', 'adventure-works\david2', '7AE3A2', 'Production Technician - WC60', '1984-12-29', 'M', 'M', '2008-12-15',33,1, '2014-06-30'),
    ('578935259', 'adventure-works\michael3', '7AE5', 'Production Supervisor - WC30', '1989-01-29', 'S', 'M', '2009-02-15',70,1, '2014-06-30'),
    ('443968955', 'adventure-works\steven0', '7AE558', 'Production Technician - WC30', '1977-05-14', 'M', 'M', '2008-12-01',41,1, '2014-06-30'),
    ('138280935', 'adventure-works\carole0', '7AE568', 'Production Technician - WC30', '1983-10-19', 'M', 'F', '2008-12-19',42,1, '2014-06-30'),
    ('420023788', 'adventure-works\bjorn0', '7AE578', 'Production Technician - WC30', '1989-11-06', 'S', 'M', '2009-01-07',43,1, '2014-06-30'),
    ('363996959', 'adventure-works\michiko0', '7AE584', 'Production Technician - WC30', '1982-06-27', 'S', 'M', '2009-01-26',44,1, '2014-06-30'),
    ('227319668', 'adventure-works\carol0', '7AE58C', 'Production Technician - WC30', '1988-10-17', 'M', 'F', '2009-02-12',45,1, '2014-06-30'),
    ('301435199', 'adventure-works\merav0', '7AE594', 'Production Technician - WC30', '1983-05-13', 'M', 'F', '2009-03-03',46,1, '2014-06-30'),
    ('370989364', 'adventure-works\reuben0', '7AE7', 'Production Supervisor - WC40', '1987-08-27', 'M', 'M', '2008-12-15',72,1, '2014-06-30'),
    ('697712387', 'adventure-works\eric1', '7AE758', 'Production Technician - WC40', '1966-12-08', 'M', 'M', '2010-01-24',60,1, '2014-06-30'),
    ('943170460', 'adventure-works\sandeep0', '7AE768', 'Production Technician - WC40', '1970-12-03', 'S', 'M', '2010-01-17',65,1, '2014-06-30'),
    ('413787783', 'adventure-works\mihail0', '7AE778', 'Production Technician - WC40', '1971-03-09', 'S', 'M', '2009-12-29',64,1, '2014-06-30'),
    ('58791499', 'adventure-works\jack1', '7AE784', 'Production Technician - WC40', '1973-08-29', 'S', 'M', '2010-03-03',62,1, '2014-06-30'),
    ('988315686', 'adventure-works\patrick1', '7AE78C', 'Production Technician - WC40', '1973-12-23', 'M', 'M', '2010-02-12',61,1, '2014-06-30'),
    ('947029962', 'adventure-works\frank3', '7AE794', 'Production Technician - WC40', '1952-03-02', 'M', 'M', '2010-02-05',66,1, '2014-06-30'),
    ('1662732', 'adventure-works\brian2', '7AE79C', 'Production Technician - WC40', '1970-12-23', 'S', 'M', '2009-12-11',63,1, '2014-06-30'),
    ('769680433', 'adventure-works\ryan0', '7AE7A2', 'Production Technician - WC40', '1972-06-13', 'M', 'M', '2009-01-05',59,1, '2014-06-30'),
    ('7201901', 'adventure-works\cristian0', '7AE880', 'Production Supervisor - WC10', '1984-04-11', 'M', 'M', '2008-12-22',67,1, '2014-06-30'),
    ('294148271', 'adventure-works\betsy0', '7AE8AC', 'Production Technician - WC10', '1966-12-17', 'S', 'F', '2009-12-18',99,1, '2014-06-30'),
    ('90888098', 'adventure-works\patrick0', '7AE8B4', 'Production Technician - WC10', '1986-09-10', 'S', 'M', '2010-02-01',96,1, '2014-06-30'),
    ('82638150', 'adventure-works\danielle0', '7AE8BC', 'Production Technician - WC10', '1986-09-07', 'S', 'F', '2010-02-20',97,1, '2014-06-30'),
    ('390124815', 'adventure-works\kimberly0', '7AE8C2', 'Production Technician - WC10', '1986-09-13', 'S', 'F', '2010-01-12',95,1, '2014-06-30'),
    ('826454897', 'adventure-works\tom0', '7AE8C6', 'Production Technician - WC10', '1986-10-01', 'M', 'M', '2010-03-10',98,1, '2014-06-30'),
    ('778552911', 'adventure-works\kok-ho0', '7AE980', 'Production Supervisor - WC50', '1980-04-28', 'S', 'M', '2008-12-27',78,1, '2014-06-30'),
    ('718299860', 'adventure-works\russell0', '7AE9AC', 'Production Technician - WC50', '1972-11-25', 'M', 'M', '2008-12-12',6,1, '2014-06-30'),
    ('674171828', 'adventure-works\jim0', '7AE9B4', 'Production Technician - WC50', '1986-09-08', 'M', 'M', '2008-12-19',1,1, '2014-06-30'),
    ('912141525', 'adventure-works\elizabeth0', '7AE9BC', 'Production Technician - WC50', '1990-01-25', 'M', 'F', '2009-03-02',5,1, '2014-06-30'),
    ('370581729', 'adventure-works\mandar0', '7AE9C2', 'Production Technician - WC50', '1986-03-21', 'S', 'M', '2009-02-10',0,1, '2014-06-30'),
    ('152085091', 'adventure-works\sameer0', '7AE9C6', 'Production Technician - WC50', '1978-06-26', 'M', 'M', '2009-02-11',4,1, '2014-06-30'),
    ('431859843', 'adventure-works\nuan0', '7AE9CA', 'Production Technician - WC50', '1979-03-29', 'S', 'M', '2009-01-06',2,1, '2014-06-30'),
    ('204035155', 'adventure-works\lolan0', '7AE9CE', 'Production Technician - WC50', '1973-01-24', 'M', 'M', '2009-01-12',7,1, '2014-06-30'),
    ('153288994', 'adventure-works\houman0', '7AE9D1', 'Production Technician - WC50', '1971-08-30', 'M', 'M', '2009-01-25',3,1, '2014-06-30'),
    ('360868122', 'adventure-works\zheng0', '7AEA80', 'Production Supervisor - WC10', '1983-10-26', 'S', 'M', '2008-12-03',66,1, '2014-06-30'),
    ('455563743', 'adventure-works\ebru0', '7AEAAC', 'Production Technician - WC10', '1986-09-22', 'S', 'M', '2009-12-06',93,1, '2014-06-30'),
    ('717889520', 'adventure-works\mary1', '7AEAB4', 'Production Technician - WC10', '1986-09-19', 'M', 'F', '2009-12-25',94,1, '2014-06-30'),
    ('801365500', 'adventure-works\kevin2', '7AEABC', 'Production Technician - WC10', '1986-09-19', 'S', 'M', '2009-12-25',90,1, '2014-06-30'),
    ('561196580', 'adventure-works\john4', '7AEAC2', 'Production Technician - WC10', '1986-09-28', 'S', 'M', '2010-02-27',92,1, '2014-06-30'),
    ('393421437', 'adventure-works\christopher0', '7AEAC6', 'Production Technician - WC10', '1986-10-01', 'M', 'M', '2010-02-08',91,1, '2014-06-30'),
    ('630184120', 'adventure-works\jinghao0', '7AEB80', 'Production Supervisor - WC50', '1989-02-05', 'S', 'M', '2008-12-08',77,1, '2014-06-30'),
    ('113695504', 'adventure-works\alice0', '7AEBAC', 'Production Technician - WC50', '1978-01-26', 'M', 'F', '2008-12-07',95,1, '2014-06-30'),
    ('857651804', 'adventure-works\jun0', '7AEBB4', 'Production Technician - WC50', '1979-07-06', 'S', 'M', '2008-12-14',90,1, '2014-06-30'),
    ('415823523', 'adventure-works\suroor0', '7AEBBC', 'Production Technician - WC50', '1978-02-25', 'S', 'M', '2008-12-17',93,1, '2014-06-30'),
    ('981597097', 'adventure-works\john1', '7AEBC2', 'Production Technician - WC50', '1978-05-31', 'S', 'M', '2009-01-01',91,1, '2014-06-30'),
    ('54759846', 'adventure-works\linda0', '7AEBC6', 'Production Technician - WC50', '1987-07-17', 'M', 'F', '2008-12-25',96,1, '2014-06-30'),
    ('342607223', 'adventure-works\mindaugas0', '7AEBCA', 'Production Technician - WC50', '1978-05-07', 'M', 'M', '2009-01-13',97,1, '2014-06-30'),
    ('563680513', 'adventure-works\angela0', '7AEBCE', 'Production Technician - WC50', '1991-05-31', 'S', 'F', '2009-01-20',92,1, '2014-06-30'),
    ('398737566', 'adventure-works\michael2', '7AEBD1', 'Production Technician - WC50', '1974-05-03', 'S', 'M', '2009-01-31',98,1, '2014-06-30'),
    ('599942664', 'adventure-works\chad0', '7AEBD3', 'Production Technician - WC50', '1990-08-04', 'M', 'M', '2009-02-18',99,1, '2014-06-30'),
    ('222400012', 'adventure-works\don0', '7AEBD5', 'Production Technician - WC50', '1971-06-13', 'M', 'M', '2009-02-13',88,1, '2014-06-30'),
    ('334834274', 'adventure-works\michael4', '7AEBD7', 'Production Technician - WC50', '1989-06-15', 'S', 'M', '2009-02-25',94,1, '2014-06-30'),
    ('211789056', 'adventure-works\kitti0', '7AEBD9', 'Production Technician - WC50', '1987-06-06', 'S', 'F', '2009-03-04',89,1, '2014-06-30'),
    ('521265716', 'adventure-works\pilar0', '7AEC80', 'Shipping and Receiving Supervisor', '1972-09-09', 'S', 'M', '2009-01-02',93,1, '2014-06-30'),
    ('586486572', 'adventure-works\susan0', '7AECAC', 'Stocker', '1978-02-17', 'S', 'F', '2008-12-07',97,1, '2014-06-30'),
    ('337752649', 'adventure-works\vamsi0', '7AECB4', 'Shipping and Receiving Clerk', '1977-03-18', 'M', 'M', '2008-12-07',95,1, '2014-06-30'),
    ('420776180', 'adventure-works\kim0', '7AECBC', 'Stocker', '1984-04-30', 'S', 'F', '2008-12-26',98,1, '2014-06-30'),
    ('584205124', 'adventure-works\matthias0', '7AECC2', 'Shipping and Receiving Clerk', '1973-11-11', 'M', 'M', '2009-01-20',94,1, '2014-06-30'),
    ('652779496', 'adventure-works\jimmy0', '7AECC6', 'Stocker', '1985-05-04', 'M', 'M', '2009-02-26',96,1, '2014-06-30'),
    ('750905084', 'adventure-works\david4', '7AED80', 'Production Supervisor - WC40', '1983-07-02', 'S', 'M', '2009-01-03',73,1, '2014-06-30'),
    ('384162788', 'adventure-works\paul0', '7AEDAC', 'Production Technician - WC40', '1980-11-13', 'S', 'M', '2008-12-04',68,1, '2014-06-30'),
    ('502058701', 'adventure-works\gary0', '7AEDB4', 'Production Technician - WC40', '1988-05-16', 'S', 'M', '2008-12-22',69,1, '2014-06-30'),
    ('578953538', 'adventure-works\rob1', '7AEDBC', 'Production Technician - WC40', '1973-08-04', 'S', 'M', '2009-02-13',71,1, '2014-06-30'),
    ('273260055', 'adventure-works\baris0', '7AEDC2', 'Production Technician - WC40', '1990-10-07', 'S', 'M', '2009-02-15',72,1, '2014-06-30'),
    ('1300049', 'adventure-works\nicole0', '7AEDC6', 'Production Technician - WC40', '1986-04-09', 'M', 'F', '2009-02-22',67,1, '2014-06-30'),
    ('830150469', 'adventure-works\michael1', '7AEDCA', 'Production Technician - WC40', '1991-01-04', 'S', 'M', '2009-01-10',70,1, '2014-06-30'),
    ('45615666', 'adventure-works\eric0', '7AEE80', 'Production Supervisor - WC20', '1985-01-19', 'M', 'M', '2009-01-14',40,1, '2014-06-30'),
    ('964089218', 'adventure-works\ivo0', '7AEEAC', 'Production Technician - WC20', '1982-01-03', 'M', 'M', '2008-12-04',9,1, '2014-06-30'),
    ('701156975', 'adventure-works\sylvester0', '7AEEB4', 'Production Technician - WC20', '1970-11-12', 'M', 'M', '2009-12-11',4,1, '2014-06-30'),
    ('63761469', 'adventure-works\anibal0', '7AEEBC', 'Production Technician - WC20', '1974-09-05', 'S', 'F', '2009-02-23',8,1, '2014-06-30'),
    ('25011600', 'adventure-works\samantha0', '7AEEC2', 'Production Technician - WC20', '1987-11-22', 'M', 'F', '2009-02-04',7,1, '2014-06-30'),
    ('113393530', 'adventure-works\hung-fu0', '7AEEC6', 'Production Technician - WC20', '1971-10-23', 'S', 'M', '2010-01-06',0,1, '2014-06-30'),
    ('339233463', 'adventure-works\prasanna0', '7AEECA', 'Production Technician - WC20', '1953-04-30', 'M', 'M', '2010-01-22',5,1, '2014-06-30'),
    ('872923042', 'adventure-works\min0', '7AEECE', 'Production Technician - WC20', '1974-09-10', 'M', 'M', '2010-01-24',1,1, '2014-06-30'),
    ('163347032', 'adventure-works\olinda0', '7AEED1', 'Production Technician - WC20', '1970-04-04', 'S', 'F', '2010-03-04',3,1, '2014-06-30'),
    ('56772045', 'adventure-works\krishna0', '7AEED3', 'Production Technician - WC20', '1971-09-05', 'S', 'M', '2010-02-13',2,1, '2014-06-30'),
    ('886023130', 'adventure-works\paul1', '7AEED5', 'Production Technician - WC20', '1990-11-04', 'M', 'M', '2009-01-17',6,1, '2014-06-30'),
    ('386315192', 'adventure-works\cynthia0', '7AEF80', 'Production Supervisor - WC30', '1981-08-18', 'S', 'F', '2009-01-27',69,1, '2014-06-30'),
    ('160739235', 'adventure-works\jianshuo0', '7AEFAC', 'Production Technician - WC30', '1989-06-25', 'S', 'M', '2008-12-07',36,1, '2014-06-30'),
    ('604664374', 'adventure-works\sandra0', '7AEFB4', 'Production Technician - WC30', '1975-11-05', 'M', 'F', '2008-12-26',37,1, '2014-06-30'),
    ('733022683', 'adventure-works\jason0', '7AEFBC', 'Production Technician - WC30', '1988-12-07', 'S', 'M', '2009-01-14',38,1, '2014-06-30'),
    ('764853868', 'adventure-works\andy0', '7AEFC2', 'Production Technician - WC30', '1983-10-20', 'M', 'M', '2009-01-31',39,1, '2014-06-30'),
    ('878395493', 'adventure-works\michael5', '7AEFC6', 'Production Technician - WC30', '1982-09-18', 'M', 'M', '2009-02-26',35,1, '2014-06-30'),
    ('993310268', 'adventure-works\rostislav0', '7AEFCA', 'Production Technician - WC30', '1977-09-13', 'M', 'M', '2009-02-19',40,1, '2014-06-30'),
    ('319472946', 'adventure-works\yuhong0', '7AF044', 'Production Supervisor - WC20', '1977-04-06', 'M', 'M', '2009-02-01',41,1, '2014-06-30'),
    ('568596888', 'adventure-works\hanying0', '7AF04560', 'Production Technician - WC20', '1974-10-16', 'S', 'M', '2008-12-16',15,1, '2014-06-30'),
    ('97728960', 'adventure-works\raymond0', '7AF045A0', 'Production Technician - WC20', '1967-03-02', 'M', 'M', '2008-12-23',10,1, '2014-06-30'),
    ('212801092', 'adventure-works\fadi0', '7AF045E0', 'Production Technician - WC20', '1989-02-15', 'S', 'M', '2009-01-04',16,1, '2014-06-30'),
    ('322160340', 'adventure-works\lane0', '7AF04610', 'Production Technician - WC20', '1974-09-23', 'M', 'M', '2009-01-11',11,1, '2014-06-30'),
    ('812797414', 'adventure-works\linda1', '7AF04630', 'Production Technician - WC20', '1977-10-05', 'S', 'F', '2009-02-03',12,1, '2014-06-30'),
    ('300946911', 'adventure-works\shelley0', '7AF04650', 'Production Technician - WC20', '1986-12-08', 'S', 'F', '2009-03-07',14,1, '2014-06-30'),
    ('404159499', 'adventure-works\terrence0', '7AF04670', 'Production Technician - WC20', '1984-12-08', 'S', 'M', '2009-02-16',13,1, '2014-06-30'),
    ('712885347', 'adventure-works\jeff0', '7AF04C', 'Production Supervisor - WC45', '1977-01-15', 'M', 'M', '2009-01-21',74,1, '2014-06-30'),
    ('275962311', 'adventure-works\kirk0', '7AF04D60', 'Production Technician - WC45', '1985-02-06', 'S', 'M', '2008-12-15',74,1, '2014-06-30'),
    ('514829225', 'adventure-works\laura0', '7AF04DA0', 'Production Technician - WC45', '1980-12-25', 'S', 'F', '2009-01-03',75,1, '2014-06-30'),
    ('377784364', 'adventure-works\alex0', '7AF04DE0', 'Production Technician - WC45', '1990-04-13', 'M', 'M', '2009-02-08',77,1, '2014-06-30'),
    ('65848458', 'adventure-works\andrew1', '7AF04E10', 'Production Technician - WC45', '1988-09-24', 'S', 'M', '2009-03-06',73,1, '2014-06-30'),
    ('539490372', 'adventure-works\chris0', '7AF04E30', 'Production Technician - WC45', '1988-12-16', 'M', 'M', '2009-01-22',76,1, '2014-06-30'),
    ('60114406', 'adventure-works\jack0', '7AF054', 'Production Supervisor - WC30', '1983-06-22', 'S', 'M', '2009-02-21',68,1, '2014-06-30'),
    ('498138869', 'adventure-works\david1', '7AF05560', 'Production Technician - WC30', '1979-11-02', 'S', 'M', '2008-12-02',25,1, '2014-06-30'),
    ('271438431', 'adventure-works\garrett0', '7AF055A0', 'Production Technician - WC30', '1984-08-25', 'S', 'M', '2008-12-07',34,1, '2014-06-30'),
    ('351069889', 'adventure-works\susan1', '7AF055E0', 'Production Technician - WC30', '1983-04-02', 'S', 'F', '2008-12-14',31,1, '2014-06-30'),
    ('476115505', 'adventure-works\george0', '7AF05610', 'Production Technician - WC30', '1977-04-16', 'M', 'M', '2008-12-21',26,1, '2014-06-30'),
    ('746373306', 'adventure-works\david3', '7AF05630', 'Production Technician - WC30', '1981-08-03', 'S', 'M', '2009-01-02',32,1, '2014-06-30'),
    ('364818297', 'adventure-works\marc0', '7AF05650', 'Production Technician - WC30', '1986-10-24', 'M', 'M', '2009-01-16',22,1, '2014-06-30'),
    ('87268837', 'adventure-works\eugene0', '7AF05670', 'Production Technician - WC30', '1987-07-15', 'S', 'M', '2009-01-21',33,1, '2014-06-30'),
    ('585408256', 'adventure-works\benjamin0', '7AF05688', 'Production Technician - WC30', '1986-01-05', 'S', 'M', '2009-01-27',28,1, '2014-06-30'),
    ('259388196', 'adventure-works\reed0', '7AF05698', 'Production Technician - WC30', '1989-01-08', 'M', 'M', '2009-02-02',23,1, '2014-06-30'),
    ('860123571', 'adventure-works\david7', '7AF056A8', 'Production Technician - WC30', '1985-09-23', 'M', 'M', '2009-02-14',29,1, '2014-06-30'),
    ('551346974', 'adventure-works\russell1', '7AF056B8', 'Production Technician - WC30', '1982-02-11', 'M', 'M', '2009-02-21',24,1, '2014-06-30'),
    ('568626529', 'adventure-works\john3', '7AF056C8', 'Production Technician - WC30', '1982-03-24', 'S', 'M', '2009-03-03',27,1, '2014-06-30'),
    ('587567941', 'adventure-works\jan0', '7AF056D8', 'Production Technician - WC30', '1974-11-15', 'S', 'M', '2009-03-05',30,1, '2014-06-30'),
    ('862951447', 'adventure-works\katie0', '7AF05C', 'Production Supervisor - WC20', '1984-11-18', 'S', 'F', '2009-02-20',42,1, '2014-06-30'),
    ('545337468', 'adventure-works\michael0', '7AF05D60', 'Production Technician - WC20', '1984-11-17', 'S', 'M', '2008-12-09',20,1, '2014-06-30'),
    ('368920189', 'adventure-works\nitin0', '7AF05DA0', 'Production Technician - WC20', '1986-12-01', 'S', 'M', '2008-12-28',21,1, '2014-06-30'),
    ('969985265', 'adventure-works\barbara0', '7AF05DE0', 'Production Technician - WC20', '1979-07-02', 'M', 'F', '2009-01-22',17,1, '2014-06-30'),
    ('305522471', 'adventure-works\john2', '7AF05E10', 'Production Technician - WC20', '1986-04-05', 'M', 'M', '2009-02-09',18,1, '2014-06-30'),
    ('621932914', 'adventure-works\stefen0', '7AF05E30', 'Production Technician - WC20', '1975-12-21', 'S', 'M', '2009-02-28',19,1, '2014-06-30'),
    ('551834634', 'adventure-works\shane0', '7AF064', 'Production Supervisor - WC45', '1990-05-24', 'S', 'M', '2009-02-08',75,1, '2014-06-30'),
    ('713403643', 'adventure-works\yvonne0', '7AF06560', 'Production Technician - WC45', '1989-04-15', 'M', 'F', '2008-12-09',79,1, '2014-06-30'),
    ('435234965', 'adventure-works\douglas0', '7AF065A0', 'Production Technician - WC45', '1985-11-24', 'M', 'M', '2008-12-27',80,1, '2014-06-30'),
    ('187369436', 'adventure-works\janeth0', '7AF065E0', 'Production Technician - WC45', '1972-07-24', 'S', 'F', '2009-01-15',81,1, '2014-06-30'),
    ('456839592', 'adventure-works\robert0', '7AF06610', 'Production Technician - WC45', '1985-02-28', 'S', 'M', '2009-02-02',82,1, '2014-06-30'),
    ('399658727', 'adventure-works\lionel0', '7AF06630', 'Production Technician - WC45', '1988-03-14', 'S', 'M', '2009-02-26',78,1, '2014-06-30'),
    ('634335025', 'adventure-works\brenda0', '7AF06C', 'Production Supervisor - WC40', '1983-02-28', 'M', 'F', '2009-03-05',71,1, '2014-06-30'),
    ('761597760', 'adventure-works\alejandro0', '7AF06D60', 'Production Technician - WC40', '1988-12-05', 'S', 'M', '2008-12-06',52,1, '2014-06-30'),
    ('295971920', 'adventure-works\fred0', '7AF06DA0', 'Production Technician - WC40', '1989-06-25', 'S', 'M', '2008-12-12',47,1, '2014-06-30'),
    ('918737118', 'adventure-works\kevin1', '7AF06DE0', 'Production Technician - WC40', '1985-12-25', 'S', 'M', '2008-12-17',58,1, '2014-06-30'),
    ('370487086', 'adventure-works\shammi0', '7AF06E10', 'Production Technician - WC40', '1980-10-04', 'M', 'M', '2008-12-24',53,1, '2014-06-30'),
    ('632092621', 'adventure-works\rajesh0', '7AF06E30', 'Production Technician - WC40', '1977-10-04', 'M', 'M', '2008-12-31',48,1, '2014-06-30'),
    ('19312190', 'adventure-works\lorraine0', '7AF06E50', 'Production Technician - WC40', '1988-11-26', 'M', 'F', '2009-01-04',49,1, '2014-06-30'),
    ('992874797', 'adventure-works\paula1', '7AF06E70', 'Production Technician - WC40', '1987-02-10', 'M', 'F', '2009-01-12',54,1, '2014-06-30'),
    ('749211824', 'adventure-works\frank0', '7AF06E88', 'Production Technician - WC40', '1987-09-06', 'M', 'M', '2009-01-17',56,1, '2014-06-30'),
    ('746201340', 'adventure-works\brian0', '7AF06E98', 'Production Technician - WC40', '1977-02-10', 'S', 'M', '2009-01-29',55,1, '2014-06-30'),
    ('436757988', 'adventure-works\tawana0', '7AF06EA8', 'Production Technician - WC40', '1989-11-10', 'S', 'M', '2009-02-05',50,1, '2014-06-30'),
    ('693168613', 'adventure-works\ken1', '7AF06EB8', 'Production Technician - WC40', '1981-05-28', 'M', 'M', '2009-02-24',51,1, '2014-06-30'),
    ('440379437', 'adventure-works\gabe0', '7AF06EC8', 'Production Technician - WC40', '1988-05-10', 'M', 'M', '2009-03-08',57,1, '2014-06-30'),
    ('332349500', 'adventure-works\lori0', '7AF074', 'Production Supervisor - WC45', '1980-07-18', 'S', 'F', '2009-02-26',76,1, '2014-06-30'),
    ('835460180', 'adventure-works\stuart0', '7AF07560', 'Production Technician - WC45', '1962-09-13', 'S', 'M', '2008-12-02',84,1, '2014-06-30'),
    ('687685941', 'adventure-works\greg0', '7AF075A0', 'Production Technician - WC45', '1970-10-18', 'S', 'M', '2008-12-02',85,1, '2014-06-30'),
    ('199546871', 'adventure-works\scott0', '7AF075E0', 'Production Technician - WC45', '1987-02-10', 'M', 'M', '2009-01-08',86,1, '2014-06-30'),
    ('167554340', 'adventure-works\kathie0', '7AF07610', 'Production Technician - WC45', '1990-11-01', 'M', 'F', '2009-01-27',87,1, '2014-06-30'),
    ('20244403', 'adventure-works\belinda0', '7AF07630', 'Production Technician - WC45', '1969-09-17', 'S', 'F', '2009-02-20',83,1, '2014-06-30'),
    ('398223854', 'adventure-works\hazem0', '7B40', 'Quality Assurance Manager', '1977-10-26', 'S', 'M', '2009-02-28',80,1, '2014-12-26'),
    ('885055826', 'adventure-works\peng0', '7B56', 'Quality Assurance Supervisor', '1976-03-18', 'M', 'M', '2008-12-09',81,1, '2014-06-30'),
    ('343861179', 'adventure-works\sootha0', '7B56B0', 'Quality Assurance Technician', '1966-12-05', 'M', 'M', '2010-02-23',85,1, '2014-06-30'),
    ('131471224', 'adventure-works\andreas0', '7B56D0', 'Quality Assurance Technician', '1989-03-28', 'M', 'M', '2009-02-02',84,1, '2014-06-30'),
    ('381772114', 'adventure-works\mark0', '7B56F0', 'Quality Assurance Technician', '1986-04-30', 'S', 'M', '2009-01-15',83,1, '2014-06-30'),
    ('403414852', 'adventure-works\sean0', '7B5708', 'Quality Assurance Technician', '1976-03-06', 'S', 'M', '2008-12-28',82,1, '2014-06-30'),
    ('345106466', 'adventure-works\zainal0', '7B5A', 'Document Control Manager', '1976-01-30', 'M', 'M', '2009-01-04',77,1, '2014-06-30'),
    ('540688287', 'adventure-works\tengiz0', '7B5AB0', 'Control Specialist', '1990-04-28', 'S', 'M', '2008-12-16',76,1, '2014-06-30'),
    ('242381745', 'adventure-works\sean1', '7B5AD0', 'Document Control Assistant', '1987-03-12', 'S', 'M', '2009-01-22',78,1, '2014-06-30'),
    ('260770918', 'adventure-works\karen0', '7B5AF0', 'Document Control Assistant', '1975-12-25', 'M', 'F', '2009-02-09',79,1, '2014-06-30'),
    ('260805477', 'adventure-works\chris1', '7B5B08', 'Control Specialist', '1987-05-26', 'M', 'M', '2009-03-06',75,1, '2014-06-30'),
    ('685233686', 'adventure-works\ascott0', '7BC0', 'Master Scheduler', '1968-09-17', 'S', 'M', '2008-12-12',44,1, '2014-12-26'),
    ('981495526', 'adventure-works\sairaj0', '7BD6', 'Scheduling Assistant', '1987-12-22', 'M', 'M', '2009-01-26',46,1, '2014-06-30'),
    ('621209647', 'adventure-works\william0', '7BDA', 'Scheduling Assistant', '1981-11-06', 'M', 'M', '2009-01-07',45,1, '2014-06-30'),
    ('470689086', 'adventure-works\alan0', '7BDE', 'Scheduling Assistant', '1984-03-29', 'M', 'M', '2009-02-13',47,1, '2014-06-30'),
    ('368691270', 'adventure-works\brian1', '7BE1', 'Scheduling Assistant', '1984-08-11', 'M', 'M', '2009-03-03',48,1, '2014-06-30'),
    ('141165819', 'adventure-works\gary1', '7C20', 'Facilities Manager', '1971-02-18', 'M', 'M', '2009-12-02',86,1, '2014-06-30'),
    ('553069203', 'adventure-works\christian0', '7C2B', 'Maintenance Supervisor', '1976-01-18', 'M', 'M', '2008-12-14',92,1, '2014-06-30'),
    ('879334904', 'adventure-works\lori1', '7C2B58', 'Janitor', '1970-07-31', 'M', 'F', '2010-02-16',90,1, '2014-06-30'),
    ('28414965', 'adventure-works\stuart1', '7C2B68', 'Janitor', '1971-12-17', 'M', 'M', '2010-03-05',88,1, '2014-06-30'),
    ('153479919', 'adventure-works\jo1', '7C2B78', 'Janitor', '1954-04-24', 'M', 'F', '2010-03-07',91,1, '2014-06-30'),
    ('646304055', 'adventure-works\pat0', '7C2B84', 'Janitor', '1970-12-03', 'S', 'M', '2010-01-27',89,1, '2014-06-30'),
    ('552560652', 'adventure-works\magnus0', '7C2D', 'Facilities Administrative Assistant', '1971-08-27', 'M', 'M', '2009-12-21',87,1, '2014-06-30'),
    ('184188301', 'adventure-works\laura1', '84', 'Chief Financial Officer', '1976-01-06', 'M', 'F', '2009-01-31',0,1, '2014-06-30'),
    ('535145551', 'adventure-works\paula0', '8560', 'Human Resources Manager', '1976-02-11', 'M', 'F', '2008-12-06',54,1, '2014-06-30'),
    ('476980013', 'adventure-works\grant0', '856B', 'Human Resources Administrative Assistant', '1976-04-16', 'S', 'M', '2009-02-25',53,1, '2014-06-30'),
    ('416679555', 'adventure-works\hao0', '856D', 'Human Resources Administrative Assistant', '1977-04-17', 'S', 'M', '2009-02-06',52,1, '2014-06-30'),
    ('264306399', 'adventure-works\vidur0', '856F', 'Recruiter', '1984-08-01', 'S', 'M', '2009-01-01',50,1, '2014-06-30'),
    ('619308550', 'adventure-works\mindy0', '857080', 'Benefits Specialist', '1984-11-20', 'M', 'F', '2008-12-25',51,1, '2014-06-30'),
    ('332040978', 'adventure-works\willis0', '857180', 'Recruiter', '1978-07-18', 'S', 'M', '2008-12-13',49,1, '2014-06-30'),
    ('30845', 'adventure-works\david6', '85A0', 'Accounts Manager', '1983-07-08', 'M', 'M', '2009-01-30',57,1, '2014-06-30'),
    ('363923697', 'adventure-works\deborah0', '85AB', 'Accounts Receivable Specialist', '1976-03-06', 'M', 'F', '2008-12-18',60,1, '2014-06-30'),
    ('60517918', 'adventure-works\candy0', '85AD', 'Accounts Receivable Specialist', '1976-02-23', 'S', 'F', '2009-01-06',61,1, '2014-06-30'),
    ('931190412', 'adventure-works\bryan1', '85AF', 'Accounts Receivable Specialist', '1984-09-20', 'S', 'M', '2009-01-24',62,1, '2014-06-30'),
    ('363910111', 'adventure-works\barbara1', '85B080', 'Accountant', '1976-01-04', 'M', 'F', '2009-02-18',58,1, '2014-06-30'),
    ('663843431', 'adventure-works\dragan0', '85B180', 'Accounts Payable Specialist', '1977-02-14', 'M', 'M', '2009-02-11',63,1, '2014-06-30'),
    ('519756660', 'adventure-works\janet0', '85B280', 'Accounts Payable Specialist', '1979-03-09', 'M', 'F', '2009-03-01',64,1, '2014-06-30'),
    ('480951955', 'adventure-works\mike0', '85B380', 'Accountant', '1979-07-01', 'S', 'M', '2009-03-08',59,1, '2014-06-30'),
    ('121491555', 'adventure-works\wendy0', '85E0', 'Finance Manager', '1984-10-11', 'S', 'F', '2008-12-25',55,1, '2014-06-30'),
    ('895209680', 'adventure-works\sheela0', '85EB', 'Purchasing Manager', '1978-02-10', 'S', 'F', '2011-02-25',49,1, '2014-06-30'),
    ('603686790', 'adventure-works\mikael0', '85EB58', 'Buyer', '1984-08-17', 'S', 'M', '2009-02-10',59,1, '2014-06-30'),
    ('792847334', 'adventure-works\arvind0', '85EB68', 'Buyer', '1974-08-21', 'M', 'M', '2009-02-28',60,1, '2014-06-30'),
    ('407505660', 'adventure-works\linda2', '85EB78', 'Buyer', '1970-11-30', 'M', 'F', '2009-12-17',56,1, '2014-06-30'),
    ('482810518', 'adventure-works\fukiko0', '85EB84', 'Buyer', '1970-11-24', 'M', 'M', '2010-01-04',57,1, '2014-06-30'),
    ('466142721', 'adventure-works\gordon0', '85EB8C', 'Buyer', '1966-11-29', 'M', 'M', '2010-01-11',52,1, '2014-06-30'),
    ('367453993', 'adventure-works\frank2', '85EB94', 'Buyer', '1952-05-12', 'M', 'M', '2010-01-23',58,1, '2014-06-30'),
    ('381073001', 'adventure-works\eric2', '85EB9C', 'Buyer', '1972-09-17', 'S', 'M', '2010-01-27',54,1, '2014-06-30'),
    ('785853949', 'adventure-works\erin0', '85EBA2', 'Buyer', '1971-01-04', 'S', 'F', '2010-01-31',53,1, '2014-06-30'),
    ('20269531', 'adventure-works\ben0', '85EBA6', 'Buyer', '1973-06-03', 'M', 'M', '2010-03-09',55,1, '2014-06-30'),
    ('437296311', 'adventure-works\annette0', '85EBAA', 'Purchasing Assistant', '1978-01-29', 'M', 'F', '2010-12-06',50,1, '2014-06-30'),
    ('280633567', 'adventure-works\reinout0', '85EBAE', 'Purchasing Assistant', '1978-01-17', 'M', 'M', '2010-12-25',51,1, '2014-06-30'),
    ('231203233', 'adventure-works\david5', '8610', 'Assistant to the Chief Financial Officer', '1964-06-21', 'S', 'M', '2009-01-12',56,1, '2014-06-30'),
    ('441044382', 'adventure-works\jean0', '8C', 'Information Services Manager', '1975-12-13', 'S', 'F', '2008-12-11',65,1, '2014-06-30'),
    ('858323870', 'adventure-works\stephanie0', '8D60', 'Network Manager', '1984-03-25', 'S', 'F', '2009-02-04',68,1, '2014-06-30'),
    ('749389530', 'adventure-works\ashvini0', '8D6B', 'Network Administrator', '1977-03-27', 'S', 'M', '2008-12-04',70,1, '2014-06-30'),
    ('672243793', 'adventure-works\peter1', '8D6D', 'Network Administrator', '1980-05-28', 'S', 'M', '2009-02-23',69,1, '2014-06-30'),
    ('58317344', 'adventure-works\karen1', '8DA0', 'Application Specialist', '1978-05-19', 'S', 'F', '2009-02-16',74,1, '2014-06-30'),
    ('314747499', 'adventure-works\ramesh0', '8DE0', 'Application Specialist', '1988-03-13', 'S', 'M', '2009-02-03',73,1, '2014-06-30'),
    ('671089628', 'adventure-works\dan0', '8E10', 'Application Specialist', '1987-05-26', 'M', 'M', '2009-01-11',72,1, '2014-06-30'),
    ('643805155', 'adventure-works\fran√ßois0', '8E30', 'Database Administrator', '1975-05-17', 'S', 'M', '2009-01-17',67,1, '2014-06-30'),
    ('929666391', 'adventure-works\dan1', '8E50', 'Database Administrator', '1976-01-06', 'M', 'M', '2009-01-22',66,1, '2014-06-30'),
    ('525932996', 'adventure-works\janaina0', '8E70', 'Application Specialist', '1985-01-30', 'M', 'F', '2008-12-23',71,1, '2014-06-30'),
    ('112432117', 'adventure-works\brian3', '94', 'Vice President of Sales', '1977-06-06', 'S', 'M', '2011-02-15',10,1, '2014-06-30'),
    ('502097814', 'adventure-works\stephen0', '9560', 'North American Sales Manager', '1951-10-17', 'M', 'M', '2011-01-04',14,1, '2014-06-30'),
    ('841560125', 'adventure-works\michael9', '956B', 'Sales Representative', '1968-12-25', 'S', 'M', '2011-05-31',38,1, '2014-06-30'),
    ('191644724', 'adventure-works\linda3', '956D', 'Sales Representative', '1980-02-27', 'M', 'F', '2011-05-31',27,1, '2014-06-30'),
    ('615389812', 'adventure-works\jillian0', '956F', 'Sales Representative', '1962-08-29', 'S', 'F', '2011-05-31',24,1, '2014-06-30'),
    ('234474252', 'adventure-works\garrett1', '957080', 'Sales Representative', '1975-02-04', 'M', 'M', '2011-05-31',33,1, '2014-06-30'),
    ('716374314', 'adventure-works\tsvi0', '957180', 'Sales Representative', '1974-01-18', 'M', 'M', '2011-05-31',29,1, '2014-06-30'),
    ('61161660', 'adventure-works\pamela0', '957280', 'Sales Representative', '1974-12-06', 'S', 'F', '2011-05-31',22,1, '2014-06-30'),
    ('139397894', 'adventure-works\shu0', '957380', 'Sales Representative', '1968-03-09', 'M', 'M', '2011-05-31',26,1, '2014-06-30'),
    ('399771412', 'adventure-works\jos√©1', '957440', 'Sales Representative', '1963-12-11', 'M', 'M', '2011-05-31',31,1, '2014-06-30'),
    ('987554265', 'adventure-works\david8', '9574C0', 'Sales Representative', '1974-02-11', 'S', 'M', '2011-05-31',23,1, '2014-06-30'),
    ('90836195', 'adventure-works\tete0', '957540', 'Sales Representative', '1978-01-05', 'M', 'M', '2012-09-30',39,1, '2014-06-30'),
    ('481044938', 'adventure-works\syed0', '95A0', 'Pacific Sales Manager', '1975-01-11', 'M', 'M', '2013-03-14',20,1, '2014-06-30'),
    ('758596752', 'adventure-works\lynn0', '95AB', 'Sales Representative', '1977-02-14', 'S', 'F', '2013-05-30',36,1, '2014-06-30'),
    ('982310417', 'adventure-works\amy0', '95E0', 'European Sales Manager', '1957-09-20', 'M', 'F', '2012-04-16',21,1, '2014-06-30'),
    ('954276278', 'adventure-works\rachel0', '95EB', 'Sales Representative', '1975-07-09', 'S', 'F', '2013-05-30',35,1, '2014-06-30'),
    ('668991357', 'adventure-works\jae0', '95ED', 'Sales Representative', '1968-03-17', 'M', 'F', '2012-05-30',37,1, '2014-06-30'),
    ('134219713', 'adventure-works\ranjit0', '95EF', 'Sales Representative', '1975-09-30', 'S', 'M', '2012-05-30',34,1, '2014-06-30');
SET DATEFORMAT ymd;
INSERT INTO bobsusedbookstore_dbo.person (;
    businessentityid, persontype, namestyle, title, firstname,
    middlename, lastname, suffix, emailpromotion, additionalcontactinfo,
    demographics, rowguid, modifieddate
) VALUES
    (1, 'EM', 0, NULL, 'Ken', 'J', 'Sánchez', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '92C4279F-1207-48A3-8448-4636514EB7E2', CAST('2009-01-07T00:00:00' AS TIMESTAMP)),
    (2, 'EM', 0, NULL, 'Terri', 'Lee', 'Duffy', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'D8763459-8AA8-47CC-AFF7-C9079AF79033', CAST('2008-01-24T00:00:00' AS TIMESTAMP)),
    (3, 'EM', 0, NULL, 'Roberto', NULL, 'Tamburello', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'E1A2555E-0828-434B-A33B-6F38136A37DE', CAST('2007-11-04T00:00:00' AS TIMESTAMP)),
    (4, 'EM', 0, NULL, 'Rob', NULL, 'Walters', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'F2D7CE06-38B3-4357-805B-F4B6B71C01FF', CAST('2007-11-28T00:00:00' AS TIMESTAMP)),
    (5, 'EM', 0, 'Ms.', 'Gail', 'A', 'Erickson', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'F3A3F6B4-AE3B-430C-A754-9F2231BA6FEF', CAST('2007-12-30T00:00:00' AS TIMESTAMP)),
    (6, 'EM', 0, 'Mr.', 'Jossef', 'H', 'Goldberg', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '0DEA28FD-EFFE-482A-AFD3-B7E8F199D56F', CAST('2013-12-16T00:00:00' AS TIMESTAMP)),
    (7, 'EM', 0, NULL, 'Dylan', 'A', 'Miller', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'C45E8AB8-01BE-4B76-B215-820C8368181A', CAST('2009-02-01T00:00:00' AS TIMESTAMP)),
    (8, 'EM', 0, NULL, 'Diane', 'L', 'Margheim', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'A948E590-4A56-45A9-BC9A-160A1CC9D990', CAST('2008-12-22T00:00:00' AS TIMESTAMP)),
    (9, 'EM', 0, NULL, 'Gigi', '', 'Matthew', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '5FC28C0E-6D36-4252-9846-05CAA0B1F6C5', CAST('2009-01-09T00:00:00' AS TIMESTAMP)),
    (10, 'EM', 0, NULL, 'Michael', NULL, 'Raheem', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'CA2C740E-75B2-420C-9D4B-E3CBC6609604', CAST('2009-04-26T00:00:00' AS TIMESTAMP)),
    (11, 'EM', 0, NULL, 'Ovidiu', 'V', 'Cracium', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'D2CC2577-EF6B-4408-BD8C-747337FE5645', CAST('2010-11-28T00:00:00' AS TIMESTAMP)),
    (12, 'EM', 0, NULL, 'Thierry', 'B', 'D''Hers', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'FA263C7F-600D-4E89-8DCD-0978F3530F5F', CAST('2007-12-04T00:00:00' AS TIMESTAMP)),
    (13, 'EM', 0, 'Ms.', 'Janice', 'M', 'Galvin', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '34EB99E0-7042-4DC1-A2FD-BDA290FF0E07', CAST('2010-12-16T00:00:00' AS TIMESTAMP)),
    (14, 'EM', 0, NULL, 'Michael', 'I', 'Sullivan', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '9A7501DE-5CAF-4700-AB07-CC81102BB696', CAST('2010-12-23T00:00:00' AS TIMESTAMP)),
    (15, 'EM', 0, NULL, 'Sharon', 'B', 'Salavaria', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'BEBA63CB-13F1-4B76-A3DE-FE9AC283A94C', CAST('2011-01-11T00:00:00' AS TIMESTAMP)),
    (16, 'EM', 0, NULL, 'David', 'M', 'Bradley', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '2CC8BA72-5DBB-497F-B941-775517993638', CAST('2007-12-13T00:00:00' AS TIMESTAMP)),
    (17, 'EM', 0, NULL, 'Kevin', 'F', 'Brown', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '9EE4713E-B3D8-4409-BC5E-DEC62497F43A', CAST('2007-01-19T00:00:00' AS TIMESTAMP)),
    (18, 'EM', 0, NULL, 'John', 'L', 'Wood', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'FE21BDA7-9327-4D13-89CC-8CA5CEE8F21E', CAST('2011-01-31T00:00:00' AS TIMESTAMP)),
    (19, 'EM', 0, NULL, 'Mary', 'A', 'Dempsey', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '36F04305-6769-4E61-9143-048B2B7AFA20', CAST('2011-02-07T00:00:00' AS TIMESTAMP)),
    (20, 'EM', 0, NULL, 'Wanida', 'M', 'Benshoof', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '1E7E56F4-A583-4E3F-A3FE-BA8A71096D10', CAST('2010-12-31T00:00:00' AS TIMESTAMP)),
    (21, 'EM', 0, NULL, 'Terry', 'J', 'Eminhizer', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '6A288FE0-D9CB-4DA2-BEEA-51370220490C', CAST('2009-02-23T00:00:00' AS TIMESTAMP)),
    (22, 'EM', 0, NULL, 'Sariya', 'E', 'Harnpadoungsataya', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '276E0EB5-0CE7-443F-987F-B7EF293C0930', CAST('2008-12-05T00:00:00' AS TIMESTAMP)),
    (23, 'EM', 0, NULL, 'Mary', 'E', 'Gibson', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'B10CF8EB-5589-4A81-B1BD-051C5759CE06', CAST('2009-01-05T00:00:00' AS TIMESTAMP)),
    (24, 'EM', 0, 'Ms.', 'Jill', 'A', 'Williams', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '3F605060-96AD-4201-9BE2-BFE7A3C4E468', CAST('2009-01-11T00:00:00' AS TIMESTAMP)),
    (25, 'EM', 0, NULL, 'James', 'R', 'Hamilton', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '423FE59B-7975-4A7E-B8D2-87105C286D4C', CAST('2009-01-27T00:00:00' AS TIMESTAMP)),
    (26, 'EM', 0, NULL, 'Peter', 'J', 'Krebs', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '6F32F507-290E-4A96-A045-F445EAE4337F', CAST('2008-11-24T00:00:00' AS TIMESTAMP)),
    (27, 'EM', 0, NULL, 'Jo', 'A', 'Brown', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'EDD8ADD6-F7FD-4086-BFDC-B4FD3E6AD8D7', CAST('2008-02-20T00:00:00' AS TIMESTAMP)),
    (28, 'EM', 0, NULL, 'Guy', 'R', 'Gilbert', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'D366A33A-8EDE-42BD-BF79-3E7FB9713FE1', CAST('2006-06-23T00:00:00' AS TIMESTAMP)),
    (29, 'EM', 0, NULL, 'Mark', 'K', 'McArthur', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '667FA3BA-B877-4BCC-A752-E461040E2DDD', CAST('2009-01-16T00:00:00' AS TIMESTAMP)),
    (30, 'EM', 0, NULL, 'Britta', 'L', 'Simon', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '5090C9A8-E39E-4A4D-9133-14E7CF07998B', CAST('2009-01-22T00:00:00' AS TIMESTAMP)),
    (31, 'EM', 0, NULL, 'Margie', 'W', 'Shoop', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '5EA8A3DA-7BEA-4ADC-85F5-C934E2033825', CAST('2008-12-28T00:00:00' AS TIMESTAMP)),
    (32, 'EM', 0, NULL, 'Rebecca', 'A', 'Laszlo', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '686BD5AF-6F30-4633-944B-3C1916CB4CA2', CAST('2008-12-22T00:00:00' AS TIMESTAMP)),
    (33, 'EM', 0, NULL, 'Annik', 'O', 'Stahl', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'BFA2BDC8-208A-447B-8A4E-72A215E9E134', CAST('2008-12-10T00:00:00' AS TIMESTAMP)),
    (34, 'EM', 0, NULL, 'Suchitra', 'O', 'Mohan', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '7E239D8B-00BF-42D6-AC6B-4EA718DBC2B3', CAST('2009-02-09T00:00:00' AS TIMESTAMP)),
    (35, 'EM', 0, NULL, 'Brandon', 'G', 'Heidepriem', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '4CC8EDC2-5502-4550-8089-9B3CC6006490', CAST('2009-02-01T00:00:00' AS TIMESTAMP)),
    (36, 'EM', 0, NULL, 'Jose', 'R', 'Lugo', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '54655E98-B81A-4041-8FA4-9349C018521F', CAST('2009-02-03T00:00:00' AS TIMESTAMP)),
    (37, 'EM', 0, NULL, 'Chris', 'O', 'Okelberry', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '5B16CA18-703B-48E8-AB3E-CA158C854808', CAST('2009-02-28T00:00:00' AS TIMESTAMP)),
    (38, 'EM', 0, NULL, 'Kim', 'B', 'Abercrombie', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '9A2163B3-2F4D-4F9A-91BD-07D326140F9C', CAST('2010-01-09T00:00:00' AS TIMESTAMP)),
    (39, 'EM', 0, NULL, 'Ed', 'R', 'Dudenhoefer', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '83C88383-9C3E-42C5-AE09-965B5F9EF5B1', CAST('2010-01-29T00:00:00' AS TIMESTAMP)),
    (40, 'EM', 0, NULL, 'JoLynn', 'M', 'Dobney', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'E8E5C9DA-F808-4439-BF5C-B28236BB8467', CAST('2007-12-19T00:00:00' AS TIMESTAMP)),
    (41, 'EM', 0, NULL, 'Bryan', NULL, 'Baker', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'A32E8274-08DC-4596-AB1F-BA6263CBC676', CAST('2009-01-14T00:00:00' AS TIMESTAMP)),
    (42, 'EM', 0, NULL, 'James', 'D', 'Kramer', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'F4F040E0-02A0-4905-B964-2E894D0F0B94', CAST('2008-12-20T00:00:00' AS TIMESTAMP)),
    (43, 'EM', 0, NULL, 'Nancy', 'A', 'Anderson', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '0681C8F9-D2EC-47D9-9BD4-751B14EAED50', CAST('2008-12-26T00:00:00' AS TIMESTAMP)),
    (44, 'EM', 0, NULL, 'Simon', 'D', 'Rapier', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'FF8EDBFC-A9A3-4C5D-8AFF-DF4D6F18DAFF', CAST('2008-12-01T00:00:00' AS TIMESTAMP)),
    (45, 'EM', 0, NULL, 'Thomas', 'R', 'Michaels', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '2CAF9ADC-7A33-48CF-B4B7-3C57D9DE39C4', CAST('2009-02-19T00:00:00' AS TIMESTAMP)),
    (46, 'EM', 0, NULL, 'Eugene', 'O', 'Kogan', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'FB0068EA-49D4-4E82-9895-2680CF59385E', CAST('2009-02-01T00:00:00' AS TIMESTAMP)),
    (47, 'EM', 0, NULL, 'Andrew', 'R', 'Hill', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'B6439F4F-E57D-4293-B0C8-8919591055A3', CAST('2009-02-15T00:00:00' AS TIMESTAMP)),
    (48, 'EM', 0, NULL, 'Ruth', 'Ann', 'Ellerbrock', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '9BE35B50-2024-4785-9393-7C7AB8D9634D', CAST('2007-12-30T00:00:00' AS TIMESTAMP)),
    (49, 'EM', 0, NULL, 'Barry', 'K', 'Johnson', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'CB28BE2E-DE93-4409-BACE-DF6042D04815', CAST('2013-11-29T00:00:00' AS TIMESTAMP)),
    (50, 'EM', 0, NULL, 'Sidney', 'M', 'Higa', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'A20BB9F5-3BBB-4AB6-9BFA-6AED32C30204', CAST('2008-01-26T00:00:00' AS TIMESTAMP)),
    (51, 'EM', 0, NULL, 'Jeffrey', 'L', 'Ford', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '293DF609-2FA3-4C00-A891-ACE08661FE70', CAST('2008-02-13T00:00:00' AS TIMESTAMP)),
    (52, 'EM', 0, NULL, 'Doris', 'M', 'Hartwig', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '075AB67F-BFBD-4433-B33E-C65B2C045B6B', CAST('2014-01-31T00:00:00' AS TIMESTAMP)),
    (53, 'EM', 0, NULL, 'Diane', 'R', 'Glimp', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '9EA27F41-36BB-4456-A506-2B87C416FB0C', CAST('2008-03-21T00:00:00' AS TIMESTAMP)),
    (54, 'EM', 0, NULL, 'Bonnie', '', 'Kearney', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'AB066D28-404A-436E-A17A-789D7F2638D3', CAST('2009-12-25T00:00:00' AS TIMESTAMP)),
    (55, 'EM', 0, NULL, 'Taylor', 'R', 'Maxwell', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '9F81714B-0C9C-43C3-8DF5-180CB0A42D40', CAST('2013-12-31T00:00:00' AS TIMESTAMP)),
    (56, 'EM', 0, NULL, 'Denise', 'H', 'Smith', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '77F4AC33-E165-49D7-BC6A-F3C2DC069C9B', CAST('2009-01-29T00:00:00' AS TIMESTAMP)),
    (57, 'EM', 0, NULL, 'Frank', 'T', 'Miller', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '05516FB2-586E-43F5-A87C-5E236F8DB8AD', CAST('2009-02-16T00:00:00' AS TIMESTAMP)),
    (58, 'EM', 0, NULL, 'Kendall', 'C', 'Keil', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'CA8D648A-166B-4D61-9AE0-A0B1FFECFB1B', CAST('2008-11-28T00:00:00' AS TIMESTAMP)),
    (59, 'EM', 0, NULL, 'Bob', '', 'Hohman', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '6384295C-C932-47C0-8E97-71D94F83CD31', CAST('2008-12-17T00:00:00' AS TIMESTAMP)),
    (60, 'EM', 0, NULL, 'Pete', 'C', 'Male', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '0AEB5713-8BB0-4B8D-BF81-777158E5FF09', CAST('2009-01-04T00:00:00' AS TIMESTAMP)),
    (61, 'EM', 0, NULL, 'Diane', 'H', 'Tibbott', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'E054FFC1-258C-4DA4-B2C1-40E155F4C88B', CAST('2009-01-11T00:00:00' AS TIMESTAMP)),
    (62, 'EM', 0, NULL, 'John', 'T', 'Campbell', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'F5A4CC1B-AEFA-46CA-8888-2CA1C6D4034B', CAST('2014-02-07T00:00:00' AS TIMESTAMP)),
    (63, 'EM', 0, NULL, 'Maciej', 'W', 'Dusza', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '611D56EB-C29D-4F90-A5C6-1B3B2D44E5F8', CAST('2010-01-22T00:00:00' AS TIMESTAMP)),
    (64, 'EM', 0, NULL, 'Michael', 'J', 'Zwilling', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'DCC5AA7B-C09A-47A5-86A2-90D88191EBE6', CAST('2010-02-16T00:00:00' AS TIMESTAMP)),
    (65, 'EM', 0, NULL, 'Randy', 'T', 'Reeves', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'D988D8E0-C335-4F4C-9ED9-199FEB7FD4A7', CAST('2010-02-16T00:00:00' AS TIMESTAMP)),
    (66, 'EM', 0, NULL, 'Karan', 'R', 'Khanna', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '58C97993-7491-49EE-BFDD-CD80CE2C922A', CAST('2009-12-15T00:00:00' AS TIMESTAMP)),
    (67, 'EM', 0, NULL, 'Jay', 'G', 'Adams', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '2FE289A7-CE57-49E5-BE61-3E6580D22EA6', CAST('2009-02-26T00:00:00' AS TIMESTAMP)),
    (68, 'EM', 0, NULL, 'Charles', 'B', 'Fitzgerald', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '1E7CD457-A854-4D68-ACFB-3D752EEBD231', CAST('2009-11-26T00:00:00' AS TIMESTAMP)),
    (69, 'EM', 0, NULL, 'Steve', 'F', 'Masters', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '85F55758-54C4-4048-ACBE-BD9515669122', CAST('2009-02-08T00:00:00' AS TIMESTAMP)),
    (70, 'EM', 0, NULL, 'David', 'J', 'Ortiz', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '60245B9F-EABD-48CF-9FA9-C5DD48BCB3DF', CAST('2008-12-08T00:00:00' AS TIMESTAMP)),
    (71, 'EM', 0, NULL, 'Michael', 'Sean', 'Ray', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'CA42A0B4-C068-4C75-A8A3-DE8953760927', CAST('2009-02-08T00:00:00' AS TIMESTAMP)),
    (72, 'EM', 0, NULL, 'Steven', 'T', 'Selikoff', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '7455FEFF-9238-4C29-819F-A4DF6508C0F8', CAST('2008-11-24T00:00:00' AS TIMESTAMP)),
    (73, 'EM', 0, NULL, 'Carole', 'M', 'Poland', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '4EE4FAF4-9C85-4022-B07F-956F1C5595D5', CAST('2008-12-12T00:00:00' AS TIMESTAMP)),
    (74, 'EM', 0, NULL, 'Bjorn', 'M', 'Rettig', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '056617D9-E65F-41C7-98AF-9C14C4569652', CAST('2008-12-31T00:00:00' AS TIMESTAMP)),
    (75, 'EM', 0, NULL, 'Michiko', 'F', 'Osada', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '670CE5A5-2B86-4AD7-AEF5-DF2AAAC4A6AB', CAST('2009-01-19T00:00:00' AS TIMESTAMP)),
    (76, 'EM', 0, NULL, 'Carol', 'M', 'Philips', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '7AC771B3-347A-49FA-9298-487B02FA359D', CAST('2009-02-05T00:00:00' AS TIMESTAMP)),
    (77, 'EM', 0, NULL, 'Merav', 'A', 'Netz', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'F9427582-FD1B-45DE-922D-2C2C58CEA0F7', CAST('2009-02-24T00:00:00' AS TIMESTAMP)),
    (78, 'EM', 0, NULL, 'Reuben', 'H', 'D''sa', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'AEBEAA5B-D861-4703-A959-6D0F6F4CDF74', CAST('2008-12-08T00:00:00' AS TIMESTAMP)),
    (79, 'EM', 0, NULL, 'Eric', 'L', 'Brown', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'D0EFAF3A-04DC-442F-9AA1-926C38105241', CAST('2010-01-17T00:00:00' AS TIMESTAMP)),
    (80, 'EM', 0, NULL, 'Sandeep', 'P', 'Kaliyath', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '7E5B79F9-5B7A-41DC-850F-23B4764B5161', CAST('2010-01-10T00:00:00' AS TIMESTAMP)),
    (81, 'EM', 0, NULL, 'Mihail', 'U', 'Frintu', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '1062CA88-998C-472C-8BD5-9F3D4BC4D2FB', CAST('2009-12-22T00:00:00' AS TIMESTAMP)),
    (82, 'EM', 0, NULL, 'Jack', 'T', 'Creasey', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'ED8B39AF-5DA5-405F-8C38-A6C3AC25CA1B', CAST('2010-02-24T00:00:00' AS TIMESTAMP)),
    (83, 'EM', 0, NULL, 'Patrick', 'M', 'Cook', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'F03E1512-0DC2-4329-8F21-6C5DBB9996F3', CAST('2010-02-05T00:00:00' AS TIMESTAMP)),
    (84, 'EM', 0, NULL, 'Frank', 'R', 'Martinez', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'B66AB99E-691C-4CAC-B62D-579816800BFA', CAST('2010-01-29T00:00:00' AS TIMESTAMP)),
    (85, 'EM', 0, NULL, 'Brian', 'Richard', 'Goldstein', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '61CE0232-4144-48AE-BA3B-1D509505F106', CAST('2009-12-04T00:00:00' AS TIMESTAMP)),
    (86, 'EM', 0, NULL, 'Ryan', 'L', 'Cornelsen', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '0E3F7512-87A6-4C0D-9E02-30919A75BF60', CAST('2008-12-29T00:00:00' AS TIMESTAMP)),
    (87, 'EM', 0, NULL, 'Cristian', 'K', 'Petculescu', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '45FE0378-ED23-4D24-A5F5-11B10B402980', CAST('2008-12-15T00:00:00' AS TIMESTAMP)),
    (88, 'EM', 0, NULL, 'Betsy', 'A', 'Stadick', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'C214AB1E-A07E-4A62-9033-19DDE0DE1937', CAST('2009-12-11T00:00:00' AS TIMESTAMP)),
    (89, 'EM', 0, NULL, 'Patrick', 'C', 'Wedge', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'CD334AC3-EE11-4999-BBA1-7F33DE161124', CAST('2010-01-25T00:00:00' AS TIMESTAMP)),
    (90, 'EM', 0, NULL, 'Danielle', 'C', 'Tiedt', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '852A07EE-1D24-4810-8121-365DAB884C8D', CAST('2010-02-13T00:00:00' AS TIMESTAMP)),
    (91, 'EM', 0, NULL, 'Kimberly', 'B', 'Zimmerman', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '67647D8C-C685-4704-81B7-AE1087CC2C6D', CAST('2010-01-05T00:00:00' AS TIMESTAMP)),
    (92, 'EM', 0, NULL, 'Tom', 'M', 'Vande Velde', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'A36DA26B-29BA-4627-9731-134D65A53143', CAST('2010-03-03T00:00:00' AS TIMESTAMP)),
    (93, 'EM', 0, NULL, 'Kok-Ho', 'T', 'Loh', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '3E4AE757-8C3E-47CC-BC20-528CCF271E3D', CAST('2008-12-20T00:00:00' AS TIMESTAMP)),
    (94, 'EM', 0, NULL, 'Russell', NULL, 'Hunter', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '288EF549-203C-439C-A6B2-32FD822327FF', CAST('2008-12-05T00:00:00' AS TIMESTAMP)),
    (95, 'EM', 0, NULL, 'Jim', 'H', 'Scardelis', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'A45F89BB-9748-41F8-9FAA-A5D76DF4B029', CAST('2008-12-12T00:00:00' AS TIMESTAMP)),
    (96, 'EM', 0, NULL, 'Elizabeth', 'I', 'Keyser', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'CB9A2A0C-68E5-475B-9D6D-EBD548FE5B9C', CAST('2009-02-23T00:00:00' AS TIMESTAMP)),
    (97, 'EM', 0, NULL, 'Mandar', 'H', 'Samant', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '907AE318-9FF7-4B56-B52B-5FDCA7BF8A62', CAST('2009-02-03T00:00:00' AS TIMESTAMP)),
    (98, 'EM', 0, NULL, 'Sameer', 'A', 'Tejani', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'F19BE575-4A2E-413D-9BE9-0AF4B75C6FCD', CAST('2009-02-04T00:00:00' AS TIMESTAMP)),
    (99, 'EM', 0, NULL, 'Nuan', NULL, 'Yu', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '938FCD64-E06D-453C-9E70-BFE41753557B', CAST('2008-12-30T00:00:00' AS TIMESTAMP)),
    (100, 'EM', 0, NULL, 'Lolan', 'B', 'Song', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'DCD41870-A67B-4D7F-B874-92C6854E1D0D', CAST('2009-01-05T00:00:00' AS TIMESTAMP)),
    (101, 'EM', 0, NULL, 'Houman', '', 'Pournasseh', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '14E39720-994D-42C0-A26D-7877BB264FF5', CAST('2009-01-18T00:00:00' AS TIMESTAMP)),
    (102, 'EM', 0, NULL, 'Zheng', 'W', 'Mu', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '17D15AE1-FB50-4303-A509-24C6C553C17D', CAST('2008-11-26T00:00:00' AS TIMESTAMP)),
    (103, 'EM', 0, NULL, 'Ebru', '', 'Ersan', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '64A9674E-9625-4EF2-8F4D-357390735C08', CAST('2009-11-29T00:00:00' AS TIMESTAMP)),
    (104, 'EM', 0, NULL, 'Mary', 'R', 'Baker', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '9E450675-B7F1-47C1-BB64-95E998B57ED4', CAST('2009-12-18T00:00:00' AS TIMESTAMP)),
    (105, 'EM', 0, NULL, 'Kevin', 'M', 'Homer', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '1D1C9D2A-EA15-409C-8E32-8F5C6F8F286A', CAST('2009-12-18T00:00:00' AS TIMESTAMP)),
    (106, 'EM', 0, NULL, 'John', 'T', 'Kane', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '4C117C8F-07C6-4B4E-A7D0-B8AD58EED8AE', CAST('2010-02-20T00:00:00' AS TIMESTAMP)),
    (107, 'EM', 0, NULL, 'Christopher', 'E', 'Hill', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'A066751C-B57F-4186-8219-6652AE1189B1', CAST('2010-02-01T00:00:00' AS TIMESTAMP)),
    (108, 'EM', 0, NULL, 'Jinghao', 'K', 'Liu', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'DD35EB13-6D4F-4C82-B33C-D693090722B6', CAST('2008-12-01T00:00:00' AS TIMESTAMP)),
    (109, 'EM', 0, NULL, 'Alice', 'O', 'Ciccu', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'B5836E66-4251-4D4D-8F49-8E6D9E3C9D64', CAST('2008-11-30T00:00:00' AS TIMESTAMP)),
    (110, 'EM', 0, NULL, 'Jun', 'T', 'Cao', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '20BDFF3B-3561-482B-B02D-DA9B6183B6D9', CAST('2008-12-07T00:00:00' AS TIMESTAMP)),
    (111, 'EM', 0, NULL, 'Suroor', 'R', 'Fatima', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '62C97C5B-5CAB-42C6-813D-C0C75BBBFD7B', CAST('2008-12-10T00:00:00' AS TIMESTAMP)),
    (112, 'EM', 0, NULL, 'John', 'P', 'Evans', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'FCFA001C-D5BC-455F-9124-21290B4A5304', CAST('2008-12-25T00:00:00' AS TIMESTAMP)),
    (113, 'EM', 0, NULL, 'Linda', 'K', 'Moschell', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '1552D700-1E1C-4725-8074-D8D7D9A49B0E', CAST('2008-12-18T00:00:00' AS TIMESTAMP)),
    (114, 'EM', 0, NULL, 'Mindaugas', 'J', 'Krapauskas', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '7C623D80-0A62-42DE-A355-24715A7160C6', CAST('2009-01-06T00:00:00' AS TIMESTAMP)),
    (115, 'EM', 0, NULL, 'Angela', 'W', 'Barbariol', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '8E6ADFD0-2FE0-4EB9-93F2-A04FD877F6DC', CAST('2009-01-13T00:00:00' AS TIMESTAMP)),
    (116, 'EM', 0, NULL, 'Michael', 'W', 'Patten', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'C31D89BE-1DB6-495B-8699-4669E5FA4B9D', CAST('2009-01-24T00:00:00' AS TIMESTAMP)),
    (117, 'EM', 0, NULL, 'Chad', 'W', 'Niswonger', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '1CAC3A75-34AB-45C1-B9F1-7CAA44C76A75', CAST('2009-02-11T00:00:00' AS TIMESTAMP)),
    (118, 'EM', 0, NULL, 'Don', 'L', 'Hall', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'F369194E-2FF0-4E61-97A7-B821F8B2BAED', CAST('2009-02-06T00:00:00' AS TIMESTAMP)),
    (119, 'EM', 0, NULL, 'Michael', 'T', 'Entin', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '7533C47D-8E8F-40AC-8383-CF3DF57E3D84', CAST('2009-02-18T00:00:00' AS TIMESTAMP)),
    (120, 'EM', 0, NULL, 'Kitti', 'H', 'Lertpiriyasuwat', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'BFADC42C-0D0E-4BDA-94B7-B14E89F5FC69', CAST('2009-02-25T00:00:00' AS TIMESTAMP)),
    (121, 'EM', 0, NULL, 'Pilar', 'G', 'Ackerman', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '81F50324-D0B5-4EA5-8B20-F99D46572C76', CAST('2008-12-26T00:00:00' AS TIMESTAMP)),
    (122, 'EM', 0, NULL, 'Susan', 'W', 'Eaton', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '84C723AC-F07F-4299-89B1-FAABB9CA47FC', CAST('2008-11-30T00:00:00' AS TIMESTAMP)),
    (123, 'EM', 0, NULL, 'Vamsi', '', 'Kuppa', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '37154EFE-002F-4D85-A84B-A8B1FF714BC6', CAST('2008-11-30T00:00:00' AS TIMESTAMP)),
    (124, 'EM', 0, NULL, 'Kim', 'T', 'Ralls', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '7AB39816-FF5A-4F3D-A3DC-88D906EC054F', CAST('2008-12-19T00:00:00' AS TIMESTAMP)),
    (125, 'EM', 0, NULL, 'Matthias', 'T', 'Berndt', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '318BF718-6CCC-4F26-AC81-00EAF17B1BFE', CAST('2009-01-13T00:00:00' AS TIMESTAMP)),
    (126, 'EM', 0, NULL, 'Jimmy', 'T', 'Bischoff', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '52182904-CFAF-4B2D-8D77-268DE7AB5DA4', CAST('2009-02-19T00:00:00' AS TIMESTAMP)),
    (127, 'EM', 0, NULL, 'David', 'P', 'Hamilton', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'D6532F6D-A832-4266-B0F0-2F874F5A85BA', CAST('2008-12-27T00:00:00' AS TIMESTAMP)),
    (128, 'EM', 0, NULL, 'Paul', 'B', 'Komosinski', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'E4145F40-88D2-43F4-A018-9BFB38D6D9FF', CAST('2008-11-27T00:00:00' AS TIMESTAMP)),
    (129, 'EM', 0, NULL, 'Gary', 'W', 'Yukish', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '09EA8640-ED99-4205-9433-078F1D81D221', CAST('2008-12-15T00:00:00' AS TIMESTAMP)),
    (130, 'EM', 0, NULL, 'Rob', 'T', 'Caron', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '909F01EF-2F6D-44DD-AF8D-1553BED7EACF', CAST('2009-02-06T00:00:00' AS TIMESTAMP)),
    (131, 'EM', 0, NULL, 'Baris', 'F', 'Cetinok', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'BA03C1A4-0577-44F5-BFBC-FC701C007F13', CAST('2009-02-08T00:00:00' AS TIMESTAMP)),
    (132, 'EM', 0, NULL, 'Nicole', 'B', 'Holliday', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'F101C5EE-17B1-4FB0-9CAE-4A88694CEEAA', CAST('2009-02-15T00:00:00' AS TIMESTAMP)),
    (133, 'EM', 0, NULL, 'Michael', 'L', 'Rothkugel', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'EE04F4CB-977A-48D0-ACB4-D89172FD5AE2', CAST('2009-01-03T00:00:00' AS TIMESTAMP)),
    (134, 'EM', 0, NULL, 'Eric', NULL, 'Gubbels', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '4A9AC912-9E22-47B7-B126-5F3B576A430E', CAST('2009-01-07T00:00:00' AS TIMESTAMP)),
    (135, 'EM', 0, NULL, 'Ivo', 'William', 'Salmre', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'DFA4B008-D83F-4828-AAC6-449E683909F5', CAST('2008-11-27T00:00:00' AS TIMESTAMP)),
    (136, 'EM', 0, NULL, 'Sylvester', 'A', 'Valdez', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '6152BEC3-BB11-43AA-B691-9881CE6DD3F3', CAST('2009-12-04T00:00:00' AS TIMESTAMP)),
    (137, 'EM', 0, NULL, 'Anibal', 'T', 'Sousa', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '9B75A538-958C-4C91-987A-B9BCCE683E8A', CAST('2009-02-16T00:00:00' AS TIMESTAMP)),
    (138, 'EM', 0, NULL, 'Samantha', 'H', 'Smith', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '11EF6F0A-29B6-4541-82F0-2E7A35179E48', CAST('2009-01-28T00:00:00' AS TIMESTAMP)),
    (139, 'EM', 0, 'Mr.', 'Hung-Fu', 'T', 'Ting', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '739C7553-13E5-4F36-86F6-4775645547AE', CAST('2009-12-30T00:00:00' AS TIMESTAMP)),
    (140, 'EM', 0, NULL, 'Prasanna', 'E', 'Samarawickrama', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'E8673E92-31F6-42F4-A65C-A595D3F899F6', CAST('2010-01-15T00:00:00' AS TIMESTAMP)),
    (141, 'EM', 0, NULL, 'Min', 'G', 'Su', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '3BB0243E-11E3-4E5C-8DB5-6B927C71432E', CAST('2010-01-17T00:00:00' AS TIMESTAMP)),
    (142, 'EM', 0, NULL, 'Olinda', 'C', 'Turner', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'BF741CEC-34E0-4B44-99C2-E0382FCD9E8E', CAST('2010-02-25T00:00:00' AS TIMESTAMP)),
    (143, 'EM', 0, NULL, 'Krishna', NULL, 'Sunkammurali', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '442C8270-1E84-47C5-A621-AF10CF1B3546', CAST('2010-02-06T00:00:00' AS TIMESTAMP)),
    (144, 'EM', 0, NULL, 'Paul', 'R', 'Singh', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'BA4C0109-A2A4-4595-A357-38A64B643E3C', CAST('2009-01-10T00:00:00' AS TIMESTAMP)),
    (145, 'EM', 0, NULL, 'Cynthia', 'S', 'Randall', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'F0C15AD6-4CFF-4931-A216-49B635596043', CAST('2009-01-20T00:00:00' AS TIMESTAMP)),
    (146, 'EM', 0, NULL, 'Jian Shuo', NULL, 'Wang', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '009EBB72-9173-4AA9-920E-B578F3C927DE', CAST('2008-11-30T00:00:00' AS TIMESTAMP)),
    (147, 'EM', 0, NULL, 'Sandra', NULL, 'Reátegui Alayo', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'B07FA8A6-A056-48AB-91F8-318C6C87B502', CAST('2008-12-19T00:00:00' AS TIMESTAMP)),
    (148, 'EM', 0, NULL, 'Jason', 'M', 'Watters', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '00D61032-0D0E-41E3-8F37-B5987C8D5087', CAST('2009-01-07T00:00:00' AS TIMESTAMP)),
    (149, 'EM', 0, NULL, 'Andy', 'M', 'Ruth', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '9CFDF60A-083A-44DC-AFE2-D578C76FD55A', CAST('2009-01-24T00:00:00' AS TIMESTAMP)),
    (150, 'EM', 0, NULL, 'Michael', 'T', 'Vanderhyde', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '944AE1F8-E154-4752-9A24-8E8FE85156F3', CAST('2009-02-19T00:00:00' AS TIMESTAMP)),
    (151, 'EM', 0, NULL, 'Rostislav', 'E', 'Shabalin', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'FAA146E7-5C07-4C47-8B66-DCDA9BE58D54', CAST('2009-02-12T00:00:00' AS TIMESTAMP)),
    (152, 'EM', 0, NULL, 'Yuhong', 'L', 'Li', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '866472D1-65C3-4AA7-B15B-F75EF10CB7D8', CAST('2009-01-25T00:00:00' AS TIMESTAMP)),
    (153, 'EM', 0, NULL, 'Hanying', 'P', 'Feng', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'DDAAE515-0A69-4750-B6EE-7AC6629F55B8', CAST('2008-12-09T00:00:00' AS TIMESTAMP)),
    (154, 'EM', 0, NULL, 'Raymond', 'K', 'Sam', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '02717918-B884-41B9-87B3-A0F8C2939EC1', CAST('2008-12-16T00:00:00' AS TIMESTAMP)),
    (155, 'EM', 0, NULL, 'Fadi', 'K', 'Fakhouri', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '3EF14439-76B4-4086-BE8D-0A03A6694425', CAST('2008-12-28T00:00:00' AS TIMESTAMP)),
    (156, 'EM', 0, NULL, 'Lane', 'M', 'Sacksteder', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '8591375E-8ED1-49C8-89F3-52AED00C77F1', CAST('2009-01-04T00:00:00' AS TIMESTAMP)),
    (157, 'EM', 0, NULL, 'Linda', 'A', 'Randall', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'EF38AC01-9C58-4CD0-AA39-D12DDA3C3E9C', CAST('2009-01-27T00:00:00' AS TIMESTAMP)),
    (158, 'EM', 0, NULL, 'Shelley', '', 'Dyck', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '77B7F905-5028-491C-A1DC-80087AAC7817', CAST('2009-02-28T00:00:00' AS TIMESTAMP)),
    (159, 'EM', 0, NULL, 'Terrence', 'W', 'Earls', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '15365ED2-53AC-4EC7-93BF-89ED5D903167', CAST('2009-02-09T00:00:00' AS TIMESTAMP)),
    (160, 'EM', 0, NULL, 'Jeff', 'V', 'Hay', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '8C7296AB-73DA-4992-8200-833B2C625D50', CAST('2009-01-14T00:00:00' AS TIMESTAMP)),
    (161, 'EM', 0, NULL, 'Kirk', 'J', 'Koenigsbauer', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '35A9A423-C54F-48C5-9527-CF1E93089D92', CAST('2008-12-08T00:00:00' AS TIMESTAMP)),
    (162, 'EM', 0, NULL, 'Laura', 'C', 'Steele', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '5FF2682D-D7E7-48A3-9DEF-B60F0B8434FE', CAST('2008-12-27T00:00:00' AS TIMESTAMP)),
    (163, 'EM', 0, NULL, 'Alex', 'M', 'Nayberg', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '08CA0103-CA0E-4B52-A20F-590BA3FECDA8', CAST('2009-02-01T00:00:00' AS TIMESTAMP)),
    (164, 'EM', 0, NULL, 'Andrew', 'M', 'Cencini', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'B1D33171-636C-440C-B4F6-F5F6F1EBBC70', CAST('2009-02-27T00:00:00' AS TIMESTAMP)),
    (165, 'EM', 0, NULL, 'Chris', 'T', 'Preston', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '9F2D6941-1DE5-4076-9817-7ECCF6C47D55', CAST('2009-01-15T00:00:00' AS TIMESTAMP)),
    (166, 'EM', 0, NULL, 'Jack', 'S', 'Richins', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '8F9BCF96-29E1-4BED-9BF4-D8260AD0AF68', CAST('2009-02-14T00:00:00' AS TIMESTAMP)),
    (167, 'EM', 0, NULL, 'David', '', 'Johnson', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'C2C7021B-3209-45F7-8560-B3132595F9DA', CAST('2008-11-25T00:00:00' AS TIMESTAMP)),
    (168, 'EM', 0, NULL, 'Garrett', 'R', 'Young', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'DA309209-A597-4D54-B717-D984B38975D1', CAST('2008-11-30T00:00:00' AS TIMESTAMP)),
    (169, 'EM', 0, NULL, 'Susan', 'A', 'Metters', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'D8414490-CA5B-4517-BBE9-7FBF4D696771', CAST('2008-12-07T00:00:00' AS TIMESTAMP)),
    (170, 'EM', 0, NULL, 'George', 'Z', 'Li', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'E9E65DEB-797B-4B49-B41C-81F1DC593BB9', CAST('2008-12-14T00:00:00' AS TIMESTAMP)),
    (171, 'EM', 0, NULL, 'David', 'A', 'Yalovsky', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '4C1F3E85-AEED-4A7D-A4FE-EEDFB750E45D', CAST('2008-12-26T00:00:00' AS TIMESTAMP)),
    (172, 'EM', 0, NULL, 'Marc', 'J', 'Ingle', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '8A6062D5-1C3A-46BF-A080-F6CF6090E5F0', CAST('2009-01-09T00:00:00' AS TIMESTAMP)),
    (173, 'EM', 0, NULL, 'Eugene', 'R', 'Zabokritski', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '1284B1A5-D53C-4BF9-9777-05108B207103', CAST('2009-01-14T00:00:00' AS TIMESTAMP)),
    (174, 'EM', 0, NULL, 'Benjamin', 'R', 'Martin', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '4430A64D-3D5D-423E-81B9-6C4F9ED88AB7', CAST('2009-01-20T00:00:00' AS TIMESTAMP)),
    (175, 'EM', 0, NULL, 'Reed', 'T', 'Koch', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '892F02CF-A623-4499-B850-1B46469B597E', CAST('2009-01-26T00:00:00' AS TIMESTAMP)),
    (176, 'EM', 0, NULL, 'David', 'Oliver', 'Lawrence', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '0D4723B9-43E8-401D-BCBA-C7DCD8178B8C', CAST('2009-02-07T00:00:00' AS TIMESTAMP)),
    (177, 'EM', 0, NULL, 'Russell', 'M', 'King', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '2F67DE81-C40E-4234-8942-C77806FABFA3', CAST('2009-02-14T00:00:00' AS TIMESTAMP)),
    (178, 'EM', 0, NULL, 'John', '', 'Frum', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'CE13FF53-4465-4E3A-90DA-2FA0E8F19378', CAST('2009-02-24T00:00:00' AS TIMESTAMP)),
    (179, 'EM', 0, NULL, 'Jan', 'S', 'Miksovsky', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'A0719EB6-7FC8-4DB8-A5DB-EA45A5BEF0E2', CAST('2009-02-26T00:00:00' AS TIMESTAMP)),
    (180, 'EM', 0, NULL, 'Katie', 'L', 'McAskill-White', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'FE4EC240-D091-4E90-8F70-E9467FAC3A18', CAST('2009-02-13T00:00:00' AS TIMESTAMP)),
    (181, 'EM', 0, NULL, 'Michael', 'T', 'Hines', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'B7004365-FDD8-4FCD-85FB-53A759447180', CAST('2008-12-02T00:00:00' AS TIMESTAMP)),
    (182, 'EM', 0, NULL, 'Nitin', 'S', 'Mirchandani', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '4BEF5E3D-5C17-4B16-AAC9-8E3611A4FFE5', CAST('2008-12-21T00:00:00' AS TIMESTAMP)),
    (183, 'EM', 0, NULL, 'Barbara', 'S', 'Decker', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'C175EA91-0A68-49DB-9827-B4528F77D630', CAST('2009-01-15T00:00:00' AS TIMESTAMP)),
    (184, 'EM', 0, NULL, 'John', 'Y', 'Chen', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '5E6EC398-C951-44A2-BEC7-DC1CD17FAACC', CAST('2009-02-02T00:00:00' AS TIMESTAMP)),
    (185, 'EM', 0, NULL, 'Stefen', 'A', 'Hesse', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '266FCE92-5534-4AC1-B68C-ECD8CEFFCEBC', CAST('2009-02-21T00:00:00' AS TIMESTAMP)),
    (186, 'EM', 0, NULL, 'Shane', 'S', 'Kim', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '1432F3E8-7CCA-4C56-BDCB-02D5B0302BD9', CAST('2009-02-01T00:00:00' AS TIMESTAMP)),
    (187, 'EM', 0, NULL, 'Yvonne', 'S', 'McKay', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'F3A901C1-4D9F-4666-8726-C2C51643A5D6', CAST('2008-12-02T00:00:00' AS TIMESTAMP)),
    (188, 'EM', 0, NULL, 'Douglas', 'B', 'Hite', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '4CE168C6-28FF-454D-887E-8F96BB2FBA93', CAST('2008-12-20T00:00:00' AS TIMESTAMP)),
    (189, 'EM', 0, NULL, 'Janeth', 'M', 'Esteves', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'A5A5A995-AD0A-4F50-847D-1CA048F11EE3', CAST('2009-01-08T00:00:00' AS TIMESTAMP)),
    (190, 'EM', 0, NULL, 'Robert', 'J', 'Rounthwaite', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'FBF84B1A-3B42-40FE-8BF0-3094DCF25888', CAST('2009-01-26T00:00:00' AS TIMESTAMP)),
    (191, 'EM', 0, NULL, 'Lionel', 'C', 'Penuchot', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '55B6EB95-61ED-4458-9BFB-F0560F001970', CAST('2009-02-19T00:00:00' AS TIMESTAMP)),
    (192, 'EM', 0, NULL, 'Brenda', 'M', 'Diaz', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '056BBD40-CDF0-428D-B12D-9FFB0FF5FEAE', CAST('2009-02-26T00:00:00' AS TIMESTAMP)),
    (193, 'EM', 0, NULL, 'Alejandro', 'E', 'McGuel', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'F38E101D-B360-4876-8E8F-07726E85AE5D', CAST('2008-11-29T00:00:00' AS TIMESTAMP)),
    (194, 'EM', 0, NULL, 'Fred', 'T', 'Northup', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'E28C41D6-D9BA-455D-B91D-E3C9F7B535E2', CAST('2008-12-05T00:00:00' AS TIMESTAMP)),
    (195, 'EM', 0, NULL, 'Kevin', 'H', 'Liu', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '14AFAE63-9C86-4E23-B82E-5AAD4DBD1963', CAST('2008-12-10T00:00:00' AS TIMESTAMP)),
    (196, 'EM', 0, NULL, 'Shammi', 'G', 'Mohamed', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '923FDAEC-6DB1-42A7-9840-D9D335996596', CAST('2008-12-17T00:00:00' AS TIMESTAMP)),
    (197, 'EM', 0, NULL, 'Rajesh', 'M', 'Patel', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'CCC3C607-1E9B-4E62-8064-0B89594472F3', CAST('2008-12-24T00:00:00' AS TIMESTAMP)),
    (198, 'EM', 0, NULL, 'Lorraine', 'O', 'Nay', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '35495D48-03AF-492F-BEE5-FDA7B3E61970', CAST('2008-12-28T00:00:00' AS TIMESTAMP)),
    (199, 'EM', 0, NULL, 'Paula', 'R', 'Nartker', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'D6FF616B-A950-48D2-8CC0-0E7F5A9ECDA0', CAST('2009-01-05T00:00:00' AS TIMESTAMP)),
    (200, 'EM', 0, NULL, 'Frank', 'T', 'Lee', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '8025020E-4FF8-488B-99CA-74640E1F8DAE', CAST('2009-01-10T00:00:00' AS TIMESTAMP)),
    (201, 'EM', 0, NULL, 'Brian', 'T', 'Lloyd', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'A3A2494B-F92D-473E-BFDA-FC3FE406E134', CAST('2009-01-22T00:00:00' AS TIMESTAMP)),
    (202, 'EM', 0, NULL, 'Tawana', 'G', 'Nusbaum', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '63B57674-1205-41A1-A532-8E6C9F38E48D', CAST('2009-01-29T00:00:00' AS TIMESTAMP)),
    (203, 'EM', 0, NULL, 'Ken', 'L', 'Myer', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '981FCDB7-9792-463D-BF1F-F1B4CED52473', CAST('2009-02-17T00:00:00' AS TIMESTAMP)),
    (204, 'EM', 0, NULL, 'Gabe', 'B', 'Mares', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '0F0FA05E-E101-47E4-9BF7-1E0790B68E00', CAST('2009-03-01T00:00:00' AS TIMESTAMP)),
    (205, 'EM', 0, NULL, 'Lori', 'A', 'Kane', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '6F059DF8-BB13-4CD0-ABE1-D3E6688CEDD1', CAST('2009-02-19T00:00:00' AS TIMESTAMP)),
    (206, 'EM', 0, NULL, 'Stuart', 'V', 'Munson', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'CE75C8B6-EAC8-4B18-96FA-8182AD7233CD', CAST('2008-11-25T00:00:00' AS TIMESTAMP)),
    (207, 'EM', 0, NULL, 'Greg', 'F', 'Alderson', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'F3A921DD-55EB-46EB-A94D-68F4B080A388', CAST('2008-11-25T00:00:00' AS TIMESTAMP)),
    (208, 'EM', 0, NULL, 'Scott', 'R', 'Gode', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '1BECEC23-19F8-4B73-A404-12CCBCFAD66E', CAST('2009-01-01T00:00:00' AS TIMESTAMP)),
    (209, 'EM', 0, NULL, 'Kathie', 'E', 'Flood', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '3BA601AE-2918-4936-9380-FD4C4F15DEA4', CAST('2009-01-20T00:00:00' AS TIMESTAMP)),
    (210, 'EM', 0, NULL, 'Belinda', 'M', 'Newman', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'FA3467EB-B6EE-43A7-8BDD-15AFE14F2738', CAST('2009-02-13T00:00:00' AS TIMESTAMP)),
    (211, 'EM', 0, NULL, 'Hazem', 'E', 'Abolrous', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'C2637051-25A5-4461-B06A-523119259430', CAST('2009-02-21T00:00:00' AS TIMESTAMP)),
    (212, 'EM', 0, NULL, 'Peng', 'J', 'Wu', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '24B9C3C3-A06D-44FA-AA24-34DDD3ABF62C', CAST('2008-12-02T00:00:00' AS TIMESTAMP)),
    (213, 'EM', 0, NULL, 'Sootha', 'T', 'Charncherngkha', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'C334506C-197B-4010-935E-AEE740818BC9', CAST('2010-02-16T00:00:00' AS TIMESTAMP)),
    (214, 'EM', 0, NULL, 'Andreas', 'T', 'Berglund', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '4F896936-FBF8-4120-BC87-62CCF30D09DB', CAST('2009-01-26T00:00:00' AS TIMESTAMP)),
    (215, 'EM', 0, NULL, 'Mark', 'L', 'Harrington', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '494202A4-EE2D-406B-974F-85B70FE0889B', CAST('2009-01-08T00:00:00' AS TIMESTAMP)),
    (216, 'EM', 0, NULL, 'Sean', 'P', 'Alexander', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'AA6F6C92-C6B0-4C05-B3A3-90887A88DE0F', CAST('2008-12-21T00:00:00' AS TIMESTAMP)),
    (217, 'EM', 0, NULL, 'Zainal', 'T', 'Arifin', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '989DB0AC-1E7B-4CC8-B90F-1799172ED3AA', CAST('2008-12-28T00:00:00' AS TIMESTAMP)),
    (218, 'EM', 0, NULL, 'Tengiz', '', 'Kharatishvili', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '06CFED75-E8F0-4E81-871A-4368D9B9F73E', CAST('2008-12-09T00:00:00' AS TIMESTAMP)),
    (219, 'EM', 0, NULL, 'Sean', '', 'Chai', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '93D0906B-B2D7-486F-BD14-9A126BE82AB6', CAST('2009-01-15T00:00:00' AS TIMESTAMP)),
    (220, 'EM', 0, NULL, 'Karen', 'R', 'Berge', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '20B3CF90-BA00-4DBF-8026-A028742DC328', CAST('2009-02-02T00:00:00' AS TIMESTAMP)),
    (221, 'EM', 0, NULL, 'Chris', 'K', 'Norred', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'B35192A9-15AC-4B64-9039-BB3F8566AF55', CAST('2009-02-27T00:00:00' AS TIMESTAMP)),
    (222, 'EM', 0, NULL, 'A. Scott', NULL, 'Wright', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '90CC98B7-6054-4AB5-844E-3ECCB8A73070', CAST('2008-12-05T00:00:00' AS TIMESTAMP)),
    (223, 'EM', 0, NULL, 'Sairaj', 'L', 'Uddin', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '4F2F3EEF-B0A5-44B9-ADD9-424C26A77BF9', CAST('2009-01-19T00:00:00' AS TIMESTAMP)),
    (224, 'EM', 0, NULL, 'William', 'S', 'Vong', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'B42F3DDD-01D6-4701-91C0-2F6D9E8847C6', CAST('2008-12-31T00:00:00' AS TIMESTAMP)),
    (225, 'EM', 0, NULL, 'Alan', 'J', 'Brewer', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '72331C0F-994F-4494-ABFC-AA129DA85635', CAST('2009-02-06T00:00:00' AS TIMESTAMP)),
    (226, 'EM', 0, NULL, 'Brian', 'P', 'LaMee', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '3F4225C1-7833-43D7-A485-BDCEE84553BF', CAST('2009-02-24T00:00:00' AS TIMESTAMP)),
    (227, 'EM', 0, NULL, 'Gary', 'E.', 'Altman', 'III', 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'A131E984-DD98-4D19-91FF-9A9BB57CDA99', CAST('2009-11-25T00:00:00' AS TIMESTAMP)),
    (228, 'EM', 0, NULL, 'Christian', 'E', 'Kleinerman', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '32852137-66C8-4BE4-B6CF-3C094534DA9B', CAST('2008-12-07T00:00:00' AS TIMESTAMP)),
    (229, 'EM', 0, NULL, 'Lori', 'K', 'Penor', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '327A5C9F-3DFC-4775-8375-368A5A29FE16', CAST('2010-02-09T00:00:00' AS TIMESTAMP)),
    (230, 'EM', 0, NULL, 'Stuart', 'J', 'Macrae', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '991FB7CC-704B-4EDE-9C8E-2615EB3F56BF', CAST('2010-02-26T00:00:00' AS TIMESTAMP)),
    (231, 'EM', 0, NULL, 'Jo', 'L', 'Berry', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '196CBA72-3810-435A-9A52-57A5E276293B', CAST('2010-02-28T00:00:00' AS TIMESTAMP)),
    (232, 'EM', 0, NULL, 'Pat', 'H', 'Coleman', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'D703625A-CFB0-4B32-BCF6-F58185E71A7C', CAST('2010-01-20T00:00:00' AS TIMESTAMP)),
    (233, 'EM', 0, NULL, 'Magnus', 'E', 'Hedlund', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '615A2903-C6D2-4265-A8E6-471DEC449224', CAST('2009-12-14T00:00:00' AS TIMESTAMP)),
    (234, 'EM', 0, NULL, 'Laura', 'F', 'Norman', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '4603A371-EE90-4D87-9C25-A13CE3F190A0', CAST('2009-01-24T00:00:00' AS TIMESTAMP)),
    (235, 'EM', 0, NULL, 'Paula', 'M', 'Barreto de Mattos', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '8E952C09-C7C4-4D51-A8CB-36C44C949A0B', CAST('2008-11-29T00:00:00' AS TIMESTAMP)),
    (236, 'EM', 0, NULL, 'Grant', '', 'Culbertson', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '242E654F-CFF1-495C-A408-1AAF2A8A0BA7', CAST('2009-02-18T00:00:00' AS TIMESTAMP)),
    (237, 'EM', 0, NULL, 'Hao', 'O', 'Chen', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '11C53AD9-2D74-480F-8D83-6AA37B1F52E1', CAST('2009-01-30T00:00:00' AS TIMESTAMP)),
    (238, 'EM', 0, NULL, 'Vidur', 'X', 'Luthra', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'E10218F6-99DE-462D-BDBD-28BDDEA8693A', CAST('2008-12-25T00:00:00' AS TIMESTAMP)),
    (239, 'EM', 0, NULL, 'Mindy', 'C', 'Martin', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'B903A253-A5CB-4C38-AA41-BC77CBA65BB3', CAST('2008-12-18T00:00:00' AS TIMESTAMP)),
    (240, 'EM', 0, NULL, 'Willis', 'T', 'Johnson', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '3B808CDB-0372-409A-AE40-C2177A7DB2B6', CAST('2008-12-06T00:00:00' AS TIMESTAMP)),
    (241, 'EM', 0, NULL, 'David', 'J', 'Liu', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'F766DCB5-CAE1-4164-B313-D597EFB41C96', CAST('2009-01-23T00:00:00' AS TIMESTAMP)),
    (242, 'EM', 0, NULL, 'Deborah', 'E', 'Poe', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '9236BDD4-DE3E-43BE-BB3C-22E377A2FFA6', CAST('2008-12-11T00:00:00' AS TIMESTAMP)),
    (243, 'EM', 0, NULL, 'Candy', 'L', 'Spoon', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '303047DF-CC05-4C50-813F-BE67719AB00E', CAST('2008-12-30T00:00:00' AS TIMESTAMP)),
    (244, 'EM', 0, NULL, 'Bryan', 'A', 'Walton', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '014BC84D-E05A-4A97-BD3E-CB21A3522DA5', CAST('2009-01-17T00:00:00' AS TIMESTAMP)),
    (245, 'EM', 0, NULL, 'Barbara', 'C', 'Moreland', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'F2CC060C-A8CB-4A93-99E3-5B9D47F00F9C', CAST('2009-02-11T00:00:00' AS TIMESTAMP)),
    (246, 'EM', 0, NULL, 'Dragan', 'K', 'Tomic', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '6CBF1558-FAF0-4A54-94E9-6AF835225872', CAST('2009-02-04T00:00:00' AS TIMESTAMP)),
    (247, 'EM', 0, NULL, 'Janet', 'L', 'Sheperdigian', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'D24AFF04-1200-43DF-A211-F28F2A8E753F', CAST('2009-02-22T00:00:00' AS TIMESTAMP)),
    (248, 'EM', 0, NULL, 'Mike', 'K', 'Seamans', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'AECB0EBA-B17A-41ED-AC2E-076EDA87F5E4', CAST('2009-03-01T00:00:00' AS TIMESTAMP)),
    (249, 'EM', 0, NULL, 'Wendy', 'Beth', 'Kahn', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'A4F5869C-E86D-46BD-BAAC-1B4FAF4CD920', CAST('2008-12-18T00:00:00' AS TIMESTAMP)),
    (250, 'EM', 0, NULL, 'Sheela', 'H', 'Word', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '73BEA116-6235-48CB-94A5-58FA56994640', CAST('2011-02-18T00:00:00' AS TIMESTAMP)),
    (251, 'EM', 0, NULL, 'Mikael', 'Q', 'Sandberg', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'D4285D37-ED4C-4A8B-AEDE-D6DBD37CC76F', CAST('2009-02-03T00:00:00' AS TIMESTAMP)),
    (252, 'EM', 0, NULL, 'Arvind', 'B', 'Rao', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'E70B4E15-AB90-483F-A417-D0A8E66D35FB', CAST('2009-02-21T00:00:00' AS TIMESTAMP)),
    (253, 'EM', 0, NULL, 'Linda', 'P', 'Meisner', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'F78F14D7-8E98-4925-821C-BE69B7A2C4BA', CAST('2009-12-10T00:00:00' AS TIMESTAMP)),
    (254, 'EM', 0, NULL, 'Fukiko', 'J', 'Ogisu', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '9F5E4E33-E097-483A-8B74-FA4D7E54EC56', CAST('2009-12-28T00:00:00' AS TIMESTAMP)),
    (255, 'EM', 0, NULL, 'Gordon', 'L', 'Hee', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '67925187-A9C0-4F6A-A377-653FFD3C50DF', CAST('2010-01-04T00:00:00' AS TIMESTAMP)),
    (256, 'EM', 0, NULL, 'Frank', 'S', 'Pellow', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '1FE09286-926C-4528-8D83-C0816F5F8521', CAST('2010-01-16T00:00:00' AS TIMESTAMP)),
    (257, 'EM', 0, NULL, 'Eric', 'S', 'Kurjan', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'BE6ED8D4-3A9D-46BF-9348-DE0753E8CE81', CAST('2010-01-20T00:00:00' AS TIMESTAMP)),
    (258, 'EM', 0, NULL, 'Erin', 'M', 'Hagens', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '09E5B805-A275-473F-8B8B-00673AEF252D', CAST('2010-01-24T00:00:00' AS TIMESTAMP)),
    (259, 'EM', 0, NULL, 'Ben', 'T', 'Miller', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'AB1DEFC1-5B4A-4032-A787-8F4147B2E363', CAST('2010-03-02T00:00:00' AS TIMESTAMP)),
    (260, 'EM', 0, NULL, 'Annette', 'L', 'Hill', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'D69499B6-7467-4D5D-A89D-F116E5752444', CAST('2010-11-29T00:00:00' AS TIMESTAMP)),
    (261, 'EM', 0, NULL, 'Reinout', '', 'Hillmann', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'BA53CB03-00ED-4650-82F6-3680524AAB3F', CAST('2010-12-18T00:00:00' AS TIMESTAMP)),
    (262, 'EM', 0, NULL, 'David', 'M', 'Barber', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '43BE0580-122B-4FDF-8B15-FD286A18E97A', CAST('2009-01-05T00:00:00' AS TIMESTAMP)),
    (263, 'EM', 0, NULL, 'Jean', 'E', 'Trenary', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '0AA3878D-0F9F-4F2A-942F-8B46C9B57C0A', CAST('2008-12-04T00:00:00' AS TIMESTAMP)),
    (264, 'EM', 0, NULL, 'Stephanie', 'A', 'Conroy', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '24757DC7-8E05-4DE0-920D-A1F4A60B30BA', CAST('2009-01-28T00:00:00' AS TIMESTAMP)),
    (265, 'EM', 0, NULL, 'Ashvini', 'R', 'Sharma', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '252A5641-6B19-4347-830F-E659BFC76AEF', CAST('2008-11-27T00:00:00' AS TIMESTAMP)),
    (266, 'EM', 0, NULL, 'Peter', 'I', 'Connelly', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '9D2546F7-7571-477D-AB76-532F0438EDDF', CAST('2009-02-16T00:00:00' AS TIMESTAMP)),
    (267, 'EM', 0, NULL, 'Karen', 'A', 'Berg', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'F2D24899-80B9-44F7-9B3B-63ACDEF3B505', CAST('2009-02-09T00:00:00' AS TIMESTAMP)),
    (268, 'EM', 0, NULL, 'Ramesh', 'V', 'Meyyappan', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'C69E8136-CBB5-48EB-84A0-59CE62920478', CAST('2009-01-27T00:00:00' AS TIMESTAMP)),
    (269, 'EM', 0, NULL, 'Dan', 'K', 'Bacon', 'Jr.', 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'D9DA7900-703F-4CA6-92BD-5ED3A25C0455', CAST('2009-01-04T00:00:00' AS TIMESTAMP)),
    (270, 'EM', 0, NULL, 'François', 'P', 'Ajenstat', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '83605AF8-6496-4362-BE19-20F2EC7114BA', CAST('2009-01-10T00:00:00' AS TIMESTAMP)),
    (271, 'EM', 0, NULL, 'Dan', 'B', 'Wilson', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '9F637D98-7182-4F6A-B68B-1BA9F2ECCB4D', CAST('2009-01-15T00:00:00' AS TIMESTAMP)),
    (272, 'EM', 0, NULL, 'Janaina', 'Barreiro Gambaro', 'Bueno', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '0204851C-3ECC-4968-8504-47706C350E3E', CAST('2008-12-16T00:00:00' AS TIMESTAMP)),
    (273, 'EM', 0, 'Mr.', 'Brian', 'S', 'Welcker', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '0950A366-1EEE-4516-86E0-6F2F94CE1046', CAST('2011-02-08T00:00:00' AS TIMESTAMP)),
    (274, 'SP', 0, NULL, 'Stephen', 'Y', 'Jiang', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '1F4062EC-0577-43DF-947A-EEE1E3D24C60', CAST('2010-12-28T00:00:00' AS TIMESTAMP)),
    (275, 'SP', 0, NULL, 'Michael', 'G', 'Blythe', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '250C3F67-B75F-4B0D-9BE2-DEB5825C8EEB', CAST('2011-05-24T00:00:00' AS TIMESTAMP)),
    (276, 'SP', 0, NULL, 'Linda', 'C', 'Mitchell', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '519A296E-CA91-450F-95C9-153459604147', CAST('2011-05-24T00:00:00' AS TIMESTAMP)),
    (277, 'SP', 0, NULL, 'Jillian', NULL, 'Carson', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '3C407F7D-2EA1-4749-8856-8C8EECF23AEA', CAST('2011-05-24T00:00:00' AS TIMESTAMP)),
    (278, 'SP', 0, NULL, 'Garrett', 'R', 'Vargas', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '6167A617-60E9-4212-9C40-BB471716776C', CAST('2011-05-24T00:00:00' AS TIMESTAMP)),
    (279, 'SP', 0, NULL, 'Tsvi', 'Michael', 'Reiter', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'FCA35010-0144-4C4C-8245-D38E9FD4CCD2', CAST('2011-05-24T00:00:00' AS TIMESTAMP)),
    (280, 'SP', 0, NULL, 'Pamela', 'O', 'Ansman-Wolfe', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '8C8F5D47-E3F4-4577-BE7E-BC224431CF2B', CAST('2011-05-24T00:00:00' AS TIMESTAMP)),
    (281, 'SP', 0, NULL, 'Shu', 'K', 'Ito', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'CA87A053-6C5F-4F9B-8790-1D0AF332153A', CAST('2011-05-24T00:00:00' AS TIMESTAMP)),
    (282, 'SP', 0, NULL, 'José', 'Edvaldo', 'Saraiva', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '120C84EB-8A22-4E1F-8C2B-FF5F144FDB7D', CAST('2011-05-24T00:00:00' AS TIMESTAMP)),
    (283, 'SP', 0, NULL, 'David', 'R', 'Campbell', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '6F44C8D9-E3D0-482C-87DC-CCEB09060F31', CAST('2011-05-24T00:00:00' AS TIMESTAMP)),
    (284, 'SP', 0, 'Mr.', 'Tete', 'A', 'Mensa-Annan', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'F5BED54C-DF64-402C-93BD-7CFD1F79DEEE', CAST('2012-09-23T00:00:00' AS TIMESTAMP)),
    (285, 'SP', 0, 'Mr.', 'Syed', 'E', 'Abbas', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'FF284881-01C2-4C77-95A7-4DB96F59BB70', CAST('2013-03-07T00:00:00' AS TIMESTAMP)),
    (286, 'SP', 0, NULL, 'Lynn', '', 'Tsoflias', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'EED57FDF-01BE-4770-A2AD-10F3349CF3DB', CAST('2013-05-23T00:00:00' AS TIMESTAMP)),
    (287, 'SP', 0, NULL, 'Amy', 'E', 'Alberts', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '0CCB2270-1C40-4E7D-9A09-0B29A94DA8B6', CAST('2012-04-09T00:00:00' AS TIMESTAMP)),
    (288, 'SP', 0, NULL, 'Rachel', 'B', 'Valdez', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'F28093ED-C889-43EB-BE88-37C9E147148C', CAST('2013-05-23T00:00:00' AS TIMESTAMP)),
    (289, 'SP', 0, NULL, 'Jae', 'B', 'Pak', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '317764BC-A515-4C2B-9A82-8136B8EC538F', CAST('2012-05-23T00:00:00' AS TIMESTAMP)),
    (290, 'SP', 0, NULL, 'Ranjit', 'R', 'Varkey Chudukatil', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '5F6547B3-A7A9-4B14-8895-4402150BD903', CAST('2012-05-23T00:00:00' AS TIMESTAMP)),
    (291, 'SC', 0, 'Mr.', 'Gustavo', NULL, 'Achong', NULL, 2, '<AdditionalContactInfo xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo" xmlns:crm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactRecord" xmlns:act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes"><act:telephoneNumber><act:number>425-555-1112</act:number><act:SpecialInstructions>Call only after 5:00 p.m.</act:SpecialInstructions></act:telephoneNumber>Note that the customer has a secondary home address.<act:homePostalAddress><act:Street>123 Oak</act:Street><act:City>Seattle</act:City><act:StateProvince>WA</act:StateProvince><act:PostalCode>98001</act:PostalCode><act:CountryRegion>USA</act:CountryRegion><act:SpecialInstructions>If correspondence to the primary address fails, try this one.</act:SpecialInstructions></act:homePostalAddress>Customer provided additional email address.<act:eMail><act:eMailAddress>customer1@sample.com</act:eMailAddress><act:SpecialInstructions>For urgent issues, do not send e-mail. Instead use this emergency contact phone<act:telephoneNumber><act:number>425-555-1111</act:number></act:telephoneNumber>.</act:SpecialInstructions></act:eMail><crm:ContactRecord date="2001-06-02Z">This customer is interested in purchasing high-end bicycles for his family. The customer contacted Michael in sales.</crm:ContactRecord></AdditionalContactInfo>', '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-13909.13111</TotalPurchaseYTD></IndividualSurvey>', 'D4C132D3-FCB5-4231-9DD5-888A54BEC693', CAST('2015-04-15 16:33:33.060000000' AS TIMESTAMP)),
    (293, 'SC', 0, 'Ms.', 'Catherine', 'R.', 'Abel', NULL, 1, '<AdditionalContactInfo xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo" xmlns:crm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactRecord" xmlns:act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes">These are additional phone and pager numbers for the customer.<act:telephoneNumber><act:number>206-555-2222</act:number><act:SpecialInstructions>On weekends, contact the manager at this number.</act:SpecialInstructions></act:telephoneNumber><act:telephoneNumber><act:number>206-555-1234</act:number></act:telephoneNumber><act:pager><act:number>206-555-1244</act:number><act:SpecialInstructions>Do not page between 9:00 a.m. and 5:00 p.m.</act:SpecialInstructions></act:pager>Customer provided this additional home address.<act:homePostalAddress><act:Street>P.O Box 5</act:Street><act:City>Edmonds</act:City><act:StateProvince>WA</act:StateProvince><act:PostalCode>98431</act:PostalCode><act:CountryRegion>USA</act:CountryRegion><act:SpecialInstructions>This is an alternative address for billing only.</act:SpecialInstructions></act:homePostalAddress><act:eMail><act:eMailAddress>Joe@sample.com</act:eMailAddress><act:SpecialInstructions>Do not send e-mail for urgent issues. Use telephone instead.</act:SpecialInstructions></act:eMail><crm:ContactRecord date="2001-07-02Z">Sales contacted this customer to explain new pricing.</crm:ContactRecord></AdditionalContactInfo>', '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3943.7544</TotalPurchaseYTD></IndividualSurvey>', 'D54E0552-C226-4C22-AF3B-762CA854CDD3', CAST('2015-04-15 16:33:33.077000000' AS TIMESTAMP)),
    (295, 'SC', 0, 'Ms.', 'Kim', NULL, 'Abercrombie', NULL, 0, '<AdditionalContactInfo xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo" xmlns:crm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactRecord" xmlns:act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes">Customer provided this telephone number for weekend access.<act:telephoneNumber><act:number>605-555-9877</act:number></act:telephoneNumber>secondary phone number.<act:pager><act:number>310-555-5432</act:number><act:SpecialInstructions>Page only if other contact attempts fail.</act:SpecialInstructions></act:pager>Additional home address.<act:homePostalAddress><act:Street>990 5th Avenue</act:Street><act:City>Redmond</act:City><act:StateProvince>WA</act:StateProvince><act:PostalCode>98052</act:PostalCode><act:CountryRegion>USA</act:CountryRegion><act:SpecialInstructions>Use this address for billing only.</act:SpecialInstructions></act:homePostalAddress><act:eMail><act:eMailAddress>Customer3@sample.com</act:eMailAddress><act:SpecialInstructions>Do not send e-mails for urgent issues. Use telephone instead.</act:SpecialInstructions></act:eMail><crm:ContactRecord date="2002-01-01Z">Customer first contacted the sales department. This customer is interested in opening a new bicycle store.</crm:ContactRecord><crm:ContactRecord date="2002-01-05Z">Linda in sales returned the call. Customer provided another telephone number for off-hour coverage.<act:telephoneNumber><act:number>302-555-7733</act:number></act:telephoneNumber>We are still negotiating possible long-term contract.</crm:ContactRecord></AdditionalContactInfo>', '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-7948.6029</TotalPurchaseYTD></IndividualSurvey>', 'F7CBDB48-0B44-470E-9F37-7060446FBFB9', CAST('2015-04-15 16:33:33.077000000' AS TIMESTAMP)),
    (297, 'SC', 0, 'Sr.', 'Humberto', NULL, 'Acevedo', NULL, 2, '<AdditionalContactInfo xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo" xmlns:crm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactRecord" xmlns:act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes">Additional phone numbers.<act:mobile><act:number>750-555-8888</act:number><act:SpecialInstructions>If customer is not at work, call<act:telephoneNumber><act:number>222-555-4444</act:number></act:telephoneNumber></act:SpecialInstructions></act:mobile>Customer uses these two additional email addresses.<act:eMail><act:eMailAddress>Customer4@sample.com</act:eMailAddress></act:eMail><act:eMail><act:eMailAddress>Customer4@contoso.com</act:eMailAddress><act:SpecialInstructions>This is secondary email address.</act:SpecialInstructions></act:eMail><crm:ContactRecord date="2002-01-01Z">Customer is expanding his sports and recreation business. Sales is negotiating large sales order with this customer. We called Joe at<act:mobile><act:number>750-555-8888</act:number></act:mobile>We are still working on competitive pricing. Looks promising, but we need additional marketing support to wrap this up.</crm:ContactRecord></AdditionalContactInfo>', '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-20021.0528</TotalPurchaseYTD></IndividualSurvey>', '5A41D336-84CF-44D7-B12B-83B64B511F7E', CAST('2015-04-15 16:33:33.090000000' AS TIMESTAMP)),
    (299, 'SC', 0, 'Sra.', 'Pilar', NULL, 'Ackerman', NULL, 0, '<AdditionalContactInfo xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo" xmlns:crm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactRecord" xmlns:act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes"><crm:ContactRecord date="2002-01-01Z">Sales contacted this customer for the first time at<act:telephoneNumber><act:number>432-4444</act:number></act:telephoneNumber>We talked about the Road bike price drop and the new spring models. Customer provided us new mobile number<act:mobile><act:number>432-555-7809</act:number></act:mobile></crm:ContactRecord></AdditionalContactInfo>', '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5158.224</TotalPurchaseYTD></IndividualSurvey>', 'DF1FB8AB-2323-4330-9AB8-54E13CE6D8F9', CAST('2015-04-15 16:33:33.090000000' AS TIMESTAMP)),
    (301, 'SC', 0, 'Ms.', 'Frances', 'B.', 'Adams', NULL, 1, '<AdditionalContactInfo xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo" xmlns:crm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactRecord" xmlns:act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes">Additional email address.<act:eMail><act:eMailAddress>Customer6@sample.com</act:eMailAddress></act:eMail><crm:ContactRecord date="2002-07-01Z">Customer called us. Interested in the new Touring models.</crm:ContactRecord></AdditionalContactInfo>', '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-14477.2375</TotalPurchaseYTD></IndividualSurvey>', '66980082-C186-40AE-972A-74560E78C1AF', CAST('2015-04-15 16:33:33.090000000' AS TIMESTAMP)),
    (303, 'SC', 0, 'Ms.', 'Margaret', 'J.', 'Smith', NULL, 0, '<AdditionalContactInfo xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo" xmlns:crm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactRecord" xmlns:act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes">These are additional phone numbers the customer provided.<act:telephoneNumber><act:number>206-555-2222</act:number><act:SpecialInstructions>Best time to call is Monday-Wednesday mornings.</act:SpecialInstructions></act:telephoneNumber><act:mobile><act:number>209-555-2122</act:number></act:mobile></AdditionalContactInfo>', '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2421.0199</TotalPurchaseYTD></IndividualSurvey>', '691818E1-FC19-445F-B161-E401867368E3', CAST('2015-04-15 16:33:33.107000000' AS TIMESTAMP)),
    (305, 'SC', 0, 'Ms.', 'Carla', 'J.', 'Adams', NULL, 0, '<AdditionalContactInfo xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo" xmlns:crm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactRecord" xmlns:act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes"><crm:ContactRecord date="2002-09-02Z">The customer is interested in the Road-450 and Mountain-500 series bicycles. Customer called us. We need to follow up. Pager <act:pager><act:number>206-555-1234</act:number></act:pager> is the best way to reach.</crm:ContactRecord></AdditionalContactInfo>', '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-22476.234</TotalPurchaseYTD></IndividualSurvey>', '5F183B92-1648-4948-8937-47C9C10F0583', CAST('2015-04-15 16:33:33.107000000' AS TIMESTAMP)),
    (307, 'SC', 0, 'Mr.', 'Jay', NULL, 'Adams', NULL, 1, '<AdditionalContactInfo xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo" xmlns:crm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactRecord" xmlns:act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes">Additional home and mobile phone numbers:<act:telephoneNumber><act:number>253-555-4689</act:number></act:telephoneNumber><act:mobile><act:number>253-555-4878</act:number></act:mobile></AdditionalContactInfo>', '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-23834.7669</TotalPurchaseYTD></IndividualSurvey>', '38256645-4B88-4169-B68A-5B0118F18445', CAST('2015-04-15 16:33:33.123000000' AS TIMESTAMP)),
    (309, 'SC', 0, 'Mr.', 'Ronald', 'L.', 'Adina', NULL, 0, '<AdditionalContactInfo xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo" xmlns:crm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactRecord" xmlns:act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes"><crm:ContactRecord date="2002-09-02Z">Marketing called this customer. Customer provided this phone number for follow-up questions.<act:telephoneNumber><act:number>305-555-8888</act:number><act:SpecialInstructions>If no answer, try this pager number.<act:pager><act:number>308-555-3678</act:number></act:pager></act:SpecialInstructions></act:telephoneNumber> and this mobile number<act:mobile><act:number>308-555-4888</act:number></act:mobile></crm:ContactRecord></AdditionalContactInfo>', '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-7618.4208</TotalPurchaseYTD></IndividualSurvey>', 'DBB05A55-2256-42B1-901E-824D28158911', CAST('2015-04-15 16:33:33.123000000' AS TIMESTAMP)),
    (311, 'SC', 0, 'Mr.', 'Samuel', 'N.', 'Agcaoili', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-12897.6219</TotalPurchaseYTD></IndividualSurvey>', '43C55826-2843-49AB-BBBD-41065965A20E', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (313, 'SC', 0, 'Mr.', 'James', 'T.', 'Aguilar', 'Jr.', 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2569.9404</TotalPurchaseYTD></IndividualSurvey>', '35AD71E7-8B4E-4C65-A92F-D6829BB292A5', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (315, 'SC', 0, 'Mr.', 'Robert', 'E.', 'Ahlering', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5255.01</TotalPurchaseYTD></IndividualSurvey>', '61629167-3A73-4923-9A2C-AAF1ABE3672E', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (317, 'SC', 0, 'Mr.', 'François', NULL, 'Ferrier', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-48861.593876</TotalPurchaseYTD></IndividualSurvey>', 'B50C8DCD-EA86-43A5-AF69-84B7A6A7FAF9', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (319, 'SC', 0, 'Ms.', 'Kim', NULL, 'Akers', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5277.0496</TotalPurchaseYTD></IndividualSurvey>', '1EE0110F-77AE-4B1B-A05B-B03E0509BE95', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (321, 'SC', 0, 'Ms.', 'Lili', 'J.', 'Alameda', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'B6D14D10-265F-4D72-ACE8-C1A42F62C82E', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (323, 'SC', 0, 'Ms.', 'Amy', 'E.', 'Alberts', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3698.450608</TotalPurchaseYTD></IndividualSurvey>', '367113B0-AB80-40D7-A0B7-B1D9D83CE06E', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (325, 'SC', 0, 'Ms.', 'Anna', 'A.', 'Albright', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2658.129</TotalPurchaseYTD></IndividualSurvey>', 'B6E43A72-8F5F-4525-B4C0-EE84D764E86F', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (327, 'SC', 0, 'Mr.', 'Milton', 'J.', 'Albury', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1712.49</TotalPurchaseYTD></IndividualSurvey>', '7385E725-3AD2-4D66-BC9E-1594362EF939', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (329, 'SC', 0, 'Mr.', 'Paul', 'L.', 'Alcorn', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1267.422</TotalPurchaseYTD></IndividualSurvey>', '45A435C5-5FE1-4194-AF2A-29B4C62E2A2A', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (331, 'SC', 0, 'Mr.', 'Gregory', 'F.', 'Alderson', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4520.0576</TotalPurchaseYTD></IndividualSurvey>', '72479586-13A3-4F91-AB31-2AD2855FED2D', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (333, 'SC', 0, 'Mr.', 'J. Phillip', 'L.', 'Alexander', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-20478.6895</TotalPurchaseYTD></IndividualSurvey>', 'B5078EF5-206C-4FC2-A934-3D0EAB5E0C60', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (335, 'SC', 0, 'Ms.', 'Michelle', NULL, 'Alexander', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-298.062</TotalPurchaseYTD></IndividualSurvey>', 'CA1AB4EA-CBD9-4F27-9CC4-C6828FCD8216', CAST('2013-03-30T00:00:00' AS TIMESTAMP)),
    (337, 'SC', 0, 'Mr.', 'Sean', 'P.', 'Jacobson', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4994.538</TotalPurchaseYTD></IndividualSurvey>', 'CEF1C975-E3D9-465D-91CF-FA0F3C7EBFA2', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (339, 'SC', 0, 'Ms.', 'Phyllis', 'A.', 'Allen', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8910.7562</TotalPurchaseYTD></IndividualSurvey>', '4865D7B7-5961-43CA-AD25-9F77D9D5E4A8', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (341, 'SC', 0, 'Mr.', 'Marvin', 'N.', 'Allen', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8171.7865</TotalPurchaseYTD></IndividualSurvey>', '99A1A11E-7E5D-4E61-B2C2-FF5F7F78CF59', CAST('2011-10-31T00:00:00' AS TIMESTAMP)),
    (343, 'SC', 0, 'Mr.', 'Michael', NULL, 'Allen', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-15764.8128</TotalPurchaseYTD></IndividualSurvey>', 'FA93C578-2A25-4820-AA5D-E2437CC24C59', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (345, 'SC', 0, 'Mr.', 'Cecil', 'J.', 'Allison', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4392.206864</TotalPurchaseYTD></IndividualSurvey>', '3FB94B42-B159-4D6E-BBF1-115659144884', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (347, 'SC', 0, 'Mr.', 'Oscar', 'L.', 'Alpuerto', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-23789.8396</TotalPurchaseYTD></IndividualSurvey>', 'C599201D-A7AE-4F0E-8CCC-C76B4F946BE8', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (349, 'SC', 0, 'Ms.', 'Sandra', 'J.', 'Altamirano', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4354.05</TotalPurchaseYTD></IndividualSurvey>', 'F2DC755A-C176-4274-955C-E10031732242', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (351, 'SC', 0, 'Ms.', 'Selena', 'R.', 'Alvarado', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8785.4535</TotalPurchaseYTD></IndividualSurvey>', 'AF662FC4-6DD0-46F8-A547-98C572D46DDF', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (353, 'SC', 0, 'Mr.', 'Emilio', 'R.', 'Alvaro', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3587.3244</TotalPurchaseYTD></IndividualSurvey>', '6CCBE1A7-4E4B-4242-9EB7-8830CB9EA77A', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (355, 'SC', 0, 'Mr.', 'Maxwell', 'J.', 'Amland', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-14020.3232</TotalPurchaseYTD></IndividualSurvey>', 'FD32C96B-D3B8-4B50-9C58-FA0AB92A217A', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (357, 'SC', 0, 'Ms.', 'Mae', 'N.', 'Anderson', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3779.67975</TotalPurchaseYTD></IndividualSurvey>', 'FF2A1330-9211-4ECE-B355-4682EA36662D', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (359, 'SC', 0, 'Ms.', 'Ramona', 'J.', 'Antrim', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1657.548</TotalPurchaseYTD></IndividualSurvey>', '4782AD14-3F09-454C-B5BC-1F1AB922F86C', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (361, 'SC', 0, 'Ms.', 'Sabria', 'B.', 'Appelbaum', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6481.6109</TotalPurchaseYTD></IndividualSurvey>', '915EC73E-1AF5-41B0-857A-BBD3F6C6730B', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (363, 'SC', 0, 'Ms.', 'Hannah', 'R.', 'Arakawa', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1298.616</TotalPurchaseYTD></IndividualSurvey>', '92D8EDC9-4948-4348-8683-01CB62F79126', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (365, 'SC', 0, 'Ms.', 'Kyley', 'J.', 'Arbelaez', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8913.89967</TotalPurchaseYTD></IndividualSurvey>', '253A9028-5D6B-4FC4-A5A3-74560FCB7DA5', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (367, 'SC', 0, 'Mr.', 'Tom', 'H', 'Johnston', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-20697.5634</TotalPurchaseYTD></IndividualSurvey>', 'BC8FC7EC-3A2F-4436-8BEA-1A08AE3A6E39', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (369, 'SC', 0, 'Mr.', 'Thomas', 'B.', 'Armstrong', 'Jr.', 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4108.89595</TotalPurchaseYTD></IndividualSurvey>', '57D6E4EE-FBEE-424D-976C-4D15CA6991FD', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (371, 'SC', 0, 'Mr.', 'John', NULL, 'Arthur', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-7693.8214</TotalPurchaseYTD></IndividualSurvey>', '902112B6-7FE7-4E85-8D77-FF49C5E6761A', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (373, 'SC', 0, 'Mr.', 'Chris', NULL, 'Ashton', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4110.372</TotalPurchaseYTD></IndividualSurvey>', '962918C8-1598-40EA-AE5E-458B4A6B6853', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (375, 'SC', 0, 'Ms.', 'Teresa', NULL, 'Atkinson', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4240.1304</TotalPurchaseYTD></IndividualSurvey>', '6D3F3644-31EB-42B2-BCB1-4A970D2EFAF3', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (377, 'SC', 0, 'Mr.', 'John', 'P.', 'Ault', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8648.19</TotalPurchaseYTD></IndividualSurvey>', 'F0B67A75-4235-45D5-A5E0-2E938A975DE8', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (379, 'SC', 0, 'Mr.', 'Robert', 'A.', 'Avalos', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8582.652</TotalPurchaseYTD></IndividualSurvey>', '7B6F52CA-0379-417E-A66D-853183B39D76', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (381, 'SC', 0, 'Mr.', 'Stephen', 'M.', 'Ayers', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-9256.6687</TotalPurchaseYTD></IndividualSurvey>', '5041E52C-1469-4579-AA66-3074605CFFA8', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (383, 'SC', 0, 'Mr.', 'Phillip', 'M.', 'Bacalzo', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1556.16</TotalPurchaseYTD></IndividualSurvey>', '115001F9-FF6F-4322-9EA0-BD2E275D6357', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (385, 'SC', 0, 'Mr.', 'Daniel', NULL, 'Blanco', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3615.5276</TotalPurchaseYTD></IndividualSurvey>', '10783772-2CA3-4744-ADBB-445045DA6208', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (387, 'SC', 0, 'Mr.', 'Cory', 'K.', 'Booth', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-10112.904583</TotalPurchaseYTD></IndividualSurvey>', 'A80867C5-ED86-487B-B1B7-7C48126EB9F3', CAST('2011-10-31T00:00:00' AS TIMESTAMP)),
    (389, 'SC', 0, 'Mr.', 'James', 'B.', 'Bailey', 'Jr.', 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4971.4072</TotalPurchaseYTD></IndividualSurvey>', 'CFA4F9E4-A865-4A76-A0AC-0460D73E7EF7', CAST('2012-08-30T00:00:00' AS TIMESTAMP)),
    (391, 'SC', 0, 'Mr.', 'Douglas', 'A.', 'Baldwin', 'Jr.', 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-12025.3101</TotalPurchaseYTD></IndividualSurvey>', 'BD35D341-DF60-4B41-AF27-28A179D3F3B9', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (393, 'SC', 0, 'Ms.', 'Jennifer', 'B.', 'Bales', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3179.724</TotalPurchaseYTD></IndividualSurvey>', '762CAC13-C911-425D-AEF7-BD6C6722DE3E', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (395, 'SC', 0, 'Mr.', 'Alberto', 'F.', 'Baltazar', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'B3622F28-96D2-45C4-8310-F9688C6C631F', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (397, 'SC', 0, 'Mr.', 'Wayne', 'N.', 'Banack', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8975.0238</TotalPurchaseYTD></IndividualSurvey>', 'AA3425B9-0F7C-4F54-A037-D117DDC8BE1D', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (399, 'SC', 0, 'Mr.', 'Darrell', 'M.', 'Banks', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'B4A92667-F303-4586-AD53-548E2254D90C', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (401, 'SC', 0, 'Ms.', 'Angela', NULL, 'Barbariol', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'E25E7C6E-F378-42E1-8F0C-CC4E79E35F1C', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (403, 'SC', 0, 'Mr.', 'David', NULL, 'Barber', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '659DA8E8-C501-4F0E-A286-398FAF22D323', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (405, 'SC', 0, 'Mr.', 'Robert', 'L.', 'Barker', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-915.0252</TotalPurchaseYTD></IndividualSurvey>', 'B1B8F17D-64AE-4BD5-A626-9C43161FDD84', CAST('2012-10-30T00:00:00' AS TIMESTAMP)),
    (407, 'SC', 0, 'Ms.', 'Rebecca', 'R.', 'Barley', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2007.09</TotalPurchaseYTD></IndividualSurvey>', 'FEE35313-0747-4361-8259-C6D91B67EE57', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (409, 'SC', 0, 'Ms.', 'Brenda', 'L.', 'Barlow', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8172.606</TotalPurchaseYTD></IndividualSurvey>', '96970EB3-8B25-4E68-8BD4-5EAB2A96F60F', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (411, 'SC', 0, 'Mr.', 'Josh', NULL, 'Barnhill', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6635.3333</TotalPurchaseYTD></IndividualSurvey>', '37B54C12-D508-446B-8085-32B85790940E', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (413, 'SC', 0, 'Mr.', 'Adam', NULL, 'Barr', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8929.5598</TotalPurchaseYTD></IndividualSurvey>', 'E87B9431-227B-4AC7-860A-B764CFF0F492', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (415, 'SC', 0, 'Ms.', 'Norma', 'N.', 'Barrera', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '0A4851DB-0028-4A91-9D57-DA5450272CAA', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (417, 'SC', 0, NULL, 'Gytis', 'M', 'Barzdukas', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3960.6052</TotalPurchaseYTD></IndividualSurvey>', '8D2FEEC9-F95E-4398-A1FA-1DFF561B8EB9', CAST('2011-10-01T00:00:00' AS TIMESTAMP)),
    (419, 'SC', 0, 'Mr.', 'David', 'M.', 'Bartness', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2172.078</TotalPurchaseYTD></IndividualSurvey>', 'DD87C1A3-1254-4D2D-9596-251B576B28CA', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (421, 'SC', 0, 'Ms.', 'Karel', 'E.', 'Bates', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-10261.0519</TotalPurchaseYTD></IndividualSurvey>', 'CC35B476-85B0-40A0-B9F9-51B7C1C849F5', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (423, 'SC', 0, 'Sr.', 'Ciro', 'J.', 'Bauer', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'D26A8A72-F5EB-4BF6-B4C6-DB2D89606719', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (425, 'SC', 0, 'Ms.', 'Glenna', 'L.', 'Beanston', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '732E7E32-7EAF-48EB-A345-90D81EF8307B', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (427, 'SC', 0, 'Mr.', 'Shaun', NULL, 'Beasley', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5771.5534</TotalPurchaseYTD></IndividualSurvey>', '1649D376-3012-40A0-A821-C745FA34CA3F', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (429, 'SC', 0, 'Mr.', 'John', 'A.', 'Beaver', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-131.2036</TotalPurchaseYTD></IndividualSurvey>', '011DD8D5-1AC4-4FE8-B139-EE9D0EA172E6', CAST('2013-02-28T00:00:00' AS TIMESTAMP)),
    (431, 'SC', 0, 'Mr.', 'Christopher', 'R.', 'Beck', 'Jr.', 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-18088.887</TotalPurchaseYTD></IndividualSurvey>', '2DCA9FBE-92DF-4B43-B475-8BD20AA2DD1F', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (433, 'SC', 0, 'Mr.', 'Bradley', NULL, 'Beck', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'D6A90F54-57E8-498C-8D84-19F07B6202FA', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (435, 'SC', 0, 'Mr.', 'Benjamin', 'J.', 'Becker', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3645.816</TotalPurchaseYTD></IndividualSurvey>', '806D1C84-0290-49E5-9CB7-DA12AA7766A0', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (437, 'SC', 0, 'Ms.', 'Ann', NULL, 'Beebe', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1000.1139</TotalPurchaseYTD></IndividualSurvey>', '3D4B934D-6559-431B-B471-1FD508407B19', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (439, 'SC', 0, 'Mr.', 'Shane', 'J.', 'Belli', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-20839.3703</TotalPurchaseYTD></IndividualSurvey>', 'A899E65B-74FD-42E5-A0FB-B2F72B3C0218', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (441, 'SC', 0, 'Mr.', 'Stanley', 'A.', 'Alan', 'Jr.', 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-11853.9216</TotalPurchaseYTD></IndividualSurvey>', 'DD152AED-AA0A-4BF0-8435-71C075F646D7', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (443, 'SC', 0, 'Mr.', 'Mason', NULL, 'Bendixen', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2164.998</TotalPurchaseYTD></IndividualSurvey>', '9D353282-B8FD-4F15-AD44-3FF3D5D3ACDA', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (445, 'SC', 0, 'Mr.', 'John', 'M.', 'Bennetts', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-729.438</TotalPurchaseYTD></IndividualSurvey>', '694258A3-633C-42F9-98B8-08E50EDEDC68', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (447, 'SC', 0, 'Mr.', 'Ido', NULL, 'Ben-Sachar', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '6F05729C-5386-459C-A638-ED8E41B19584', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (449, 'SC', 0, 'Ms.', 'Edna', 'J.', 'Benson', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6487.11</TotalPurchaseYTD></IndividualSurvey>', '39E5E96C-C4AA-4A12-A8A8-B0C711115B4D', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (451, 'SC', 0, 'Mr.', 'Payton', 'P.', 'Benson', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-7018.7156</TotalPurchaseYTD></IndividualSurvey>', '912BFF37-4777-4899-A0B1-0FC112B2B79C', CAST('2011-10-01T00:00:00' AS TIMESTAMP)),
    (453, 'SC', 0, 'Mr.', 'Max', NULL, 'Benson', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4314.7686</TotalPurchaseYTD></IndividualSurvey>', '7B630976-FD10-4DBF-97C3-DB840853145E', CAST('2011-10-01T00:00:00' AS TIMESTAMP)),
    (455, 'SC', 0, 'Mr.', 'Scot', 'A.', 'Bent', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3154.584</TotalPurchaseYTD></IndividualSurvey>', '0D80E5F2-2723-433A-826D-BCF7D860688D', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (457, 'SC', 0, 'Mr.', 'Richard', 'M.', 'Bentley', 'Jr.', 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '07B1C116-AE07-4B1A-AC53-69D6943C1D3C', CAST('2013-03-30T00:00:00' AS TIMESTAMP)),
    (459, 'SC', 0, 'Ms.', 'Marian', 'M.', 'Berch', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'B9B136E9-A5A8-4207-90AC-AA896690975C', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (461, 'SC', 0, 'Ms.', 'Karen', NULL, 'Berge', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '2CAFBF86-4D0B-4864-9963-964413812403', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (463, 'SC', 0, 'Mr.', 'Alexander', 'J.', 'Berger', 'II', 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1274.764216</TotalPurchaseYTD></IndividualSurvey>', 'B66BB606-03A8-44E8-831B-2B8278534CE8', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (465, 'SC', 0, 'Mr.', 'John', 'M.', 'Berger', 'Jr.', 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-11626.0099</TotalPurchaseYTD></IndividualSurvey>', 'B901DD8D-087B-49BE-BF1F-3B11F6D95820', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (467, 'SC', 0, 'Ms.', 'Kris', 'R.', 'Bergin', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '32DCE686-0370-4E9F-8E4B-317D2278346A', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (469, 'SC', 0, NULL, 'Andreas', NULL, 'Berglund', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '5DB095E5-82F2-4742-B010-C14BA56E7537', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (471, 'SC', 0, 'Mr.', 'Robert', 'M.', 'Bernacchi', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3545.613</TotalPurchaseYTD></IndividualSurvey>', '15155B90-85C9-4B09-8ECA-2C03696F3A3F', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (473, 'SC', 0, 'Mr.', 'Matthias', NULL, 'Berndt', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-20873.9571</TotalPurchaseYTD></IndividualSurvey>', '8CECFF02-4D31-4331-AEA4-33468D7032F6', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (475, 'SC', 0, NULL, 'John', NULL, 'Berry', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-16463.544</TotalPurchaseYTD></IndividualSurvey>', '8F36A32A-BC2C-4313-910C-E7A1E2D13045', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (477, 'SC', 0, 'Mr.', 'Steven', 'B.', 'Brown', 'IV', 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-11792.0114</TotalPurchaseYTD></IndividualSurvey>', '3DC2AAA7-145C-47FD-978E-0D33083C8360', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (479, 'SC', 0, 'Mr.', 'Chris', 'N.', 'Bidelman', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4340.298</TotalPurchaseYTD></IndividualSurvey>', '9924416A-13DA-48FE-90DE-7EAAC04D6238', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (481, 'SC', 0, 'Ms.', 'Mary', 'B.', 'Billstrom', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-7677.462</TotalPurchaseYTD></IndividualSurvey>', '98A83410-B6FE-4CED-BEB6-FE552CCAC92E', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (483, 'SC', 0, 'Mr.', 'Jimmy', NULL, 'Bischoff', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3996.7435</TotalPurchaseYTD></IndividualSurvey>', '68023A5B-740B-45A6-BC8F-F8EEAE4C6B7B', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (485, 'SC', 0, 'Mr.', 'Mary', NULL, 'Bishop', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '6701B3D4-654F-452C-96F3-7AB7C7130A0E', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (487, 'SC', 0, 'Ms.', 'Mae', 'M.', 'Black', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4101.288</TotalPurchaseYTD></IndividualSurvey>', '9E1691E3-B0BF-40D2-9491-8073B2FBC95A', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (489, 'SC', 0, 'Ms.', 'Jackie', 'E.', 'Blackwell', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-218.85</TotalPurchaseYTD></IndividualSurvey>', '38CC4C3E-38F0-4169-AB2F-494B2B0F6ED1', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (491, 'SC', 0, 'Mr.', 'Donald', 'L.', 'Blanton', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2816.314</TotalPurchaseYTD></IndividualSurvey>', 'FF0E980C-B977-48A2-B390-DCCD57FC93F0', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (493, 'SC', 0, 'Ms.', 'Linda', 'E.', 'Burnett', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-9128.7368</TotalPurchaseYTD></IndividualSurvey>', 'CA8E700A-A8FA-4CF3-B71E-F3F57B9DF5CB', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (495, 'SC', 0, 'Mr.', 'Michael', 'Greg', 'Blythe', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5174.4768</TotalPurchaseYTD></IndividualSurvey>', '4FF1B5B1-435E-4262-B48E-D6B9A87B0257', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (497, 'SC', 0, 'Ms.', 'Gabriel', 'L.', 'Bockenkamp', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-16774.4932</TotalPurchaseYTD></IndividualSurvey>', '325ED05B-148A-4A9F-A714-AF1D7412B1B4', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (499, 'SC', 0, 'Mr.', 'Michael', 'L.', 'Bohling', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '25F763CA-6461-48DA-8DFF-0FB14B6F47D1', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (501, 'SC', 0, 'Ms.', 'Corinna', NULL, 'Bolender', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-207.749816</TotalPurchaseYTD></IndividualSurvey>', '72B2C875-D28C-48D6-AC64-D8C4A5E0EE37', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (503, 'SC', 0, 'Sr.', 'Luis', NULL, 'Bonifaz', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6234.4455</TotalPurchaseYTD></IndividualSurvey>', 'EA724F36-2135-42A5-8D9C-33658584E7F4', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (505, 'SC', 0, 'Mr.', 'Randall', NULL, 'Boseman', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3134.513</TotalPurchaseYTD></IndividualSurvey>', 'AE08C9D1-7700-4BAD-BDD1-80ABEC1E1DC5', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (507, 'SC', 0, 'Ms.', 'Stephanie', NULL, 'Bourne', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-738.09</TotalPurchaseYTD></IndividualSurvey>', 'CDD08CF9-EE2E-44F6-A486-8E40B32F688D', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (509, 'SC', 0, 'Mr.', 'Eli', NULL, 'Bowen', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1764.0159</TotalPurchaseYTD></IndividualSurvey>', '46CD304E-AF55-4AF3-9602-F78182864BEA', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (511, 'SC', 0, 'Mr.', 'Lester', 'J.', 'Bowman', 'Sr.', 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-7842.8321</TotalPurchaseYTD></IndividualSurvey>', '6B2E1E9B-E298-4F97-91C3-F6026A5C3AA8', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (513, 'SC', 0, 'Mr.', 'David', 'M.', 'Bradley', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-647.988</TotalPurchaseYTD></IndividualSurvey>', '66F455D6-78A2-4105-B768-53264395BE94', CAST('2013-08-30T00:00:00' AS TIMESTAMP)),
    (515, 'SC', 0, 'Mr.', 'Cornelius', 'L.', 'Brandon', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1611.741</TotalPurchaseYTD></IndividualSurvey>', '79AEC05A-E153-4600-81E3-090097B60C8E', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (517, 'SC', 0, 'Mr.', 'Richard', NULL, 'Bready', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-32607.13905</TotalPurchaseYTD></IndividualSurvey>', '2B5DA487-220D-45DA-8E61-996BC090AD89', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (519, 'SC', 0, 'Ms.', 'Sara', 'N.', 'Breer', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5744.6578</TotalPurchaseYTD></IndividualSurvey>', '498B64BB-D82B-46C0-AC38-5B93B760B847', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (521, 'SC', 0, 'Mr.', 'Ted', NULL, 'Bremer', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5008.2744</TotalPurchaseYTD></IndividualSurvey>', '4CD2E02D-3249-4DF7-A444-598A30B7BFB8', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (523, 'SC', 0, 'Mr.', 'Alan', NULL, 'Brewer', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3385.3678</TotalPurchaseYTD></IndividualSurvey>', 'E6164829-8FEC-4583-BFDD-8371C57926F2', CAST('2011-10-01T00:00:00' AS TIMESTAMP)),
    (525, 'SC', 0, 'Mr.', 'Walter', 'J.', 'Brian', 'IV', 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2380.26</TotalPurchaseYTD></IndividualSurvey>', '881E3408-CE51-4665-B800-9A5ACF9377FD', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (527, 'SC', 0, 'Mr.', 'Christopher', 'M.', 'Bright', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-838.9178</TotalPurchaseYTD></IndividualSurvey>', '6B3718BA-54AB-46B9-A60C-76CE3A54880D', CAST('2011-10-01T00:00:00' AS TIMESTAMP)),
    (529, 'SC', 0, 'Ms.', 'Carol', 'J.', 'Brink', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '423D97B7-6FE7-46AE-BB48-C2F400F12173', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (531, 'SC', 0, 'Mr.', 'David', 'J.', 'Brink', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2296.5304</TotalPurchaseYTD></IndividualSurvey>', '7892935F-1314-4505-952A-C536E6EDFF66', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (533, 'SC', 0, 'Mr.', 'John', 'R.', 'Brooks', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3947.6869</TotalPurchaseYTD></IndividualSurvey>', '4B21D63C-181F-404A-A1AB-03EDF4E1D478', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (535, 'SC', 0, 'Mr.', 'Willie', 'P.', 'Brooks', 'Jr.', 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4605.3478</TotalPurchaseYTD></IndividualSurvey>', '0446E735-E6A5-4C76-9154-08C65D4C046E', CAST('2011-10-01T00:00:00' AS TIMESTAMP)),
    (537, 'SC', 0, 'Ms.', 'Carolee', 'J.', 'Brown', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4852.752</TotalPurchaseYTD></IndividualSurvey>', '2D327432-4BF3-4C2B-A731-FDC896EEFDAD', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (539, 'SC', 0, 'Mr.', 'Jo', NULL, 'Brown', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8177.3631</TotalPurchaseYTD></IndividualSurvey>', 'B531E652-FB76-496C-A4A9-DB3C0CD3B88D', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (541, 'SC', 0, 'Mr.', 'Robert', NULL, 'Brown', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6308.544</TotalPurchaseYTD></IndividualSurvey>', 'D7B162E3-A30F-4E31-9F2C-DEBD9F8766C8', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (543, 'SC', 0, 'Mr.', 'Kevin', 'F.', 'Browne', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-10862.087624</TotalPurchaseYTD></IndividualSurvey>', 'A67CCA3B-E2CA-4001-ADFA-64A2B2F7452E', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (545, 'SC', 0, 'Ms.', 'Mary', 'K.', 'Browning', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2768.9177</TotalPurchaseYTD></IndividualSurvey>', '586B6ECC-96A6-4584-9D6C-A06AC6266791', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (547, 'SC', 0, 'Mr.', 'Dave', 'P.', 'Browning', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2855.215</TotalPurchaseYTD></IndividualSurvey>', '628DBA22-0EC1-4AE0-BCD2-8172ADCFA31F', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (549, 'SC', 0, 'Ms.', 'Bridget', 'E.', 'Browqett', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3438.6228</TotalPurchaseYTD></IndividualSurvey>', '1C3B3E89-6C89-4489-B305-0137CB8DC1D2', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (551, 'SC', 0, 'Mr.', 'Eric', 'J.', 'Brumfield', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4134.2279</TotalPurchaseYTD></IndividualSurvey>', '309505BC-2173-479A-9E49-AE93E07CBCC7', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (553, 'SC', 0, 'Mr.', 'Dick', 'R.', 'Brummer', 'Jr.', 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-12969.3408</TotalPurchaseYTD></IndividualSurvey>', '87D8475F-8E44-4DE5-9217-BE305C56ECD2', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (555, 'SC', 0, 'Mr.', 'Michael', NULL, 'Brundage', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2769.0792</TotalPurchaseYTD></IndividualSurvey>', 'F754087B-0F9C-4317-AA7C-6CECA33EBB3E', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (557, 'SC', 0, 'Ms.', 'Shirley', 'R.', 'Bruner', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-652.937</TotalPurchaseYTD></IndividualSurvey>', 'BA56D00B-AB71-46B7-859E-455484A60C79', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (559, 'SC', 0, 'Ms.', 'June', 'B.', 'Brunner', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-17373.1394</TotalPurchaseYTD></IndividualSurvey>', '3F1AF50B-36D5-4080-91AD-91D3CAC823F9', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (561, 'SC', 0, 'Mr.', 'Dirk', 'J.', 'Bruno', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-17658.3144</TotalPurchaseYTD></IndividualSurvey>', 'B2F789C1-05D8-40B2-9105-B2A8FFCF9CC5', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (563, 'SC', 0, 'Ms.', 'Nancy', NULL, 'Buchanan', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4138.8612</TotalPurchaseYTD></IndividualSurvey>', 'ED848E8C-5E2A-4FBE-88D7-8FC4F45EDF25', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (565, 'SC', 0, 'Sra.', 'Janaina Barreiro Gambaro', NULL, 'Bueno', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2324.55</TotalPurchaseYTD></IndividualSurvey>', '4CA3AB6C-CBBA-4AB3-8B8D-1B0E497274DF', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (567, 'SC', 0, 'Mr.', 'Edward', 'T.', 'Buensalido', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2761.32</TotalPurchaseYTD></IndividualSurvey>', '230D320F-6EFD-4B15-B110-3405FE2CE8D0', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (569, 'SC', 0, 'Ms.', 'Megan', 'E.', 'Burke', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-19859.289508</TotalPurchaseYTD></IndividualSurvey>', '3E2FB5D8-D299-4F33-B24A-5F70F42694A3', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (571, 'SC', 0, 'Ms.', 'Ingrid', 'K.', 'Burkhardt', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '7DDDFCD7-E203-4D0C-BB97-5B10A5CF9CC0', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (573, 'SC', 0, 'Ms.', 'Karren', 'K.', 'Burkhardt', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5056.3756</TotalPurchaseYTD></IndividualSurvey>', '8B6115C8-404E-4178-B784-87F833B5A095', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (575, 'SC', 0, 'Mr.', 'Ovidiu', NULL, 'Burlacu', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'B1BD6887-A5B7-4E1E-AEB8-A1F76A2F76F2', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (577, 'SC', 0, 'Ms.', 'Dana', 'H.', 'Burnell', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-127.8</TotalPurchaseYTD></IndividualSurvey>', '6B8EEDA2-CD1C-4AA8-A77B-1CC089533E49', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (579, 'SC', 0, 'Mr.', 'Timothy', 'B.', 'Burnett', 'Jr.', 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5345.13258</TotalPurchaseYTD></IndividualSurvey>', 'B4A086B9-B9BA-40C1-B08F-AF78BED920EB', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (581, 'SC', 0, 'Mr.', 'Stephen', 'R.', 'Burton', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8868.93</TotalPurchaseYTD></IndividualSurvey>', 'FB56A714-9382-4417-9E89-AC61415D6C9A', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (583, 'SC', 0, 'Ms.', 'Deanna', 'R.', 'Buskirk', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3749.7846</TotalPurchaseYTD></IndividualSurvey>', 'C544B152-6E8C-49A2-BA7F-AD9F64A1AEDC', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (585, 'SC', 0, 'Mr.', 'Jared', 'L.', 'Bustamante', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4302.2176</TotalPurchaseYTD></IndividualSurvey>', '50DCEBC6-14DF-4ABE-8484-40408407D116', CAST('2011-10-01T00:00:00' AS TIMESTAMP)),
    (587, 'SC', 0, 'Mr.', 'Richard', 'A.', 'Byham', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-669</TotalPurchaseYTD></IndividualSurvey>', 'DEC2779C-1BC9-493B-B050-7F5E67BADE01', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (589, 'SC', 0, 'Mr.', 'David', 'J.', 'Byrnes', 'Sr.', 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4883.9847</TotalPurchaseYTD></IndividualSurvey>', 'A8579A7F-2D79-41A2-979E-B2A1EE81DFA0', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (591, 'SC', 0, 'Mr.', 'Ryan', NULL, 'Calafato', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-20243.2341</TotalPurchaseYTD></IndividualSurvey>', 'C52CD03A-8653-472C-AE2E-5490A2590D75', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (593, 'SC', 0, 'Ms.', 'Sylvia', 'A.', 'Caldwell', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'C65DCD1D-FBCA-4CBF-8FFB-2B2F50991691', CAST('2012-09-30T00:00:00' AS TIMESTAMP)),
    (595, 'SC', 0, 'Ms.', 'Mari', 'B.', 'Caldwell', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-7830.498</TotalPurchaseYTD></IndividualSurvey>', 'CAD9AED3-9D15-4494-9AAC-AC66B8AD65A0', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (597, 'SC', 0, 'Ms.', 'Barbara', 'J.', 'Calone', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-30764.7584</TotalPurchaseYTD></IndividualSurvey>', '99D918E9-0DE7-4E70-8DD4-AC98C4297792', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (599, 'SC', 0, 'Ms.', 'Lindsey', 'R.', 'Camacho', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-9999.2076</TotalPurchaseYTD></IndividualSurvey>', '32E0B800-B5E8-4AAB-9394-BE1523A19B62', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (601, 'SC', 0, 'Sr.', 'Gustavo', NULL, 'Camargo', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-7333.5315</TotalPurchaseYTD></IndividualSurvey>', 'CD476813-1A70-4DB4-8A1D-B26C02A1340C', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (603, 'SC', 0, 'Ms.', 'DeeDee', 'J.', 'Cameron', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-352.9867</TotalPurchaseYTD></IndividualSurvey>', '788034C8-39DD-4DE2-9ACA-A522E731DBB1', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (605, 'SC', 0, 'Ms.', 'Deborah', 'M.', 'Lee', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '3981DA23-757F-4715-8220-2E538DBAE568', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (607, 'SC', 0, 'Ms.', 'Joan', 'M.', 'Campbell', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-10060.0858</TotalPurchaseYTD></IndividualSurvey>', 'B0932973-C642-4B35-883B-03A5FE5AD44E', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (609, 'SC', 0, 'Mr.', 'David', NULL, 'Campbell', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-12428.518</TotalPurchaseYTD></IndividualSurvey>', 'B493CF71-F031-4B25-BDFE-20B3681DD4D3', CAST('2012-09-30T00:00:00' AS TIMESTAMP)),
    (611, 'SC', 0, 'Mr.', 'Henry', 'L.', 'Campen', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-18217.76435</TotalPurchaseYTD></IndividualSurvey>', '6EFD9EDF-B06C-4530-9C5F-14054A8EEA90', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (613, 'SC', 0, 'Mr.', 'Chris', NULL, 'Cannon', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-7514.436</TotalPurchaseYTD></IndividualSurvey>', '92ED161A-249A-4C74-B8F0-CC818FFBE12A', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (615, 'SC', 0, 'Mr.', 'Joseph', 'J.', 'Cantoni', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5646.8774</TotalPurchaseYTD></IndividualSurvey>', 'E0EF5905-7AD2-4510-8ED9-9A207176689F', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (617, 'SC', 0, 'Ms.', 'Suzana De Abreu', 'A.', 'Canuto', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6071.536125</TotalPurchaseYTD></IndividualSurvey>', 'CA9D7C75-44C1-4170-BFF8-E731974D2E3A', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (619, 'SC', 0, 'Mr.', 'Jun', NULL, 'Cao', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5525.13</TotalPurchaseYTD></IndividualSurvey>', '83877DF5-9A89-4A03-B1AA-0C78F9043E1B', CAST('2012-09-30T00:00:00' AS TIMESTAMP)),
    (621, 'SC', 0, 'Mr.', 'Johnny', 'A.', 'Caprio', 'Jr.', 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-12330.318752</TotalPurchaseYTD></IndividualSurvey>', 'F0278BEE-A86C-43A7-920C-58F5FD5F5175', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (623, 'SC', 0, 'Mr.', 'Richard', NULL, 'Carey', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-13653.726</TotalPurchaseYTD></IndividualSurvey>', 'F80F9900-7FCA-4A4A-A060-F180E0561679', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (625, 'SC', 0, 'Mr.', 'Carlton', 'M.', 'Carlisle', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-11928.228</TotalPurchaseYTD></IndividualSurvey>', '77656232-BDDE-4CBE-9E6F-B4261E32505E', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (627, 'SC', 0, 'Mr.', 'Ty Loren', NULL, 'Carlson', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4672.5218</TotalPurchaseYTD></IndividualSurvey>', '2957170D-8AE7-4555-8EF7-0D9BFC87AF91', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (629, 'SC', 0, 'Ms.', 'Jane', 'N.', 'Carmichael', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6357.9036</TotalPurchaseYTD></IndividualSurvey>', 'B5331048-01B4-448B-8F5D-6C0C6E9E3DB0', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (631, 'SC', 0, 'Ms.', 'Jovita', 'A.', 'Carmody', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8697.474375</TotalPurchaseYTD></IndividualSurvey>', 'D39915B3-9EB7-4048-AEA2-E421107ADE58', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (633, 'SC', 0, 'Mr.', 'Steve', 'J.', 'Carnes', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3532.986</TotalPurchaseYTD></IndividualSurvey>', 'C4D75D81-A251-400D-ACD1-058B35339FA7', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (635, 'SC', 0, 'Mr.', 'Fernando', NULL, 'Caro', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6357.384</TotalPurchaseYTD></IndividualSurvey>', 'F6BB29A1-54BA-4E7A-BB9C-470C780B35D8', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (637, 'SC', 0, 'Mr.', 'Rob', NULL, 'Caron', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5623.4144</TotalPurchaseYTD></IndividualSurvey>', '40D427EE-D647-4E23-96B2-727869A910B2', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (639, 'SC', 0, 'Mr.', 'Andy', NULL, 'Carothers', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5167.734</TotalPurchaseYTD></IndividualSurvey>', '12AAD41F-CB14-47B4-8D5D-8AB4B403FB3E', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (641, 'SC', 0, 'Ms.', 'Donna', 'F.', 'Carreras', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-9616.6719</TotalPurchaseYTD></IndividualSurvey>', '2820F4B0-135D-4387-A507-1F70A3505FB1', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (643, 'SC', 0, 'Ms.', 'Rosmarie', 'J.', 'Carroll', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-955.104</TotalPurchaseYTD></IndividualSurvey>', 'E1D657EF-68CB-4378-A676-2FCF67EBF8AB', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (645, 'SC', 0, 'Mr.', 'Matthew', NULL, 'Carroll', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '60797E4A-461A-425F-8E11-02CCA751977C', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (647, 'SC', 0, 'Mr.', 'Joseph', 'N.', 'Castellucio', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-17110.6054</TotalPurchaseYTD></IndividualSurvey>', '9A23E182-5BC7-44E4-800A-A1744AB449A4', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (649, 'SC', 0, 'Ms.', 'Pamela', 'A.', 'Carlson', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3435.6315</TotalPurchaseYTD></IndividualSurvey>', 'D4ABC852-2033-4C47-B3C0-32CDEB6F33D0', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (651, 'SC', 0, 'Mr.', 'Raul', 'E.', 'Casts', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-971.514</TotalPurchaseYTD></IndividualSurvey>', '431227C0-A31B-4D91-A43F-84F490715059', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (653, 'SC', 0, 'Ms.', 'Elizabeth', 'E.', 'Catalano', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-16461.01595</TotalPurchaseYTD></IndividualSurvey>', '5963C3DB-BE38-45BA-BDFD-DA1D61300206', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (655, 'SC', 0, 'Mr.', 'Matthew', 'J.', 'Cavallari', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2641.7628</TotalPurchaseYTD></IndividualSurvey>', 'D388A69D-A6AF-42AC-9597-7CFAF0501475', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (657, 'SC', 0, 'Ms.', 'Brigid', 'F.', 'Cavendish', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6513.8842</TotalPurchaseYTD></IndividualSurvey>', '56F7C46E-39F8-48BD-8708-0CB77475BCAB', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (659, 'SC', 0, 'Mr.', 'Andrew', NULL, 'Cencini', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5393.0088</TotalPurchaseYTD></IndividualSurvey>', '9B80DBEE-6A75-45F5-84DC-10C3EF6FF808', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (661, 'SC', 0, 'Ms.', 'Stacey', 'M.', 'Cereghino', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-27472.2599</TotalPurchaseYTD></IndividualSurvey>', '55F9D6D3-43D7-44C1-9B1A-1A398CF3BE4A', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (663, 'SC', 0, 'Mr.', 'Baris', NULL, 'Cetinok', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2930.831308</TotalPurchaseYTD></IndividualSurvey>', '46F7CCCA-DC1B-4AD4-8DAB-1212DB19F7F2', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (665, 'SC', 0, 'Mr.', 'Sean', NULL, 'Chai', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-479.898</TotalPurchaseYTD></IndividualSurvey>', 'EF57D74A-6847-447D-864B-740B8E241627', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (667, 'SC', 0, 'Mr.', 'Pat', 'A.', 'Chambers', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-15720.93635</TotalPurchaseYTD></IndividualSurvey>', 'F219DAEF-4372-4E5B-A9EF-60B56240EBD7', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (669, 'SC', 0, 'Mr.', 'Forrest', 'J.', 'Chandler', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1803.228</TotalPurchaseYTD></IndividualSurvey>', '486D5868-CEA6-470D-B41D-CBB2CC8046E8', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (671, 'SC', 0, 'Mr.', 'Lee', 'J.', 'Chapla', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8958.1152</TotalPurchaseYTD></IndividualSurvey>', 'FE1AB8DB-A700-4D29-AEC7-B555D38EA840', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (673, 'SC', 0, 'Mr.', 'Greg', NULL, 'Chapman', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'DF20285D-EC36-438A-B3B2-46D088FDFBC7', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (675, 'SC', 0, 'Mr.', 'Neil', NULL, 'Charney', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-490.446</TotalPurchaseYTD></IndividualSurvey>', '9A5AFDCA-413A-45E3-B8CD-5C3DB6BE90C6', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (677, 'SC', 0, 'Mr.', 'Hao', NULL, 'Chen', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '5CA4A02B-3327-4BEE-B698-30DD5CDFB5BA', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (679, 'SC', 0, 'Mr.', 'John', 'Y.', 'Chen', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'D6E4BD36-001D-4286-BEC4-634E1886CBDE', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (681, 'SC', 0, 'Mr.', 'Pei', NULL, 'Chow', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2235.186</TotalPurchaseYTD></IndividualSurvey>', '3989A851-C05D-4F53-98E0-B73650ACB2B0', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (683, 'SC', 0, 'Mr.', 'Yao-Qiang', NULL, 'Cheng', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-10075.9737</TotalPurchaseYTD></IndividualSurvey>', '58FE206C-79F0-4F45-8394-6BF7BF5B2D4C', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (685, 'SC', 0, 'Ms.', 'Nicky', 'E.', 'Chesnut', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-13362.06075</TotalPurchaseYTD></IndividualSurvey>', '8AC42F96-E03E-44CD-98F2-9CE548963D75', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (687, 'SC', 0, 'Ms.', 'Susan', 'B.', 'Chestnut', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6801.876</TotalPurchaseYTD></IndividualSurvey>', '3FE0425A-9682-4089-9986-62E5C16B403A', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (689, 'SC', 0, 'Mr.', 'Martin', NULL, 'Chisholm', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2447.622</TotalPurchaseYTD></IndividualSurvey>', '815C70E3-011E-4D90-9F32-0CC64609A472', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (691, 'SC', 0, 'Mr.', 'Mike', 'M.', 'Choi', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-7881.469576</TotalPurchaseYTD></IndividualSurvey>', 'DBB26B94-07C5-435F-9FC2-6EC971F9B986', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (693, 'SC', 0, 'Ms.', 'Ruth', 'A.', 'Choin', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2566.6891</TotalPurchaseYTD></IndividualSurvey>', '8F1BE194-D9BE-45D3-BD00-53291893B45B', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (695, 'SC', 0, 'Mr.', 'Anthony', NULL, 'Chor', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5502.820875</TotalPurchaseYTD></IndividualSurvey>', 'C84289C0-F96E-445E-9912-293027DD5279', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (697, 'SC', 0, 'Mr.', 'Charles', 'M.', 'Christensen', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8018.9485</TotalPurchaseYTD></IndividualSurvey>', '3A2D4953-5D05-4949-9499-A68A8C63B478', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (699, 'SC', 0, 'Ms.', 'Jill', 'J.', 'Christie', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4951.6101</TotalPurchaseYTD></IndividualSurvey>', '99E89D47-4587-4834-9C2E-73CBA6B3BB5B', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (701, 'SC', 0, 'Ms.', 'Alice', NULL, 'Clark', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6973.188</TotalPurchaseYTD></IndividualSurvey>', '8C3BAD59-0A4B-4981-96E3-3AA82CA63DF7', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (703, 'SC', 0, 'Ms.', 'Gina', 'N.', 'Clark', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-18314.946</TotalPurchaseYTD></IndividualSurvey>', '2AFFCF46-56CF-4941-9FFA-C43C42F86AC0', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (705, 'SC', 0, 'Mr.', 'James', 'J.', 'Clark', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3389.37</TotalPurchaseYTD></IndividualSurvey>', '74FE7967-D8BF-4A1C-A685-A79A5242CB02', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (707, 'SC', 0, 'Ms.', 'Jane', NULL, 'Clayton', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3200.418</TotalPurchaseYTD></IndividualSurvey>', '22A626D6-0E68-4D1F-9388-436AA774DA0C', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (709, 'SC', 0, 'Ms.', 'Kristine', 'J.', 'Cleary', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-7741.674</TotalPurchaseYTD></IndividualSurvey>', '4EE9E5D6-F899-4277-83DB-0C638875F277', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (711, 'SC', 0, 'Ms.', 'Teanna', 'M.', 'Cobb', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '5E07B7BB-6EC5-480E-9392-D828D6651AE8', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (713, 'SC', 0, 'Ms.', 'Connie', 'L.', 'Coffman', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-838.9178</TotalPurchaseYTD></IndividualSurvey>', 'B71DF301-3AE6-4544-B113-10A360A4C021', CAST('2011-10-01T00:00:00' AS TIMESTAMP)),
    (715, 'SC', 0, 'Ms.', 'Jeanette', 'R.', 'Cole', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-9681.3596</TotalPurchaseYTD></IndividualSurvey>', '4A48A3F0-FE92-4490-988C-B1F95E3A8F2B', CAST('2011-10-31T00:00:00' AS TIMESTAMP)),
    (717, 'SC', 0, 'Mr.', 'Eric', 'E.', 'Coleman', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3806.94975</TotalPurchaseYTD></IndividualSurvey>', '5254BEF7-B51A-4ABC-BEE2-6EE46FEFEE03', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (719, 'SC', 0, 'Mr.', 'Pat', NULL, 'Coleman', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4712.440875</TotalPurchaseYTD></IndividualSurvey>', 'E9F5B558-CB09-4212-9A9D-6B87E1D82AEF', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (721, 'SC', 0, 'Mr.', 'Takiko', 'J.', 'Collins', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2572.122</TotalPurchaseYTD></IndividualSurvey>', '0D7BFDFC-F7CD-444B-95F1-9304059795A8', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (723, 'SC', 0, 'Mr.', 'John', 'L.', 'Colon', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3355.6712</TotalPurchaseYTD></IndividualSurvey>', '23030320-BA4C-47BA-A202-1D241D26EB83', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (725, 'SC', 0, 'Mr.', 'Scott', 'A.', 'Colvin', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1145.8902</TotalPurchaseYTD></IndividualSurvey>', '34E39986-605E-494B-8BFB-0126446141BF', CAST('2011-10-31T00:00:00' AS TIMESTAMP)),
    (727, 'SC', 0, 'Mr.', 'Aaron', NULL, 'Con', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-7983.5739</TotalPurchaseYTD></IndividualSurvey>', '8FAED624-34E1-4E5E-88E6-D59320E67AC4', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (729, 'SC', 0, 'Mr.', 'Peter', NULL, 'Connelly', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1924.374</TotalPurchaseYTD></IndividualSurvey>', '9258DC85-D106-4833-B157-01F7002876EF', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (731, 'SC', 0, 'Mr.', 'William', 'J.', 'Conner', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6705.4794</TotalPurchaseYTD></IndividualSurvey>', 'A26C02DE-1268-44A3-8E34-3AFC37D7331A', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (733, 'SC', 0, 'Ms.', 'Stephanie', NULL, 'Conroy', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6044.7467</TotalPurchaseYTD></IndividualSurvey>', '99849527-310E-4F39-AF11-B95525F959CC', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (735, 'SC', 0, 'Ms.', 'Amy', 'R.', 'Consentino', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3294.282</TotalPurchaseYTD></IndividualSurvey>', '69772008-1512-4370-8F77-4C5D5C316DBA', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (737, 'SC', 0, 'Ms.', 'Dorothy', 'J.', 'Contreras', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-12448.5143</TotalPurchaseYTD></IndividualSurvey>', '71F2130C-84FF-4DF5-B5A2-73C6A95D1848', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (739, 'SC', 0, 'Mr.', 'Patrick', 'M.', 'Cook', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4170.8765</TotalPurchaseYTD></IndividualSurvey>', '57D91698-A060-4F4D-99E0-22B015350C88', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (741, 'SC', 0, 'Mr.', 'Scott', NULL, 'Cooper', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3635.2066</TotalPurchaseYTD></IndividualSurvey>', '51B4D79C-C098-4422-B570-7BE3CA0C8FCF', CAST('2011-08-31T00:00:00' AS TIMESTAMP)),
    (743, 'SC', 0, 'Ms.', 'Eva', NULL, 'Corets', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3246.97657</TotalPurchaseYTD></IndividualSurvey>', 'FC24E5A2-5AA5-430E-B661-F4EE9D52029B', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (745, 'SC', 0, 'Mr.', 'Marlin', 'M.', 'Coriell', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-13675.891175</TotalPurchaseYTD></IndividualSurvey>', '0F2B7C68-4D2D-43E9-8A4A-D1B31108C6C1', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (747, 'SC', 0, 'Mr.', 'Ryan', NULL, 'Cornelsen', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '3A076391-3EBB-4B38-BDFE-05DF6543081A', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (749, 'SC', 0, 'Mr.', 'Bruno', NULL, 'Costa Da Silva', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '06ADA335-52F1-4128-BA4B-F9920740E80A', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (751, 'SC', 0, 'Ms.', 'Pamela', 'R.', 'Cox', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-24303.19495</TotalPurchaseYTD></IndividualSurvey>', '9874D04F-EEED-4BBC-B78C-BBBC2482C677', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (753, 'SC', 0, 'Mr.', 'Jack', NULL, 'Creasey', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-11372.322</TotalPurchaseYTD></IndividualSurvey>', '7403B4C0-AFF2-428E-8593-7E566E2472AA', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (755, 'SC', 0, 'Ms.', 'Sharon', 'A.', 'Crow', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'DE44A5AC-CCFC-4A2C-B48C-9915CC450511', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (757, 'SC', 0, 'Ms.', 'Shelley', 'R.', 'Crow', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1221.036</TotalPurchaseYTD></IndividualSurvey>', '31E2DF54-57BB-4902-82B9-4C0C5D6FDB47', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (759, 'SC', 0, 'Mr.', 'Grant', NULL, 'Culbertson', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5003.7408</TotalPurchaseYTD></IndividualSurvey>', 'D9025B48-F8A9-4D83-9837-C362D8D822D3', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (761, 'SC', 0, 'Mr.', 'Scott', NULL, 'Culp', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4751.7771</TotalPurchaseYTD></IndividualSurvey>', 'FDB8A700-3D5E-4D44-8DF4-EA4D5497BABB', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (763, 'SC', 0, 'Mr.', 'Conor', NULL, 'Cunningham', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3785.6497</TotalPurchaseYTD></IndividualSurvey>', '5B22508A-224A-424C-9C79-30A87895C6A1', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (765, 'SC', 0, 'Mr.', 'Jose', 'M.', 'Curry', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6587.5794</TotalPurchaseYTD></IndividualSurvey>', '820EC1B0-EFB7-4363-8E9E-AB4DF5387E0B', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (767, 'SC', 0, 'Mr.', 'Thierry', NULL, 'D''Hers', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3116.492825</TotalPurchaseYTD></IndividualSurvey>', '83C2BA9B-7197-4CE5-89D8-BFCAB7534672', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (769, 'SC', 0, 'Mr.', 'Ryan', NULL, 'Danner', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-10586.106</TotalPurchaseYTD></IndividualSurvey>', '748C5ACA-D021-4B7D-BED0-905DB7497D89', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (771, 'SC', 0, 'Mr.', 'Mike', NULL, 'Danseglio', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5592.5316</TotalPurchaseYTD></IndividualSurvey>', '4DC82108-E043-418B-8A54-7F3D4E600C9B', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (773, 'SC', 0, 'Ms.', 'Megan', 'N.', 'Davis', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2170.458</TotalPurchaseYTD></IndividualSurvey>', '1FED9B9B-5398-4DEC-8454-90B2844BA2AA', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (775, 'SC', 0, 'Sr.', 'Alvaro', NULL, 'De Matos Miranda Filho', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-10554.6266</TotalPurchaseYTD></IndividualSurvey>', 'F5C85E68-C674-4DDE-A7BF-583F08B1936A', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (777, 'SC', 0, 'Mr.', 'Jose', NULL, 'De Oliveira', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1445.1898</TotalPurchaseYTD></IndividualSurvey>', '3E7D3DD6-5027-4BA7-9A77-4DC413F24E86', CAST('2012-04-30T00:00:00' AS TIMESTAMP)),
    (779, 'SC', 0, 'Mr.', 'Jacob', 'N.', 'Dean', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6186.4826</TotalPurchaseYTD></IndividualSurvey>', '366627CC-57CD-4F6B-A248-468D11F59173', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (781, 'SC', 0, 'Mr.', 'Alexander', 'J.', 'Deborde', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-728.161</TotalPurchaseYTD></IndividualSurvey>', '49E1AFE9-FEFC-40A7-808C-214CBDD79EFB', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (783, 'SC', 0, 'Ms.', 'Barbara', 'S.', 'Decker', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1940.406</TotalPurchaseYTD></IndividualSurvey>', '027E39F9-5466-438E-8A90-02FA366D7C6C', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (785, 'SC', 0, 'Mr.', 'Kirk', NULL, 'DeGrasse', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8847.4712</TotalPurchaseYTD></IndividualSurvey>', '6BD6792C-8834-4725-B45D-A277C57958E2', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (787, 'SC', 0, 'Ms.', 'Aidan', NULL, 'Delaney', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6274.951775</TotalPurchaseYTD></IndividualSurvey>', '0DAF75FD-4C86-4E43-B6BA-FB9830C4135F', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (789, 'SC', 0, 'Mr.', 'Stefan', NULL, 'Delmarco', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-22297.0914</TotalPurchaseYTD></IndividualSurvey>', '14A72F97-3D24-42E4-AAD4-CD8B0B5EC9E1', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (791, 'SC', 0, 'Mr.', 'Shawn', 'R.', 'Demicell', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5350.0724</TotalPurchaseYTD></IndividualSurvey>', 'BE9FA09C-D5DF-49BB-A10C-AC989672E483', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (793, 'SC', 0, 'Ms.', 'Della', 'F.', 'Demott Jr', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6321.006292</TotalPurchaseYTD></IndividualSurvey>', '0335F445-4AFA-4DBF-88E7-98429A34540C', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (795, 'SC', 0, 'Mr.', 'Bruno', NULL, 'Deniut', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5938.434</TotalPurchaseYTD></IndividualSurvey>', '945A67E6-CAC2-47D8-8B7E-569DEFA040D5', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (797, 'SC', 0, 'Ms.', 'Helen', 'J.', 'Dennis', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8695.694676</TotalPurchaseYTD></IndividualSurvey>', '4409E074-05F8-43EC-97C0-58EDAF8E7B89', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (799, 'SC', 0, 'Mr.', 'Prashanth', NULL, 'Desai', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-205.321</TotalPurchaseYTD></IndividualSurvey>', '3A9C3CB6-1A91-4AB2-AB16-A65AA6EB9CAE', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (801, 'SC', 0, 'Ms.', 'Bev', 'L.', 'Desalvo', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6047.245</TotalPurchaseYTD></IndividualSurvey>', '3CBB4C2B-9BA6-4FE1-AB04-06F6195A571F', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (803, 'SC', 0, 'Ms.', 'Brenda', NULL, 'Diaz', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-17479.758</TotalPurchaseYTD></IndividualSurvey>', '3B346F3B-0706-4A79-964A-D33446EA693A', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (805, 'SC', 0, 'Ms.', 'Gabriele', NULL, 'Dickmann', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-9402.006</TotalPurchaseYTD></IndividualSurvey>', '4D3BDBA2-A575-4520-B9CD-19C3240A1595', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (807, 'SC', 0, 'Ms.', 'Holly', NULL, 'Dickson', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-7275.1536</TotalPurchaseYTD></IndividualSurvey>', 'A9823A48-8715-4635-99C2-E5106983F0A4', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (809, 'SC', 0, 'Mr.', 'Dick', NULL, 'Dievendorff', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1462.386</TotalPurchaseYTD></IndividualSurvey>', '8ED8C1DA-9A33-48A8-8473-B47085EA6772', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (811, 'SC', 0, 'Mr.', 'Rudolph', 'J.', 'Dillon', 'Sr.', 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-11516.9692</TotalPurchaseYTD></IndividualSurvey>', '8D3BF552-B9DD-43D5-B4E3-727D7B2EF9FB', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (813, 'SC', 0, 'Mr.', 'Andrew', NULL, 'Dixon', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-44002.3023</TotalPurchaseYTD></IndividualSurvey>', '4B60B9E7-9275-486C-816C-563A5869B786', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (815, 'SC', 0, 'Mr.', 'Blaine', NULL, 'Dockter', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-28362.4553</TotalPurchaseYTD></IndividualSurvey>', 'C5A18908-0DA8-43D4-95A6-27DA0D22D5C9', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (817, 'SC', 0, 'Ms.', 'Cindy', 'M.', 'Dodd', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-14131.0484</TotalPurchaseYTD></IndividualSurvey>', '3E0ED174-68E8-4A5B-9C05-6C55F4849A37', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (819, 'SC', 0, 'Mr.', 'John', 'T.', 'Donovan', 'Jr.', 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-14892.8367</TotalPurchaseYTD></IndividualSurvey>', 'EC1FB547-F0C4-457E-8998-D3ECBD5A9A2C', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (821, 'SC', 0, 'Ms.', 'Patricia', NULL, 'Doyle', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4795.2682</TotalPurchaseYTD></IndividualSurvey>', 'B27D4EAC-209C-4940-BFA8-57C90A938FC0', CAST('2012-09-30T00:00:00' AS TIMESTAMP)),
    (823, 'SC', 0, 'Mr.', 'Gerald', 'M.', 'Drury', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-13619.052</TotalPurchaseYTD></IndividualSurvey>', '7F0C126C-FA81-456D-A2E2-9DB418BF2D37', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (825, 'SC', 0, 'Mr.', 'Gary', 'T.', 'Drury', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4621.7156</TotalPurchaseYTD></IndividualSurvey>', 'D5E4DFBD-81CA-47AA-A3CA-97E974C31334', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (827, 'SC', 0, 'Mr.', 'Reuben', NULL, 'D''sa', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-9054.124126</TotalPurchaseYTD></IndividualSurvey>', 'E0BDA6CF-EFD4-440F-873A-ECA707F6D474', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (829, 'SC', 0, 'Mr.', 'Ed', NULL, 'Dudenhoefer', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1951.0288</TotalPurchaseYTD></IndividualSurvey>', 'BB198792-853E-495F-A186-BB04EF68C566', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (831, 'SC', 0, 'Mr.', 'Bernard', NULL, 'Duerr', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-18730.5835</TotalPurchaseYTD></IndividualSurvey>', 'F22DD3D1-EC3A-479C-B5B1-7250E4668F34', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (833, 'SC', 0, 'Ms.', 'Tish', 'R.', 'Duff', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2289.8924</TotalPurchaseYTD></IndividualSurvey>', '2AB2C6FE-C649-4BB0-B861-9F3098060B2F', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (835, 'SC', 0, 'Sr.', 'Adrian', NULL, 'Dumitrascu', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3214.836</TotalPurchaseYTD></IndividualSurvey>', '37109ABD-952F-435A-B5EA-C7A1CBD41801', CAST('2012-10-30T00:00:00' AS TIMESTAMP)),
    (837, 'SC', 0, 'Mr.', 'Bart', NULL, 'Duncan', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4223.364</TotalPurchaseYTD></IndividualSurvey>', '8606A98E-A480-412A-98AA-6CE99295D9B1', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (839, 'SC', 0, 'Mr.', 'Maciej', NULL, 'Dusza', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3528.0164</TotalPurchaseYTD></IndividualSurvey>', '06941E78-D1B9-4EEF-9BB5-E28A5AD6F269', CAST('2011-10-01T00:00:00' AS TIMESTAMP)),
    (841, 'SC', 0, 'Ms.', 'Shelley', NULL, 'Dyck', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-647.988</TotalPurchaseYTD></IndividualSurvey>', '9DFE5A5A-800C-43EB-A8D0-21D142F4D35B', CAST('2014-01-29T00:00:00' AS TIMESTAMP)),
    (843, 'SC', 0, 'Ms.', 'Linda', 'R.', 'Ecoffey', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8329.6964</TotalPurchaseYTD></IndividualSurvey>', '14376057-098B-413D-8980-BEEED85F022F', CAST('2012-10-30T00:00:00' AS TIMESTAMP)),
    (845, 'SC', 0, 'Ms.', 'Carla', 'L.', 'Eldridge', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-12493.8451</TotalPurchaseYTD></IndividualSurvey>', '9F63941A-82F2-4254-857C-D69880AA99BC', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (847, 'SC', 0, 'Ms.', 'Carol', 'B.', 'Elliott', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5493.8109</TotalPurchaseYTD></IndividualSurvey>', '7A23FA52-B434-4AEC-A1CB-B098F163FCD0', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (849, 'SC', 0, 'Ms.', 'Shannon', 'P.', 'Elliott', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1452.2086</TotalPurchaseYTD></IndividualSurvey>', 'A99ABE00-EC27-4F0C-BAAE-C63456944B61', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (851, 'SC', 0, 'Ms.', 'Jauna', 'E.', 'Elson', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-12541.9712</TotalPurchaseYTD></IndividualSurvey>', '2884D7D6-747B-473E-9910-E44E3B4DB300', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (853, 'SC', 0, 'Mr.', 'Michael', NULL, 'Emanuel', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1876.518</TotalPurchaseYTD></IndividualSurvey>', '4270FF35-5CD9-43A2-BC56-C4862D34F32F', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (855, 'SC', 0, 'Mr.', 'Terry', NULL, 'Eminhizer', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-17817.885792</TotalPurchaseYTD></IndividualSurvey>', 'BD0D5959-B717-4A95-A90F-F16E5FA118EC', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (857, 'SC', 0, 'Mr.', 'John', NULL, 'Emory', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-10584.318</TotalPurchaseYTD></IndividualSurvey>', '46D8141F-65D3-40EA-BE3D-8A1747C27923', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (859, 'SC', 0, 'Ms.', 'Gail', NULL, 'Erickson', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2787.78375</TotalPurchaseYTD></IndividualSurvey>', 'B66B678C-3E52-4105-817F-C9832F41B884', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (861, 'SC', 0, 'Mr.', 'Mark', 'B', 'Erickson', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2126.6427</TotalPurchaseYTD></IndividualSurvey>', '6EC8593F-F21D-4ADF-AB22-5D0AA1710E27', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (863, 'SC', 0, 'Ms.', 'Martha', 'R.', 'Espinoza', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5934.4566</TotalPurchaseYTD></IndividualSurvey>', 'F8959DE4-34A5-47FC-A70F-4F2ED6C9283A', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (865, 'SC', 0, 'Ms.', 'Julie', 'P.', 'Estes', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '1E1EC6E1-A1D5-4BCA-9C9E-208AECD6C313', CAST('2012-12-31T00:00:00' AS TIMESTAMP)),
    (867, 'SC', 0, 'Sra.', 'Janeth', NULL, 'Esteves', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2159.7348</TotalPurchaseYTD></IndividualSurvey>', 'F856D984-5AA3-4C73-9F58-B97E7E715371', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (869, 'SC', 0, 'Ms.', 'Twanna', 'R.', 'Evans', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-397.3725</TotalPurchaseYTD></IndividualSurvey>', 'AE3C7E11-A25E-40E2-83B3-C2CFA61C4398', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (871, 'SC', 0, 'Ms.', 'Ann', 'R.', 'Evans', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2539.0238</TotalPurchaseYTD></IndividualSurvey>', 'B52B85BD-7903-4A1E-B215-072A3DEAE7E1', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (873, 'SC', 0, 'Mr.', 'John', NULL, 'Evans', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3483.0418</TotalPurchaseYTD></IndividualSurvey>', 'C1C5773F-6FBC-4636-BF03-96E804CD6A7C', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (875, 'SC', 0, 'Mr.', 'Marc', NULL, 'Faeber', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-753.8058</TotalPurchaseYTD></IndividualSurvey>', 'EBF40090-1B25-40D2-A890-DDF37F814CAA', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (877, 'SC', 0, 'Mr.', 'Fadi', NULL, 'Fakhouri', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-9456.0682</TotalPurchaseYTD></IndividualSurvey>', 'B2DF4B83-4EDA-4EBD-9924-8739A7BAE2C9', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (879, 'SC', 0, 'Ms.', 'Carolyn', NULL, 'Farino', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-13307.7563</TotalPurchaseYTD></IndividualSurvey>', 'F46A3A00-AB39-4ED6-AD93-A0CB1C7C065C', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (881, 'SC', 0, 'Ms.', 'Geri', 'P.', 'Farrell', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-11977.365225</TotalPurchaseYTD></IndividualSurvey>', '459895F2-25CA-4B0E-A404-5435E1263ECC', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (883, 'SC', 0, 'Ms.', 'Hanying', NULL, 'Feng', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3637.8778</TotalPurchaseYTD></IndividualSurvey>', '40C40BC4-B47C-42BA-A907-DE905100615F', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (885, 'SC', 0, 'Ms.', 'Rhoda', 'J.', 'Finley', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3470.4322</TotalPurchaseYTD></IndividualSurvey>', 'FF0C8B0F-9356-4D16-994D-2B1BEBB0CC80', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (887, 'SC', 0, 'Mr.', 'Duane', 'R.', 'Fitzgerald', 'Jr.', 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2689.176</TotalPurchaseYTD></IndividualSurvey>', 'CCA34D47-2995-4E4C-BEC5-1E176758A79A', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (889, 'SC', 0, 'Mr.', 'James', NULL, 'Fine', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1882.7904</TotalPurchaseYTD></IndividualSurvey>', '638E90E1-5B29-4BC9-A4E6-BD65533A4B7A', CAST('2013-09-30T00:00:00' AS TIMESTAMP)),
    (891, 'SC', 0, 'Ms.', 'Kathie', NULL, 'Flood', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3288.2067</TotalPurchaseYTD></IndividualSurvey>', 'C28FB5E2-141D-48B0-8840-D35D984698F1', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (893, 'SC', 0, 'Mr.', 'Jay', NULL, 'Fluegel', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2860.884</TotalPurchaseYTD></IndividualSurvey>', '79F1FDF3-51A6-4665-A386-14BE6411DB03', CAST('2014-05-01T00:00:00' AS TIMESTAMP)),
    (895, 'SC', 0, 'Ms.', 'Kelly', NULL, 'Focht', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8697.474375</TotalPurchaseYTD></IndividualSurvey>', '25B7E2AF-7485-40FC-93E4-9A6C6816B40E', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (897, 'SC', 0, 'Mr.', 'Jeffrey', 'L.', 'Ford', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3399.396</TotalPurchaseYTD></IndividualSurvey>', 'D953F87F-5433-41F3-A7B0-32AA6E9AA01D', CAST('2011-10-01T00:00:00' AS TIMESTAMP)),
    (899, 'SC', 0, 'Mr.', 'Garth', NULL, 'Fort', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-958.101</TotalPurchaseYTD></IndividualSurvey>', 'BFA8E1B8-9ABB-4842-9710-7E17B9A28348', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (901, 'SC', 0, 'Ms.', 'Dorothy', 'J.', 'Fox', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2857.1869</TotalPurchaseYTD></IndividualSurvey>', 'E4CBB1EC-77DE-4708-80BF-0AAD4C944A72', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (903, 'SC', 0, 'Ms.', 'Judith', 'B.', 'Frazier', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3152.1667</TotalPurchaseYTD></IndividualSurvey>', 'AD1F11BC-63CC-4A61-BF3B-5B2D83515AE2', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (905, 'SC', 0, 'Mr.', 'John', NULL, 'Fredericksen', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2030.73375</TotalPurchaseYTD></IndividualSurvey>', 'AB39C90F-FB62-4C1E-B2BD-8378E5C306BB', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (907, 'SC', 0, 'Ms.', 'Susan', 'E.', 'French', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8681.7192</TotalPurchaseYTD></IndividualSurvey>', '7F837621-4620-49ED-9DC1-3B762EA3821B', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (909, 'SC', 0, 'Mr.', 'Liam', 'J.', 'Friedland', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6978.222</TotalPurchaseYTD></IndividualSurvey>', '3B97FBD6-B364-4EEC-9207-17DF8F387703', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (911, 'SC', 0, 'Mr.', 'Mihail', NULL, 'Frintu', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-182.352</TotalPurchaseYTD></IndividualSurvey>', 'D90A4789-1000-493C-A0EF-6A9863393254', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (913, 'SC', 0, 'Mr.', 'John', NULL, 'Ford', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5505.6174</TotalPurchaseYTD></IndividualSurvey>', '7AB0363A-C2A5-46F6-8D54-49ED1237D8F2', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (915, 'SC', 0, 'Mr.', 'Paul', 'J.', 'Fulton', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-142.6553</TotalPurchaseYTD></IndividualSurvey>', 'CEC65603-F126-4952-A706-6CE95868CEC1', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (917, 'SC', 0, 'Mr.', 'Don', NULL, 'Funk', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '1E578891-1836-494D-B8E2-C4C85B62A556', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (919, 'SC', 0, 'Mr.', 'Bob', NULL, 'Gage', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2776.782</TotalPurchaseYTD></IndividualSurvey>', '5670D671-198E-44A7-A4D1-7488A4BA0952', CAST('2012-12-31T00:00:00' AS TIMESTAMP)),
    (921, 'SC', 0, 'Ms.', 'Aldeen', 'J.', 'Gallagher', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-48.588</TotalPurchaseYTD></IndividualSurvey>', 'FEA2C5D9-7D58-4643-B220-054952B2CB98', CAST('2013-08-30T00:00:00' AS TIMESTAMP)),
    (923, 'SC', 0, 'Mr.', 'Michael', NULL, 'Galos', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-838.9178</TotalPurchaseYTD></IndividualSurvey>', '209ADEE4-B82C-4628-A216-7C41A2C58CB9', CAST('2011-12-01T00:00:00' AS TIMESTAMP)),
    (925, 'SC', 0, 'Mr.', 'Jon', NULL, 'Ganio', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-13299.96075</TotalPurchaseYTD></IndividualSurvey>', 'A6AE0A24-232F-4163-916B-5FDDDF25E75C', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (927, 'SC', 0, 'Ms.', 'Kathleen', 'M.', 'Garza', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-17024.192</TotalPurchaseYTD></IndividualSurvey>', '6EB95FDA-0E00-474B-9F8A-8AD24B1BF078', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (929, 'SC', 0, 'Mr.', 'Dominic', 'P.', 'Gash', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1210.6737</TotalPurchaseYTD></IndividualSurvey>', '195FCEF8-BBB7-4CD0-9D1D-E31B4E3AE084', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (931, 'SC', 0, 'Ms.', 'Janet', 'M.', 'Gates', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-14427.257592</TotalPurchaseYTD></IndividualSurvey>', '3D33B6AC-C73F-43CA-9059-A02A5F7C96D6', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (933, 'SC', 0, 'Mr.', 'Orlando', 'N.', 'Gee', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5212.8878</TotalPurchaseYTD></IndividualSurvey>', '2B396F04-D0F4-4175-9B34-49D9083C2E69', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (935, 'SC', 0, 'Mr.', 'Darren', NULL, 'Gehring', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-20439.1534</TotalPurchaseYTD></IndividualSurvey>', 'B695BC67-5988-489B-A5AB-FF84FC9FDE7E', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (937, 'SC', 0, 'Mr.', 'Jim', NULL, 'Geist', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6453.4763</TotalPurchaseYTD></IndividualSurvey>', '3F0AA68F-506F-4781-94B4-D32148244B3D', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (939, 'SC', 0, 'Ms.', 'Barbara', 'J.', 'German', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2236.288875</TotalPurchaseYTD></IndividualSurvey>', 'AF738035-38E8-455B-B5A0-0854681BC376', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (941, 'SC', 0, 'Mr.', 'Tom', NULL, 'Getzinger', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1572.696</TotalPurchaseYTD></IndividualSurvey>', '078F4C25-68B1-4957-BB80-05A71B86646E', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (943, 'SC', 0, 'Mr.', 'Leo', NULL, 'Giakoumakis', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8760.882</TotalPurchaseYTD></IndividualSurvey>', '4857E574-4200-46EE-B775-D7E3F5451C42', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (945, 'SC', 0, 'Mr.', 'Cornett', 'L.', 'Gibbens', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-7624.998</TotalPurchaseYTD></IndividualSurvey>', 'E6013E35-645D-470D-BFF3-CDA1023BC28E', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (947, 'SC', 0, 'Mr.', 'Frances', 'J.', 'Giglio', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-14726.506</TotalPurchaseYTD></IndividualSurvey>', '64A4271E-5520-4AFF-A9F5-309D7EC139A9', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (949, 'SC', 0, 'Mr.', 'Guy', NULL, 'Gilbert', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-7326.3973</TotalPurchaseYTD></IndividualSurvey>', 'AB835AC6-74E5-4FB0-9D83-DC2745F487E4', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (951, 'SC', 0, 'Ms.', 'Janet', 'J.', 'Gilliat', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-315.80328</TotalPurchaseYTD></IndividualSurvey>', 'C05CEE7C-89ED-42EA-8E4A-0C379D9757A3', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (953, 'SC', 0, 'Ms.', 'Mary', 'M.', 'Gimmi', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-12751.4895</TotalPurchaseYTD></IndividualSurvey>', '7BD71F64-EC08-43F5-BD1C-E64E07465A43', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (955, 'SC', 0, 'Mr.', 'David', 'L.', 'Givens', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'F339E919-19E8-4ADC-80BE-F5A865AE2B54', CAST('2011-10-31T00:00:00' AS TIMESTAMP)),
    (957, 'SC', 0, 'Ms.', 'Jeanie', 'R.', 'Glenn', 'PhD', 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-13468.0398</TotalPurchaseYTD></IndividualSurvey>', '5A9C0503-7E40-4798-A676-65277C292387', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (959, 'SC', 0, 'Ms.', 'Diane', 'R.', 'Glimp', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2064.8257</TotalPurchaseYTD></IndividualSurvey>', '43D2D6E9-FBB7-40FC-BE4E-C067BEDEAA7D', CAST('2011-10-01T00:00:00' AS TIMESTAMP)),
    (961, 'SC', 0, 'Mr.', 'James', 'R.', 'Glynn', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2816.6334</TotalPurchaseYTD></IndividualSurvey>', 'E1892D16-DF5B-41D6-B128-C0A2B77EF5C9', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (963, 'SC', 0, 'Mr.', 'Scott', NULL, 'Gode', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-12689.3078</TotalPurchaseYTD></IndividualSurvey>', '21D1A0D9-255F-4D3D-B023-001388BBC5B2', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (965, 'SC', 0, 'Mr.', 'Mete', NULL, 'Goktepe', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5576.8058</TotalPurchaseYTD></IndividualSurvey>', 'C4C51328-CC2D-451F-9471-19BBA515B52C', CAST('2011-10-31T00:00:00' AS TIMESTAMP)),
    (967, 'SC', 0, 'Mr.', 'Jossef', NULL, 'Goldberg', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '593813BE-C467-4B1A-B98B-B3763D04CAA7', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (969, 'SC', 0, 'Mr.', 'Brian', 'R', 'Goldstein', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-34326.2696</TotalPurchaseYTD></IndividualSurvey>', '33847C60-967D-4663-A586-89512FC6EEE6', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (971, 'SC', 0, 'Ms.', 'Lynn', 'A.', 'Gonzales', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-400.104</TotalPurchaseYTD></IndividualSurvey>', '60D55C4A-8BCF-4503-BD87-701B65A4C4F7', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (973, 'SC', 0, 'Ms.', 'Linda', 'L.', 'Gonzales', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4225.708</TotalPurchaseYTD></IndividualSurvey>', '2910102F-2584-430F-9F6A-1E4FAB50EFE9', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (975, 'SC', 0, 'Ms.', 'Abigail', 'J.', 'Gonzalez', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-7930.8163</TotalPurchaseYTD></IndividualSurvey>', '209718D7-3541-4649-964B-B87F895C63B5', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (977, 'SC', 0, 'Mr.', 'Michael', NULL, 'Graff', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-7925.681</TotalPurchaseYTD></IndividualSurvey>', '1ED42026-48AE-4D74-9277-55FB69466D70', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (979, 'SC', 0, 'Mr.', 'Derek', NULL, 'Graham', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-10962.918</TotalPurchaseYTD></IndividualSurvey>', 'F722FF45-3AD4-4912-8EEB-7EB71C49C512', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (981, 'SC', 0, 'Mr.', 'Lowell', 'J.', 'Graham', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2864.8513</TotalPurchaseYTD></IndividualSurvey>', '2CA49C8F-9987-4456-B89F-2ACA7A827009', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (983, 'SC', 0, 'Mr.', 'Jon', NULL, 'Grande', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3075.312</TotalPurchaseYTD></IndividualSurvey>', '8C84C445-23C4-4E56-B4CF-8A37B5A8655F', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (985, 'SC', 0, 'Ms.', 'Jane', 'P.', 'Greer', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4884.6826</TotalPurchaseYTD></IndividualSurvey>', 'DCD73FC7-1479-418D-AB89-1390889F4F0A', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (987, 'SC', 0, 'Mr.', 'Geoff', NULL, 'Grisso', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-7294.722</TotalPurchaseYTD></IndividualSurvey>', '15E9078D-60DB-4B81-84D8-9DBE82871E73', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (989, 'SC', 0, 'Mr.', 'Douglas', NULL, 'Groncki', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2675.07975</TotalPurchaseYTD></IndividualSurvey>', 'D51716AC-715C-4882-AF99-F942050E2EE5', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (991, 'SC', 0, 'Mr.', 'Brian', NULL, 'Groth', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1770.6198</TotalPurchaseYTD></IndividualSurvey>', '759505FB-BC7E-44D0-862C-AB020F5EE24B', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (993, 'SC', 0, 'Ms.', 'Faith', 'M.', 'Gustafson', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6652.11</TotalPurchaseYTD></IndividualSurvey>', 'C53B0FEC-1904-4895-A816-85D73512A8FF', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (995, 'SC', 0, 'Mr.', 'Greg', NULL, 'Harrison', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-288</TotalPurchaseYTD></IndividualSurvey>', '273A8514-0196-4370-8360-34161F6F9569', CAST('2013-08-30T00:00:00' AS TIMESTAMP)),
    (997, 'SC', 0, 'Ms.', 'Hattie', 'J.', 'Haemon', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-12187.599375</TotalPurchaseYTD></IndividualSurvey>', '078AD793-260A-44EA-9E48-6E1550B262D4', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (999, 'SC', 0, 'Mr.', 'Matthew', 'M.', 'Hagemann', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8637.408</TotalPurchaseYTD></IndividualSurvey>', '2B2BFE50-C11F-4F8D-A2B5-3BD07C7D69A0', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1001, 'SC', 0, 'Ms.', 'Erin', 'M.', 'Hagens', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-14594.3532</TotalPurchaseYTD></IndividualSurvey>', 'CFB11FCB-979F-42A8-97A7-445110D9368E', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (1003, 'SC', 0, 'Ms.', 'Betty', 'M.', 'Haines', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4035.652875</TotalPurchaseYTD></IndividualSurvey>', '24D004A7-8161-4561-A81B-01B635321CB2', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1005, 'SC', 0, 'Ms.', 'Karen', 'E.', 'Hall', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'F3206D91-ABBD-4249-89A1-7975DF4C5B36', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (1007, 'SC', 0, 'Mr.', 'Don', NULL, 'Hall', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '352D1885-C1AD-4363-8605-3F3B871D5148', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1009, 'SC', 0, 'Mr.', 'Bryan', NULL, 'Hamilton', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-14201.358</TotalPurchaseYTD></IndividualSurvey>', 'E37C923E-517A-4C65-A330-0564B8D03A13', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (1011, 'SC', 0, 'Mr.', 'James', 'R.', 'Hamilton', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6399.5121</TotalPurchaseYTD></IndividualSurvey>', '6F252FB9-ED64-410E-B4EE-2C4B7A50F8C6', CAST('2011-10-31T00:00:00' AS TIMESTAMP)),
    (1013, 'SC', 0, 'Mr.', 'Kerim', NULL, 'Hanif', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-10583.3402</TotalPurchaseYTD></IndividualSurvey>', '27E64B39-5471-426E-8F36-F9E14567D4ED', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1015, 'SC', 0, 'Ms.', 'Jean', 'P.', 'Handley', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-13817.791675</TotalPurchaseYTD></IndividualSurvey>', '6E0ACFFE-342D-4CF4-AF91-2E8D726EB0A6', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (1017, 'SC', 0, 'Mr.', 'Mark', NULL, 'Hanson', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-15363.837592</TotalPurchaseYTD></IndividualSurvey>', '5906DA28-7B28-4615-9BC3-359CB0A8BDF5', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (1019, 'SC', 0, 'Mr.', 'William', 'J.', 'Hapke', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-939.6934</TotalPurchaseYTD></IndividualSurvey>', '2E3B8C3F-7C67-4A83-8E48-9FF1FE275FB7', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1021, 'SC', 0, 'Ms.', 'Katherine', NULL, 'Harding', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-12199.164</TotalPurchaseYTD></IndividualSurvey>', 'DA05D5A5-F0F6-464D-A969-A3BD57F8AB0B', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (1023, 'SC', 0, 'Ms.', 'Kimberly', 'Beth', 'Harrington', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3689.9268</TotalPurchaseYTD></IndividualSurvey>', '357CDE49-FC26-4768-BAF4-183904A6B2C9', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1025, 'SC', 0, 'Mr.', 'Lucy', NULL, 'Harrington', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4760.592</TotalPurchaseYTD></IndividualSurvey>', '62D0A71B-A907-49BC-80E3-9586D661945B', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1027, 'SC', 0, 'Mr.', 'Keith', NULL, 'Harris', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5886.937992</TotalPurchaseYTD></IndividualSurvey>', '64ACB192-766D-47E9-B7BA-6CCF3E6A8309', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1029, 'SC', 0, 'Ms.', 'Doris', NULL, 'Hartwig', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2415.48</TotalPurchaseYTD></IndividualSurvey>', '298A910A-2659-40E3-97A7-EAD2281F3FBB', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1031, 'SC', 0, 'Mr.', 'Roger', NULL, 'Harui', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-46721.4743</TotalPurchaseYTD></IndividualSurvey>', '0A6D3974-E188-4146-8928-02F4E5358C98', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (1033, 'SC', 0, 'Ms.', 'Ann', 'T.', 'Hass', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3351.4347</TotalPurchaseYTD></IndividualSurvey>', 'BA9518A7-003B-4FB6-BAB2-A52BBE6756CE', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1035, 'SC', 0, 'Mr.', 'Mark', NULL, 'Hassall', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-11660.202</TotalPurchaseYTD></IndividualSurvey>', 'C6F4C2AC-2C06-4453-AE82-C86CDC0A8185', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (1037, 'SC', 0, 'Mr.', 'Neal', 'B.', 'Hasty', 'III', 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5294.39775</TotalPurchaseYTD></IndividualSurvey>', 'E8BCFD08-EB0D-441F-BCD5-3ED3D059DC1A', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1039, 'SC', 0, 'Mr.', 'James', 'B.', 'Haugh', 'Jr.', 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-25165.2171</TotalPurchaseYTD></IndividualSurvey>', '46D384C7-E46D-4396-B3EA-DA52B5391DDE', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1041, 'SC', 0, 'Mr.', 'Jeff', NULL, 'Hay', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2927.604</TotalPurchaseYTD></IndividualSurvey>', '0C3C732B-01A7-4639-9367-13DB26FAFAB3', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1043, 'SC', 0, 'Ms.', 'Brenda', 'F.', 'Heaney', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3044.6805</TotalPurchaseYTD></IndividualSurvey>', 'FF077FB8-4764-446A-B57C-492C6537A721', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (1045, 'SC', 0, NULL, 'James', NULL, 'Hendergart', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-7997.91356</TotalPurchaseYTD></IndividualSurvey>', '22770301-09BD-481A-B43E-F7F6119A2B79', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (1047, 'SC', 0, 'Mr.', 'John', NULL, 'Hanson', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3544.227</TotalPurchaseYTD></IndividualSurvey>', '5C96AB93-1919-4CC7-A0FA-9AC1D5FF26B0', CAST('2012-08-30T00:00:00' AS TIMESTAMP)),
    (1049, 'SC', 0, 'Ms.', 'Valerie', 'M.', 'Hendricks', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6954.4314</TotalPurchaseYTD></IndividualSurvey>', '58752170-C62C-402F-919B-D057289093EA', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (1051, 'SC', 0, 'Mr.', 'Jay', NULL, 'Henningsen', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-15591.158125</TotalPurchaseYTD></IndividualSurvey>', '89DED201-A34A-48DA-B465-5D8D20277B46', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1053, 'SC', 0, 'Mr.', 'Jeff', 'D.', 'Henshaw', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2669.110875</TotalPurchaseYTD></IndividualSurvey>', 'DD3CB920-10E1-4664-9009-7327E30184DA', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (1055, 'SC', 0, 'Mr.', 'Kari', NULL, 'Hensien', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6056.8247</TotalPurchaseYTD></IndividualSurvey>', 'B8202390-FE7D-4F2A-98D0-405579E28E09', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (1057, 'SC', 0, 'Ms.', 'Deena', 'J.', 'Herman', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '4E0C7AB4-4C3A-4F19-9D46-E0DB29F49A21', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1059, 'SC', 0, 'Ms.', 'Irene', 'J.', 'Hernandez', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-299.748</TotalPurchaseYTD></IndividualSurvey>', 'EF6ED666-FAB9-42F4-A3F2-FDB293F70FC6', CAST('2014-05-01T00:00:00' AS TIMESTAMP)),
    (1061, 'SC', 0, 'Mr.', 'Jésus', NULL, 'Hernandez', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-865.866</TotalPurchaseYTD></IndividualSurvey>', '2FDFA7BE-D20A-4A8F-85BB-BD3CC9200940', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1063, 'SC', 0, 'Ms.', 'Pam', 'L.', 'Herrick', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3963.3522</TotalPurchaseYTD></IndividualSurvey>', '19662316-60F9-483B-AF1D-681BB66344F6', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1065, 'SC', 0, 'Ms.', 'Cheryl', 'M.', 'Herring', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-11211.8696</TotalPurchaseYTD></IndividualSurvey>', '6F163020-E65B-4B8C-831C-5B5733BB5E81', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (1067, 'SC', 0, 'Mr.', 'Ronald', 'K.', 'Heymsfield', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3953.4113</TotalPurchaseYTD></IndividualSurvey>', '476DB19C-980A-476C-837A-B72F9CD73F3C', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1069, 'SC', 0, 'Mr.', 'Sidney', NULL, 'Higa', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1045.1786</TotalPurchaseYTD></IndividualSurvey>', '1A087930-B829-4A7E-853C-95571FFD495B', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1071, 'SC', 0, 'Ms.', 'Onetha', 'F.', 'Higgs', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2850.2448</TotalPurchaseYTD></IndividualSurvey>', '6683066A-1C9F-4FAF-A520-CFF102B846C8', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (1073, 'SC', 0, 'Ms.', 'Fran', 'P.', 'Highfill', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2096.5438</TotalPurchaseYTD></IndividualSurvey>', 'A76AEFB5-9E9D-4F28-95BD-D196331C21DB', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1075, 'SC', 0, 'Ms.', 'Geneva', 'T.', 'Hill', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3792.282</TotalPurchaseYTD></IndividualSurvey>', '4A86A671-3CCA-49BE-8C73-78E514D66F2A', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1077, 'SC', 0, 'Mr.', 'Andrew', 'R.', 'Hill', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1560.024</TotalPurchaseYTD></IndividualSurvey>', '5DDF5918-AEA4-4983-9DCD-38C938D04FEA', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1079, 'SC', 0, 'Mr.', 'Reinout', NULL, 'Hillmann', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1964.156625</TotalPurchaseYTD></IndividualSurvey>', 'F23E361D-3D64-493F-BF1C-EE78CDF147D8', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1081, 'SC', 0, 'Mr.', 'Mike', NULL, 'Hines', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3706.0356</TotalPurchaseYTD></IndividualSurvey>', '05B6F0C3-AF29-4BEB-9295-EAC923B8E6E3', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (1083, 'SC', 0, 'Mr.', 'Matthew', NULL, 'Hink', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6830.15175</TotalPurchaseYTD></IndividualSurvey>', 'EE805F29-0F3B-4FAC-AA71-A826B7D68B1E', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1085, 'SC', 0, 'Ms.', 'Nancy', 'E.', 'Hirota', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-12357.8352</TotalPurchaseYTD></IndividualSurvey>', '6B7CC8CD-DAAE-407D-87FC-DB444F734072', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (1087, 'SC', 0, 'Ms.', 'Rose', NULL, 'Hirsch', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1824.036</TotalPurchaseYTD></IndividualSurvey>', 'E80CE16D-63ED-41CB-BABF-FD360A7FA11D', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1089, 'SC', 0, 'Mr.', 'Douglas', NULL, 'Hite', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5444.0304</TotalPurchaseYTD></IndividualSurvey>', 'DBF9A4E5-098B-4A55-91CC-9223A317BC4E', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (1091, 'SC', 0, 'Mr.', 'David', NULL, 'Hodgson', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3025.5698</TotalPurchaseYTD></IndividualSurvey>', '4EFA4D8E-3679-43AC-95D0-5CA3896F92C0', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1093, 'SC', 0, 'Ms.', 'Helge', NULL, 'Hoeing', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2275.224</TotalPurchaseYTD></IndividualSurvey>', '1C6223D2-B1BB-4EF7-86CF-806439B20A67', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1095, 'SC', 0, 'Ms.', 'Barbara', NULL, 'Hoffman', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5615.8963</TotalPurchaseYTD></IndividualSurvey>', '60F53D96-0721-484B-AE3E-B2C1EE7D0504', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (1097, 'SC', 0, 'Ms.', 'Holly', 'J.', 'Holt', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'BD3E13F7-91EA-4E42-A78A-D6850400F9CD', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (1099, 'SC', 0, 'Mr.', 'Bob', NULL, 'Hodges', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2405.97</TotalPurchaseYTD></IndividualSurvey>', 'D532040E-3BC5-46FF-BF3E-6E894C79F5E0', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (1101, 'SC', 0, 'Ms.', 'Jean', 'J.', 'Holloway', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1457.7952</TotalPurchaseYTD></IndividualSurvey>', 'DC05084C-49B4-446B-B1F0-DEF425669BFD', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1103, 'SC', 0, 'Mr.', 'Michael', NULL, 'Holm', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '0A161B07-06DB-445F-BA6E-45679BC3C148', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1105, 'SC', 0, 'Mr.', 'Eddie', 'M.', 'Holmes', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-780.109</TotalPurchaseYTD></IndividualSurvey>', 'E1FA30EB-9098-4329-A354-965068A842C5', CAST('2012-10-30T00:00:00' AS TIMESTAMP)),
    (1107, 'SC', 0, 'Ms.', 'Juanita', 'J.', 'Holman', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-11622.4263</TotalPurchaseYTD></IndividualSurvey>', '6A76BF58-73FC-4B64-957B-FC9AA165B74F', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (1109, 'SC', 0, 'Mr.', 'Peter', NULL, 'Houston', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1541.358</TotalPurchaseYTD></IndividualSurvey>', '5E4C6CB6-06CC-414E-B38E-0D8152726DCE', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1111, 'SC', 0, 'Mr.', 'Curtis', 'P.', 'Howard', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5489.1688</TotalPurchaseYTD></IndividualSurvey>', '7DBF0770-9280-489B-B283-2144D707B6AB', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (1113, 'SC', 0, 'Mr.', 'Joe', NULL, 'Howard', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4606.9217</TotalPurchaseYTD></IndividualSurvey>', '9A55AF97-D7B4-4168-B189-8CB905C30811', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1115, 'SC', 0, 'Ms.', 'Janice', 'K.', 'Hows', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1692.231</TotalPurchaseYTD></IndividualSurvey>', '448BE0C1-7B1B-452F-B4D0-D1AD3587ABD2', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1117, 'SC', 0, 'Mr.', 'George', 'M.', 'Huckaby', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1727.724</TotalPurchaseYTD></IndividualSurvey>', '1B35A756-D47E-4A75-9D7A-4B0871A25B7A', CAST('2011-12-01T00:00:00' AS TIMESTAMP)),
    (1119, 'SC', 0, 'Mr.', 'Joshua', 'J.', 'Huff', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3463.2998</TotalPurchaseYTD></IndividualSurvey>', '7522288A-1D85-4EBA-8027-23E59910D917', CAST('2012-01-29T00:00:00' AS TIMESTAMP)),
    (1121, 'SC', 0, 'Ms.', 'Arlene', NULL, 'Huff', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-400.104</TotalPurchaseYTD></IndividualSurvey>', 'A824044B-2BE8-4CDC-A9EF-CD45F462687B', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1123, 'SC', 0, 'Mr.', 'Matthew', 'M.', 'Hunter', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '3608CFE5-8EA2-49C9-A9AB-39F83941FAC9', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (1125, 'SC', 0, 'Ms.', 'Phyllis', 'R.', 'Huntsman', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-7084.5696</TotalPurchaseYTD></IndividualSurvey>', '64953C7E-623F-4FCB-B0BF-94DCC349639E', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (1127, 'SC', 0, 'Mr.', 'Lawrence', 'E.', 'Hurkett', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-367.8764</TotalPurchaseYTD></IndividualSurvey>', '7CAB3D77-85D3-402F-9B38-AC033DEFD3FD', CAST('2012-08-30T00:00:00' AS TIMESTAMP)),
    (1129, 'SC', 0, 'Mr.', 'Ryan', NULL, 'Ihrig', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4102.602</TotalPurchaseYTD></IndividualSurvey>', 'EA77D6DD-6FE7-4102-A74A-746C4F675842', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1131, 'SC', 0, 'Ms.', 'Beth', NULL, 'Inghram', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-917.506</TotalPurchaseYTD></IndividualSurvey>', '28207EF8-348A-4EE5-B377-BE13953BAE3F', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1133, 'SC', 0, 'Mr.', 'Lucio', NULL, 'Iallo', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4334.5279</TotalPurchaseYTD></IndividualSurvey>', '64341963-8BEC-4D7D-ACBB-2CF7698ABCF2', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (1135, 'SC', 0, 'Mr.', 'Richard', 'L.', 'Irwin', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6660.5168</TotalPurchaseYTD></IndividualSurvey>', 'D3F02054-A958-439F-B86D-94B4B20AFE81', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (1137, 'SC', 0, 'Mr.', 'Erik', NULL, 'Ismert', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6167.824</TotalPurchaseYTD></IndividualSurvey>', '7A6F688B-83AF-489F-99DA-DE15A8335925', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (1139, 'SC', 0, 'Ms.', 'Denean', 'J.', 'Ison', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-366.252</TotalPurchaseYTD></IndividualSurvey>', 'A8C4775E-E0AD-4C6A-809E-0E42C4D2C8F5', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1141, 'SC', 0, 'Mr.', 'Raman', NULL, 'Iyer', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3078.4498</TotalPurchaseYTD></IndividualSurvey>', '7790503C-10F1-4E9F-8D30-C4B2486355C1', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1143, 'SC', 0, 'Mr.', 'Bronson', 'R.', 'Jacobs', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1344.588</TotalPurchaseYTD></IndividualSurvey>', 'E4991566-CB50-490F-88A0-970AFFBF973C', CAST('2014-05-01T00:00:00' AS TIMESTAMP)),
    (1145, 'SC', 0, 'Mr.', 'Eric', 'A.', 'Jacobsen', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-9595.510875</TotalPurchaseYTD></IndividualSurvey>', '8273B73B-1BEF-4498-9295-AB6FEFCA957C', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (1147, 'SC', 0, 'Ms.', 'Jodan', 'M.', 'Jacobson', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3934.4716</TotalPurchaseYTD></IndividualSurvey>', '627F073A-FC32-4A7F-80AA-9556201083C7', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (1149, 'SC', 0, 'Ms.', 'Mary', NULL, 'Alexander', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4049.8548</TotalPurchaseYTD></IndividualSurvey>', 'FF8E8B89-BCFF-46AC-A215-8D581A50E156', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1151, 'SC', 0, 'Mr.', 'David', NULL, 'Jaffe', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8838.63</TotalPurchaseYTD></IndividualSurvey>', '131DB561-4D70-4A3E-9110-0B169A8F940C', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (1153, 'SC', 0, 'Mr.', 'Jay', NULL, 'Jamison', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2171.3296</TotalPurchaseYTD></IndividualSurvey>', '18A24D70-D8E9-45FB-B5AC-E307F7C7BA79', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (1155, 'SC', 0, 'Ms.', 'Vance', 'P.', 'Johns', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5914.4176</TotalPurchaseYTD></IndividualSurvey>', '4B4936BA-62EB-4303-9A40-469535B738A3', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1157, 'SC', 0, 'Ms.', 'Joyce', NULL, 'Jarvis', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8840.028</TotalPurchaseYTD></IndividualSurvey>', '49812AEF-524C-40F2-9CC2-754C66053C62', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1159, 'SC', 0, 'Mr.', 'George', NULL, 'Jiang', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5054.272875</TotalPurchaseYTD></IndividualSurvey>', '231D39F9-3836-46C6-8BFE-AA6617548AD5', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1161, 'SC', 0, 'Mr.', 'Stephen', 'Yuan', 'Jiang', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-10422.8841</TotalPurchaseYTD></IndividualSurvey>', '12CD778A-CEA4-4789-9EE9-255F04E1FEA7', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (1163, 'SC', 0, 'Mr.', 'Samuel', 'A.', 'Johnson', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-25101.045192</TotalPurchaseYTD></IndividualSurvey>', 'C12F4596-1FBD-4F99-B163-0AAB59832178', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (1165, 'SC', 0, 'Ms.', 'Danielle', 'B.', 'Johnson', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1164.408</TotalPurchaseYTD></IndividualSurvey>', '6CDB2B14-D87A-4265-908F-67B026617275', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1167, 'SC', 0, 'Mr.', 'Greg', 'M.', 'Johnson', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-362.4763</TotalPurchaseYTD></IndividualSurvey>', '2622191E-64F5-4AF6-B7C1-3771E3E4737F', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1169, 'SC', 0, 'Mr.', 'Barry', NULL, 'Johnson', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5191.6962</TotalPurchaseYTD></IndividualSurvey>', '783935F5-9A74-4A6C-8A52-97D577A8F6E5', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (1171, 'SC', 0, 'Mr.', 'Brian', NULL, 'Johnson', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-135.078</TotalPurchaseYTD></IndividualSurvey>', '0E30C955-7867-43DF-B10D-7585C91EF22D', CAST('2013-01-28T00:00:00' AS TIMESTAMP)),
    (1173, 'SC', 0, 'Mr.', 'David', NULL, 'Johnson', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-18655.0422</TotalPurchaseYTD></IndividualSurvey>', '9A499C76-ECB6-4334-9FD7-1A5B9082ADE7', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (1175, 'SC', 0, 'Mr.', 'Willis', NULL, 'Johnson', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-115.3616</TotalPurchaseYTD></IndividualSurvey>', '7C796E8B-722A-4495-8687-0F749148919D', CAST('2011-08-31T00:00:00' AS TIMESTAMP)),
    (1177, 'SC', 0, 'Ms.', 'Tamara', NULL, 'Johnston', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-332.358</TotalPurchaseYTD></IndividualSurvey>', 'F391731B-15F6-4D6D-AF8E-EFA1525AB8D2', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1179, 'SC', 0, 'Mr.', 'Robert', 'E.', 'Jones', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '2C91835B-FA20-4C34-BE6D-66DFD46AADE2', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (1181, 'SC', 0, 'Mr.', 'Brannon', NULL, 'Jones', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-29819.7779</TotalPurchaseYTD></IndividualSurvey>', 'CE3B88D7-3320-46F7-9FB2-2052BF75A152', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (1183, 'SC', 0, 'Ms.', 'Jean', NULL, 'Jordan', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6239.1524</TotalPurchaseYTD></IndividualSurvey>', 'A61EB755-6EB6-4181-864A-FC413295E66C', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (1185, 'SC', 0, 'Ms.', 'Peggy', 'J.', 'Justice', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1472.2185</TotalPurchaseYTD></IndividualSurvey>', '49385D62-755D-4B24-A7F1-79A8B0093D06', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (1187, 'SC', 0, 'Ms.', 'Diane', 'F.', 'Krane', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-11388.7887</TotalPurchaseYTD></IndividualSurvey>', '33488099-FB42-4382-AA74-6078B6DAE7F4', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1189, 'SC', 0, 'Mr.', 'Scott', 'B.', 'Kaffer', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '4A5F2A79-0334-43BE-8BA7-44031A3252DB', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1191, 'SC', 0, 'Ms.', 'Sandra', 'T.', 'Kitt', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5929.6869</TotalPurchaseYTD></IndividualSurvey>', '0DE74214-8D0B-435E-9D07-24A043EE2EE4', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (1193, 'SC', 0, 'Ms.', 'Wendy', NULL, 'Kahn', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'E4C0B90C-595F-49B8-9A4D-44D490E9227D', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (1195, 'SC', 0, 'Mr.', 'Sandeep', NULL, 'Kaliyath', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2041.188</TotalPurchaseYTD></IndividualSurvey>', 'B3EE6BE4-D9D6-4B86-9492-E21B507128A1', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (1197, 'SC', 0, 'Mr.', 'John', NULL, 'Kane', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6501.528</TotalPurchaseYTD></IndividualSurvey>', '38A0FE20-40AB-47B9-9EEB-929D7E782E21', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (1199, 'SC', 0, 'Ms.', 'Lori', NULL, 'Kane', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-9703.881</TotalPurchaseYTD></IndividualSurvey>', '891A215F-103E-49E2-9E8A-DB2EE90DBC32', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1201, 'SC', 0, 'Ms.', 'Judith', 'F.', 'Krane', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3805.8795</TotalPurchaseYTD></IndividualSurvey>', 'BAF2BB1F-FEF8-4F13-9F21-E8D92E15F790', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1203, 'SC', 0, 'Ms.', 'Kay', 'E.', 'Krane', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2501.407</TotalPurchaseYTD></IndividualSurvey>', '8D74437A-0149-4139-A535-2B16CA54D4D7', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (1205, 'SC', 0, 'Mr.', 'Sandeep', NULL, 'Katyal', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-16724.4292</TotalPurchaseYTD></IndividualSurvey>', 'CEA347C5-A218-4DD3-9D90-31ADE771DE19', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (1207, 'SC', 0, 'Ms.', 'Bonnie', NULL, 'Kearney', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'D731D368-4F47-426C-AA82-8BFA5DB79131', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1209, 'SC', 0, 'Mr.', 'Kendall', NULL, 'Keil', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-12967.926</TotalPurchaseYTD></IndividualSurvey>', 'F1E588E1-B459-4338-A4C5-5D7898922BC1', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1211, 'SC', 0, 'Mr.', 'Victor', 'A.', 'Kelley', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-781.7335</TotalPurchaseYTD></IndividualSurvey>', 'DA5943B7-815C-4574-A0A4-D3B8FF2CF19F', CAST('2012-10-30T00:00:00' AS TIMESTAMP)),
    (1213, 'SC', 0, 'Mr.', 'John', NULL, 'Kelly', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-12267.621525</TotalPurchaseYTD></IndividualSurvey>', 'C5CF67E1-7134-4C5E-A994-02AACE0F81DD', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (1215, 'SC', 0, 'Mr.', 'Robert', NULL, 'Kelly', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1751.9487</TotalPurchaseYTD></IndividualSurvey>', '76CB0633-1C1C-45B6-87DF-158754639CDF', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1217, 'SC', 0, 'Mr.', 'Kevin', NULL, 'Kennedy', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1771.8884</TotalPurchaseYTD></IndividualSurvey>', '2C53DB93-3437-418F-B313-0B754471668D', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1219, 'SC', 0, 'Ms.', 'Mary', 'R.', 'Kesslep', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-11418.3659</TotalPurchaseYTD></IndividualSurvey>', '596D929A-88D6-4C08-8F41-8B9CAFB2CC36', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1221, 'SC', 0, 'Ms.', 'Alice', 'L.', 'Kesterson', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'C97264E8-BE7C-4302-B701-44D353B687CA', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1223, 'SC', 0, 'Ms.', 'Elizabeth', NULL, 'Keyser', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1258.3767</TotalPurchaseYTD></IndividualSurvey>', '00E85176-678F-4B08-9966-A0F5F16BEB3C', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (1225, 'SC', 0, 'Ms.', 'Tammy', 'J.', 'Khan', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'B0A01341-E8C0-475B-A718-C0FCA1A9C046', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (1227, 'SC', 0, 'Mr.', 'Imtiaz', NULL, 'Khan', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6485.0558</TotalPurchaseYTD></IndividualSurvey>', '6DC8C11D-E4FE-43CD-BA3D-74B4A57288A7', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (1229, 'SC', 0, 'Ms.', 'Karan', NULL, 'Khanna', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1357.536</TotalPurchaseYTD></IndividualSurvey>', 'B7166CB2-8A98-4B65-95B3-DB247F8C0054', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1231, 'SC', 0, 'Mr.', 'Joe', NULL, 'Kim', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-155.964</TotalPurchaseYTD></IndividualSurvey>', '346CB799-7A96-44DC-9AE7-0F317CFC78E3', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1233, 'SC', 0, 'Mr.', 'Jim', NULL, 'Kim', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4551.48148</TotalPurchaseYTD></IndividualSurvey>', 'C2406274-C746-4600-BFB7-0FB43624D7EB', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (1235, 'SC', 0, 'Mr.', 'Shane', 'S.', 'Kim', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1286.282</TotalPurchaseYTD></IndividualSurvey>', '40C3B790-FC65-49ED-AACD-AC152E7BCBF5', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1237, 'SC', 0, 'Mr.', 'Tim', NULL, 'Kim', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1823.958</TotalPurchaseYTD></IndividualSurvey>', 'FD904563-FC9F-4044-A20B-A4C6A303A52F', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1239, 'SC', 0, 'Mr.', 'Russell', NULL, 'King', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-12412.6456</TotalPurchaseYTD></IndividualSurvey>', '8902C8CA-94C6-4686-99C0-1FDA74760AD6', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (1241, 'SC', 0, 'Mr.', 'Anton', NULL, 'Kirilov', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8164.5356</TotalPurchaseYTD></IndividualSurvey>', '6C36C7F2-F794-477E-B94B-B375EE86FBF3', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1243, 'SC', 0, 'Mr.', 'Christian', NULL, 'Kleinerman', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1118.4311</TotalPurchaseYTD></IndividualSurvey>', 'B3631E6B-3E85-4136-921A-1DCACEBB2F4C', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (1245, 'SC', 0, 'Mr.', 'Andrew', 'P.', 'Kobylinski', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8097.6664</TotalPurchaseYTD></IndividualSurvey>', '49F78DAA-9DAF-449C-80E5-AA33DAA62017', CAST('2011-10-31T00:00:00' AS TIMESTAMP)),
    (1247, 'SC', 0, 'Mr.', 'Reed', NULL, 'Koch', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1869.259584</TotalPurchaseYTD></IndividualSurvey>', 'AC327BE8-67EB-403A-9A8C-D60B67BB54BE', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1249, 'SC', 0, 'Mr.', 'Jim', NULL, 'Kennedy', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8249.076</TotalPurchaseYTD></IndividualSurvey>', '0EB10B35-6A95-4156-83BC-F0598EA856DC', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1251, 'SC', 0, 'Mr.', 'Kirk', 'T', 'King', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-9975.246</TotalPurchaseYTD></IndividualSurvey>', 'A40D8239-5F34-4F2D-B4F0-F3C47CEFC6A8', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1253, 'SC', 0, 'Mr.', 'Eugene', NULL, 'Kogan', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-25834.042</TotalPurchaseYTD></IndividualSurvey>', 'A3D52266-4E01-4892-904C-E31D6775BE68', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1255, 'SC', 0, 'Mr.', 'Scott', NULL, 'Konersmann', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2165.7328</TotalPurchaseYTD></IndividualSurvey>', '2AC3D1FC-31A4-469B-8116-499792BCC69A', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (1257, 'SC', 0, 'Ms.', 'Joy', 'R.', 'Koski', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-7283.2227</TotalPurchaseYTD></IndividualSurvey>', '191C04A8-8D77-4E34-BF26-99DFCC83A7DB', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (1259, 'SC', 0, 'Ms.', 'Pamala', 'M.', 'Kotc', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2108.88</TotalPurchaseYTD></IndividualSurvey>', 'D4760B72-6EB5-46BB-81AD-51CB11AE7919', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1261, 'SC', 0, 'Mr.', 'Edward', 'J.', 'Kozlowski', 'Jr.', 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-10287.846375</TotalPurchaseYTD></IndividualSurvey>', '237CFF8A-FC5F-43ED-8BDD-257A989F2FA0', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1263, 'SC', 0, 'Mr.', 'James', 'D.', 'Kramer', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'FBA8126E-A78C-4D0A-AFFB-E78BC3017B12', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (1265, 'SC', 0, 'Mr.', 'Mitch', NULL, 'Kennedy', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-17019.977325</TotalPurchaseYTD></IndividualSurvey>', '884C6553-2769-46FC-AE38-D219A6CDFA9B', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1267, 'SC', 0, 'Mr.', 'James', 'J.', 'Krow', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '797C0054-8145-4277-9E26-3C3EBD1B1864', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (1269, 'SC', 0, 'Ms.', 'Margaret', 'T.', 'Krupka', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-18996.6408</TotalPurchaseYTD></IndividualSurvey>', '92592686-1A2D-4255-87A2-E5E43538090B', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (1271, 'SC', 0, 'Mr.', 'Deepak', NULL, 'Kumar', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4754.928</TotalPurchaseYTD></IndividualSurvey>', '3D311A37-3355-491D-ACD2-07C91E4ADC14', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1273, 'SC', 0, 'Mr.', 'Jeffrey', 'B.', 'Kung', 'Jr.', 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5146.644</TotalPurchaseYTD></IndividualSurvey>', '0DEED92A-B15E-4CF6-932E-5E0E4C168A18', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1275, 'SC', 0, 'Mr.', 'Vamsi', NULL, 'Kuppa', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2239.296</TotalPurchaseYTD></IndividualSurvey>', '9F82648A-ED4B-4FD0-AC97-85B1ECE45594', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1277, 'SC', 0, 'Mr.', 'Jeffrey', NULL, 'Kurtz', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5619.3654</TotalPurchaseYTD></IndividualSurvey>', '141DBA98-A629-43F2-84E7-D9F7CB398EBF', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1279, 'SC', 0, 'Mr.', 'Peter', NULL, 'Kurniawan', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1178.1911</TotalPurchaseYTD></IndividualSurvey>', '1398EAC2-C855-49FC-960C-2B6468803F8A', CAST('2011-10-01T00:00:00' AS TIMESTAMP)),
    (1281, 'SC', 0, 'Mr.', 'Eric', NULL, 'Lang', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2855.498625</TotalPurchaseYTD></IndividualSurvey>', '5DAFD177-9FBD-43AC-BB52-E391A4D667F3', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1283, 'SC', 0, 'Ms.', 'Rebecca', NULL, 'Laszlo', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8833.548</TotalPurchaseYTD></IndividualSurvey>', 'E36AE0A1-C262-4227-AD4F-2660090492F0', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1285, 'SC', 0, 'Ms.', 'Cecilia', 'M.', 'Laursen', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-156.024</TotalPurchaseYTD></IndividualSurvey>', '4086B1F4-3295-476B-BC44-8FE6EAC35D33', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1287, 'SC', 0, 'Mr.', 'David', 'O', 'Lawrence', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-404.664</TotalPurchaseYTD></IndividualSurvey>', 'A3F2188D-2A4F-4E53-9DA1-162739BB80B7', CAST('2012-10-30T00:00:00' AS TIMESTAMP)),
    (1289, 'SC', 0, 'Ms.', 'Elsa', NULL, 'Leavitt', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-12476.144</TotalPurchaseYTD></IndividualSurvey>', 'F1A22FC4-BBDE-4B71-8216-CDF1D6D53506', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1291, 'SC', 0, 'Mr.', 'Michael', 'J.', 'Lee', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2916.088875</TotalPurchaseYTD></IndividualSurvey>', '56F48EE0-AE0E-4A09-B55F-66CFBCCC7486', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1293, 'SC', 0, 'Ms.', 'Marjorie', 'M.', 'Lee', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1132.859476</TotalPurchaseYTD></IndividualSurvey>', 'E9C645D5-A101-4C4E-968A-493AE907E098', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (1295, 'SC', 0, 'Mr.', 'Frank', NULL, 'Campbell', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-16315.0115</TotalPurchaseYTD></IndividualSurvey>', 'FC564029-F29A-47ED-9F49-BFA7E8E1DFD6', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (1297, 'SC', 0, 'Mr.', 'Mark', NULL, 'Lee', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2357.16</TotalPurchaseYTD></IndividualSurvey>', '1186CA57-C6B5-4893-8B7F-1F211772536D', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1299, 'SC', 0, 'Mr.', 'Robertson', NULL, 'Lee', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3719.412</TotalPurchaseYTD></IndividualSurvey>', '3A3D92B3-028C-42A5-84A5-FEDCDDA5D351', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1301, 'SC', 0, 'Ms.', 'Jolie', NULL, 'Lenehan', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2258.4124</TotalPurchaseYTD></IndividualSurvey>', '4D714D1D-B458-4555-BA2C-0DC3C82F268E', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (1303, 'SC', 0, 'Mr.', 'Roger', NULL, 'Lengel', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-17090.4</TotalPurchaseYTD></IndividualSurvey>', 'E462E2DD-8A56-4641-9605-21CAEA5C74CF', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1305, 'SC', 0, NULL, 'A.', 'Francesca', 'Leonetti', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4256.3016</TotalPurchaseYTD></IndividualSurvey>', '1E1403A8-6B43-4E6B-861C-1D49E6F23AC8', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1307, 'SC', 0, 'Ms.', 'Bonnie', 'B.', 'Lepro', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4165.5585</TotalPurchaseYTD></IndividualSurvey>', '3F69F157-009C-4FA1-8728-4F0FEBB30C09', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (1309, 'SC', 0, 'Ms.', 'Gloria', 'J.', 'Lesko', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-15430.1657</TotalPurchaseYTD></IndividualSurvey>', 'D30ABE00-4F94-437F-966B-F61A5C2E7DFC', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (1311, 'SC', 0, 'Ms.', 'Linda', NULL, 'Leste', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-16725.3924</TotalPurchaseYTD></IndividualSurvey>', 'C68C07A7-3C6C-42F2-AF9E-F16DBE26BAB8', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (1313, 'SC', 0, 'Mr.', 'Steven', 'B.', 'Levy', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '77046421-3852-49B0-A0A1-2E8B8B378391', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1315, 'SC', 0, 'Ms.', 'Judy', NULL, 'Lew', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-9084.1833</TotalPurchaseYTD></IndividualSurvey>', 'A80B439E-EEB3-4761-A0A6-7B8857CFC781', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1317, 'SC', 0, 'Ms.', 'Elsie', 'L.', 'Lewin', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5356.608</TotalPurchaseYTD></IndividualSurvey>', 'E93D81BE-EBE9-46D6-94E7-AC64F25516B8', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1319, 'SC', 0, 'Mr.', 'George', 'Z.', 'Li', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4925.3913</TotalPurchaseYTD></IndividualSurvey>', '7993BB35-4963-49C4-B677-A372D689BA64', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1321, 'SC', 0, 'Mr.', 'Yale', NULL, 'Li', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5389.533825</TotalPurchaseYTD></IndividualSurvey>', '96FB75A0-37C1-4138-9E14-E828D3648EAD', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (1323, 'SC', 0, 'Ms.', 'Yan', NULL, 'Li', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-7294.4246</TotalPurchaseYTD></IndividualSurvey>', 'CF457803-118A-4E24-B9F7-9151F104EBCF', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1325, 'SC', 0, 'Ms.', 'Yuhong', NULL, 'Li', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8020.1574</TotalPurchaseYTD></IndividualSurvey>', '39D3B8EE-A3CA-4DA5-BCF4-6D30F61BC6D1', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1327, 'SC', 0, 'Mr.', 'Joseph', 'M.', 'Lique', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6664.3908</TotalPurchaseYTD></IndividualSurvey>', '977EBB32-1CB8-4E96-A7E5-089EC3A4CE50', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1329, 'SC', 0, 'Mr.', 'Paulo', 'H.', 'Lisboa', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3638.814</TotalPurchaseYTD></IndividualSurvey>', '87D7B397-3FDC-4C07-846B-BEEDB6665BCA', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1331, 'SC', 0, 'Mr.', 'David', 'J.', 'Liu', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-35549.7461</TotalPurchaseYTD></IndividualSurvey>', 'E511D139-9556-4D36-97B6-C4ADA97DFDCD', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (1333, 'SC', 0, NULL, 'Jinghao', NULL, 'Liu', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-9708.2505</TotalPurchaseYTD></IndividualSurvey>', '3EF93BF0-BB51-4BB9-9718-BBE45CB21A35', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1335, 'SC', 0, 'Mr.', 'Kevin', NULL, 'Liu', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3522.09819</TotalPurchaseYTD></IndividualSurvey>', '6493BA77-F11F-4574-A026-24EEFC77AFAF', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1337, 'SC', 0, 'Mr.', 'Run', NULL, 'Liu', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-20972.4849</TotalPurchaseYTD></IndividualSurvey>', 'B8E6687A-9217-491B-B5AF-5E5009DC8434', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (1339, 'SC', 0, 'Mr.', 'Todd', 'R.', 'Logan', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2978.3265</TotalPurchaseYTD></IndividualSurvey>', '37C4E8BB-AECA-455A-91F0-A59C3F928D38', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1341, 'SC', 0, 'Mr.', 'Kok-Ho', NULL, 'Loh', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3024.8796</TotalPurchaseYTD></IndividualSurvey>', 'A5992E48-F0BB-4F18-80CF-017B1596FE76', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1343, 'SC', 0, 'Mr.', 'John', 'K.', 'Long', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-9495.6099</TotalPurchaseYTD></IndividualSurvey>', 'FF38055E-D73F-4450-A98A-8A237423160A', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (1345, 'SC', 0, 'Ms.', 'Sharon', 'J.', 'Looney', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3533.9869</TotalPurchaseYTD></IndividualSurvey>', '2337E86B-0D46-49CB-94FE-E80027511575', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1347, 'SC', 0, 'Mr.', 'Jeremy', NULL, 'Los', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '64F81ED9-A92B-43D8-8129-85F6D038C267', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (1349, 'SC', 0, 'Mr.', 'Spencer', NULL, 'Low', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-21227.2898</TotalPurchaseYTD></IndividualSurvey>', '07F3859D-4B0D-46A7-8876-38DAB0B60FDA', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (1351, 'SC', 0, 'Ms.', 'Anita', 'R.', 'Lucerne', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-7494.35775</TotalPurchaseYTD></IndividualSurvey>', '5C28FCE8-DB52-4222-BD91-2AB9FED54696', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1353, 'SC', 0, 'Mr.', 'Jose', NULL, 'Lugo', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6878.16</TotalPurchaseYTD></IndividualSurvey>', 'A6627E59-66AB-4347-BDF7-B78956633EDE', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1355, 'SC', 0, 'Mr.', 'Richard', NULL, 'Lum', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4567.23766</TotalPurchaseYTD></IndividualSurvey>', 'AD9AD3EA-FC58-4F9A-B0EE-2293B87BAEAF', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (1357, 'SC', 0, 'Ms.', 'Judy', 'R.', 'Lundahl', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-18027.5247</TotalPurchaseYTD></IndividualSurvey>', '79A79E46-4CEF-4DAD-BFAB-3C352C0B32DC', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (1359, 'SC', 0, 'Mr.', 'Sean', 'J.', 'Lunt', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '62E81186-C871-4703-9671-E99295BCE668', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1361, 'SC', 0, 'Ms.', 'Helen', 'R.', 'Lutes', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-19717.022</TotalPurchaseYTD></IndividualSurvey>', '34698CFB-3401-4AB7-A4F2-36330167FDE8', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (1363, 'SC', 0, 'Mr.', 'Robert', 'P.', 'Lyeba', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5434.7106</TotalPurchaseYTD></IndividualSurvey>', '924982EF-745A-4F0C-965E-B2B47ADAC6CD', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (1365, 'SC', 0, 'Ms.', 'Sharon', 'F.', 'Lynn', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5776.524</TotalPurchaseYTD></IndividualSurvey>', 'A3A292D7-0601-4912-A06A-B5507230E68C', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (1367, 'SC', 0, 'Mr.', 'Robert', NULL, 'Lyon', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4463.957</TotalPurchaseYTD></IndividualSurvey>', 'B894EE96-2BFA-41C8-B0D2-F819F5F2E4BE', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1369, 'SC', 0, 'Ms.', 'Jenny', NULL, 'Lysaker', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3699.894</TotalPurchaseYTD></IndividualSurvey>', '094C19E1-D85C-439D-86F4-552F1EE7A05F', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1371, 'SC', 0, 'Ms.', 'Denise', 'R.', 'Maccietto', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6857.3454</TotalPurchaseYTD></IndividualSurvey>', '22D1058E-C2B1-4D97-AB64-421874F719FB', CAST('2011-08-31T00:00:00' AS TIMESTAMP)),
    (1373, 'SC', 0, 'Mr.', 'Scott', NULL, 'MacDonald', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-16286.946</TotalPurchaseYTD></IndividualSurvey>', '77527F01-CF80-46AB-868A-75F891E7B81D', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (1375, 'SC', 0, 'Mr.', 'Walter', 'J.', 'Mays', 'Sr.', 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6291.4342</TotalPurchaseYTD></IndividualSurvey>', '45306013-4C42-40BE-969E-89CC1F40972C', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1377, 'SC', 0, 'Mr.', 'Patrick', 'J.', 'Magenheimer', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6219.6683</TotalPurchaseYTD></IndividualSurvey>', 'F498A20F-1759-4296-9CEE-C07519054063', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1379, 'SC', 0, 'Ms.', 'Kimberly', 'N.', 'Malmendier', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2065.866</TotalPurchaseYTD></IndividualSurvey>', '6FEF2768-5E92-4FE7-B94E-3AC5E492E2A4', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1381, 'SC', 0, 'Mr.', 'Ajay', NULL, 'Manchepalli', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-563.946</TotalPurchaseYTD></IndividualSurvey>', '5DD53673-7012-4821-9171-4D79880B751D', CAST('2013-12-31T00:00:00' AS TIMESTAMP)),
    (1383, 'SC', 0, 'Ms.', 'Parul', NULL, 'Manek', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2914.728</TotalPurchaseYTD></IndividualSurvey>', '2270A8B3-97FD-49A1-ABA3-C2F61FD5BCEA', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1385, 'SC', 0, 'Mr.', 'Tomas', 'M.', 'Manzanares', 'II', 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-364.704</TotalPurchaseYTD></IndividualSurvey>', 'A573668A-D115-4E03-9D9B-955BFD65D671', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1387, 'SC', 0, 'Ms.', 'Kathy', 'R.', 'Marcovecchio', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-9758.058</TotalPurchaseYTD></IndividualSurvey>', '71B83B01-15C3-4DB4-A1F9-46A8A8A055C8', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (1389, 'SC', 0, 'Ms.', 'Jill', 'K.', 'Markwood', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '143C728D-7946-4796-91A6-41214EF4EBB2', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (1391, 'SC', 0, 'Ms.', 'Melissa', 'R.', 'Marple', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-7507.2519</TotalPurchaseYTD></IndividualSurvey>', '3AA82687-F265-4939-889F-275362B977AC', CAST('2011-10-31T00:00:00' AS TIMESTAMP)),
    (1393, 'SC', 0, 'Ms.', 'Cecelia', 'L.', 'Marshall', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-711.25</TotalPurchaseYTD></IndividualSurvey>', 'D5334C1B-5F15-4141-AADF-59EFCB72CE5D', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1395, 'SC', 0, 'Mr.', 'Benjamin', NULL, 'Martin', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-683.724</TotalPurchaseYTD></IndividualSurvey>', '9EFCDAA0-8DB7-4E22-9E9D-08E710EF62A4', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1397, 'SC', 0, 'Ms.', 'Linda', NULL, 'Martin', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-12902.4311</TotalPurchaseYTD></IndividualSurvey>', '3BFF9302-E5DB-4F8D-983C-2BA0A7EB50B9', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1399, 'SC', 0, 'Ms.', 'Mindy', NULL, 'Martin', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3492.8728</TotalPurchaseYTD></IndividualSurvey>', '3CC90EA4-6133-4153-B54F-D7083D15821D', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1401, 'SC', 0, 'Ms.', 'Sandra', 'I.', 'Martinez', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'E700EC61-7F49-4DB3-B062-7E31093EDD02', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1403, 'SC', 0, 'Mr.', 'Frank', NULL, 'Mart¡nez', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-26077.157268</TotalPurchaseYTD></IndividualSurvey>', '6CCA7B0A-A6B5-499C-AC9C-739E1BD05ADE', CAST('2013-05-30T00:00:00' AS TIMESTAMP)),
    (1405, 'SC', 0, 'Mr.', 'Steve', NULL, 'Masters', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-10443.8046</TotalPurchaseYTD></IndividualSurvey>', '416BDE0F-76A9-4D9B-AE96-B2E92D25A621', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (1407, 'SC', 0, 'Mr.', 'Joseph', NULL, 'Matthews', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-824.73</TotalPurchaseYTD></IndividualSurvey>', 'D0EC82B9-52FC-4E84-8525-247F6200FF9D', CAST('2012-09-30T00:00:00' AS TIMESTAMP)),
    (1409, 'SC', 0, 'Ms.', 'Jennifer', 'J.', 'Maxham', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6131.9367</TotalPurchaseYTD></IndividualSurvey>', '87CB3177-81C4-4071-BB37-7726259D2046', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1411, 'SC', 0, 'Mr.', 'Chris', NULL, 'Maxwell', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4288.0306</TotalPurchaseYTD></IndividualSurvey>', '8D0C2B71-009B-45B8-907E-2D90B1C53127', CAST('2012-09-30T00:00:00' AS TIMESTAMP)),
    (1413, 'SC', 0, 'Ms.', 'Sandra', 'B.', 'Maynard', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-12044.95685</TotalPurchaseYTD></IndividualSurvey>', '66423D78-B443-4AF8-954F-2EBA29F5F1C7', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (1415, 'SC', 0, 'Mr.', 'John', 'J.', 'McClane', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1956.3698</TotalPurchaseYTD></IndividualSurvey>', '97175B3E-D8BF-47C7-8288-88F084632343', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1417, 'SC', 0, 'Ms.', 'Robin', 'M.', 'McGuigan', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8575.8129</TotalPurchaseYTD></IndividualSurvey>', '8C0A56CB-8E6F-4F54-8F41-903FB62A3051', CAST('2011-05-31T00:00:00' AS TIMESTAMP)),
    (1419, 'SC', 0, 'Ms.', 'Stacie', 'K.', 'Mcanich', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-7974.804</TotalPurchaseYTD></IndividualSurvey>', '19DD2C32-77C6-4E41-BFE9-5E63B6D79DBC', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1421, 'SC', 0, 'Ms.', 'Katie', NULL, 'McAskill-White', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-10262.768999</TotalPurchaseYTD></IndividualSurvey>', '043E4B9E-A58E-478D-845D-AEF0BCA5C51D', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1423, 'SC', 0, 'Ms.', 'Lola', 'M.', 'McCarthy', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-16876.3516</TotalPurchaseYTD></IndividualSurvey>', 'CB93BF5D-5AFE-410A-A83D-D9669AD65131', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1425, 'SC', 0, 'Ms.', 'Jane', 'A.', 'McCarty', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-13055.5736</TotalPurchaseYTD></IndividualSurvey>', '04BFF651-678A-491A-8060-D625DE99FA1B', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1427, 'SC', 0, 'Ms.', 'Nikki', NULL, 'McCormick', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2085.0114</TotalPurchaseYTD></IndividualSurvey>', '4881DC6E-51BB-482C-AA97-A97DA4DE14E9', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (1429, 'SC', 0, 'Mr.', 'James', 'L.', 'McCoy', 'II', 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-15390.6382</TotalPurchaseYTD></IndividualSurvey>', '6B4F444C-F70D-46BD-9844-BC4E0CBFBD18', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (1431, 'SC', 0, 'Ms.', 'Christinia', 'A.', 'McDonald', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1610.334</TotalPurchaseYTD></IndividualSurvey>', '55270F25-C806-4C69-90A5-76F5FB9B3E30', CAST('2013-08-30T00:00:00' AS TIMESTAMP)),
    (1433, 'SC', 0, 'Mr.', 'Alejandro', NULL, 'McGuel', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1123.854</TotalPurchaseYTD></IndividualSurvey>', '87CD7A8E-C675-4E30-9D52-79B47C138FC7', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1435, 'SC', 0, 'Ms.', 'Yvonne', NULL, 'McKay', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8548.8998</TotalPurchaseYTD></IndividualSurvey>', 'C2287535-1A4D-4ABB-AACE-87C7EF315D6B', CAST('2011-08-01T00:00:00' AS TIMESTAMP)),
    (1437, 'SC', 0, 'Ms.', 'Nkenge', NULL, 'McLin', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-21623.3869</TotalPurchaseYTD></IndividualSurvey>', '488BC551-1F37-4203-B5B4-B1505C430D17', CAST('2011-07-01T00:00:00' AS TIMESTAMP)),
    (1439, 'SC', 0, 'Ms.', 'Nancy', 'A.', 'McPhearson', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-5733.978</TotalPurchaseYTD></IndividualSurvey>', 'CA7F46A5-C071-49A4-8F3B-66CE13EF5D85', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1441, 'SC', 0, 'Ms.', 'Nellie', 'T.', 'Medina', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1019.29575</TotalPurchaseYTD></IndividualSurvey>', '6DFAC7EC-0A3A-432F-9CAF-691B7E1F3845', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1443, 'SC', 0, 'Ms.', 'Raquel', NULL, 'Mello', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-11744.8338</TotalPurchaseYTD></IndividualSurvey>', 'D6A548D6-676E-434C-9133-D4C0B3B90564', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1445, 'SC', 0, 'Ms.', 'Gladys', 'F.', 'Mendiola', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '29E7C318-AF58-4E1B-8F2F-C44E5CBD12A2', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1447, 'SC', 0, 'Mr.', 'R. Morgan', 'L.', 'Mendoza', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1202.22</TotalPurchaseYTD></IndividualSurvey>', 'D0E6394D-E7DB-4CC8-8D6E-92AB6951F426', CAST('2013-04-30T00:00:00' AS TIMESTAMP)),
    (1449, 'SC', 0, 'Mr.', 'Tosh', NULL, 'Meston', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-7848.8242</TotalPurchaseYTD></IndividualSurvey>', 'D2EAF764-131F-4A73-924F-507AC5A14DC1', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1451, 'SC', 0, 'Ms.', 'Susan', NULL, 'Metters', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '0B03A0AF-3897-45F7-AC4E-508771A1137B', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1453, 'SC', 0, 'Mr.', 'Stephen', 'A.', 'Mew', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1713.7118</TotalPurchaseYTD></IndividualSurvey>', '278FA142-89D8-42F1-80A1-E3000B642800', CAST('2011-10-01T00:00:00' AS TIMESTAMP)),
    (1455, 'SC', 0, 'Mr.', 'Eric', 'B.', 'Meyer', 'Jr.', 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-13356.4863</TotalPurchaseYTD></IndividualSurvey>', '63201227-20A4-497D-BC84-69517711C3BE', CAST('2011-10-01T00:00:00' AS TIMESTAMP)),
    (1457, 'SC', 0, 'Ms.', 'Helen', 'M.', 'Meyer', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6316.4716</TotalPurchaseYTD></IndividualSurvey>', 'D1C4D14E-CC64-4FE8-AD40-373C0D426885', CAST('2011-10-01T00:00:00' AS TIMESTAMP)),
    (1459, 'SC', 0, 'Ms.', 'Deanna', NULL, 'Meyer', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2574.4342</TotalPurchaseYTD></IndividualSurvey>', 'F9B3FE97-BC2F-4D22-B632-3678AB37AD75', CAST('2011-10-31T00:00:00' AS TIMESTAMP)),
    (1461, 'SC', 0, 'Mr.', 'Gary', 'P.', 'Meyerhoff', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3114.096</TotalPurchaseYTD></IndividualSurvey>', 'C1C82D81-8F35-4C73-9B10-F21C25B8080E', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1463, 'SC', 0, 'Mr.', 'Ramesh', NULL, 'Meyyappan', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2206.122</TotalPurchaseYTD></IndividualSurvey>', '074E4861-0B71-4A94-89D0-94A58A2EDE44', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1465, 'SC', 0, 'Mr.', 'Thomas', 'R.', 'Michaels', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2458.9178</TotalPurchaseYTD></IndividualSurvey>', '7A43F075-EFA0-4617-AE12-DDBF8AF72B58', CAST('2012-09-30T00:00:00' AS TIMESTAMP)),
    (1467, 'SC', 0, 'Mr.', 'Jan', NULL, 'Miksovsky', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1366.2229</TotalPurchaseYTD></IndividualSurvey>', 'A56A8EB0-444C-40E7-8FC0-E11668D12375', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1469, 'SC', 0, 'Ms.', 'Virginia', 'L.', 'Miller', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1191.954192</TotalPurchaseYTD></IndividualSurvey>', 'D8B3540A-4A9E-4538-949B-C052DE95E0BD', CAST('2012-05-30T00:00:00' AS TIMESTAMP)),
    (1471, 'SC', 0, 'Mr.', 'Matthew', 'J.', 'Miller', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6207.012</TotalPurchaseYTD></IndividualSurvey>', '973E3B7D-6844-4F66-83DD-687E1A06178F', CAST('2012-07-31T00:00:00' AS TIMESTAMP)),
    (1473, 'SC', 0, 'Mr.', 'Emilo', 'R.', 'Miller', 'Jr.', 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-2115.03</TotalPurchaseYTD></IndividualSurvey>', 'E7D01A5E-348D-436F-A59B-6F234F8C35E0', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1475, 'SC', 0, 'Mr.', 'Ben', NULL, 'Miller', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-6000.798</TotalPurchaseYTD></IndividualSurvey>', '8CBF0F79-F979-495A-8044-4A8F0629751A', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1477, 'SC', 0, 'Mr.', 'Dylan', NULL, 'Miller', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-8558.2205</TotalPurchaseYTD></IndividualSurvey>', 'B6A6DFE5-5AF5-4052-A88A-0CA437E6036E', CAST('2011-10-01T00:00:00' AS TIMESTAMP)),
    (1479, 'SC', 0, 'Mr.', 'Frank', NULL, 'Miller', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-1871.1352</TotalPurchaseYTD></IndividualSurvey>', 'D3B77A11-4CA5-433D-A956-A1B34E18360D', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1481, 'SC', 0, 'Ms.', 'Neva', 'M.', 'Mitchell', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-3755.180952</TotalPurchaseYTD></IndividualSurvey>', '5954BC0D-6F69-487A-B721-40F1D9857B24', CAST('2013-06-30T00:00:00' AS TIMESTAMP)),
    (1483, 'SC', 0, 'Ms.', 'Linda', NULL, 'Mitchell', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-80.91</TotalPurchaseYTD></IndividualSurvey>', 'A24F2479-2DE8-464F-9BDA-FED6F4165AAC', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1485, 'SC', 0, 'Mr.', 'Scott', NULL, 'Mitchell', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-7925.9676</TotalPurchaseYTD></IndividualSurvey>', 'C6F97317-1E7C-4CB2-8475-91BD88BEF25A', CAST('2012-06-30T00:00:00' AS TIMESTAMP)),
    (1487, 'SC', 0, 'Mr.', 'Robert', NULL, 'Mitosinka', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '5A5045B3-1F75-4181-A41B-32D418E175C4', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1489, 'SC', 0, 'Mr.', 'Joseph', 'P.', 'Mitzner', 'Jr.', 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>-4387.62</TotalPurchaseYTD></IndividualSurvey>', 'FA5EFC39-5704-48AF-9A59-4431A2E1770F', CAST('2013-07-31T00:00:00' AS TIMESTAMP)),
    (1491, 'VC', 0, 'Ms.', 'Paula', 'B.', 'Moberly', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '9E368CD5-E5B6-43B4-A006-31D018D7C8E7', CAST('2011-12-23T00:00:00' AS TIMESTAMP)),
    (1493, 'VC', 0, 'Ms.', 'Suchitra', NULL, 'Mohan', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '43F4AFC3-86D7-4E2E-B585-1709DE5E0488', CAST('2011-04-25T00:00:00' AS TIMESTAMP)),
    (1495, 'VC', 0, 'Mr.', 'Jonathan', NULL, 'Moeller', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '5707FDA4-1564-4650-9068-643DAC5F3A45', CAST('2011-04-25T00:00:00' AS TIMESTAMP)),
    (1497, 'VC', 0, 'Mr.', 'William', 'J.', 'Monroe', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '08658234-8FB7-4CA8-A175-7D25BF2D279D', CAST('2012-02-03T00:00:00' AS TIMESTAMP)),
    (1499, 'VC', 0, 'Ms.', 'Alan', 'L.', 'Monitor', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'D78842CD-A022-4C78-9E05-0A8388B95AE3', CAST('2012-02-02T00:00:00' AS TIMESTAMP)),
    (1501, 'VC', 0, 'Ms.', 'Hillaine', 'N.', 'Montera', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '27440F5A-748B-4AC3-ABB8-5A1F14B55F23', CAST('2011-12-24T00:00:00' AS TIMESTAMP)),
    (1503, 'VC', 0, 'Mr.', 'Bobby', NULL, 'Moore', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '0DF34150-EF64-498C-B804-E7A773ED0BF5', CAST('2011-12-24T00:00:00' AS TIMESTAMP)),
    (1505, 'VC', 0, 'Ms.', 'Barbara', NULL, 'Moreland', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'DDAC3657-9C8B-4EBD-A800-5B0CEADD4E08', CAST('2012-01-25T00:00:00' AS TIMESTAMP)),
    (1507, 'VC', 0, 'Mr.', 'Jon', NULL, 'Morris', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'A691F19D-4968-47D0-8E19-0ECCAC1B23EB', CAST('2011-12-24T00:00:00' AS TIMESTAMP)),
    (1509, 'VC', 0, 'Ms.', 'Julia', NULL, 'Moseley', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'AD2071C7-AF42-4015-AEFC-C8A7BBCBC39D', CAST('2012-01-25T00:00:00' AS TIMESTAMP)),
    (1511, 'VC', 0, 'Ms.', 'Marie', 'E.', 'Moya', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '978D673F-1EF2-4E58-9962-29F4B4503082', CAST('2011-12-23T00:00:00' AS TIMESTAMP)),
    (1513, 'VC', 0, 'Mr.', 'Zheng', NULL, 'Mu', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'CFF47D41-05C5-4786-9A07-8E28BBDB29E4', CAST('2012-02-03T00:00:00' AS TIMESTAMP)),
    (1515, 'VC', 0, 'Mr.', 'Salman', NULL, 'Mughal', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'F502F0F9-97DF-4E2A-B49E-D61EC2B37726', CAST('2012-01-25T00:00:00' AS TIMESTAMP)),
    (1517, 'VC', 0, 'Mr.', 'Albert', NULL, 'Mungin', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '6CA86E4E-FDAB-4403-96D0-55750F18673B', CAST('2011-12-24T00:00:00' AS TIMESTAMP)),
    (1519, 'VC', 0, 'Mr.', 'Stuart', NULL, 'Munson', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '8C23B46F-090B-49D9-B25C-A196DC6ED99F', CAST('2011-12-24T00:00:00' AS TIMESTAMP)),
    (1521, 'VC', 0, 'Ms.', 'Billie Jo', NULL, 'Murray', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '0D85BFF5-7900-4930-A093-253041883930', CAST('2012-01-25T00:00:00' AS TIMESTAMP)),
    (1523, 'VC', 0, 'Ms.', 'Dorothy', 'J.', 'Myer', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'DF46EA08-DFD7-45F9-9D33-1AC3F0678426', CAST('2012-02-02T00:00:00' AS TIMESTAMP)),
    (1525, 'VC', 0, 'Mr.', 'Ken', NULL, 'Myer', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '0D7E8D2A-CE67-431D-B66D-4D5A643544FD', CAST('2012-01-25T00:00:00' AS TIMESTAMP)),
    (1527, 'VC', 0, 'Ms.', 'Suzanne', NULL, 'Nelson', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'F501A45F-B97F-42DE-BFE0-5A1D6A416239', CAST('2012-02-03T00:00:00' AS TIMESTAMP)),
    (1529, 'VC', 0, NULL, 'Mandar', NULL, 'Naik', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'B7C7EEDE-01C6-46EE-96A0-30DACEF5DFD4', CAST('2011-12-24T00:00:00' AS TIMESTAMP)),
    (1531, 'VC', 0, 'Mr.', 'Greg', 'F.', 'Mohamed', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '79F148E6-A1F6-4541-9654-6E217F8E4C9C', CAST('2012-01-29T00:00:00' AS TIMESTAMP)),
    (1533, 'VC', 0, 'Mr.', 'Mike', NULL, 'Nash', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'BF0B6804-90D3-4FF4-B91E-9744E00DDCC5', CAST('2012-02-02T00:00:00' AS TIMESTAMP)),
    (1535, 'VC', 0, 'Ms.', 'Lorraine', NULL, 'Nay', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '218FB7AA-8157-44FE-8FE4-B9FC65F859F8', CAST('2012-01-17T00:00:00' AS TIMESTAMP)),
    (1537, 'VC', 0, 'Mr.', 'Alex', NULL, 'Nayberg', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'CB6F7B14-9C7E-4927-87ED-CE52E8E9C89C', CAST('2012-02-18T00:00:00' AS TIMESTAMP)),
    (1539, 'VC', 0, 'Ms.', 'Jan', 'R.', 'Nelsen', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '96F356C6-BC33-408B-BCEF-AF61F651675F', CAST('2011-12-23T00:00:00' AS TIMESTAMP)),
    (1541, 'VC', 0, 'Mr.', 'Amir', 'T.', 'Netz', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '02039E2B-5F88-452A-BB2D-B3C4446DE3C8', CAST('2012-01-25T00:00:00' AS TIMESTAMP)),
    (1543, 'VC', 0, 'Mr.', 'Donals', 'E.', 'Nilson', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'EA2053A1-F88E-4C3A-8200-90F21BE83970', CAST('2011-12-24T00:00:00' AS TIMESTAMP)),
    (1545, 'VC', 0, 'Mr.', 'Toby', NULL, 'Nixon', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '2D560D09-EFBF-44A0-B2F8-42D2427384F9', CAST('2012-01-29T00:00:00' AS TIMESTAMP)),
    (1547, 'VC', 0, 'Ms.', 'Laura', NULL, 'Norman', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '07C69FA9-3E22-4312-B47C-C24E91C41D0D', CAST('2011-12-24T00:00:00' AS TIMESTAMP)),
    (1549, 'VC', 0, 'Mr.', 'Fred', NULL, 'Northup', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '9FCF7E19-24C1-4B71-A5F0-A6BB130ECDA2', CAST('2012-02-03T00:00:00' AS TIMESTAMP)),
    (1551, 'VC', 0, 'Mr.', 'Michael', 'J', 'O''Connell', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'BDF392A4-39D7-4A5E-A04B-0D5C3CF0127E', CAST('2012-01-25T00:00:00' AS TIMESTAMP)),
    (1553, 'VC', 0, 'Mr.', 'Tim', NULL, 'O''Brien', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'DC80D2B4-9188-4300-AF2C-90CF548AB1B2', CAST('2012-02-18T00:00:00' AS TIMESTAMP)),
    (1555, 'VC', 0, NULL, 'Tina', 'Slone', 'O''Dell', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '8C3FDB6D-C448-4E1C-BDD6-C764D7A950E8', CAST('2012-02-18T00:00:00' AS TIMESTAMP)),
    (1557, 'VC', 0, 'Mr.', 'Robert', NULL, 'O''Hara', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'F1836FE1-F554-4868-A09E-44D1DEBFCB7E', CAST('2012-02-03T00:00:00' AS TIMESTAMP)),
    (1559, 'VC', 0, 'Mr.', 'Nino', 'E.', 'Olivotto', NULL, 2, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '8EBC4868-9A31-4ADC-8161-A2BAAE1EADAE', CAST('2011-12-24T00:00:00' AS TIMESTAMP)),
    (1561, 'VC', 0, 'Mr.', 'Lee', 'M.', 'Olguin', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', 'F5301349-F133-4190-B6D5-5902CF08442F', CAST('2012-02-02T00:00:00' AS TIMESTAMP)),
    (1563, 'VC', 0, 'Mr.', 'Tad', NULL, 'Orman', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '63BD791B-4A5F-4EA4-888E-327536B4F5A3', CAST('2011-12-23T00:00:00' AS TIMESTAMP)),
    (1565, 'VC', 0, 'Ms.', 'Gloria', 'B.', 'Orona', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '6890365D-9084-43A5-B784-610EA5A50E44', CAST('2011-12-23T00:00:00' AS TIMESTAMP)),
    (1567, 'VC', 0, 'Mr.', 'Fred', 'A.', 'Ortiz', NULL, 0, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '72A644D6-789A-4E39-9BA0-7955E9E923C8', CAST('2012-01-17T00:00:00' AS TIMESTAMP)),
    (1569, 'VC', 0, 'Mr.', 'John', 'E.', 'Ortiz', NULL, 1, NULL, '<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"><TotalPurchaseYTD>0</TotalPurchaseYTD></IndividualSurvey>', '488B7FD6-4B8C-4E95-B3C4-0F54C0F2427C', CAST('2012-01-25T00:00:00' AS TIMESTAMP));
SET DATEFORMAT ymd;
INSERT INTO bobsusedbookstore_dbo.billofmaterials (;
    productassemblyid, componentid, startdate, enddate, unitmeasurecode, bomlevel, perassemblyqty, modifieddate
) VALUES
    (893, 749, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (271, 750, CAST('2010-03-04 00:00:00' AS TIMESTAMP), CAST('2010-05-03 00:00:00' AS TIMESTAMP), 'EA', 0, 1.00, CAST('2010-05-03 00:00:00' AS TIMESTAMP)),
    (34, 750, CAST('2010-05-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-04-20 00:00:00' AS TIMESTAMP)),
    (830, 751, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (2074, 752, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (1950, 753, CAST('2010-06-19 00:00:00' AS TIMESTAMP), CAST('2010-08-18 00:00:00' AS TIMESTAMP), 'EA', 0, 1.00, CAST('2010-08-18 00:00:00' AS TIMESTAMP)),
    (1761, 753, CAST('2010-08-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-08-05 00:00:00' AS TIMESTAMP)),
    (3088, 754, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (3351, 755, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (3246, 756, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2760, 757, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (2395, 758, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3087, 759, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (3350, 760, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2822, 761, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (3245, 762, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2759, 763, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (2394, 764, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3341, 765, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2815, 766, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (2449, 767, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (2899, 768, CAST('2010-09-15 00:00:00' AS TIMESTAMP), CAST('2010-11-14 00:00:00' AS TIMESTAMP), 'EA', 0, 1.00, CAST('2010-11-14 00:00:00' AS TIMESTAMP)),
    (2738, 768, CAST('2010-11-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-11-01 00:00:00' AS TIMESTAMP)),
    (2363, 769, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (1265, 770, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1195, 771, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (3017, 772, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (3281, 773, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2783, 774, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (5, 775, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (2737, 776, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (2362, 777, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (1264, 778, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1642, 779, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (393, 780, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (52, 781, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (3217, 782, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (808, 783, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (2049, 784, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (4, 785, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (2736, 786, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (2361, 787, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (1263, 788, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (3247, 789, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2761, 790, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (2396, 791, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3089, 792, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (2739, 793, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (2364, 794, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (1266, 795, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (482, 796, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (1024, 797, CAST('2010-05-26 00:00:00' AS TIMESTAMP), CAST('2010-07-25 00:00:00' AS TIMESTAMP), 'EA', 0, 1.00, CAST('2010-07-25 00:00:00' AS TIMESTAMP)),
    (783, 797, CAST('2010-07-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-07-12 00:00:00' AS TIMESTAMP)),
    (2333, 798, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (1240, 799, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (450, 800, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (92, 801, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1303, 953, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1699, 954, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3060, 955, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (3326, 956, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2107, 957, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (2800, 958, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (1778, 959, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3102, 960, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (2027, 961, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (1698, 962, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3059, 963, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (879, 964, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (1789, 965, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3037, 966, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (3304, 967, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2801, 968, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (1779, 969, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (419, 970, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (73, 971, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1071, 972, CAST('2010-05-26 00:00:00' AS TIMESTAMP), CAST('2010-07-25 00:00:00' AS TIMESTAMP), 'EA', 0, 1.00, CAST('2010-07-25 00:00:00' AS TIMESTAMP)),
    (867, 972, CAST('2010-07-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-07-12 00:00:00' AS TIMESTAMP)),
    (2993, 973, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (33, 974, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (829, 975, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (2073, 976, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (103, 977, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1668, 978, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3036, 979, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (1641, 980, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (392, 981, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (51, 982, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (850, 983, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (1194, 984, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (3016, 985, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (3280, 986, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2782, 987, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (2422, 988, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3, 989, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (2735, 990, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (2360, 991, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (1262, 992, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (481, 993, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (809, 997, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (2050, 998, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (1938, 999, CAST('2010-06-19 00:00:00' AS TIMESTAMP), CAST('2010-08-18 00:00:00' AS TIMESTAMP), 'EA', 0, 1.00, CAST('2010-08-18 00:00:00' AS TIMESTAMP)),
    (1731, 999, CAST('2010-08-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 0, 1.00, CAST('2010-08-05 00:00:00' AS TIMESTAMP)),
    (2000, 2, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 3, 10.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (1657, 461, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 3, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (389, 504, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 3, 2.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (805, 505, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 3, 2.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (2433, 486, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 4, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (1290, 486, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 3, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (875, 483, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 3, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (3337, 482, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 3, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2806, 482, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 3, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (2432, 482, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 3, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (1289, 482, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 4, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (492, 486, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 4, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (876, 487, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 3, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (3338, 485, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 3, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (543, 523, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 3, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (2162, 525, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 3, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (935, 524, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 3, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (2487, 526, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 3, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (2327, 497, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3138, 528, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (1830, 530, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3135, 908, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (1219, 497, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (3400, 528, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (3140, 530, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (2858, 909, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (386, 497, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (2862, 528, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (3402, 530, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (1357, 910, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (28, 497, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (2489, 528, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (2864, 530, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (348, 911, CAST('2010-03-04 00:00:00' AS TIMESTAMP), CAST('2010-05-03 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-05-03 00:00:00' AS TIMESTAMP)),
    (140, 911, CAST('2010-05-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-04-20 00:00:00' AS TIMESTAMP)),
    (1032, 497, CAST('2010-05-26 00:00:00' AS TIMESTAMP), CAST('2010-07-25 00:00:00' AS TIMESTAMP), 'EA', 1, 5.00, CAST('2010-07-25 00:00:00' AS TIMESTAMP)),
    (803, 497, CAST('2010-07-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-07-12 00:00:00' AS TIMESTAMP)),
    (1360, 528, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (2491, 530, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (2161, 912, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (2022, 497, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (546, 528, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (1362, 530, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (3136, 913, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (1660, 497, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (144, 528, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (548, 530, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (2859, 914, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (3012, 497, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (938, 528, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (146, 530, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1358, 915, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (3239, 497, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2165, 528, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (1124, 530, CAST('2010-05-26 00:00:00' AS TIMESTAMP), CAST('2010-07-25 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-07-25 00:00:00' AS TIMESTAMP)),
    (940, 530, CAST('2010-07-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-12 00:00:00' AS TIMESTAMP)),
    (141, 916, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1288, 477, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 3, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (2094, 487, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 4, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (1956, 484, CAST('2010-06-19 00:00:00' AS TIMESTAMP), CAST('2010-08-18 00:00:00' AS TIMESTAMP), 'EA', 2, 2.00, CAST('2010-08-18 00:00:00' AS TIMESTAMP)),
    (1769, 484, CAST('2010-08-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 3, 1.00, CAST('2010-08-05 00:00:00' AS TIMESTAMP)),
    (100, 478, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 3, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (491, 482, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 3, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (1445, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1881, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3453, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2541, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3190, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (1617, 492, CAST('2010-06-09 00:00:00' AS TIMESTAMP), CAST('2010-08-08 00:00:00' AS TIMESTAMP), 'OZ', 1, 9.00, CAST('2010-08-08 00:00:00' AS TIMESTAMP)),
    (1446, 492, CAST('2010-08-09 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-07-26 00:00:00' AS TIMESTAMP)),
    (626, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (987, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (220, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (219, 804, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (776, 324, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (1999, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3482, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2709, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3215, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (777, 493, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (778, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (1190, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (779, 534, CAST('2010-05-06 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-04-22 00:00:00' AS TIMESTAMP)),
    (360, 804, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1453, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1887, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3459, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2547, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3196, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (771, 493, CAST('2010-03-18 00:00:00' AS TIMESTAMP), CAST('2010-05-17 00:00:00' AS TIMESTAMP), 'OZ', 1, 9.00, CAST('2010-05-17 00:00:00' AS TIMESTAMP)),
    (636, 493, CAST('2010-05-18 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-05-04 00:00:00' AS TIMESTAMP)),
    (637, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (993, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (232, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (231, 804, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1449, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1883, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3455, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2689, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), CAST('2010-10-04 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-10-04 00:00:00' AS TIMESTAMP)),
    (2543, 327, CAST('2010-10-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-09-21 00:00:00' AS TIMESTAMP)),
    (3192, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (628, 493, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (629, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (989, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (224, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (223, 804, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1450, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1884, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3456, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2544, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3193, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (770, 493, CAST('2010-03-18 00:00:00' AS TIMESTAMP), CAST('2010-05-17 00:00:00' AS TIMESTAMP), 'OZ', 1, 9.00, CAST('2010-05-17 00:00:00' AS TIMESTAMP)),
    (630, 493, CAST('2010-05-18 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-05-04 00:00:00' AS TIMESTAMP)),
    (631, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (990, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (226, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (225, 804, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1451, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1885, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3457, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2545, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3194, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (632, 493, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (633, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (1167, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), CAST('2010-07-25 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-07-25 00:00:00' AS TIMESTAMP)),
    (991, 533, CAST('2010-07-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-12 00:00:00' AS TIMESTAMP)),
    (228, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (227, 804, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1452, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1886, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3458, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2546, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3195, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (634, 493, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (635, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (992, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (230, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (229, 804, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1409, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1860, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3432, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2520, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3169, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (1411, 492, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (585, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (1151, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), CAST('2010-07-25 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-07-25 00:00:00' AS TIMESTAMP)),
    (966, 533, CAST('2010-07-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-12 00:00:00' AS TIMESTAMP)),
    (195, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1410, 802, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1412, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1861, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3433, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2521, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3170, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (1414, 492, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (586, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (967, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (196, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1413, 802, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1602, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), CAST('2010-08-08 00:00:00' AS TIMESTAMP), 'EA', 1, 3.00, CAST('2010-08-08 00:00:00' AS TIMESTAMP)),
    (1415, 324, CAST('2010-08-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-07-26 00:00:00' AS TIMESTAMP)),
    (1862, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3434, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2522, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3171, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (1417, 492, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (587, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (968, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (197, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1416, 802, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1418, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1863, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3435, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2675, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), CAST('2010-10-04 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-10-04 00:00:00' AS TIMESTAMP)),
    (2523, 327, CAST('2010-10-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-09-21 00:00:00' AS TIMESTAMP)),
    (3172, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (588, 493, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (589, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (969, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (198, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1419, 802, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1420, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1864, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3436, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2524, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3173, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (766, 493, CAST('2010-03-18 00:00:00' AS TIMESTAMP), CAST('2010-05-17 00:00:00' AS TIMESTAMP), 'OZ', 1, 9.00, CAST('2010-05-17 00:00:00' AS TIMESTAMP)),
    (590, 493, CAST('2010-05-18 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-05-04 00:00:00' AS TIMESTAMP)),
    (591, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (970, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (199, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1421, 802, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1422, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1865, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3437, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2525, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3174, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (592, 493, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (593, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (1152, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), CAST('2010-07-25 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-07-25 00:00:00' AS TIMESTAMP)),
    (971, 533, CAST('2010-07-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-12 00:00:00' AS TIMESTAMP)),
    (200, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1423, 802, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1603, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), CAST('2010-08-08 00:00:00' AS TIMESTAMP), 'EA', 1, 3.00, CAST('2010-08-08 00:00:00' AS TIMESTAMP)),
    (1424, 324, CAST('2010-08-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-07-26 00:00:00' AS TIMESTAMP)),
    (1866, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3438, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2526, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3175, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (594, 493, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (595, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (972, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (201, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1425, 802, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1426, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1867, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3439, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2676, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), CAST('2010-10-04 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-10-04 00:00:00' AS TIMESTAMP)),
    (2527, 327, CAST('2010-10-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-09-21 00:00:00' AS TIMESTAMP)),
    (3176, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (596, 493, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (597, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (973, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (202, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1427, 802, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1428, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1868, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3440, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2528, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3177, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (767, 493, CAST('2010-03-18 00:00:00' AS TIMESTAMP), CAST('2010-05-17 00:00:00' AS TIMESTAMP), 'OZ', 1, 9.00, CAST('2010-05-17 00:00:00' AS TIMESTAMP)),
    (598, 493, CAST('2010-05-18 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-05-04 00:00:00' AS TIMESTAMP)),
    (599, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (974, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (203, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1429, 802, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1430, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1869, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3441, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2682, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), CAST('2010-10-04 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-10-04 00:00:00' AS TIMESTAMP)),
    (2529, 327, CAST('2010-10-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-09-21 00:00:00' AS TIMESTAMP)),
    (3178, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (601, 493, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (602, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (975, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (204, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (600, 803, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (1431, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1870, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3442, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2530, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3179, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (768, 493, CAST('2010-03-18 00:00:00' AS TIMESTAMP), CAST('2010-05-17 00:00:00' AS TIMESTAMP), 'OZ', 1, 9.00, CAST('2010-05-17 00:00:00' AS TIMESTAMP)),
    (604, 493, CAST('2010-05-18 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-05-04 00:00:00' AS TIMESTAMP)),
    (605, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (976, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (205, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (603, 803, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (1432, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1871, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3443, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2531, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3180, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (607, 493, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (608, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (1160, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), CAST('2010-07-25 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-07-25 00:00:00' AS TIMESTAMP)),
    (977, 533, CAST('2010-07-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-12 00:00:00' AS TIMESTAMP)),
    (206, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (606, 803, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (1611, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), CAST('2010-08-08 00:00:00' AS TIMESTAMP), 'EA', 1, 3.00, CAST('2010-08-08 00:00:00' AS TIMESTAMP)),
    (1433, 324, CAST('2010-08-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-07-26 00:00:00' AS TIMESTAMP)),
    (1872, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3444, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2532, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3181, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (610, 493, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (611, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (978, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (207, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (609, 803, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (1434, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1873, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3445, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2683, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), CAST('2010-10-04 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-10-04 00:00:00' AS TIMESTAMP)),
    (2533, 327, CAST('2010-10-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-09-21 00:00:00' AS TIMESTAMP)),
    (3182, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (613, 493, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (614, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (979, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (208, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (612, 803, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (1400, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1857, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3429, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2517, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3166, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (1402, 492, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (582, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (963, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (192, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1401, 802, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1600, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), CAST('2010-08-08 00:00:00' AS TIMESTAMP), 'EA', 1, 3.00, CAST('2010-08-08 00:00:00' AS TIMESTAMP)),
    (1403, 324, CAST('2010-08-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-07-26 00:00:00' AS TIMESTAMP)),
    (1858, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3430, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2518, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3167, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (1405, 492, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (583, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (964, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (193, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1404, 802, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1406, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1859, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3431, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2674, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), CAST('2010-10-04 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-10-04 00:00:00' AS TIMESTAMP)),
    (2519, 327, CAST('2010-10-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-09-21 00:00:00' AS TIMESTAMP)),
    (3168, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (1408, 492, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (584, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (965, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (194, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1407, 802, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1396, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1853, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3425, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2513, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3162, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (181, 494, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (578, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (1145, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), CAST('2010-07-25 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-07-25 00:00:00' AS TIMESTAMP)),
    (959, 533, CAST('2010-07-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-12 00:00:00' AS TIMESTAMP)),
    (182, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (180, 804, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1397, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1854, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3426, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2514, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3163, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (184, 494, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (579, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (960, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (185, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (183, 804, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1596, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), CAST('2010-08-08 00:00:00' AS TIMESTAMP), 'EA', 1, 3.00, CAST('2010-08-08 00:00:00' AS TIMESTAMP)),
    (1398, 324, CAST('2010-08-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-07-26 00:00:00' AS TIMESTAMP)),
    (1855, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3427, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2515, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3164, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (187, 494, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (580, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (961, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (188, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (186, 804, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1399, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1856, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3428, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2670, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), CAST('2010-10-04 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-10-04 00:00:00' AS TIMESTAMP)),
    (2516, 327, CAST('2010-10-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-09-21 00:00:00' AS TIMESTAMP)),
    (3165, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (190, 494, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (581, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (962, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (191, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (189, 804, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1388, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1849, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3421, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2509, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3158, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (1389, 492, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (574, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (955, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (173, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (172, 804, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1592, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), CAST('2010-08-08 00:00:00' AS TIMESTAMP), 'EA', 1, 3.00, CAST('2010-08-08 00:00:00' AS TIMESTAMP)),
    (1390, 324, CAST('2010-08-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-07-26 00:00:00' AS TIMESTAMP)),
    (1850, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3422, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2510, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3159, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (1391, 492, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (575, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (956, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (175, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (174, 804, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1392, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1851, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3423, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2667, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), CAST('2010-10-04 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-10-04 00:00:00' AS TIMESTAMP)),
    (2511, 327, CAST('2010-10-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-09-21 00:00:00' AS TIMESTAMP)),
    (3160, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (1393, 492, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (576, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (957, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (177, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (176, 804, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1394, 324, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1852, 325, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3424, 326, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2512, 327, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3161, 399, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (1593, 492, CAST('2010-06-09 00:00:00' AS TIMESTAMP), CAST('2010-08-08 00:00:00' AS TIMESTAMP), 'OZ', 1, 9.00, CAST('2010-08-08 00:00:00' AS TIMESTAMP)),
    (1395, 492, CAST('2010-08-09 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-07-26 00:00:00' AS TIMESTAMP)),
    (577, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (958, 533, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (179, 534, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (178, 804, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (2305, 324, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (2720, 325, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (2307, 326, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (1202, 327, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (3236, 399, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (3011, 492, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (2653, 532, CAST('2010-08-05 00:00:00' AS TIMESTAMP), CAST('2010-10-04 00:00:00' AS TIMESTAMP), 'EA', 1, 5.00, CAST('2010-10-04 00:00:00' AS TIMESTAMP)),
    (2493, 532, CAST('2010-10-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-09-21 00:00:00' AS TIMESTAMP)),
    (1364, 533, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1838, 534, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (18, 804, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (368, 324, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (1200, 325, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 2.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (371, 326, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (262, 327, CAST('2010-03-04 00:00:00' AS TIMESTAMP), CAST('2010-05-03 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-05-03 00:00:00' AS TIMESTAMP)),
    (11, 327, CAST('2010-05-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-04-20 00:00:00' AS TIMESTAMP)),
    (2323, 399, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (2203, 494, CAST('2010-07-08 00:00:00' AS TIMESTAMP), CAST('2010-09-06 00:00:00' AS TIMESTAMP), 'OZ', 1, 9.00, CAST('2010-09-06 00:00:00' AS TIMESTAMP)),
    (2020, 494, CAST('2010-09-07 00:00:00' AS TIMESTAMP), NULL, 'OZ', 2, 8.00, CAST('2010-08-24 00:00:00' AS TIMESTAMP)),
    (550, 532, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 4.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (148, 533, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (3409, 534, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2012, 804, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 2, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (2989, 519, CAST('2010-09-15 00:00:00' AS TIMESTAMP), CAST('2010-11-14 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-11-14 00:00:00' AS TIMESTAMP)),
    (2857, 519, CAST('2010-11-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-11-01 00:00:00' AS TIMESTAMP)),
    (1793, 717, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3108, 807, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (3363, 813, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (511, 820, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (752, 828, CAST('2010-03-18 00:00:00' AS TIMESTAMP), CAST('2010-05-17 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-05-17 00:00:00' AS TIMESTAMP)),
    (531, 828, CAST('2010-05-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-04 00:00:00' AS TIMESTAMP)),
    (2464, 894, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3110, 907, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (3364, 940, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (1319, 945, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (111, 948, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1317, 951, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (2823, 952, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (1316, 996, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (2980, 519, CAST('2010-09-15 00:00:00' AS TIMESTAMP), CAST('2010-11-14 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-11-14 00:00:00' AS TIMESTAMP)),
    (2852, 519, CAST('2010-11-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-11-01 00:00:00' AS TIMESTAMP)),
    (2036, 718, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (411, 807, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (44, 813, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (3025, 820, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (746, 828, CAST('2010-03-18 00:00:00' AS TIMESTAMP), CAST('2010-05-17 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-05-17 00:00:00' AS TIMESTAMP)),
    (526, 828, CAST('2010-05-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-04 00:00:00' AS TIMESTAMP)),
    (2456, 894, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (416, 907, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (46, 940, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1674, 945, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3256, 948, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (1671, 951, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (1037, 952, CAST('2010-05-26 00:00:00' AS TIMESTAMP), CAST('2010-07-25 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-07-25 00:00:00' AS TIMESTAMP)),
    (811, 952, CAST('2010-07-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-12 00:00:00' AS TIMESTAMP)),
    (1667, 996, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (1116, 519, CAST('2010-05-26 00:00:00' AS TIMESTAMP), CAST('2010-07-25 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-07-25 00:00:00' AS TIMESTAMP)),
    (928, 519, CAST('2010-07-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-12 00:00:00' AS TIMESTAMP)),
    (1710, 719, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (441, 807, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (64, 813, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (3047, 820, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (3124, 828, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (2125, 894, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (447, 907, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (68, 940, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1707, 945, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3290, 948, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (1932, 951, CAST('2010-06-19 00:00:00' AS TIMESTAMP), CAST('2010-08-18 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-08-18 00:00:00' AS TIMESTAMP)),
    (1703, 951, CAST('2010-08-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-08-05 00:00:00' AS TIMESTAMP)),
    (832, 952, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (1697, 996, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (2983, 519, CAST('2010-09-15 00:00:00' AS TIMESTAMP), CAST('2010-11-14 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-11-14 00:00:00' AS TIMESTAMP)),
    (2855, 519, CAST('2010-11-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-11-01 00:00:00' AS TIMESTAMP)),
    (3067, 720, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (472, 807, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (85, 813, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (3069, 820, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (748, 828, CAST('2010-03-18 00:00:00' AS TIMESTAMP), CAST('2010-05-17 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-05-17 00:00:00' AS TIMESTAMP)),
    (530, 828, CAST('2010-05-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-04 00:00:00' AS TIMESTAMP)),
    (2461, 894, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (703, 907, CAST('2010-03-18 00:00:00' AS TIMESTAMP), CAST('2010-05-17 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-05-17 00:00:00' AS TIMESTAMP)),
    (478, 907, CAST('2010-05-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-04 00:00:00' AS TIMESTAMP)),
    (291, 940, CAST('2010-03-04 00:00:00' AS TIMESTAMP), CAST('2010-05-03 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-05-03 00:00:00' AS TIMESTAMP)),
    (89, 940, CAST('2010-05-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-04-20 00:00:00' AS TIMESTAMP)),
    (1738, 945, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3313, 948, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (1734, 951, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (852, 952, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (1730, 996, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (1119, 519, CAST('2010-05-26 00:00:00' AS TIMESTAMP), CAST('2010-07-25 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-07-25 00:00:00' AS TIMESTAMP)),
    (931, 519, CAST('2010-07-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-12 00:00:00' AS TIMESTAMP)),
    (3334, 721, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (490, 807, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (97, 813, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (3080, 820, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (3126, 828, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (2129, 894, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (3086, 907, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (3339, 940, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (1765, 945, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3331, 948, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (1763, 951, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (868, 952, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (1760, 996, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (139, 518, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (3347, 734, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (1298, 806, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (496, 812, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (1776, 819, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (1818, 827, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (2131, 894, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (499, 907, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (497, 939, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (1774, 945, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3345, 948, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2098, 950, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (881, 952, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (2238, 995, CAST('2010-07-08 00:00:00' AS TIMESTAMP), CAST('2010-09-06 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-09-06 00:00:00' AS TIMESTAMP)),
    (2096, 995, CAST('2010-09-07 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-08-24 00:00:00' AS TIMESTAMP)),
    (3395, 518, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2818, 735, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (1311, 806, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (502, 812, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (1785, 819, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (1348, 827, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (2463, 894, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (507, 907, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (505, 939, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (1784, 945, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3354, 948, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2109, 950, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (887, 952, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (2106, 995, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (130, 518, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (2750, 731, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (1685, 806, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3026, 812, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (1505, 819, CAST('2010-06-09 00:00:00' AS TIMESTAMP), CAST('2010-08-08 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-08-08 00:00:00' AS TIMESTAMP)),
    (1231, 819, CAST('2010-08-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-26 00:00:00' AS TIMESTAMP)),
    (1808, 827, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (2122, 894, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (3032, 907, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (3029, 939, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (1227, 945, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (39, 948, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (2338, 950, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (2741, 952, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (2331, 995, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3386, 518, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2379, 732, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (1719, 806, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3048, 812, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (1252, 819, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1340, 827, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (2458, 894, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3055, 907, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (3052, 939, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (1246, 945, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (279, 948, CAST('2010-03-04 00:00:00' AS TIMESTAMP), CAST('2010-05-03 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-05-03 00:00:00' AS TIMESTAMP)),
    (58, 948, CAST('2010-05-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-04-20 00:00:00' AS TIMESTAMP)),
    (2369, 950, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (2763, 952, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (2587, 995, CAST('2010-08-05 00:00:00' AS TIMESTAMP), CAST('2010-10-04 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-10-04 00:00:00' AS TIMESTAMP)),
    (2358, 995, CAST('2010-10-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-09-21 00:00:00' AS TIMESTAMP)),
    (135, 518, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1273, 733, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1945, 806, CAST('2010-06-19 00:00:00' AS TIMESTAMP), CAST('2010-08-18 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-08-18 00:00:00' AS TIMESTAMP)),
    (1748, 806, CAST('2010-08-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-08-05 00:00:00' AS TIMESTAMP)),
    (3070, 812, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (1275, 819, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1814, 827, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (2127, 894, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (3076, 907, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (3073, 939, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (1270, 945, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (78, 948, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (2401, 950, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (2785, 952, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (2392, 995, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (540, 517, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (2438, 728, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (1297, 806, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1296, 811, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (2243, 818, CAST('2010-07-08 00:00:00' AS TIMESTAMP), CAST('2010-09-06 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-09-06 00:00:00' AS TIMESTAMP)),
    (2102, 818, CAST('2010-09-07 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-08-24 00:00:00' AS TIMESTAMP)),
    (2146, 826, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (2130, 894, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (498, 907, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (1300, 938, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1773, 945, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3344, 948, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2097, 950, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (1079, 952, CAST('2010-05-26 00:00:00' AS TIMESTAMP), CAST('2010-07-25 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-07-25 00:00:00' AS TIMESTAMP)),
    (880, 952, CAST('2010-07-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-12 00:00:00' AS TIMESTAMP)),
    (2809, 994, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (3133, 517, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (1307, 729, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1310, 806, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1309, 811, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (2112, 818, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (2475, 826, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (2462, 894, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (506, 907, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (1312, 938, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1783, 945, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3353, 948, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2108, 950, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (886, 952, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (2813, 994, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (542, 517, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (510, 730, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (1322, 806, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1321, 811, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (2118, 818, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (2149, 826, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (2133, 894, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (513, 907, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (1323, 938, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1792, 945, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3360, 948, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2116, 950, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (894, 952, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (2821, 994, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (534, 517, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (1230, 725, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1684, 806, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (1682, 811, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (2351, 818, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (2138, 826, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (2121, 894, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (3031, 907, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (1689, 938, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (1226, 945, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (273, 948, CAST('2010-03-04 00:00:00' AS TIMESTAMP), CAST('2010-05-03 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-05-03 00:00:00' AS TIMESTAMP)),
    (38, 948, CAST('2010-05-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-04-20 00:00:00' AS TIMESTAMP)),
    (2337, 950, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (2740, 952, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (806, 994, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (3132, 517, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (432, 726, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (1718, 806, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (1716, 811, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (2382, 818, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (2471, 826, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (2457, 894, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3054, 907, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (1723, 938, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (1245, 945, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (57, 948, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (2368, 950, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (2762, 952, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (1047, 994, CAST('2010-05-26 00:00:00' AS TIMESTAMP), CAST('2010-07-25 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-07-25 00:00:00' AS TIMESTAMP)),
    (826, 994, CAST('2010-07-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-12 00:00:00' AS TIMESTAMP)),
    (538, 517, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (82, 727, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1747, 806, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (1745, 811, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (2601, 818, CAST('2010-08-05 00:00:00' AS TIMESTAMP), CAST('2010-10-04 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-10-04 00:00:00' AS TIMESTAMP)),
    (2413, 818, CAST('2010-10-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-09-21 00:00:00' AS TIMESTAMP)),
    (2142, 826, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (2126, 894, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (3075, 907, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (1752, 938, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (1269, 945, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (77, 948, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (2400, 950, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (2784, 952, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (848, 994, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (1572, 517, CAST('2010-06-09 00:00:00' AS TIMESTAMP), CAST('2010-08-08 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-08-08 00:00:00' AS TIMESTAMP)),
    (1355, 517, CAST('2010-08-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-26 00:00:00' AS TIMESTAMP)),
    (2437, 722, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (2440, 806, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (2439, 811, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (884, 818, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (1109, 826, CAST('2010-05-26 00:00:00' AS TIMESTAMP), CAST('2010-07-25 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-07-25 00:00:00' AS TIMESTAMP)),
    (923, 826, CAST('2010-07-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-12 00:00:00' AS TIMESTAMP)),
    (911, 894, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (1301, 907, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (2441, 938, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (2100, 945, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (3092, 948, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (1080, 950, CAST('2010-05-26 00:00:00' AS TIMESTAMP), CAST('2010-07-25 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-07-25 00:00:00' AS TIMESTAMP)),
    (883, 950, CAST('2010-07-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-12 00:00:00' AS TIMESTAMP)),
    (104, 952, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (3340, 994, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (1827, 517, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (1306, 723, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (2447, 806, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (2446, 811, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (889, 818, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (2850, 826, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (2839, 894, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (1314, 907, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (2448, 938, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (2111, 945, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (3098, 948, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (888, 950, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (108, 952, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (3348, 994, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (1573, 517, CAST('2010-06-09 00:00:00' AS TIMESTAMP), CAST('2010-08-08 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-08-08 00:00:00' AS TIMESTAMP)),
    (1356, 517, CAST('2010-08-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-26 00:00:00' AS TIMESTAMP)),
    (740, 724, CAST('2010-03-18 00:00:00' AS TIMESTAMP), CAST('2010-05-17 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-05-17 00:00:00' AS TIMESTAMP)),
    (509, 724, CAST('2010-05-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-04 00:00:00' AS TIMESTAMP)),
    (2453, 806, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (2452, 811, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (896, 818, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (1111, 826, CAST('2010-05-26 00:00:00' AS TIMESTAMP), CAST('2010-07-25 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-07-25 00:00:00' AS TIMESTAMP)),
    (924, 826, CAST('2010-07-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-12 00:00:00' AS TIMESTAMP)),
    (912, 894, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (1324, 907, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (2454, 938, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (2117, 945, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (3105, 948, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (895, 950, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (110, 952, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (3359, 994, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (1570, 517, CAST('2010-06-09 00:00:00' AS TIMESTAMP), CAST('2010-08-08 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-08-08 00:00:00' AS TIMESTAMP)),
    (1350, 517, CAST('2010-08-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-26 00:00:00' AS TIMESTAMP)),
    (1229, 736, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (2041, 806, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (2038, 811, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (2751, 818, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (1105, 826, CAST('2010-05-26 00:00:00' AS TIMESTAMP), CAST('2010-07-25 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-07-25 00:00:00' AS TIMESTAMP)),
    (917, 826, CAST('2010-07-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-12 00:00:00' AS TIMESTAMP)),
    (902, 894, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (1693, 907, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (2043, 938, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (2579, 945, CAST('2010-08-05 00:00:00' AS TIMESTAMP), CAST('2010-10-04 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-10-04 00:00:00' AS TIMESTAMP)),
    (2344, 945, CAST('2010-10-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-09-21 00:00:00' AS TIMESTAMP)),
    (400, 948, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (2744, 950, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (3251, 952, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (32, 994, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1822, 517, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (689, 737, CAST('2010-03-18 00:00:00' AS TIMESTAMP), CAST('2010-05-17 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-05-17 00:00:00' AS TIMESTAMP)),
    (431, 737, CAST('2010-05-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-04 00:00:00' AS TIMESTAMP)),
    (2065, 806, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (2062, 811, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (2772, 818, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (2845, 826, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (2833, 894, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (1728, 907, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (2067, 938, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (2376, 945, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (427, 948, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (2907, 950, CAST('2010-09-15 00:00:00' AS TIMESTAMP), CAST('2010-11-14 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-11-14 00:00:00' AS TIMESTAMP)),
    (2766, 950, CAST('2010-11-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-11-01 00:00:00' AS TIMESTAMP)),
    (3285, 952, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (49, 994, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1571, 517, CAST('2010-06-09 00:00:00' AS TIMESTAMP), CAST('2010-08-08 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-08-08 00:00:00' AS TIMESTAMP)),
    (1353, 517, CAST('2010-08-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-26 00:00:00' AS TIMESTAMP)),
    (81, 738, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (2083, 806, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (2080, 811, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (2793, 818, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (1107, 826, CAST('2010-05-26 00:00:00' AS TIMESTAMP), CAST('2010-07-25 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-07-25 00:00:00' AS TIMESTAMP)),
    (921, 826, CAST('2010-07-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-12 00:00:00' AS TIMESTAMP)),
    (909, 894, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (1947, 907, CAST('2010-06-19 00:00:00' AS TIMESTAMP), CAST('2010-08-18 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-08-18 00:00:00' AS TIMESTAMP)),
    (1757, 907, CAST('2010-08-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-08-05 00:00:00' AS TIMESTAMP)),
    (2223, 938, CAST('2010-07-08 00:00:00' AS TIMESTAMP), CAST('2010-09-06 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-09-06 00:00:00' AS TIMESTAMP)),
    (2085, 938, CAST('2010-09-07 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-08-24 00:00:00' AS TIMESTAMP)),
    (2408, 945, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (458, 948, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (2788, 950, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (3308, 952, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (71, 994, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (3128, 516, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (3229, 748, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (21, 807, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (1495, 810, CAST('2010-06-09 00:00:00' AS TIMESTAMP), CAST('2010-08-08 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-08-08 00:00:00' AS TIMESTAMP)),
    (1212, 810, CAST('2010-08-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-26 00:00:00' AS TIMESTAMP)),
    (378, 817, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (2468, 825, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (1550, 894, CAST('2010-06-09 00:00:00' AS TIMESTAMP), CAST('2010-08-08 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-08-08 00:00:00' AS TIMESTAMP)),
    (1326, 894, CAST('2010-08-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-26 00:00:00' AS TIMESTAMP)),
    (3242, 907, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (804, 937, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (3001, 945, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (2008, 948, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (2004, 951, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (786, 952, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (1910, 996, CAST('2010-06-19 00:00:00' AS TIMESTAMP), CAST('2010-08-18 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-08-18 00:00:00' AS TIMESTAMP)),
    (1639, 996, CAST('2010-08-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-08-05 00:00:00' AS TIMESTAMP)),
    (533, 516, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (1676, 739, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3273, 807, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (1681, 810, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (2350, 817, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (2137, 825, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (1799, 894, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3277, 907, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (1688, 937, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (403, 945, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (814, 948, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (396, 951, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (2335, 952, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3015, 996, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (3131, 516, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (3045, 740, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (3297, 807, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (1936, 810, CAST('2010-06-19 00:00:00' AS TIMESTAMP), CAST('2010-08-18 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-08-18 00:00:00' AS TIMESTAMP)),
    (1715, 810, CAST('2010-08-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-08-05 00:00:00' AS TIMESTAMP)),
    (2381, 817, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (2470, 825, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (1553, 894, CAST('2010-06-09 00:00:00' AS TIMESTAMP), CAST('2010-08-08 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-08-08 00:00:00' AS TIMESTAMP)),
    (1330, 894, CAST('2010-08-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-26 00:00:00' AS TIMESTAMP)),
    (3301, 907, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (1722, 937, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (430, 945, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (836, 948, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (423, 951, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (2366, 952, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3035, 996, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (537, 516, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (3315, 741, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (3321, 807, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (1744, 810, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (2412, 817, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (2141, 825, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (1803, 894, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (3324, 907, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (1751, 937, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (461, 945, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (855, 948, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (454, 951, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (2398, 952, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3058, 996, CAST('2010-12-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-01 00:00:00' AS TIMESTAMP)),
    (2151, 516, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (795, 747, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (1496, 807, CAST('2010-06-09 00:00:00' AS TIMESTAMP), CAST('2010-08-08 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-08-08 00:00:00' AS TIMESTAMP)),
    (1214, 807, CAST('2010-08-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-26 00:00:00' AS TIMESTAMP)),
    (2729, 810, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (2316, 817, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3377, 825, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2827, 894, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (1664, 907, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (388, 937, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (2011, 945, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (15, 948, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (8, 951, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (365, 952, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (782, 996, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (2481, 516, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (2347, 743, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (1687, 807, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (821, 810, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (3270, 817, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (124, 825, CAST('2010-03-04 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-02-18 00:00:00' AS TIMESTAMP)),
    (901, 894, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (1692, 907, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (825, 937, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (2343, 945, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (399, 948, CAST('2010-03-18 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-03-04 00:00:00' AS TIMESTAMP)),
    (2340, 951, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP)),
    (3250, 952, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2206, 996, CAST('2010-07-08 00:00:00' AS TIMESTAMP), CAST('2010-09-06 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-09-06 00:00:00' AS TIMESTAMP)),
    (2026, 996, CAST('2010-09-07 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-08-24 00:00:00' AS TIMESTAMP)),
    (2155, 516, CAST('2010-07-08 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-24 00:00:00' AS TIMESTAMP)),
    (1249, 744, CAST('2010-06-09 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-26 00:00:00' AS TIMESTAMP)),
    (1937, 807, CAST('2010-06-19 00:00:00' AS TIMESTAMP), CAST('2010-08-18 00:00:00' AS TIMESTAMP), 'EA', 1, 2.00, CAST('2010-08-18 00:00:00' AS TIMESTAMP)),
    (1721, 807, CAST('2010-08-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-08-05 00:00:00' AS TIMESTAMP)),
    (842, 810, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (3294, 817, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (3380, 825, CAST('2010-12-23 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-12-09 00:00:00' AS TIMESTAMP)),
    (2832, 894, CAST('2010-09-15 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-09-01 00:00:00' AS TIMESTAMP)),
    (1727, 907, CAST('2010-06-19 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-06-05 00:00:00' AS TIMESTAMP)),
    (846, 937, CAST('2010-05-26 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-05-12 00:00:00' AS TIMESTAMP)),
    (2375, 945, CAST('2010-08-05 00:00:00' AS TIMESTAMP), NULL, 'EA', 1, 1.00, CAST('2010-07-22 00:00:00' AS TIMESTAMP));
-- SET IDENTITY_INSERT [dbo].[Product] ON;
SET DATEFORMAT ymd;
INSERT INTO bobsusedbookstore_dbo.product (productid, name, productnumber, makeflag, finishedgoodsflag, color, safetystocklevel, reorderpoint, standardcost, listprice, size, sizeunitmeasurecode, weightunitmeasurecode, weight, daystomanufacture, productline, class, style, productsubcategoryid, productmodelid, sellstartdate, sellenddate, discontinueddate, rowguid, modifieddate);
VALUES
(1, 'Adjustable Race', 'AR-5381', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '694215b7-08f7-4c0d-acb1-d734ba44c0c8', clock_timestamp()),
(2, 'Bearing Ball', 'BA-8327', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '58ae3c20-4f3a-4749-a7d4-d568806cc537', clock_timestamp()),
(3, 'BB Ball Bearing', 'BE-2349', '1', '0', NULL, 800, 600, 0, 0, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '9c21aed2-5bfa-4f18-bcb8-f11638dc2e4e', clock_timestamp()),
(4, 'Headset Ball Bearings', 'BE-2908', '0', '0', NULL, 800, 600, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'ecfed6cb-51ff-49b5-b06c-7d8ac834db8b', clock_timestamp()),
(316, 'Blade', 'BL-2036', '1', '0', NULL, 800, 600, 0, 0, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'e73e9750-603b-4131-89f5-3dd15ed5ff80', clock_timestamp()),
(317, 'LL Crankarm', 'CA-5965', '0', '0', 'Black', 500, 375, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 'L', NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '3c9d10b7-a6b2-4774-9963-c19dcee72fea', clock_timestamp()),
(318, 'ML Crankarm', 'CA-6738', '0', '0', 'Black', 500, 375, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 'M', NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'eabb9a92-fa07-4eab-8955-f0517b4a4ca7', clock_timestamp()),
(319, 'HL Crankarm', 'CA-7457', '0', '0', 'Black', 500, 375, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '7d3fd384-4f29-484b-86fa-4206e276fe58', clock_timestamp()),
(320, 'Chainring Bolts', 'CB-2903', '0', '0', 'Silver', 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '7be38e48-b7d6-4486-888e-f53c26735101', clock_timestamp()),
(321, 'Chainring Nut', 'CN-6137', '0', '0', 'Silver', 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '3314b1d7-ef69-4431-b6dd-dc75268bd5df', clock_timestamp()),
(322, 'Chainring', 'CR-7833', '0', '0', 'Black', 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'f0ac2c4d-1a1f-4e3c-b4d9-68aea0ec1ce4', clock_timestamp()),
(323, 'Crown Race', 'CR-9981', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '51a32ca6-65a1-4c31-af2b-d9e4f5d631d4', clock_timestamp()),
(324, 'Chain Stays', 'CS-2812', '1', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'fe0678ed-aef2-4c58-a450-8151cc24ddd8', clock_timestamp()),
(325, 'Decal 1', 'DC-8732', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '05ce123c-a402-478e-ae9b-75d7727aeaad', clock_timestamp()),
(326, 'Decal 2', 'DC-9824', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'a56851f9-1cd7-4e2f-8779-2e773e1b5209', clock_timestamp()),
(327, 'Down Tube', 'DT-2377', '1', '0', NULL, 800, 600, 0, 0, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '1dad47dd-e259-42b8-b8b4-15a0b7d21b2f', clock_timestamp()),
(328, 'Mountain End Caps', 'EC-M092', '1', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '6070b1ea-59b7-4f8b-950f-2be07d00449d', clock_timestamp()),
(329, 'Road End Caps', 'EC-R098', '1', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '88399d13-719e-4545-81d6-f0650f372fa2', clock_timestamp()),
(330, 'Touring End Caps', 'EC-T209', '1', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '6903ce24-d0ce-4191-9198-4231de37a929', clock_timestamp()),
(331, 'Fork End', 'FE-3760', '1', '0', NULL, 800, 600, 0, 0, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'c91d602e-da52-43d2-bd7e-eb110a9392b9', clock_timestamp()),
(332, 'Freewheel', 'FH-2981', '0', '0', 'Silver', 500, 375, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'd864879a-e8b1-4f7b-bafa-1f136089c2c8', clock_timestamp()),
(341, 'Flat Washer 1', 'FW-1000', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'a3f2fa3a-22e1-43d8-a131-a9b89c32d8ea', clock_timestamp()),
(342, 'Flat Washer 6', 'FW-1200', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '331addec-e9b9-4a7e-9324-42069c2dcdc4', clock_timestamp()),
(343, 'Flat Washer 2', 'FW-1400', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '84a3473e-ae26-4a21-81b9-60bb418a79b2', clock_timestamp()),
(344, 'Flat Washer 9', 'FW-3400', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '0ae4ce60-5242-48f5-ada1-3013ff45f969', clock_timestamp()),
(345, 'Flat Washer 4', 'FW-3800', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '2c1c58b4-234c-4b3a-8c8e-84524ac05eea', clock_timestamp()),
(346, 'Flat Washer 3', 'FW-5160', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '590c2c3f-a8b6-42b5-9412-d655e37f0eae', clock_timestamp()),
(347, 'Flat Washer 8', 'FW-5800', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '1b73f5fe-ab85-49fc-99ad-0500cebda91d', clock_timestamp()),
(348, 'Flat Washer 5', 'FW-7160', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'd182cf18-4ddf-429b-a0df-de1cfc92622d', clock_timestamp()),
(349, 'Flat Washer 7', 'FW-9160', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '7e55f64d-ea3c-45ff-be72-f7f7b9d61a79', clock_timestamp()),
(350, 'Fork Crown', 'FC-3654', '1', '0', NULL, 800, 600, 0, 0, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '1cbfa85b-5c9b-4b58-9c17-95238215d926', clock_timestamp()),
(351, 'Front Derailleur Cage', 'FC-3982', '0', '0', 'Silver', 800, 600, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '01c901e3-4323-48ed-ab9e-9bfda28bdef6', clock_timestamp()),
(352, 'Front Derailleur Linkage', 'FL-2301', '0', '0', 'Silver', 800, 600, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '88ed2e08-e775-4915-b506-831600b773fd', clock_timestamp()),
(355, 'Guide Pulley', 'GP-0982', '0', '0', NULL, 800, 600, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '6a89205b-90c3-4997-8c63-bc6a5ebc752d', clock_timestamp()),
(356, 'LL Grip Tape', 'GT-0820', '0', '0', NULL, 800, 600, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 'L', NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '32c82181-1969-4660-ae04-a02d51994ec1', clock_timestamp()),
(357, 'ML Grip Tape', 'GT-1209', '0', '0', NULL, 800, 600, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 'M', NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '09343e22-2494-4279-9f32-5d961a0fbfea', clock_timestamp()),
(358, 'HL Grip Tape', 'GT-2908', '0', '0', NULL, 800, 600, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '8e5b2bf7-81dd-4454-b75e-d9ae2a6fbd26', clock_timestamp()),
(359, 'Thin-Jam Hex Nut 9', 'HJ-1213', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'a63aff3c-4143-4016-bc99-d3f80ec1ade5', clock_timestamp()),
(360, 'Thin-Jam Hex Nut 10', 'HJ-1220', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'a1ae0c6d-92a5-4fda-b33b-1301e83efe5b', clock_timestamp()),
(361, 'Thin-Jam Hex Nut 1', 'HJ-1420', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'e33e8c4c-282a-4d1f-91e7-e9969cf7134f', clock_timestamp()),
(362, 'Thin-Jam Hex Nut 2', 'HJ-1428', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'a992684f-4642-4856-a817-2c0740ae8c55', clock_timestamp()),
(363, 'Thin-Jam Hex Nut 15', 'HJ-3410', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'b9d9a30d-cb07-422d-a312-f0535575337e', clock_timestamp()),
(364, 'Thin-Jam Hex Nut 16', 'HJ-3416', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '0ec8f653-24c9-41b6-86f5-39c1789db580', clock_timestamp()),
(365, 'Thin-Jam Hex Nut 5', 'HJ-3816', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '94506c9d-5991-46a7-82ea-00e05d8d9b9c', clock_timestamp()),
(366, 'Thin-Jam Hex Nut 6', 'HJ-3824', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '71e984c6-1d11-4cf2-baee-6c8df494bdad', clock_timestamp()),
(367, 'Thin-Jam Hex Nut 3', 'HJ-5161', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'efc09cdb-ecd5-4db5-9e27-277dda6d7f50', clock_timestamp()),
(368, 'Thin-Jam Hex Nut 4', 'HJ-5162', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '0a0c93aa-d06c-48aa-99eb-20f2c8a6d6c4', clock_timestamp()),
(369, 'Thin-Jam Hex Nut 13', 'HJ-5811', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'a2728648-9517-4dec-8606-d7d98ecd1e91', clock_timestamp()),
(370, 'Thin-Jam Hex Nut 14', 'HJ-5818', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '0a7ad37c-3696-4844-8633-9fddcd5fcefc', clock_timestamp()),
(371, 'Thin-Jam Hex Nut 7', 'HJ-7161', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'acbb1de1-680c-4034-a8c5-3c6b01e57aa7', clock_timestamp()),
(372, 'Thin-Jam Hex Nut 8', 'HJ-7162', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'a0da8f8f-45fb-4e62-ab14-aa229087de1e', clock_timestamp()),
(373, 'Thin-Jam Hex Nut 12', 'HJ-9080', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'db99cbcd-f18d-4979-8dcf-1012f3b1cb15', clock_timestamp()),
(374, 'Thin-Jam Hex Nut 11', 'HJ-9161', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'ec2e54f5-9d07-4c26-b969-40f835395be3', clock_timestamp()),
(375, 'Hex Nut 5', 'HN-1024', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'f2f3a14c-df15-4957-966d-55e5fcad1161', clock_timestamp()),
(376, 'Hex Nut 6', 'HN-1032', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'e73e44dd-f0b7-45d4-9066-e49f1b1fe7d0', clock_timestamp()),
(377, 'Hex Nut 16', 'HN-1213', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '2b2a5641-bffe-4079-b9f0-8bf355bc3996', clock_timestamp()),
(378, 'Hex Nut 17', 'HN-1220', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'f70bbecd-5be7-4ee9-a9e7-15786e622ba9', clock_timestamp()),
(379, 'Hex Nut 7', 'HN-1224', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'ba3631d1-33d6-4a2f-8413-758bfda6f9c2', clock_timestamp()),
(380, 'Hex Nut 8', 'HN-1420', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'b478b33a-1fd5-4db6-b99a-eb3b2a7c1623', clock_timestamp()),
(381, 'Hex Nut 9', 'HN-1428', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'da46d979-59df-456d-b5ae-e7e89fc589df', clock_timestamp()),
(382, 'Hex Nut 22', 'HN-3410', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '2f457404-197d-4ddf-9868-a3aad1b32d6b', clock_timestamp()),
(383, 'Hex Nut 23', 'HN-3416', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '5f02449e-96e5-4fc8-ade0-8a9a7f533624', clock_timestamp()),
(384, 'Hex Nut 12', 'HN-3816', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '32c97696-7c3d-4793-a54b-3d73200badbc', clock_timestamp()),
(385, 'Hex Nut 13', 'HN-3824', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '8f0902d0-274d-4a4b-8fde-e37f53b2ab29', clock_timestamp()),
(386, 'Hex Nut 1', 'HN-4402', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '57456f8c-cb78-45ec-b9b8-21a9be5c12f5', clock_timestamp()),
(387, 'Hex Nut 10', 'HN-5161', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '955811b4-2f17-48f0-a8b4-0c96cba4aa6d', clock_timestamp()),
(388, 'Hex Nut 11', 'HN-5162', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '7d4bad17-374f-4281-9ae5-49abc3fe585d', clock_timestamp()),
(389, 'Hex Nut 2', 'HN-5400', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '17c4b7ba-8574-4ec7-bd3b-7a51aba61f69', clock_timestamp()),
(390, 'Hex Nut 20', 'HN-5811', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'b4e990b7-b3f7-4f97-8f98-ce373833adb4', clock_timestamp()),
(391, 'Hex Nut 21', 'HN-5818', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '433ee702-e028-4630-895c-8cdbd0f1fd89', clock_timestamp()),
(392, 'Hex Nut 3', 'HN-6320', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'ee76fae0-161e-409c-a6f5-837b5b8b344d', clock_timestamp()),
(393, 'Hex Nut 14', 'HN-7161', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'eb10b88c-5351-4c06-af51-116baa48a2c8', clock_timestamp()),
(394, 'Hex Nut 15', 'HN-7162', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '35e28755-e8f0-47be-a8be-a20836dbe28d', clock_timestamp()),
(395, 'Hex Nut 4', 'HN-8320', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '69ab8d5e-6101-4203-81b1-794e923782ea', clock_timestamp()),
(396, 'Hex Nut 18', 'HN-9161', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '39d42384-66f6-4ccd-b471-0589fc3fc576', clock_timestamp()),
(397, 'Hex Nut 19', 'HN-9168', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'b63f827e-9055-4678-9e90-4ffd8d06d4d4', clock_timestamp()),
(398, 'Handlebar Tube', 'HT-2981', '1', '0', NULL, 800, 600, 0, 0, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '9f88c58e-5cfa-46c9-8994-da4f3ffe92ed', clock_timestamp()),
(399, 'Head Tube', 'HT-8019', '1', '0', NULL, 800, 600, 0, 0, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'b047c048-b4fb-4f80-94bc-c5fc00a6f77f', clock_timestamp()),
(400, 'LL Hub', 'HU-6280', '1', '0', NULL, 500, 375, 0, 0, NULL, NULL, NULL, NULL, 1, NULL, 'L', NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'ab332dda-dda5-44ad-8c50-34ffaceffa8e', clock_timestamp()),
(401, 'HL Hub', 'HU-8998', '1', '0', NULL, 500, 375, 0, 0, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'd59403a3-d19e-4803-bda2-b436a6416fda', clock_timestamp()),
(402, 'Keyed Washer', 'KW-4091', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '43024784-2741-4cab-a6dc-8050ce507f2e', clock_timestamp()),
(403, 'External Lock Washer 3', 'LE-1000', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '763412f0-6d53-43e2-b371-dcbed69f5e98', clock_timestamp()),
(404, 'External Lock Washer 4', 'LE-1200', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '89b6e84f-5c08-4cd9-b803-01f2ce24e417', clock_timestamp()),
(405, 'External Lock Washer 9', 'LE-1201', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '3330a721-e8cb-4e67-8d27-300db68c2395', clock_timestamp()),
(406, 'External Lock Washer 5', 'LE-1400', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '39314098-768b-49f9-a777-af2e3bb06b17', clock_timestamp()),
(407, 'External Lock Washer 7', 'LE-3800', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '93f7bc73-bd22-45a0-9f2e-a11932342e6b', clock_timestamp()),
(408, 'External Lock Washer 6', 'LE-5160', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'dc5f4cb0-a599-42cd-a96f-e9f01bc1dacc', clock_timestamp()),
(409, 'External Lock Washer 1', 'LE-6000', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '802b7687-bc74-43f8-98ae-2112166faca7', clock_timestamp()),
(410, 'External Lock Washer 8', 'LE-7160', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '02c48826-21ad-41f3-85a6-bc9a85a4dce4', clock_timestamp()),
(411, 'External Lock Washer 2', 'LE-8000', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '502a2a3d-cd72-43ad-8fb6-77505187edf4', clock_timestamp()),
(412, 'Internal Lock Washer 3', 'LI-1000', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'f1168c45-e4d2-4c37-adad-b76eaf402b71', clock_timestamp()),
(413, 'Internal Lock Washer 4', 'LI-1200', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '7f7413bb-bad2-47e4-9bc4-d98b194be35d', clock_timestamp()),
(414, 'Internal Lock Washer 9', 'LI-1201', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '4f040109-8332-4fcf-8084-57e6d8c49283', clock_timestamp()),
(415, 'Internal Lock Washer 5', 'LI-1400', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '0c02f2cc-bdb4-4794-a4f9-0eb33f7545c2', clock_timestamp()),
(416, 'Internal Lock Washer 7', 'LI-3800', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '3c2ac5bc-3f49-4fa4-8340-bc4cda983f46', clock_timestamp()),
(417, 'Internal Lock Washer 6', 'LI-5160', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '7f175dfe-1669-4ee9-8eeb-7b55fce9961c', clock_timestamp()),
(418, 'Internal Lock Washer 10', 'LI-5800', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'c8323eec-bdb2-4933-b3c6-24287638ad56', clock_timestamp()),
(419, 'Internal Lock Washer 1', 'LI-6000', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '71f8232d-2b59-41ac-99a1-f5ea197671b5', clock_timestamp()),
(420, 'Internal Lock Washer 8', 'LI-7160', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'e2f03586-02e8-4cd9-a342-1a8d65d393bd', clock_timestamp()),
(421, 'Internal Lock Washer 2', 'LI-8000', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '97741a88-92a1-4e72-b0aa-bcb198a1c378', clock_timestamp()),
(422, 'Thin-Jam Lock Nut 9', 'LJ-1213', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '7da2613b-3347-4072-a1dc-943ada161d7f', clock_timestamp()),
(423, 'Thin-Jam Lock Nut 10', 'LJ-1220', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'a88f15be-2719-4741-93a4-2d96ef3712eb', clock_timestamp()),
(424, 'Thin-Jam Lock Nut 1', 'LJ-1420', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '48461e5d-d58a-47e5-8ba3-ce4430fca611', clock_timestamp()),
(425, 'Thin-Jam Lock Nut 2', 'LJ-1428', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '36187eb6-ad84-47b7-a55e-2941d3435fe2', clock_timestamp()),
(426, 'Thin-Jam Lock Nut 15', 'LJ-3410', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '99215648-afe8-4556-bc80-b6c62ae74fc8', clock_timestamp()),
(427, 'Thin-Jam Lock Nut 16', 'LJ-3416', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'b4fc4c32-049c-417f-bbb0-f19cdfd64252', clock_timestamp()),
(428, 'Thin-Jam Lock Nut 5', 'LJ-3816', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'a57b7915-2e65-49de-87ba-acd007c55adb', clock_timestamp()),
(429, 'Thin-Jam Lock Nut 6', 'LJ-3824', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '5abd940c-d61f-4108-8312-0ea97e469613', clock_timestamp()),
(430, 'Thin-Jam Lock Nut 3', 'LJ-5161', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '9883496f-4785-4bfc-8af3-c357347b9f89', clock_timestamp()),
(431, 'Thin-Jam Lock Nut 4', 'LJ-5162', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '8c5ee683-d93c-4f25-9454-22faa4c31365', clock_timestamp()),
(432, 'Thin-Jam Lock Nut 13', 'LJ-5811', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '38e4a447-3d3c-4087-abad-97f006525b52', clock_timestamp()),
(433, 'Thin-Jam Lock Nut 14', 'LJ-5818', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'dce24b6c-76d8-4934-a4f6-c934364943ea', clock_timestamp()),
(434, 'Thin-Jam Lock Nut 7', 'LJ-7161', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '344ad07c-cca5-4374-a3f3-8a7e0a1d9916', clock_timestamp()),
(435, 'Thin-Jam Lock Nut 8', 'LJ-7162', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'b2508cf2-c64f-493d-9db4-0d6601af1f73', clock_timestamp()),
(436, 'Thin-Jam Lock Nut 12', 'LJ-9080', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '5d3e589f-4584-406b-b9cc-3c8c060cb9a5', clock_timestamp()),
(437, 'Thin-Jam Lock Nut 11', 'LJ-9161', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '64169a28-161c-4737-b724-f42ffd99de80', clock_timestamp()),
(438, 'Lock Nut 5', 'LN-1024', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'eb4c1d34-4816-4130-bb30-07b4de4072b6', clock_timestamp()),
(439, 'Lock Nut 6', 'LN-1032', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '98ccbb38-4683-486e-bbfe-cbbe4ea63c03', clock_timestamp()),
(440, 'Lock Nut 16', 'LN-1213', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'bbfd88f8-28c5-44ee-b625-52e882393dfc', clock_timestamp()),
(441, 'Lock Nut 17', 'LN-1220', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '92dc4ba8-a052-45df-83ec-226f050f876b', clock_timestamp()),
(442, 'Lock Nut 7', 'LN-1224', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'd583d825-c707-4529-b6f2-abffa21b81ec', clock_timestamp()),
(443, 'Lock Nut 8', 'LN-1420', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'e91c3dc2-c99b-4d01-8108-5dde3c87830a', clock_timestamp()),
(444, 'Lock Nut 9', 'LN-1428', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '06534a20-4c00-4824-8bba-b4e3a5724d93', clock_timestamp()),
(445, 'Lock Nut 22', 'LN-3410', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '1e4fa4ec-367e-4d8d-88b4-6cd34d1cfb89', clock_timestamp()),
(446, 'Lock Nut 23', 'LN-3416', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'afa814c8-8ec8-49db-9fee-a291197a8fe9', clock_timestamp()),
(447, 'Lock Nut 12', 'LN-3816', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '9a751f85-7130-4562-9f22-db9cab6e5bbc', clock_timestamp()),
(448, 'Lock Nut 13', 'LN-3824', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '06be8347-45c1-4c40-afcb-6ab34ad135fb', clock_timestamp()),
(449, 'Lock Nut 1', 'LN-4400', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '1dc29704-e0e0-4ef5-b581-4a524730c448', clock_timestamp()),
(450, 'Lock Nut 10', 'LN-5161', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '612c26c7-6018-4050-b628-8b2d2e6841fa', clock_timestamp()),
(451, 'Lock Nut 11', 'LN-5162', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '5bcc4558-6c16-48f1-92f0-fd2eefb17306', clock_timestamp()),
(452, 'Lock Nut 2', 'LN-5400', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '53ad147d-c16d-4a8c-b086-625a31405574', clock_timestamp()),
(453, 'Lock Nut 20', 'LN-5811', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '2749030e-49b7-4b24-8d47-fbcf194aba38', clock_timestamp()),
(454, 'Lock Nut 21', 'LN-5818', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'e10a7b34-87f5-42cd-88b3-27a3d8e16b18', clock_timestamp()),
(455, 'Lock Nut 3', 'LN-6320', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'aa5071eb-2145-4d08-9d33-b9d2ba9e1493', clock_timestamp()),
(456, 'Lock Nut 14', 'LN-7161', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '1e96b03d-dc07-4a98-bc24-bf5b24c393e5', clock_timestamp()),
(457, 'Lock Nut 15', 'LN-7162', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'ce04de2b-4eca-4203-a108-b7d92ff0e96e', clock_timestamp()),
(458, 'Lock Nut 4', 'LN-8320', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '41bd9389-8b22-4a35-9a2c-233d39ada7ea', clock_timestamp()),
(459, 'Lock Nut 19', 'LN-9080', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '5986504b-22a0-4e74-a137-c7cf99a8216f', clock_timestamp()),
(460, 'Lock Nut 18', 'LN-9161', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'a420963f-92fd-4cd4-8531-6926e4162c41', clock_timestamp()),
(461, 'Lock Ring', 'LR-2398', '0', '0', 'Silver', 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'aeca59da-b61c-4976-8316-97e14cd4eff1', clock_timestamp()),
(462, 'Lower Head Race', 'LR-8520', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'dbb962bf-0603-4095-959b-5ba9c74fbd32', clock_timestamp()),
(463, 'Lock Washer 4', 'LW-1000', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'a3ee3bc5-73c5-45f3-a952-9991d038dd9c', clock_timestamp()),
(464, 'Lock Washer 5', 'LW-1200', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'ecaed08d-2cf5-4d81-a4ed-8369e25af227', clock_timestamp()),
(465, 'Lock Washer 10', 'LW-1201', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'a2212bab-af58-41a5-a659-a6141c8967ca', clock_timestamp()),
(466, 'Lock Washer 6', 'LW-1400', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '9092f2e1-3637-4669-8565-55404a55750e', clock_timestamp()),
(467, 'Lock Washer 13', 'LW-3400', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '3cb31f4a-c61c-408c-be1e-48bee412e511', clock_timestamp()),
(468, 'Lock Washer 8', 'LW-3800', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '900d26e6-21a0-427d-b43c-173f6dcb2045', clock_timestamp()),
(469, 'Lock Washer 1', 'LW-4000', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '5402ea37-29df-47ff-9fc7-867d60594c48', clock_timestamp()),
(470, 'Lock Washer 7', 'LW-5160', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '99357255-e66b-458c-ab2e-6f68ef5452d2', clock_timestamp()),
(471, 'Lock Washer 12', 'LW-5800', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '7bc9d58e-3e62-481f-8343-beb0883b3ecf', clock_timestamp()),
(472, 'Lock Washer 2', 'LW-6000', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '5f201424-9e6a-4f8d-9c2c-30777e27d64f', clock_timestamp()),
(473, 'Lock Washer 9', 'LW-7160', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'f9426fb2-1e68-464e-bf32-615026e0249e', clock_timestamp()),
(474, 'Lock Washer 3', 'LW-8000', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'ac007b7f-73b7-4623-8150-02444c5ec023', clock_timestamp()),
(475, 'Lock Washer 11', 'LW-9160', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '639d8448-b427-47b1-9e5b-0e5090a27632', clock_timestamp()),
(476, 'Metal Angle', 'MA-7075', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'e876e239-7ec2-45c8-ba4b-b9ceacb379a6', clock_timestamp()),
(477, 'Metal Bar 1', 'MB-2024', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '8b5429ce-7876-44b3-9332-baf78a238b36', clock_timestamp()),
(478, 'Metal Bar 2', 'MB-6061', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '2a14f60e-3827-49ba-af13-466dbc30c5ba', clock_timestamp()),
(479, 'Metal Plate 2', 'MP-2066', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '0773a2c9-f47f-429e-814a-25b2e08c128a', clock_timestamp()),
(480, 'Metal Plate 1', 'MP-2503', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '242389be-dde0-42a1-85d9-f99fdc981336', clock_timestamp()),
(481, 'Metal Plate 3', 'MP-4960', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '8b7e90e5-7785-455e-bc7c-e962f18c6848', clock_timestamp()),
(482, 'Metal Sheet 2', 'MS-0253', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '8bb96dfb-23aa-4877-9c5e-866bb18facc7', clock_timestamp()),
(483, 'Metal Sheet 3', 'MS-1256', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '9074e00d-005b-450e-9c92-6667782e8108', clock_timestamp()),
(484, 'Metal Sheet 7', 'MS-1981', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'a9539885-0cee-4aa0-9072-8db1d34a16db', clock_timestamp()),
(485, 'Metal Sheet 4', 'MS-2259', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '3cb3cf7d-ab8e-44a3-b7e9-73149f5ec29f', clock_timestamp()),
(486, 'Metal Sheet 5', 'MS-2341', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '2a2c555d-328d-4299-bd83-591d0762df62', clock_timestamp()),
(487, 'Metal Sheet 6', 'MS-2348', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '64844011-a1c3-4f8f-9caa-9c8d214ecc12', clock_timestamp()),
(488, 'Metal Sheet 1', 'MS-6061', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '3b2febc6-c76c-4a56-9cf7-8af5b76e24ee', clock_timestamp()),
(489, 'Metal Tread Plate', 'MT-1000', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'd2177b6c-3352-43f0-9a41-719754dd280c', clock_timestamp()),
(490, 'LL Nipple', 'NI-4127', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 'L', NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '88310f73-ab0a-41a2-8597-936f192b7d12', clock_timestamp()),
(491, 'HL Nipple', 'NI-9522', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '88a7b897-6ff5-4ca2-b68a-6ea0e86f92b9', clock_timestamp()),
(492, 'Paint - Black', 'PA-187B', '0', '0', NULL, 60, 45, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'df20e514-3d47-491b-9454-0911ec3f7d29', clock_timestamp()),
(493, 'Paint - Red', 'PA-361R', '0', '0', NULL, 60, 45, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '4c568357-5d21-4ad4-bb85-bb5519b3b50c', clock_timestamp()),
(494, 'Paint - Silver', 'PA-529S', '0', '0', NULL, 60, 45, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'fa81e47d-7333-49c2-809b-308171ca2fb1', clock_timestamp()),
(495, 'Paint - Blue', 'PA-632U', '0', '0', NULL, 60, 45, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '25a73761-ae90-49d3-8d1d-dd7858db4704', clock_timestamp()),
(496, 'Paint - Yellow', 'PA-823Y', '0', '0', NULL, 60, 45, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '1c8adb43-9fe8-44a6-b949-8af33ce9486e', clock_timestamp()),
(497, 'Pinch Bolt', 'PB-6109', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'f1694c24-dfab-4c92-bc66-6e717db24ea8', clock_timestamp()),
(504, 'Cup-Shaped Race', 'RA-2345', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '874c800e-334d-4a3c-8d3a-1e872d5b2a1b', clock_timestamp()),
(505, 'Cone-Shaped Race', 'RA-7490', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '35ce3995-9dd2-40e2-98b8-275931ac2d76', clock_timestamp()),
(506, 'Reflector', 'RF-9198', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '1c850499-38ed-4c2d-8665-7edb6a7ce93d', clock_timestamp()),
(507, 'LL Mountain Rim', 'RM-M464', '0', '0', NULL, 800, 600, 0, 0, NULL, NULL, 'G', 435.00, 0, NULL, 'L', NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'b2cc7dfb-783d-4587-88c0-2712a538a5b2', clock_timestamp()),
(508, 'ML Mountain Rim', 'RM-M692', '0', '0', NULL, 800, 600, 0, 0, NULL, NULL, 'G', 450.00, 0, NULL, 'M', NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '733fd04d-322f-44f5-beec-f326189d1ce6', clock_timestamp()),
(509, 'HL Mountain Rim', 'RM-M823', '0', '0', NULL, 800, 600, 0, 0, NULL, NULL, 'G', 400.00, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '9fa4a3b5-d396-48d4-adfc-b573bc4a800a', clock_timestamp()),
(510, 'LL Road Rim', 'RM-R436', '0', '0', NULL, 800, 600, 0, 0, NULL, NULL, 'G', 445.00, 0, NULL, 'L', NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'c2770757-b258-4eec-a811-6856faf87437', clock_timestamp()),
(511, 'ML Road Rim', 'RM-R600', '0', '0', NULL, 800, 600, 0, 0, NULL, NULL, 'G', 450.00, 0, NULL, 'M', NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '80108059-0002-4253-a805-53a2324c33a4', clock_timestamp()),
(512, 'HL Road Rim', 'RM-R800', '0', '0', NULL, 800, 600, 0, 0, NULL, NULL, 'G', 400.00, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'cd9b5c44-fb31-4e0f-9905-3b2086966cc5', clock_timestamp()),
(513, 'Touring Rim', 'RM-T801', '0', '0', NULL, 800, 600, 0, 0, NULL, NULL, 'G', 460.00, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '4852db13-308a-4893-aafa-390a0dfe9f12', clock_timestamp()),
(514, 'LL Mountain Seat Assembly', 'SA-M198', '1', '0', NULL, 500, 375, 98.77, 133.34, NULL, NULL, NULL, NULL, 1, NULL, 'L', NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'fcfc0a4f-4563-4e0b-bff4-5ddcfe3a9273', clock_timestamp()),
(515, 'ML Mountain Seat Assembly', 'SA-M237', '1', '0', NULL, 500, 375, 108.99, 147.14, NULL, NULL, NULL, NULL, 1, NULL, 'M', NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'd3c8ae4c-a1be-448d-bf58-6ecbf36afa0b', clock_timestamp()),
(516, 'HL Mountain Seat Assembly', 'SA-M687', '1', '0', NULL, 500, 375, 145.87, 196.92, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '9e18adab-b9c7-45b1-bd95-1805ec4f297d', clock_timestamp()),
(517, 'LL Road Seat Assembly', 'SA-R127', '1', '0', NULL, 500, 375, 98.77, 133.34, NULL, NULL, NULL, NULL, 1, NULL, 'L', NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'f5a30b8d-f35b-43f2-83a0-f7f6b51f6241', clock_timestamp()),
(518, 'ML Road Seat Assembly', 'SA-R430', '1', '0', NULL, 500, 375, 108.99, 147.14, NULL, NULL, NULL, NULL, 1, NULL, 'M', NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'ad109395-fda9-4c2a-96f1-515ccde3d9f4', clock_timestamp()),
(519, 'HL Road Seat Assembly', 'SA-R522', '1', '0', NULL, 500, 375, 145.87, 196.92, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '7b52ee2a-7100-4a39-a0af-c89012da6ef8', clock_timestamp()),
(520, 'LL Touring Seat Assembly', 'SA-T467', '1', '0', NULL, 500, 375, 98.77, 133.34, NULL, NULL, NULL, NULL, 1, NULL, 'L', NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'af3d83ba-4b8e-4072-817f-e6b095a1c879', clock_timestamp()),
(521, 'ML Touring Seat Assembly', 'SA-T612', '1', '0', NULL, 500, 375, 108.99, 147.14, NULL, NULL, NULL, NULL, 1, NULL, 'M', NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '85b9a3de-000c-4351-9494-05796689c216', clock_timestamp()),
(522, 'HL Touring Seat Assembly', 'SA-T872', '1', '0', NULL, 500, 375, 145.87, 196.92, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '8c471bca-a735-4087-ad50-90ede0ac1a1b', clock_timestamp()),
(523, 'LL Spindle/Axle', 'SD-2342', '0', '0', NULL, 500, 375, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 'L', NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'd2bd1f55-2cd4-4998-89fa-28ff2e28de2c', clock_timestamp()),
(524, 'HL Spindle/Axle', 'SD-9872', '0', '0', NULL, 500, 375, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '6ce0661d-ba1f-4012-b785-55165b3b241a', clock_timestamp()),
(525, 'LL Shell', 'SH-4562', '0', '0', NULL, 800, 600, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 'L', NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'ae7bcda7-e836-4f68-9e61-745f27f9aa3e', clock_timestamp()),
(526, 'HL Shell', 'SH-9312', '0', '0', NULL, 800, 600, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'd215a3ae-aaf2-4cb0-9d20-3758aad078e2', clock_timestamp()),
(527, 'Spokes', 'SK-9283', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '5aabb729-343b-4084-a235-ccb3da9f29e7', clock_timestamp()),
(528, 'Seat Lug', 'SL-0931', '0', '0', NULL, 1000, 750, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '4a898b1e-9a3b-4beb-9873-a7465934051a', clock_timestamp()),
(529, 'Stem', 'SM-9087', '1', '0', NULL, 500, 375, 0, 0, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '1173306e-b616-4c4a-b715-4e0a483ba2b5', clock_timestamp()),
(530, 'Seat Post', 'SP-2981', '0', '0', NULL, 500, 375, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '9b4ceb84-4e84-43f3-b326-9b7f22905363', clock_timestamp()),
(531, 'Steerer', 'SR-2098', '1', '0', NULL, 500, 375, 0, 0, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'f3b140a1-b139-4bb5-b144-1b7cbbee6c9a', clock_timestamp()),
(532, 'Seat Stays', 'SS-2985', '1', '0', NULL, 800, 600, 0, 0, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '20c2c611-dffc-49b5-99cf-d89bdd3a91ce', clock_timestamp()),
(533, 'Seat Tube', 'ST-9828', '1', '0', NULL, 500, 375, 0, 0, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '41f5388b-7253-4002-bcc6-b2a50920d11f', clock_timestamp()),
(534, 'Top Tube', 'TO-2301', '1', '0', NULL, 500, 375, 0, 0, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '4c0bad8e-066b-46b8-bfe9-da61539606e8', clock_timestamp()),
(535, 'Tension Pulley', 'TP-0923', '0', '0', NULL, 800, 600, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '13df62b2-8a7b-47d5-9084-f1172c4779e4', clock_timestamp()),
(679, 'Rear Derailleur Cage', 'RC-0291', '0', '0', 'Silver', 500, 375, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '912b03ea-4447-48c8-85da-09b80ab26340', clock_timestamp()),
(680, 'HL Road Frame - Black, 58', 'FR-R92B-58', '1', '1', 'Black', 500, 375, 1059.31, 1431.5, '58', 'CM', 'LB', 2.24, 1, 'R', 'H', 'U', 14, 6, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '43dd68d6-14a4-461f-9069-55309d90ea7e', clock_timestamp()),
(706, 'HL Road Frame - Red, 58', 'FR-R92R-58', '1', '1', 'Red', 500, 375, 1059.31, 1431.5, '58', 'CM', 'LB', 2.24, 1, 'R', 'H', 'U', 14, 6, CAST('2008-04-30 00:00:00' AS TIMESTAMP), NULL, NULL, '9540ff17-2712-4c90-a3d1-8ce5568b2462', clock_timestamp()),
(707, 'Sport-100 Helmet, Red', 'HL-U509-R', '0', '1', 'Red', 4, 3, 13.0863, 34.99, NULL, NULL, NULL, NULL, 0, 'S', NULL, NULL, 31, 33, CAST('2011-05-31 00:00:00' AS TIMESTAMP), NULL, NULL, '2e1ef41a-c08a-4ff6-8ada-bde58b64a712', clock_timestamp()),
(708, 'Sport-100 Helmet, Black', 'HL-U509', '0', '1', 'Black', 4, 3, 13.0863, 34.99, NULL, NULL, NULL, NULL, 0, 'S', NULL, NULL, 31, 33, CAST('2011-05-31 00:00:00' AS TIMESTAMP), NULL, NULL, 'a25a44fb-c2de-4268-958f-110b8d7621e2', clock_timestamp()),
(709, 'Mountain Bike Socks, M', 'SO-B909-M', '0', '1', 'White', 4, 3, 3.3963, 9.5, 'M', NULL, NULL, NULL, 0, 'M', NULL, 'U', 23, 18, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, '18f95f47-1540-4e02-8f1f-cc1bcb6828d0', clock_timestamp()),
(710, 'Mountain Bike Socks, L', 'SO-B909-L', '0', '1', 'White', 4, 3, 3.3963, 9.5, 'L', NULL, NULL, NULL, 0, 'M', NULL, 'U', 23, 18, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, '161c035e-21b3-4e14-8e44-af508f35d80a', clock_timestamp()),
(711, 'Sport-100 Helmet, Blue', 'HL-U509-B', '0', '1', 'Blue', 4, 3, 13.0863, 34.99, NULL, NULL, NULL, NULL, 0, 'S', NULL, NULL, 31, 33, CAST('2011-05-31 00:00:00' AS TIMESTAMP), NULL, NULL, 'fd7c0858-4179-48c2-865b-abd5dfc7bc1d', clock_timestamp()),
(712, 'AWC Logo Cap', 'CA-1098', '0', '1', 'Multi', 4, 3, 6.9223, 8.99, NULL, NULL, NULL, NULL, 0, 'S', NULL, 'U', 19, 2, CAST('2011-05-31 00:00:00' AS TIMESTAMP), NULL, NULL, 'b9ede243-a6f4-4629-b1d4-ffe1aedc6de7', clock_timestamp()),
(713, 'Long-Sleeve Logo Jersey, S', 'LJ-0192-S', '0', '1', 'Multi', 4, 3, 38.4923, 49.99, 'S', NULL, NULL, NULL, 0, 'S', NULL, 'U', 21, 11, CAST('2011-05-31 00:00:00' AS TIMESTAMP), NULL, NULL, 'fd449c82-a259-4fae-8584-6ca0255faf68', clock_timestamp()),
(714, 'Long-Sleeve Logo Jersey, M', 'LJ-0192-M', '0', '1', 'Multi', 4, 3, 38.4923, 49.99, 'M', NULL, NULL, NULL, 0, 'S', NULL, 'U', 21, 11, CAST('2011-05-31 00:00:00' AS TIMESTAMP), NULL, NULL, '6a290063-a0cf-432a-8110-2ea0fda14308', clock_timestamp()),
(715, 'Long-Sleeve Logo Jersey, L', 'LJ-0192-L', '0', '1', 'Multi', 4, 3, 38.4923, 49.99, 'L', NULL, NULL, NULL, 0, 'S', NULL, 'U', 21, 11, CAST('2011-05-31 00:00:00' AS TIMESTAMP), NULL, NULL, '34cf5ef5-c077-4ea0-914a-084814d5cbd5', clock_timestamp()),
(716, 'Long-Sleeve Logo Jersey, XL', 'LJ-0192-X', '0', '1', 'Multi', 4, 3, 38.4923, 49.99, 'XL', NULL, NULL, NULL, 0, 'S', NULL, 'U', 21, 11, CAST('2011-05-31 00:00:00' AS TIMESTAMP), NULL, NULL, '6ec47ec9-c041-4dda-b686-2125d539ce9b', clock_timestamp()),
(717, 'HL Road Frame - Red, 62', 'FR-R92R-62', '1', '1', 'Red', 500, 375, 868.6342, 1431.5, '62', 'CM', 'LB', 2.30, 1, 'R', 'H', 'U', 14, 6, CAST('2011-05-31 00:00:00' AS TIMESTAMP), NULL, NULL, '052e4f8b-0a2a-46b2-9f42-10febcfae416', clock_timestamp()),
(718, 'HL Road Frame - Red, 44', 'FR-R92R-44', '1', '1', 'Red', 500, 375, 868.6342, 1431.5, '44', 'CM', 'LB', 2.12, 1, 'R', 'H', 'U', 14, 6, CAST('2011-05-31 00:00:00' AS TIMESTAMP), NULL, NULL, 'a88d3b54-2cae-43f2-8c6e-ea1d97b46a7c', clock_timestamp()),
(719, 'HL Road Frame - Red, 48', 'FR-R92R-48', '1', '1', 'Red', 500, 375, 868.6342, 1431.5, '48', 'CM', 'LB', 2.16, 1, 'R', 'H', 'U', 14, 6, CAST('2011-05-31 00:00:00' AS TIMESTAMP), NULL, NULL, '07befc9a-7634-402b-b234-d7797733baaf', clock_timestamp()),
(720, 'HL Road Frame - Red, 52', 'FR-R92R-52', '1', '1', 'Red', 500, 375, 868.6342, 1431.5, '52', 'CM', 'LB', 2.20, 1, 'R', 'H', 'U', 14, 6, CAST('2011-05-31 00:00:00' AS TIMESTAMP), NULL, NULL, 'fcfea68f-310e-4e6e-9f99-bb17d011ebae', clock_timestamp()),
(721, 'HL Road Frame - Red, 56', 'FR-R92R-56', '1', '1', 'Red', 500, 375, 868.6342, 1431.5, '56', 'CM', 'LB', 2.24, 1, 'R', 'H', 'U', 14, 6, CAST('2011-05-31 00:00:00' AS TIMESTAMP), NULL, NULL, '56c85873-4993-41b4-8096-1067cfd7e4bd', clock_timestamp()),
(722, 'LL Road Frame - Black, 58', 'FR-R38B-58', '1', '1', 'Black', 500, 375, 204.6251, 337.22, '58', 'CM', 'LB', 2.46, 1, 'R', 'L', 'U', 14, 9, CAST('2011-05-31 00:00:00' AS TIMESTAMP), NULL, NULL, '2140f256-f705-4d67-975d-32de03265838', clock_timestamp()),
(723, 'LL Road Frame - Black, 60', 'FR-R38B-60', '1', '1', 'Black', 500, 375, 204.6251, 337.22, '60', 'CM', 'LB', 2.48, 1, 'R', 'L', 'U', 14, 9, CAST('2011-05-31 00:00:00' AS TIMESTAMP), NULL, NULL, 'aa95e2a5-e7c4-4b74-b1ea-b52ee3b51537', clock_timestamp()),
(724, 'LL Road Frame - Black, 62', 'FR-R38B-62', '1', '1', 'Black', 500, 375, 204.6251, 337.22, '62', 'CM', 'LB', 2.50, 1, 'R', 'L', 'U', 14, 9, CAST('2011-05-31 00:00:00' AS TIMESTAMP), NULL, NULL, '5247be33-50bf-4527-8a30-a39aae500a8e', clock_timestamp()),
(725, 'LL Road Frame - Red, 44', 'FR-R38R-44', '1', '1', 'Red', 500, 375, 187.1571, 337.22, '44', 'CM', 'LB', 2.32, 1, 'R', 'L', 'U', 14, 9, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '137d319d-44ad-42b2-ab61-60b9ce52b5f2', clock_timestamp()),
(726, 'LL Road Frame - Red, 48', 'FR-R38R-48', '1', '1', 'Red', 500, 375, 187.1571, 337.22, '48', 'CM', 'LB', 2.36, 1, 'R', 'L', 'U', 14, 9, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '35213547-275f-4767-805d-c8a4b8e13745', clock_timestamp()),
(727, 'LL Road Frame - Red, 52', 'FR-R38R-52', '1', '1', 'Red', 500, 375, 187.1571, 337.22, '52', 'CM', 'LB', 2.40, 1, 'R', 'L', 'U', 14, 9, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, 'c455e0b3-d716-419d-abf0-7e03efdd2e26', clock_timestamp()),
(728, 'LL Road Frame - Red, 58', 'FR-R38R-58', '1', '1', 'Red', 500, 375, 187.1571, 337.22, '58', 'CM', 'LB', 2.46, 1, 'R', 'L', 'U', 14, 9, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '799a56ff-5ad2-41b3-bfac-528b477ad129', clock_timestamp()),
(729, 'LL Road Frame - Red, 60', 'FR-R38R-60', '1', '1', 'Red', 500, 375, 187.1571, 337.22, '60', 'CM', 'LB', 2.48, 1, 'R', 'L', 'U', 14, 9, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '1784bb14-d1f5-4b24-92da-9127ad179302', clock_timestamp()),
(730, 'LL Road Frame - Red, 62', 'FR-R38R-62', '1', '1', 'Red', 500, 375, 187.1571, 337.22, '62', 'CM', 'LB', 2.50, 1, 'R', 'L', 'U', 14, 9, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '7e73aa1f-8569-4d87-9f80-ac2e513e0803', clock_timestamp()),
(731, 'ML Road Frame - Red, 44', 'FR-R72R-44', '1', '1', 'Red', 500, 375, 352.1394, 594.83, '44', 'CM', 'LB', 2.22, 1, 'R', 'M', 'U', 14, 16, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, '459e041c-3234-409e-b4cd-81728f8a2398', clock_timestamp()),
(732, 'ML Road Frame - Red, 48', 'FR-R72R-48', '1', '1', 'Red', 500, 375, 352.1394, 594.83, '48', 'CM', 'LB', 2.26, 1, 'R', 'M', 'U', 14, 16, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, 'b673189c-c042-413b-8194-73bc44b0492c', clock_timestamp()),
(733, 'ML Road Frame - Red, 52', 'FR-R72R-52', '1', '1', 'Red', 500, 375, 352.1394, 594.83, '52', 'CM', 'LB', 2.30, 1, 'R', 'M', 'U', 14, 16, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, '55ea276b-82d8-4ccb-9ab1-9b1b75b15a83', clock_timestamp()),
(734, 'ML Road Frame - Red, 58', 'FR-R72R-58', '1', '1', 'Red', 500, 375, 352.1394, 594.83, '58', 'CM', 'LB', 2.36, 1, 'R', 'M', 'U', 14, 16, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, 'df4ce1e2-ba9a-4657-b999-ccfa6c55d9c1', clock_timestamp()),
(735, 'ML Road Frame - Red, 60', 'FR-R72R-60', '1', '1', 'Red', 500, 375, 352.1394, 594.83, '60', 'CM', 'LB', 2.38, 1, 'R', 'M', 'U', 14, 16, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, 'b2e48e8c-63a5-469a-ba4c-4f5ebb1104a4', clock_timestamp()),
(736, 'LL Road Frame - Black, 44', 'FR-R38B-44', '1', '1', 'Black', 500, 375, 204.6251, 337.22, '44', 'CM', 'LB', 2.32, 1, 'R', 'L', 'U', 14, 9, CAST('2011-05-31 00:00:00' AS TIMESTAMP), NULL, NULL, 'c9967889-f490-4a66-943a-bce432e938d8', clock_timestamp()),
(737, 'LL Road Frame - Black, 48', 'FR-R38B-48', '1', '1', 'Black', 500, 375, 204.6251, 337.22, '48', 'CM', 'LB', 2.36, 1, 'R', 'L', 'U', 14, 9, CAST('2011-05-31 00:00:00' AS TIMESTAMP), NULL, NULL, '3b5f29b6-a441-4ff7-a0fa-fad10e2ceb4c', clock_timestamp()),
(738, 'LL Road Frame - Black, 52', 'FR-R38B-52', '1', '1', 'Black', 500, 375, 204.6251, 337.22, '52', 'CM', 'LB', 2.40, 1, 'R', 'L', 'U', 14, 9, CAST('2011-05-31 00:00:00' AS TIMESTAMP), NULL, NULL, '18fc5d72-a012-4dc7-bb35-0d01a84d0219', clock_timestamp()),
(739, 'HL Mountain Frame - Silver, 42', 'FR-M94S-42', '1', '1', 'Silver', 500, 375, 747.2002, 1364.5, '42', 'CM', 'LB', 2.72, 1, 'M', 'H', 'U', 12, 5, CAST('2011-05-31 00:00:00' AS TIMESTAMP), NULL, NULL, '8ae32663-8d6f-457d-8343-5b181fec43a7', clock_timestamp()),
(740, 'HL Mountain Frame - Silver, 44', 'FR-M94S-44', '1', '1', 'Silver', 500, 375, 706.811, 1364.5, '44', 'CM', 'LB', 2.76, 1, 'M', 'H', 'U', 12, 5, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, '1909c60c-c490-411d-b3e6-12ddd7832482', clock_timestamp()),
(741, 'HL Mountain Frame - Silver, 48', 'FR-M94S-52', '1', '1', 'Silver', 500, 375, 706.811, 1364.5, '48', 'CM', 'LB', 2.80, 1, 'M', 'H', 'U', 12, 5, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, 'b181ec1f-ca20-4724-b2eb-15f3e455142e', clock_timestamp()),
(742, 'HL Mountain Frame - Silver, 46', 'FR-M94S-46', '1', '1', 'Silver', 500, 375, 747.2002, 1364.5, '46', 'CM', 'LB', 2.84, 1, 'M', 'H', 'U', 12, 5, CAST('2011-05-31 00:00:00' AS TIMESTAMP), NULL, NULL, 'a189d86e-d923-4336-b13d-a5db6f426540', clock_timestamp()),
(743, 'HL Mountain Frame - Black, 42', 'FR-M94B-42', '1', '1', 'Black', 500, 375, 739.041, 1349.6, '42', 'CM', 'LB', 2.72, 1, 'M', 'H', 'U', 12, 5, CAST('2011-05-31 00:00:00' AS TIMESTAMP), NULL, NULL, '27db28f8-5ab8-4091-b94e-6f1b2d8e7ab0', clock_timestamp()),
(744, 'HL Mountain Frame - Black, 44', 'FR-M94B-44', '1', '1', 'Black', 500, 375, 699.0928, 1349.6, '44', 'CM', 'LB', 2.76, 1, 'M', 'H', 'U', 12, 5, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, 'cb443286-6b25-409f-a10b-1ad4eeb4bd4e', clock_timestamp()),
(745, 'HL Mountain Frame - Black, 48', 'FR-M94B-48', '1', '1', 'Black', 500, 375, 699.0928, 1349.6, '48', 'CM', 'LB', 2.80, 1, 'M', 'H', 'U', 12, 5, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, '1fee0573-6676-432d-8d6d-41ba9faa5865', clock_timestamp()),
(746, 'HL Mountain Frame - Black, 46', 'FR-M94B-46', '1', '1', 'Black', 500, 375, 739.041, 1349.6, '46', 'CM', 'LB', 2.84, 1, 'M', 'H', 'U', 12, 5, CAST('2011-05-31 00:00:00' AS TIMESTAMP), NULL, NULL, '50abebcb-451e-42b9-8dbb-e5c4a34470e9', clock_timestamp()),
(747, 'HL Mountain Frame - Black, 38', 'FR-M94B-38', '1', '1', 'Black', 500, 375, 739.041, 1349.6, '38', 'CM', 'LB', 2.68, 2, 'M', 'H', 'U', 12, 5, CAST('2011-05-31 00:00:00' AS TIMESTAMP), NULL, NULL, '0c548577-3171-4ce2-b9a0-1ed526849de8', clock_timestamp()),
(748, 'HL Mountain Frame - Silver, 38', 'FR-M94S-38', '1', '1', 'Silver', 500, 375, 747.2002, 1364.5, '38', 'CM', 'LB', 2.68, 2, 'M', 'H', 'U', 12, 5, CAST('2011-05-31 00:00:00' AS TIMESTAMP), NULL, NULL, 'f246acaa-a80b-40ec-9208-02edef885129', clock_timestamp()),
(749, 'Road-150 Red, 62', 'BK-R93R-62', '1', '1', 'Red', 100, 75, 2171.2942, 3578.27, '62', 'CM', 'LB', 15.00, 4, 'R', 'H', 'U', 2, 25, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, 'bc621e1f-2553-4fdc-b22e-5e44a9003569', clock_timestamp()),
(750, 'Road-150 Red, 44', 'BK-R93R-44', '1', '1', 'Red', 100, 75, 2171.2942, 3578.27, '44', 'CM', 'LB', 13.77, 4, 'R', 'H', 'U', 2, 25, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, 'c19e1136-5da4-4b40-8758-54a85d7ea494', clock_timestamp()),
(751, 'Road-150 Red, 48', 'BK-R93R-48', '1', '1', 'Red', 100, 75, 2171.2942, 3578.27, '48', 'CM', 'LB', 14.13, 4, 'R', 'H', 'U', 2, 25, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, 'd10b7cc1-455e-435b-a08f-ec5b1c5776e9', clock_timestamp()),
(752, 'Road-150 Red, 52', 'BK-R93R-52', '1', '1', 'Red', 100, 75, 2171.2942, 3578.27, '52', 'CM', 'LB', 14.42, 4, 'R', 'H', 'U', 2, 25, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, '5e085ba0-3cd5-487f-85bb-79ed1c701f23', clock_timestamp()),
(753, 'Road-150 Red, 56', 'BK-R93R-56', '1', '1', 'Red', 100, 75, 2171.2942, 3578.27, '56', 'CM', 'LB', 14.68, 4, 'R', 'H', 'U', 2, 25, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, '30819b88-f0d3-4e7a-8105-19f6fac2cefb', clock_timestamp()),
(754, 'Road-450 Red, 58', 'BK-R68R-58', '1', '1', 'Red', 100, 75, 884.7083, 1457.99, '58', 'CM', 'LB', 17.79, 4, 'R', 'M', 'U', 2, 28, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, '40d5effa-c0c4-479f-af66-5f1bf8ed3bfb', clock_timestamp()),
(755, 'Road-450 Red, 60', 'BK-R68R-60', '1', '1', 'Red', 100, 75, 884.7083, 1457.99, '60', 'CM', 'LB', 17.90, 4, 'R', 'M', 'U', 2, 28, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, '181a90cb-3678-490e-8418-78f73fb5343d', clock_timestamp()),
(756, 'Road-450 Red, 44', 'BK-R68R-44', '1', '1', 'Red', 100, 75, 884.7083, 1457.99, '44', 'CM', 'LB', 16.77, 4, 'R', 'M', 'U', 2, 28, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, 'f8b5e26a-3d33-4e39-b500-cc21a133062e', clock_timestamp()),
(757, 'Road-450 Red, 48', 'BK-R68R-48', '1', '1', 'Red', 100, 75, 884.7083, 1457.99, '48', 'CM', 'LB', 17.13, 4, 'R', 'M', 'U', 2, 28, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, 'c72c9978-0b04-46b3-9de6-948feca1c86e', clock_timestamp()),
(758, 'Road-450 Red, 52', 'BK-R68R-52', '1', '1', 'Red', 100, 75, 884.7083, 1457.99, '52', 'CM', 'LB', 17.42, 4, 'R', 'M', 'U', 2, 28, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, '040a4b7d-4060-4507-aa92-7508b434797e', clock_timestamp()),
(759, 'Road-650 Red, 58', 'BK-R50R-58', '1', '1', 'Red', 100, 75, 486.7066, 782.99, '58', 'CM', 'LB', 19.79, 4, 'R', 'L', 'U', 2, 30, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '6711d6bc-664f-4890-9f69-af1de321d055', clock_timestamp()),
(760, 'Road-650 Red, 60', 'BK-R50R-60', '1', '1', 'Red', 100, 75, 486.7066, 782.99, '60', 'CM', 'LB', 19.90, 4, 'R', 'L', 'U', 2, 30, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '664867e5-4ab3-4783-96f9-42efde92f49b', clock_timestamp()),
(761, 'Road-650 Red, 62', 'BK-R50R-62', '1', '1', 'Red', 100, 75, 486.7066, 782.99, '62', 'CM', 'LB', 20.00, 4, 'R', 'L', 'U', 2, 30, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '1da14e09-6d71-4e2a-9ee9-1bdfdfd8a109', clock_timestamp()),
(762, 'Road-650 Red, 44', 'BK-R50R-44', '1', '1', 'Red', 100, 75, 486.7066, 782.99, '44', 'CM', 'LB', 18.77, 4, 'R', 'L', 'U', 2, 30, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, 'f247aaae-12e3-4048-a37b-cce4a8999e81', clock_timestamp()),
(763, 'Road-650 Red, 48', 'BK-R50R-48', '1', '1', 'Red', 100, 75, 486.7066, 782.99, '48', 'CM', 'LB', 19.13, 4, 'R', 'L', 'U', 2, 30, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '3da5fa6e-9e0f-4896-ac10-948c27f4eb79', clock_timestamp()),
(764, 'Road-650 Red, 52', 'BK-R50R-52', '1', '1', 'Red', 100, 75, 486.7066, 782.99, '52', 'CM', 'LB', 19.42, 4, 'R', 'L', 'U', 2, 30, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '07cfe1ea-8a37-4d2a-835f-bc8d37e564af', clock_timestamp()),
(765, 'Road-650 Black, 58', 'BK-R50B-58', '1', '1', 'Black', 100, 75, 486.7066, 782.99, '58', 'CM', 'LB', 19.79, 4, 'R', 'L', 'U', 2, 30, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '74645b12-3ce9-49a6-bd96-2cd814b37420', clock_timestamp()),
(766, 'Road-650 Black, 60', 'BK-R50B-60', '1', '1', 'Black', 100, 75, 486.7066, 782.99, '60', 'CM', 'LB', 19.90, 4, 'R', 'L', 'U', 2, 30, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, 'a2db196d-6640-49ea-a84f-2e87ca6f50c6', clock_timestamp()),
(767, 'Road-650 Black, 62', 'BK-R50B-62', '1', '1', 'Black', 100, 75, 486.7066, 782.99, '62', 'CM', 'LB', 20.00, 4, 'R', 'L', 'U', 2, 30, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, 'c82a8309-63d3-4c0c-ad71-e91272397095', clock_timestamp()),
(768, 'Road-650 Black, 44', 'BK-R50B-44', '1', '1', 'Black', 100, 75, 486.7066, 782.99, '44', 'CM', 'LB', 18.77, 4, 'R', 'L', 'U', 2, 30, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '11d563ac-115c-4f0d-a1e5-e946eee8b38b', clock_timestamp()),
(769, 'Road-650 Black, 48', 'BK-R50B-48', '1', '1', 'Black', 100, 75, 486.7066, 782.99, '48', 'CM', 'LB', 19.13, 4, 'R', 'L', 'U', 2, 30, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, 'a7e2179e-137c-497e-a5e6-c9ea64935fb0', clock_timestamp()),
(770, 'Road-650 Black, 52', 'BK-R50B-52', '1', '1', 'Black', 100, 75, 486.7066, 782.99, '52', 'CM', 'LB', 19.42, 4, 'R', 'L', 'U', 2, 30, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '136e2865-e0da-4624-963a-31349279ab1a', clock_timestamp()),
(771, 'Mountain-100 Silver, 38', 'BK-M82S-38', '1', '1', 'Silver', 100, 75, 1912.1544, 3399.99, '38', 'CM', 'LB', 20.35, 4, 'M', 'H', 'U', 1, 19, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, 'ca74b54e-fc30-4464-8b83-019bfd1b2dbb', clock_timestamp()),
(772, 'Mountain-100 Silver, 42', 'BK-M82S-42', '1', '1', 'Silver', 100, 75, 1912.1544, 3399.99, '42', 'CM', 'LB', 20.77, 4, 'M', 'H', 'U', 1, 19, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, 'bbfff5a5-4bdc-49a9-a5ad-7584adffe808', clock_timestamp()),
(773, 'Mountain-100 Silver, 44', 'BK-M82S-44', '1', '1', 'Silver', 100, 75, 1912.1544, 3399.99, '44', 'CM', 'LB', 21.13, 4, 'M', 'H', 'U', 1, 19, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, '155fd77e-d6d6-43f0-8a5b-4a8305eb45cd', clock_timestamp()),
(774, 'Mountain-100 Silver, 48', 'BK-M82S-48', '1', '1', 'Silver', 100, 75, 1912.1544, 3399.99, '48', 'CM', 'LB', 21.42, 4, 'M', 'H', 'U', 1, 19, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, 'ba5551df-c9ee-4b43-b3ca-8c19d0f9384d', clock_timestamp()),
(775, 'Mountain-100 Black, 38', 'BK-M82B-38', '1', '1', 'Black', 100, 75, 1898.0944, 3374.99, '38', 'CM', 'LB', 20.35, 4, 'M', 'H', 'U', 1, 19, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, 'dea33347-fcd3-4346-aa0f-068cd6b3ad06', clock_timestamp()),
(776, 'Mountain-100 Black, 42', 'BK-M82B-42', '1', '1', 'Black', 100, 75, 1898.0944, 3374.99, '42', 'CM', 'LB', 20.77, 4, 'M', 'H', 'U', 1, 19, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, '02935111-a546-4c6d-941f-be12d42c158e', clock_timestamp()),
(777, 'Mountain-100 Black, 44', 'BK-M82B-44', '1', '1', 'Black', 100, 75, 1898.0944, 3374.99, '44', 'CM', 'LB', 21.13, 4, 'M', 'H', 'U', 1, 19, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, '7920bc3b-8fd4-4610-93d2-e693a66b6474', clock_timestamp()),
(778, 'Mountain-100 Black, 48', 'BK-M82B-48', '1', '1', 'Black', 100, 75, 1898.0944, 3374.99, '48', 'CM', 'LB', 21.42, 4, 'M', 'H', 'U', 1, 19, CAST('2011-05-31 00:00:00' AS TIMESTAMP), CAST('2012-05-29 00:00:00' AS TIMESTAMP), NULL, '1b486300-7e64-4c5d-a9ba-a8368e20c5a0', clock_timestamp()),
(779, 'Mountain-200 Silver, 38', 'BK-M68S-38', '1', '1', 'Silver', 100, 75, 1265.6195, 2319.99, '38', 'CM', 'LB', 23.35, 4, 'M', 'H', 'U', 1, 20, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '3a45d835-abae-4806-ac03-c53abcd3b974', clock_timestamp()),
(780, 'Mountain-200 Silver, 42', 'BK-M68S-42', '1', '1', 'Silver', 100, 75, 1265.6195, 2319.99, '42', 'CM', 'LB', 23.77, 4, 'M', 'H', 'U', 1, 20, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'ce4849b4-56e6-4b50-808b-9bde67cc4704', clock_timestamp()),
(781, 'Mountain-200 Silver, 46', 'BK-M68S-46', '1', '1', 'Silver', 100, 75, 1265.6195, 2319.99, '46', 'CM', 'LB', 24.13, 4, 'M', 'H', 'U', 1, 20, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '20799030-420c-496a-9922-09189c2b457e', clock_timestamp()),
(782, 'Mountain-200 Black, 38', 'BK-M68B-38', '1', '1', 'Black', 100, 75, 1251.9813, 2294.99, '38', 'CM', 'LB', 23.35, 4, 'M', 'H', 'U', 1, 20, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '82cb8f9b-b8bb-4841-98d3-bcdb807c4dd8', clock_timestamp()),
(783, 'Mountain-200 Black, 42', 'BK-M68B-42', '1', '1', 'Black', 100, 75, 1251.9813, 2294.99, '42', 'CM', 'LB', 23.77, 4, 'M', 'H', 'U', 1, 20, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '2b0af5b9-7571-4621-b760-47df599f9650', clock_timestamp()),
(784, 'Mountain-200 Black, 46', 'BK-M68B-46', '1', '1', 'Black', 100, 75, 1251.9813, 2294.99, '46', 'CM', 'LB', 24.13, 4, 'M', 'H', 'U', 1, 20, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '33f42284-e216-4b98-ba48-b4ee18a01fa0', clock_timestamp()),
(785, 'Mountain-300 Black, 38', 'BK-M47B-38', '1', '1', 'Black', 100, 75, 598.4354, 1079.99, '38', 'CM', 'LB', 25.35, 4, 'M', 'M', 'U', 1, 21, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, 'f06c2cbf-0901-4c08-80ed-fb4e87171b3b', clock_timestamp()),
(786, 'Mountain-300 Black, 40', 'BK-M47B-40', '1', '1', 'Black', 100, 75, 598.4354, 1079.99, '40', 'CM', 'LB', 25.77, 4, 'M', 'M', 'U', 1, 21, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '580d4322-be03-4c91-83d2-ee33ec6008ab', clock_timestamp()),
(787, 'Mountain-300 Black, 44', 'BK-M47B-44', '1', '1', 'Black', 100, 75, 598.4354, 1079.99, '44', 'CM', 'LB', 26.13, 4, 'M', 'M', 'U', 1, 21, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '07c2a548-0452-47b4-9dce-6edb0a30c85e', clock_timestamp()),
(788, 'Mountain-300 Black, 48', 'BK-M47B-48', '1', '1', 'Black', 100, 75, 598.4354, 1079.99, '48', 'CM', 'LB', 26.42, 4, 'M', 'M', 'U', 1, 21, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '16078dbe-388d-4c18-aa8f-0c8f48035468', clock_timestamp()),
(789, 'Road-250 Red, 44', 'BK-R89R-44', '1', '1', 'Red', 100, 75, 1518.7864, 2443.35, '44', 'CM', 'LB', 14.77, 4, 'R', 'H', 'U', 2, 26, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '0aa71ad6-afaf-43c6-9745-35d815b50a5b', clock_timestamp()),
(790, 'Road-250 Red, 48', 'BK-R89R-48', '1', '1', 'Red', 100, 75, 1518.7864, 2443.35, '48', 'CM', 'LB', 15.13, 4, 'R', 'H', 'U', 2, 26, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '115ddade-70e3-43f9-80dc-638daea271c4', clock_timestamp()),
(791, 'Road-250 Red, 52', 'BK-R89R-52', '1', '1', 'Red', 100, 75, 1518.7864, 2443.35, '52', 'CM', 'LB', 15.42, 4, 'R', 'H', 'U', 2, 26, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, 'c9fd1df4-9512-420a-b379-067108033b75', clock_timestamp()),
(792, 'Road-250 Red, 58', 'BK-R89R-58', '1', '1', 'Red', 100, 75, 1554.9479, 2443.35, '58', 'CM', 'LB', 15.79, 4, 'R', 'H', 'U', 2, 26, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'df629c11-8d8b-4774-9d52-ecb64dc95212', clock_timestamp()),
(793, 'Road-250 Black, 44', 'BK-R89B-44', '1', '1', 'Black', 100, 75, 1554.9479, 2443.35, '44', 'CM', 'LB', 14.77, 4, 'R', 'H', 'U', 2, 26, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '1ff419b5-52af-4f7e-aeae-4fec5e99de35', clock_timestamp()),
(794, 'Road-250 Black, 48', 'BK-R89B-48', '1', '1', 'Black', 100, 75, 1554.9479, 2443.35, '48', 'CM', 'LB', 15.13, 4, 'R', 'H', 'U', 2, 26, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '9d165ddf-8f5d-41c7-9bb8-13f41a3d1f62', clock_timestamp()),
(795, 'Road-250 Black, 52', 'BK-R89B-52', '1', '1', 'Black', 100, 75, 1554.9479, 2443.35, '52', 'CM', 'LB', 15.42, 4, 'R', 'H', 'U', 2, 26, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '74fe3957-cbc3-450a-ab92-849bd13530e2', clock_timestamp()),
(796, 'Road-250 Black, 58', 'BK-R89B-58', '1', '1', 'Black', 100, 75, 1554.9479, 2443.35, '58', 'CM', 'LB', 15.68, 4, 'R', 'H', 'U', 2, 26, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '1c530fe8-a169-4adc-b3dc-b11a48245e63', clock_timestamp()),
(797, 'Road-550-W Yellow, 38', 'BK-R64Y-38', '1', '1', 'Yellow', 100, 75, 713.0798, 1120.49, '38', 'CM', 'LB', 17.35, 4, 'R', 'M', 'W', 2, 29, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'aad81532-a572-49a5-83c3-dfa9e3b4fea6', clock_timestamp()),
(798, 'Road-550-W Yellow, 40', 'BK-R64Y-40', '1', '1', 'Yellow', 100, 75, 713.0798, 1120.49, '40', 'CM', 'LB', 17.77, 4, 'R', 'M', 'W', 2, 29, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'a35a1c35-c128-4697-951e-4199062e78f3', clock_timestamp()),
(799, 'Road-550-W Yellow, 42', 'BK-R64Y-42', '1', '1', 'Yellow', 100, 75, 713.0798, 1120.49, '42', 'CM', 'LB', 18.13, 4, 'R', 'M', 'W', 2, 29, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'a359ab09-16f2-4726-a60f-0dfdb1c9527e', clock_timestamp()),
(800, 'Road-550-W Yellow, 44', 'BK-R64Y-44', '1', '1', 'Yellow', 100, 75, 713.0798, 1120.49, '44', 'CM', 'LB', 18.42, 4, 'R', 'M', 'W', 2, 29, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '0a7028fb-ff06-4d38-aaa1-b64816278165', clock_timestamp()),
(801, 'Road-550-W Yellow, 48', 'BK-R64Y-48', '1', '1', 'Yellow', 100, 75, 713.0798, 1120.49, '48', 'CM', 'LB', 18.68, 4, 'R', 'M', 'W', 2, 29, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'c90cc877-804c-4ce7-afc3-4c8791a13dfb', clock_timestamp()),
(802, 'LL Fork', 'FK-1639', '1', '1', NULL, 500, 375, 65.8097, 148.22, NULL, NULL, NULL, NULL, 1, NULL, 'L', NULL, 10, 104, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, 'fb8502be-07eb-4134-ab06-c3a9959a52ae', clock_timestamp()),
(803, 'ML Fork', 'FK-5136', '1', '1', NULL, 500, 375, 77.9176, 175.49, NULL, NULL, NULL, NULL, 1, NULL, 'M', NULL, 10, 105, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, 'f5fa4e2f-b976-48a4-bf79-85632f697d2e', clock_timestamp()),
(804, 'HL Fork', 'FK-9939', '1', '1', NULL, 500, 375, 101.8936, 229.49, NULL, NULL, NULL, NULL, 1, NULL, 'H', NULL, 10, 106, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '553229b3-1ad9-4a71-a21c-2af4332cfce9', clock_timestamp()),
(805, 'LL Headset', 'HS-0296', '1', '1', NULL, 500, 375, 15.1848, 34.2, NULL, NULL, NULL, NULL, 1, NULL, 'L', NULL, 11, 59, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, 'bb6bd7b3-a34d-4d64-822e-781fa6838e19', clock_timestamp()),
(806, 'ML Headset', 'HS-2451', '1', '1', NULL, 500, 375, 45.4168, 102.29, NULL, NULL, NULL, NULL, 1, NULL, 'M', NULL, 11, 60, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '23b5d52b-8c29-4059-b899-75c53b5ee2e6', clock_timestamp()),
(807, 'HL Headset', 'HS-3479', '1', '1', NULL, 500, 375, 55.3801, 124.73, NULL, NULL, NULL, NULL, 1, NULL, 'H', NULL, 11, 61, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '12e4d5e8-79ed-4bcb-a532-6275d1a93417', clock_timestamp()),
(808, 'LL Mountain Handlebars', 'HB-M243', '1', '1', NULL, 500, 375, 19.7758, 44.54, NULL, NULL, NULL, NULL, 1, 'M', 'L', NULL, 4, 52, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'b59b7bf2-7afc-4a74-b063-f942f1e0da19', clock_timestamp()),
(809, 'ML Mountain Handlebars', 'HB-M763', '1', '1', NULL, 500, 375, 27.4925, 61.92, NULL, NULL, NULL, NULL, 1, 'M', 'M', NULL, 4, 54, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'ae6020df-d9c9-4d34-9795-1f80e6bbf5a5', clock_timestamp()),
(810, 'HL Mountain Handlebars', 'HB-M918', '1', '1', NULL, 500, 375, 53.3999, 120.27, NULL, NULL, NULL, NULL, 1, 'M', 'H', NULL, 4, 55, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '6aa0f921-0f09-4f99-8d3c-335946873553', clock_timestamp()),
(811, 'LL Road Handlebars', 'HB-R504', '1', '1', NULL, 500, 375, 19.7758, 44.54, NULL, NULL, NULL, NULL, 1, 'R', 'L', NULL, 4, 56, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'acdae407-b40e-435e-8e84-1bfc33013e81', clock_timestamp()),
(812, 'ML Road Handlebars', 'HB-R720', '1', '1', NULL, 500, 375, 27.4925, 61.92, NULL, NULL, NULL, NULL, 1, 'R', 'M', NULL, 4, 57, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '33fa1a03-38d6-405e-be9b-eea92f3d204f', clock_timestamp()),
(813, 'HL Road Handlebars', 'HB-R956', '1', '1', NULL, 500, 375, 53.3999, 120.27, NULL, NULL, NULL, NULL, 1, 'R', 'H', NULL, 4, 58, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '5c5327b9-ad2e-4c33-8d74-edf49e0c2dd8', clock_timestamp()),
(814, 'ML Mountain Frame - Black, 38', 'FR-M63B-38', '1', '1', 'Black', 500, 375, 185.8193, 348.76, '38', 'CM', 'LB', 2.73, 2, 'M', 'M', 'U', 12, 15, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '0d879312-a7d3-441d-9d23-b6550bab3814', clock_timestamp()),
(815, 'LL Mountain Front Wheel', 'FW-M423', '1', '1', 'Black', 500, 375, 26.9708, 60.745, NULL, NULL, NULL, NULL, 1, 'M', 'L', NULL, 17, 42, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, 'd7b1d161-182e-44f6-a9ff-9c1eba76613b', clock_timestamp()),
(816, 'ML Mountain Front Wheel', 'FW-M762', '1', '1', 'Black', 500, 375, 92.8071, 209.025, NULL, NULL, NULL, NULL, 1, 'M', 'M', NULL, 17, 45, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '5e3e5033-9a77-4dca-8b7f-dfed78efa08a', clock_timestamp()),
(817, 'HL Mountain Front Wheel', 'FW-M928', '1', '1', 'Black', 500, 375, 133.2955, 300.215, NULL, NULL, NULL, NULL, 1, 'M', 'H', NULL, 17, 46, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '3c8ffff6-a8dc-45a3-963b-a6284ced7596', clock_timestamp()),
(818, 'LL Road Front Wheel', 'FW-R623', '1', '1', 'Black', 500, 375, 37.9909, 85.565, NULL, NULL, 'G', 900.00, 1, 'R', 'L', NULL, 17, 49, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '9e66de78-decb-438a-b9a9-023c773c60a2', clock_timestamp()),
(819, 'ML Road Front Wheel', 'FW-R762', '1', '1', 'Black', 500, 375, 110.2829, 248.385, NULL, NULL, 'G', 850.00, 1, 'R', 'M', NULL, 17, 50, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '6ea94fbf-b9aa-43fc-84e8-91d508dde751', clock_timestamp()),
(820, 'HL Road Front Wheel', 'FW-R820', '1', '1', 'Black', 500, 375, 146.5466, 330.06, NULL, NULL, 'G', 650.00, 1, 'R', 'H', NULL, 17, 51, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '727a3cd5-8d40-4884-a7e4-dfd3ffdeb164', clock_timestamp()),
(821, 'Touring Front Wheel', 'FW-T905', '1', '1', 'Black', 500, 375, 96.7964, 218.01, NULL, NULL, NULL, NULL, 1, 'T', NULL, NULL, 17, 44, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '8d1cdb07-4fa1-4ac1-840f-a16c3dca5009', clock_timestamp()),
(822, 'ML Road Frame-W - Yellow, 38', 'FR-R72Y-38', '1', '1', 'Yellow', 500, 375, 360.9428, 594.83, '38', 'CM', 'LB', 2.18, 2, 'R', 'M', 'W', 14, 17, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '22976fa7-0ad0-40f9-b4f9-ba10279ea1a3', clock_timestamp()),
(823, 'LL Mountain Rear Wheel', 'RW-M423', '1', '1', 'Black', 500, 375, 38.9588, 87.745, NULL, NULL, NULL, NULL, 1, 'M', 'L', NULL, 17, 123, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, 'e6c39f58-995f-4786-a309-df3812d8b30f', clock_timestamp()),
(824, 'ML Mountain Rear Wheel', 'RW-M762', '1', '1', 'Black', 500, 375, 104.7951, 236.025, NULL, NULL, NULL, NULL, 1, 'M', 'M', NULL, 17, 124, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, 'b2f7cf9b-a7bf-49ab-9cca-9f6e791cd693', clock_timestamp()),
(825, 'HL Mountain Rear Wheel', 'RW-M928', '1', '1', 'Black', 500, 375, 145.2835, 327.215, NULL, NULL, NULL, NULL, 1, 'M', 'H', NULL, 17, 125, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '35d02edc-1120-41fb-b5df-8655a93b3353', clock_timestamp()),
(826, 'LL Road Rear Wheel', 'RW-R623', '1', '1', 'Black', 500, 375, 49.9789, 112.565, NULL, NULL, 'G', 1050.00, 1, 'R', 'L', NULL, 17, 126, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '78d01117-8dcd-465f-9dc7-94a2cdc35582', clock_timestamp()),
(827, 'ML Road Rear Wheel', 'RW-R762', '1', '1', 'Black', 500, 375, 122.2709, 275.385, NULL, NULL, 'G', 1000.00, 1, 'R', 'M', NULL, 17, 77, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, 'cf739f9a-0af0-4810-b229-c431a31d7779', clock_timestamp()),
(828, 'HL Road Rear Wheel', 'RW-R820', '1', '1', 'Black', 500, 375, 158.5346, 357.06, NULL, NULL, 'G', 890.00, 1, 'R', 'H', NULL, 17, 78, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '8f262a37-43aa-4ad5-ae1f-8bd6967d8e9b', clock_timestamp()),
(829, 'Touring Rear Wheel', 'RW-T905', '1', '1', 'Black', 500, 375, 108.7844, 245.01, NULL, NULL, NULL, NULL, 1, 'T', NULL, NULL, 17, 43, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '30d2254d-e26d-4586-b4c5-e8ccb8a059b8', clock_timestamp()),
(830, 'ML Mountain Frame - Black, 40', 'FR-M63B-40', '1', '1', 'Black', 500, 375, 185.8193, 348.76, '40', 'CM', 'LB', 2.77, 1, 'M', 'M', 'U', 12, 14, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, 'aed1c9c4-c139-45d2-b38e-0a0a9f518665', clock_timestamp()),
(831, 'ML Mountain Frame - Black, 44', 'FR-M63B-44', '1', '1', 'Black', 500, 375, 185.8193, 348.76, '44', 'CM', 'LB', 2.81, 1, 'M', 'M', 'U', 12, 14, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '3f2135d4-ec5f-4e30-bde8-5444518f0637', clock_timestamp()),
(832, 'ML Mountain Frame - Black, 48', 'FR-M63B-48', '1', '1', 'Black', 500, 375, 185.8193, 348.76, '48', 'CM', 'LB', 2.85, 1, 'M', 'M', 'U', 12, 14, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, 'c2009b69-f15a-47ec-b710-1809d299318a', clock_timestamp()),
(833, 'ML Road Frame-W - Yellow, 40', 'FR-R72Y-40', '1', '1', 'Yellow', 500, 375, 360.9428, 594.83, '40', 'CM', 'LB', 2.22, 1, 'R', 'M', 'W', 14, 17, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '22df26f2-60bc-493e-a14a-5500633e9f7e', clock_timestamp()),
(834, 'ML Road Frame-W - Yellow, 42', 'FR-R72Y-42', '1', '1', 'Yellow', 500, 375, 360.9428, 594.83, '42', 'CM', 'LB', 2.26, 1, 'R', 'M', 'W', 14, 17, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '207b54da-5404-415d-8578-9a45082e3bf1', clock_timestamp()),
(835, 'ML Road Frame-W - Yellow, 44', 'FR-R72Y-44', '1', '1', 'Yellow', 500, 375, 360.9428, 594.83, '44', 'CM', 'LB', 2.30, 1, 'R', 'M', 'W', 14, 17, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'a0fad492-ac24-4fcf-8d2a-d21d06386ae1', clock_timestamp()),
(836, 'ML Road Frame-W - Yellow, 48', 'FR-R72Y-48', '1', '1', 'Yellow', 500, 375, 360.9428, 594.83, '48', 'CM', 'LB', 2.34, 1, 'R', 'M', 'W', 14, 17, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '8487bfe0-2138-471e-9c6d-fdb3a67e7d86', clock_timestamp()),
(837, 'HL Road Frame - Black, 62', 'FR-R92B-62', '1', '1', 'Black', 500, 375, 868.6342, 1431.5, '62', 'CM', 'LB', 2.30, 1, 'R', 'H', 'U', 14, 6, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '5dce9c8c-fb94-46f8-b826-11658f6a3682', clock_timestamp()),
(838, 'HL Road Frame - Black, 44', 'FR-R92B-44', '1', '1', 'Black', 500, 375, 868.6342, 1431.5, '44', 'CM', 'LB', 2.12, 1, 'R', 'H', 'U', 14, 6, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'e4902656-a4bc-4b08-9d47-4f3da0fd76c3', clock_timestamp()),
(839, 'HL Road Frame - Black, 48', 'FR-R92B-48', '1', '1', 'Black', 500, 375, 868.6342, 1431.5, '48', 'CM', 'LB', 2.16, 1, 'R', 'H', 'U', 14, 6, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '557b603b-407b-41a4-ae34-4f7747866dba', clock_timestamp()),
(840, 'HL Road Frame - Black, 52', 'FR-R92B-52', '1', '1', 'Black', 500, 375, 868.6342, 1431.5, '52', 'CM', 'LB', 2.20, 1, 'R', 'H', 'U', 14, 6, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '0ed082b3-fbba-43af-9149-8741b9fc78c8', clock_timestamp()),
(841, 'Men''s Sports Shorts, S', 'SH-M897-S', '0', '1', 'Black', 4, 3, 24.7459, 59.99, 'S', NULL, NULL, NULL, 0, 'S', NULL, 'M', 22, 13, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '34b08c1f-99d1-43c4-8ef7-2cd754b6665d', clock_timestamp()),
(842, 'Touring-Panniers, Large', 'PA-T100', '0', '1', 'Grey', 4, 3, 51.5625, 125, NULL, NULL, NULL, NULL, 0, 'T', NULL, NULL, 35, 120, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '56334fff-91d4-495e-bf98-933bc1010f23', clock_timestamp()),
(843, 'Cable Lock', 'LO-C100', '0', '1', NULL, 4, 3, 10.3125, 25, NULL, NULL, NULL, NULL, 0, 'S', NULL, NULL, 34, 115, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '56ffd7b9-1014-4640-b1bd-b2649589b4d7', clock_timestamp()),
(844, 'Minipump', 'PU-0452', '0', '1', NULL, 4, 3, 8.2459, 19.99, NULL, NULL, NULL, NULL, 0, 'S', NULL, NULL, 36, 116, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, 'aaf7a076-9ee3-46bf-a69f-414d847e858b', clock_timestamp()),
(845, 'Mountain Pump', 'PU-M044', '0', '1', NULL, 4, 3, 10.3084, 24.99, NULL, NULL, NULL, NULL, 0, 'M', NULL, NULL, 36, 117, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '57169f80-fafb-4678-8f51-fe1f131d0c83', clock_timestamp()),
(846, 'Taillights - Battery-Powered', 'LT-T990', '0', '1', NULL, 4, 3, 5.7709, 13.99, NULL, NULL, NULL, NULL, 0, 'R', NULL, NULL, 33, 108, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '3c617b87-50a5-434c-a0d3-22314b7027ee', clock_timestamp()),
(847, 'Headlights - Dual-Beam', 'LT-H902', '0', '1', NULL, 4, 3, 14.4334, 34.99, NULL, NULL, NULL, NULL, 0, 'R', NULL, NULL, 33, 109, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '417db6cb-f38f-4b0d-87e7-e1ebf7456c3a', clock_timestamp()),
(848, 'Headlights - Weatherproof', 'LT-H903', '0', '1', NULL, 4, 3, 18.5584, 44.99, NULL, NULL, NULL, NULL, 0, 'R', NULL, NULL, 33, 110, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, 'fc362c1a-4b9c-4d5f-a6d3-0775846c61f0', clock_timestamp()),
(849, 'Men''s Sports Shorts, M', 'SH-M897-M', '0', '1', 'Black', 4, 3, 24.7459, 59.99, 'M', NULL, NULL, NULL, 0, 'S', NULL, 'M', 22, 13, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, 'db37b435-74b9-43d3-b363-abbead107bc4', clock_timestamp()),
(850, 'Men''s Sports Shorts, L', 'SH-M897-L', '0', '1', 'Black', 4, 3, 24.7459, 59.99, 'L', NULL, NULL, NULL, 0, 'S', NULL, 'M', 22, 13, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '714184c5-669b-4cf1-a802-30e7b1ea7722', clock_timestamp()),
(851, 'Men''s Sports Shorts, XL', 'SH-M897-X', '0', '1', 'Black', 4, 3, 24.7459, 59.99, 'XL', NULL, NULL, NULL, 0, 'S', NULL, 'M', 22, 13, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, 'bd3ffe40-fe2e-44cb-a4e0-81786c3a751f', clock_timestamp()),
(852, 'Women''s Tights, S', 'TG-W091-S', '0', '1', 'Black', 4, 3, 30.9334, 74.99, 'S', NULL, NULL, NULL, 0, 'S', NULL, 'W', 24, 38, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '7de86c98-4f5b-4155-8572-c977f14ebaeb', clock_timestamp()),
(853, 'Women''s Tights, M', 'TG-W091-M', '0', '1', 'Black', 4, 3, 30.9334, 74.99, 'M', NULL, NULL, NULL, 0, 'S', NULL, 'W', 24, 38, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '4d8e186c-b8c9-4c64-b411-4995dd87e316', clock_timestamp()),
(854, 'Women''s Tights, L', 'TG-W091-L', '0', '1', 'Black', 4, 3, 30.9334, 74.99, 'L', NULL, NULL, NULL, 0, 'S', NULL, 'W', 24, 38, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, 'e378c2f3-54f6-4ea9-b049-e8bb32b5bdfd', clock_timestamp()),
(855, 'Men''s Bib-Shorts, S', 'SB-M891-S', '0', '1', 'Multi', 4, 3, 37.1209, 89.99, 'S', NULL, NULL, NULL, 0, 'S', NULL, 'M', 18, 12, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '9f60af1e-4c11-4e90-baea-48e834e8b4c2', clock_timestamp()),
(856, 'Men''s Bib-Shorts, M', 'SB-M891-M', '0', '1', 'Multi', 4, 3, 37.1209, 89.99, 'M', NULL, NULL, NULL, 0, 'S', NULL, 'M', 18, 12, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, 'e0cbec04-f4fc-450f-9780-f8ea7691febd', clock_timestamp()),
(857, 'Men''s Bib-Shorts, L', 'SB-M891-L', '0', '1', 'Multi', 4, 3, 37.1209, 89.99, 'L', NULL, NULL, NULL, 0, 'S', NULL, 'M', 18, 12, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, 'e1df75a4-9986-489e-a5de-ad3da824eb5e', clock_timestamp()),
(858, 'Half-Finger Gloves, S', 'GL-H102-S', '0', '1', 'Black', 4, 3, 9.1593, 24.49, 'S', NULL, NULL, NULL, 0, 'S', NULL, 'U', 20, 4, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '9e1db5c3-539d-4061-9433-d762dc195cd8', clock_timestamp()),
(859, 'Half-Finger Gloves, M', 'GL-H102-M', '0', '1', 'Black', 4, 3, 9.1593, 24.49, 'M', NULL, NULL, NULL, 0, 'S', NULL, 'U', 20, 4, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '9d458fd5-392d-4ab1-afef-6a5548e48858', clock_timestamp()),
(860, 'Half-Finger Gloves, L', 'GL-H102-L', '0', '1', 'Black', 4, 3, 9.1593, 24.49, 'L', NULL, NULL, NULL, 0, 'S', NULL, 'U', 20, 4, CAST('2012-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'fa710215-925f-4959-81df-538e72a6a255', clock_timestamp()),
(861, 'Full-Finger Gloves, S', 'GL-F110-S', '0', '1', 'Black', 4, 3, 15.6709, 37.99, 'S', NULL, NULL, NULL, 0, 'M', NULL, 'U', 20, 3, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '76fac097-1fb3-456b-8fb9-2c7a613771b4', clock_timestamp()),
(862, 'Full-Finger Gloves, M', 'GL-F110-M', '0', '1', 'Black', 4, 3, 15.6709, 37.99, 'M', NULL, NULL, NULL, 0, 'M', NULL, 'U', 20, 3, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '1084221e-1890-443e-9d87-afcad6358355', clock_timestamp()),
(863, 'Full-Finger Gloves, L', 'GL-F110-L', '0', '1', 'Black', 4, 3, 15.6709, 37.99, 'L', NULL, NULL, NULL, 0, 'M', NULL, 'U', 20, 3, CAST('2012-05-30 00:00:00' AS TIMESTAMP), CAST('2013-05-29 00:00:00' AS TIMESTAMP), NULL, '6116f9d4-8a1d-4022-a642-9c445c197203', clock_timestamp()),
(864, 'Classic Vest, S', 'VE-C304-S', '0', '1', 'Blue', 4, 3, 23.749, 63.5, 'S', NULL, NULL, NULL, 0, 'S', NULL, 'U', 25, 1, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'eb423ef3-409d-46fe-b35b-d69970820314', clock_timestamp()),
(865, 'Classic Vest, M', 'VE-C304-M', '0', '1', 'Blue', 4, 3, 23.749, 63.5, 'M', NULL, NULL, NULL, 0, 'S', NULL, 'U', 25, 1, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '2e52f96e-64a1-4069-911c-e3fd6e094a1e', clock_timestamp()),
(866, 'Classic Vest, L', 'VE-C304-L', '0', '1', 'Blue', 4, 3, 23.749, 63.5, 'L', NULL, NULL, NULL, 0, 'S', NULL, 'U', 25, 1, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '3211f5a8-b6c4-48bd-9aa4-d69cb40d97dd', clock_timestamp()),
(867, 'Women''s Mountain Shorts, S', 'SH-W890-S', '0', '1', 'Black', 4, 3, 26.1763, 69.99, 'S', NULL, NULL, NULL, 0, 'M', NULL, 'W', 22, 37, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '22616fd2-b99f-4f7d-acf6-33dff66d42d2', clock_timestamp()),
(868, 'Women''s Mountain Shorts, M', 'SH-W890-M', '0', '1', 'Black', 4, 3, 26.1763, 69.99, 'M', NULL, NULL, NULL, 0, 'M', NULL, 'W', 22, 37, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '968e3610-e583-42e8-8ab6-484a799b1774', clock_timestamp()),
(869, 'Women''s Mountain Shorts, L', 'SH-W890-L', '0', '1', 'Black', 4, 3, 26.1763, 69.99, 'L', NULL, NULL, NULL, 0, 'M', NULL, 'W', 22, 37, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '1a66b244-5ca0-4153-b539-ae048d14faec', clock_timestamp()),
(870, 'Water Bottle - 30 oz.', 'WB-H098', '0', '1', NULL, 4, 3, 1.8663, 4.99, NULL, NULL, NULL, NULL, 0, 'S', NULL, NULL, 28, 111, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '834e8d1a-69a7-4c42-8b68-fa08d9ec9e5b', clock_timestamp()),
(871, 'Mountain Bottle Cage', 'BC-M005', '0', '1', NULL, 4, 3, 3.7363, 9.99, NULL, NULL, NULL, NULL, 0, 'M', NULL, NULL, 28, 112, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '684491de-63f8-4632-90e3-36773c4e63bd', clock_timestamp()),
(872, 'Road Bottle Cage', 'BC-R205', '0', '1', NULL, 4, 3, 3.3623, 8.99, NULL, NULL, NULL, NULL, 0, 'R', NULL, NULL, 28, 113, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '601b1fe8-d4d0-4cfb-9379-29481cc05291', clock_timestamp()),
(873, 'Patch Kit/8 Patches', 'PK-7098', '0', '1', NULL, 4, 3, 0.8565, 2.29, NULL, NULL, NULL, NULL, 0, 'S', NULL, NULL, 37, 114, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '36e638e4-68df-411b-930a-daad57221aa6', clock_timestamp()),
(874, 'Racing Socks, M', 'SO-R809-M', '0', '1', 'White', 4, 3, 3.3623, 8.99, 'M', NULL, NULL, NULL, 0, 'R', NULL, 'U', 23, 24, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'b9c7eb0a-1dd1-4a1d-b4c3-1dad83a8ea7e', clock_timestamp()),
(875, 'Racing Socks, L', 'SO-R809-L', '0', '1', 'White', 4, 3, 3.3623, 8.99, 'L', NULL, NULL, NULL, 0, 'R', NULL, 'U', 23, 24, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'c0a16305-74b7-4fae-b5c9-3e8bd0e44762', clock_timestamp()),
(876, 'Hitch Rack - 4-Bike', 'RA-H123', '0', '1', NULL, 4, 3, 44.88, 120, NULL, NULL, NULL, NULL, 0, 'S', NULL, NULL, 26, 118, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '7a0c4bbd-9679-4f59-9ebc-9daf3439a38a', clock_timestamp()),
(877, 'Bike Wash - Dissolver', 'CL-9009', '0', '1', NULL, 4, 3, 2.9733, 7.95, NULL, NULL, NULL, NULL, 0, 'S', NULL, NULL, 29, 119, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '3c40b5ad-e328-4715-88a7-ec3220f02acf', clock_timestamp()),
(878, 'Fender Set - Mountain', 'FE-6654', '0', '1', NULL, 4, 3, 8.2205, 21.98, NULL, NULL, NULL, NULL, 0, 'M', NULL, NULL, 30, 121, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'e6e76c7f-c145-4cad-a9e8-b1e4e845a2c0', clock_timestamp()),
(879, 'All-Purpose Bike Stand', 'ST-1401', '0', '1', NULL, 4, 3, 59.466, 159, NULL, NULL, NULL, NULL, 0, 'M', NULL, NULL, 27, 122, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'c7bb564b-a637-40f5-b21b-cbf7e4f713be', clock_timestamp()),
(880, 'Hydration Pack - 70 oz.', 'HY-1023-70', '0', '1', 'Silver', 4, 3, 20.5663, 54.99, '70', NULL, NULL, NULL, 0, 'S', NULL, NULL, 32, 107, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'a99d90c0-05e2-4e44-ad90-c55c9f0784de', clock_timestamp()),
(881, 'Short-Sleeve Classic Jersey, S', 'SJ-0194-S', '0', '1', 'Yellow', 4, 3, 41.5723, 53.99, 'S', NULL, NULL, NULL, 0, 'S', NULL, 'U', 21, 32, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '05b2e20f-2399-4cb3-9b49-b28d6649c104', clock_timestamp()),
(882, 'Short-Sleeve Classic Jersey, M', 'SJ-0194-M', '0', '1', 'Yellow', 4, 3, 41.5723, 53.99, 'M', NULL, NULL, NULL, 0, 'S', NULL, 'U', 21, 32, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'bbbf003b-367d-4d71-af71-10f50b6234a0', clock_timestamp()),
(883, 'Short-Sleeve Classic Jersey, L', 'SJ-0194-L', '0', '1', 'Yellow', 4, 3, 41.5723, 53.99, 'L', NULL, NULL, NULL, 0, 'S', NULL, 'U', 21, 32, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '2d9f59b8-9f24-46eb-98ad-553e48bb9db9', clock_timestamp()),
(884, 'Short-Sleeve Classic Jersey, XL', 'SJ-0194-X', '0', '1', 'Yellow', 4, 3, 41.5723, 53.99, 'XL', NULL, NULL, NULL, 0, 'S', NULL, 'U', 21, 32, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '906d42f6-c21f-4d20-b528-02ffdb55fd1e', clock_timestamp()),
(885, 'HL Touring Frame - Yellow, 60', 'FR-T98Y-60', '1', '1', 'Yellow', 500, 375, 601.7437, 1003.91, '60', 'CM', 'LB', 3.08, 1, 'T', 'H', 'U', 16, 7, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'c49679bd-96a9-4176-a7ed-5bc6d6444647', clock_timestamp()),
(886, 'LL Touring Frame - Yellow, 62', 'FR-T67Y-62', '1', '1', 'Yellow', 500, 375, 199.8519, 333.42, '62', 'CM', 'LB', 3.20, 1, 'T', 'L', 'U', 16, 10, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '8d4d52a6-8abc-4c05-be4d-c067faf1a64e', clock_timestamp()),
(887, 'HL Touring Frame - Yellow, 46', 'FR-T98Y-46', '1', '1', 'Yellow', 500, 375, 601.7437, 1003.91, '46', 'CM', 'LB', 2.96, 1, 'T', 'H', 'U', 16, 7, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '137675a7-34cd-4b7a-abe1-4e0eeb79b65d', clock_timestamp()),
(888, 'HL Touring Frame - Yellow, 50', 'FR-T98Y-50', '1', '1', 'Yellow', 500, 375, 601.7437, 1003.91, '50', 'CM', 'LB', 3.00, 1, 'T', 'H', 'U', 16, 7, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '105ec6e5-30c5-4fe3-a08b-cb324c85323d', clock_timestamp()),
(889, 'HL Touring Frame - Yellow, 54', 'FR-T98Y-54', '1', '1', 'Yellow', 500, 375, 601.7437, 1003.91, '54', 'CM', 'LB', 3.04, 1, 'T', 'H', 'U', 16, 7, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '12b1f317-c39b-48d0-b1a7-8018c60aea53', clock_timestamp()),
(890, 'HL Touring Frame - Blue, 46', 'FR-T98U-46', '1', '1', 'Blue', 500, 375, 601.7437, 1003.91, '46', 'CM', 'LB', 2.96, 1, 'T', 'H', 'U', 16, 7, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '8bbd3437-a58b-41a0-9503-fc14b23e7678', clock_timestamp()),
(891, 'HL Touring Frame - Blue, 50', 'FR-T98U-50', '1', '1', 'Blue', 500, 375, 601.7437, 1003.91, '50', 'CM', 'LB', 3.00, 1, 'T', 'H', 'U', 16, 7, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'c4244f0c-abce-451b-a895-83c0e6d1f448', clock_timestamp()),
(892, 'HL Touring Frame - Blue, 54', 'FR-T98U-54', '1', '1', 'Blue', 500, 375, 601.7437, 1003.91, '54', 'CM', 'LB', 3.04, 1, 'T', 'H', 'U', 16, 7, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'e9aae947-6bc3-4909-8937-3e1cdcec8a8f', clock_timestamp()),
(893, 'HL Touring Frame - Blue, 60', 'FR-T98U-60', '1', '1', 'Blue', 500, 375, 601.7437, 1003.91, '60', 'CM', 'LB', 3.08, 1, 'T', 'H', 'U', 16, 7, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'b01951a4-a581-4d10-9dc2-515da180f1b8', clock_timestamp()),
(894, 'Rear Derailleur', 'RD-2308', '1', '1', 'Silver', 500, 375, 53.9282, 121.46, NULL, NULL, 'G', 215.00, 1, NULL, NULL, NULL, 9, 127, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '5ebfcf02-4e3e-443a-ad60-5aeef28dac76', clock_timestamp()),
(895, 'LL Touring Frame - Blue, 50', 'FR-T67U-50', '1', '1', 'Blue', 500, 375, 199.8519, 333.42, '50', 'CM', 'LB', 3.10, 1, 'T', 'L', 'U', 16, 10, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'b78eccca-fa88-4071-9110-410585127e46', clock_timestamp()),
(896, 'LL Touring Frame - Blue, 54', 'FR-T67U-54', '1', '1', 'Blue', 500, 375, 199.8519, 333.42, '54', 'CM', 'LB', 3.14, 1, 'T', 'L', 'U', 16, 10, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '0ff799c9-dd11-4b81-aaf7-65410017405b', clock_timestamp()),
(897, 'LL Touring Frame - Blue, 58', 'FR-T67U-58', '1', '1', 'Blue', 500, 375, 199.8519, 333.42, '58', 'CM', 'LB', 3.16, 1, 'T', 'L', 'U', 16, 10, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'ccd4fa47-7194-4bd0-909b-1fa4bd7916a7', clock_timestamp()),
(898, 'LL Touring Frame - Blue, 62', 'FR-T67U-62', '1', '1', 'Blue', 500, 375, 199.8519, 333.42, '62', 'CM', 'LB', 3.20, 1, 'T', 'L', 'U', 16, 10, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '08a211a5-dcd2-42d0-9276-64d92d4890a6', clock_timestamp()),
(899, 'LL Touring Frame - Yellow, 44', 'FR-T67Y-44', '1', '1', 'Yellow', 500, 375, 199.8519, 333.42, '44', 'CM', 'LB', 3.02, 1, 'T', 'L', 'U', 16, 10, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '109cb7bc-6ec6-4a36-85c8-55b843b2ab12', clock_timestamp()),
(900, 'LL Touring Frame - Yellow, 50', 'FR-T67Y-50', '1', '1', 'Yellow', 500, 375, 199.8519, 333.42, '50', 'CM', 'LB', 3.10, 1, 'T', 'L', 'U', 16, 10, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '285fd682-c647-49d1-b8f3-368a43c9cda0', clock_timestamp()),
(901, 'LL Touring Frame - Yellow, 54', 'FR-T67Y-54', '1', '1', 'Yellow', 500, 375, 199.8519, 333.42, '54', 'CM', 'LB', 3.14, 1, 'T', 'L', 'U', 16, 10, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '2536e3b2-d4da-49e6-965a-f612c2c8914f', clock_timestamp()),
(902, 'LL Touring Frame - Yellow, 58', 'FR-T67Y-58', '1', '1', 'Yellow', 500, 375, 199.8519, 333.42, '58', 'CM', 'LB', 3.16, 1, 'T', 'L', 'U', 16, 10, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '5d17ff1c-f50e-438f-a4e9-7c400fb762e7', clock_timestamp()),
(903, 'LL Touring Frame - Blue, 44', 'FR-T67U-44', '1', '1', 'Blue', 500, 375, 199.8519, 333.42, '44', 'CM', 'LB', 3.02, 1, 'T', 'L', 'U', 16, 10, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'e9c17be7-f4dc-465e-ab73-c0198f37bfdd', clock_timestamp()),
(904, 'ML Mountain Frame-W - Silver, 40', 'FR-M63S-40', '1', '1', 'Silver', 500, 375, 199.3757, 364.09, '40', 'CM', 'LB', 2.77, 1, 'M', 'M', 'W', 12, 15, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'a7dde43e-f7d5-4075-a0c1-c866ad7aa154', clock_timestamp()),
(905, 'ML Mountain Frame-W - Silver, 42', 'FR-M63S-42', '1', '1', 'Silver', 500, 375, 199.3757, 364.09, '42', 'CM', 'LB', 2.81, 1, 'M', 'M', 'W', 12, 15, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'd4a2fcad-1e63-4ebd-863c-5a7c48d5b8d9', clock_timestamp()),
(906, 'ML Mountain Frame-W - Silver, 46', 'FR-M63S-46', '1', '1', 'Silver', 500, 375, 199.3757, 364.09, '46', 'CM', 'LB', 2.85, 1, 'M', 'M', 'W', 12, 15, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '82025c63-7b28-412d-92c1-408e0e6ae646', clock_timestamp()),
(907, 'Rear Brakes', 'RB-9231', '0', '1', 'Silver', 500, 375, 47.286, 106.5, NULL, NULL, 'G', 317.00, 1, NULL, NULL, NULL, 6, 128, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '5946f163-93f0-4141-b17e-55d9778cc274', clock_timestamp()),
(908, 'LL Mountain Seat/Saddle', 'SE-M236', '0', '1', NULL, 500, 375, 12.0413, 27.12, NULL, NULL, NULL, NULL, 1, 'M', 'L', NULL, 15, 79, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '4dab53c5-31e7-47d6-a5a0-940f8d4dad22', clock_timestamp()),
(909, 'ML Mountain Seat/Saddle', 'SE-M798', '0', '1', NULL, 500, 375, 17.3782, 39.14, NULL, NULL, NULL, NULL, 1, 'M', 'M', NULL, 15, 80, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '30222244-0fd8-4d28-8448-f2e658bf52bd', clock_timestamp()),
(910, 'HL Mountain Seat/Saddle', 'SE-M940', '0', '1', NULL, 500, 375, 23.3722, 52.64, NULL, NULL, NULL, NULL, 1, 'M', 'H', NULL, 15, 81, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'a96a5024-87de-488a-bf81-bc0c81f6cd18', clock_timestamp()),
(911, 'LL Road Seat/Saddle', 'SE-R581', '0', '1', NULL, 500, 375, 12.0413, 27.12, NULL, NULL, NULL, NULL, 1, 'R', 'L', NULL, 15, 82, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '31b9bc62-792b-4e7a-a24d-411dc76e0271', clock_timestamp()),
(912, 'ML Road Seat/Saddle', 'SE-R908', '0', '1', NULL, 500, 375, 17.3782, 39.14, NULL, NULL, NULL, NULL, 1, 'T', 'M', NULL, 15, 83, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '49845afe-a8cc-4354-a5d4-09d35bf7fb9e', clock_timestamp()),
(913, 'HL Road Seat/Saddle', 'SE-R995', '0', '1', NULL, 500, 375, 23.3722, 52.64, NULL, NULL, NULL, NULL, 1, 'R', 'H', NULL, 15, 84, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '2befe629-4b2a-41a1-a009-df13ead69105', clock_timestamp()),
(914, 'LL Touring Seat/Saddle', 'SE-T312', '0', '1', NULL, 500, 375, 12.0413, 27.12, NULL, NULL, NULL, NULL, 1, 'T', 'L', NULL, 15, 66, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '7874a1d6-7a5b-412f-a2eb-c2f457b9603d', clock_timestamp()),
(915, 'ML Touring Seat/Saddle', 'SE-T762', '0', '1', NULL, 500, 375, 17.3782, 39.14, NULL, NULL, NULL, NULL, 1, 'T', 'M', NULL, 15, 65, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '072acb72-7796-4bd0-9bbb-6efc29ac336c', clock_timestamp()),
(916, 'HL Touring Seat/Saddle', 'SE-T924', '0', '1', NULL, 500, 375, 23.3722, 52.64, NULL, NULL, NULL, NULL, 1, 'T', 'H', NULL, 15, 67, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '0e158724-934d-4a64-991f-94fec00bdea8', clock_timestamp()),
(917, 'LL Mountain Frame - Silver, 42', 'FR-M21S-42', '1', '1', 'Silver', 500, 375, 144.5938, 264.05, '42', 'CM', 'LB', 2.92, 1, 'M', 'L', 'U', 12, 8, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '37bd4d2b-346b-4c6b-8f3f-85c084282529', clock_timestamp()),
(918, 'LL Mountain Frame - Silver, 44', 'FR-M21S-44', '1', '1', 'Silver', 500, 375, 144.5938, 264.05, '44', 'CM', 'LB', 2.96, 1, 'M', 'L', 'U', 12, 8, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '393a4d00-7428-41f0-a48a-af26b00e9a9c', clock_timestamp()),
(919, 'LL Mountain Frame - Silver, 48', 'FR-M21S-48', '1', '1', 'Silver', 500, 375, 144.5938, 264.05, '48', 'CM', 'LB', 3.00, 1, 'M', 'L', 'U', 12, 8, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '8dfef6f2-91a8-4884-8949-b2551218b37a', clock_timestamp()),
(920, 'LL Mountain Frame - Silver, 52', 'FR-M21S-52', '1', '1', 'Silver', 500, 375, 144.5938, 264.05, '52', 'CM', 'LB', 3.04, 1, 'M', 'L', 'U', 12, 8, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'f230baac-5951-4eb1-b1e8-94c2ca2b37fa', clock_timestamp()),
(921, 'Mountain Tire Tube', 'TT-M928', '0', '1', NULL, 500, 375, 1.8663, 4.99, NULL, NULL, NULL, NULL, 0, 'M', NULL, NULL, 37, 92, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '01a8c3fc-ed52-458e-a634-d5b6e2accfed', clock_timestamp()),
(922, 'Road Tire Tube', 'TT-R982', '0', '1', NULL, 500, 375, 1.4923, 3.99, NULL, NULL, NULL, NULL, 0, 'R', NULL, NULL, 37, 93, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'ea442bd7-f69b-42d9-aa71-95e10b648f52', clock_timestamp()),
(923, 'Touring Tire Tube', 'TT-T092', '0', '1', NULL, 500, 375, 1.8663, 4.99, NULL, NULL, NULL, NULL, 0, 'T', NULL, NULL, 37, 94, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '179fec38-cab5-4a47-bcff-31cfc9e43a3c', clock_timestamp()),
(924, 'LL Mountain Frame - Black, 42', 'FR-M21B-42', '1', '1', 'Black', 500, 375, 136.785, 249.79, '42', 'CM', 'LB', 2.92, 1, 'M', 'L', 'U', 12, 8, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'faabd7fb-cb35-4bad-8857-ec71468686ad', clock_timestamp()),
(925, 'LL Mountain Frame - Black, 44', 'FR-M21B-44', '1', '1', 'Black', 500, 375, 136.785, 249.79, '44', 'CM', 'LB', 2.96, 1, 'M', 'L', 'U', 12, 8, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '47ab0300-7b55-4d35-a786-80190976b9b5', clock_timestamp()),
(926, 'LL Mountain Frame - Black, 48', 'FR-M21B-48', '1', '1', 'Black', 500, 375, 136.785, 249.79, '48', 'CM', 'LB', 3.00, 1, 'M', 'L', 'U', 12, 8, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '408435aa-15c0-41e5-981f-32a8226af15f', clock_timestamp()),
(927, 'LL Mountain Frame - Black, 52', 'FR-M21B-52', '1', '1', 'Black', 500, 375, 136.785, 249.79, '52', 'CM', 'LB', 3.04, 1, 'M', 'L', 'U', 12, 8, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '4800f4e6-99ea-4afd-a392-2cb05265d0d4', clock_timestamp()),
(928, 'LL Mountain Tire', 'TI-M267', '0', '1', NULL, 500, 375, 9.3463, 24.99, NULL, NULL, NULL, NULL, 0, 'M', 'L', NULL, 37, 85, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '76060a93-949c-48ea-9b31-a593d6c14983', clock_timestamp()),
(929, 'ML Mountain Tire', 'TI-M602', '0', '1', NULL, 500, 375, 11.2163, 29.99, NULL, NULL, NULL, NULL, 0, 'M', 'M', NULL, 37, 86, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'daff9e11-6254-432d-8c4f-f06e52687184', clock_timestamp()),
(930, 'HL Mountain Tire', 'TI-M823', '0', '1', NULL, 500, 375, 13.09, 35, NULL, NULL, NULL, NULL, 0, 'M', 'H', NULL, 37, 87, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'ddad25f5-0445-4b5c-8466-6446930ad8b8', clock_timestamp()),
(931, 'LL Road Tire', 'TI-R092', '0', '1', NULL, 500, 375, 8.0373, 21.49, NULL, NULL, NULL, NULL, 0, 'R', 'L', NULL, 37, 88, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '15b569a6-d172-42c2-a420-62ab5946cc80', clock_timestamp()),
(932, 'ML Road Tire', 'TI-R628', '0', '1', NULL, 500, 375, 9.3463, 24.99, NULL, NULL, NULL, NULL, 0, 'R', 'M', NULL, 37, 89, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'd1016cc5-c12b-4f05-915c-70fa062e4a64', clock_timestamp()),
(933, 'HL Road Tire', 'TI-R982', '0', '1', NULL, 500, 375, 12.1924, 32.6, NULL, NULL, NULL, NULL, 0, 'R', 'H', NULL, 37, 90, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'c86de56a-5048-4b89-b7c7-56bc75c9bcee', clock_timestamp()),
(934, 'Touring Tire', 'TI-T723', '0', '1', NULL, 500, 375, 10.8423, 28.99, NULL, NULL, NULL, NULL, 0, 'T', NULL, NULL, 37, 91, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '9d5ca300-5302-41e1-bca5-8ce5b93f26a5', clock_timestamp()),
(935, 'LL Mountain Pedal', 'PD-M282', '0', '1', 'Silver/Black', 500, 375, 17.9776, 40.49, NULL, NULL, 'G', 218.00, 1, 'M', 'L', NULL, 13, 62, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '9fdd0c65-b2b0-4c6c-8704-3a9747be5174', clock_timestamp()),
(936, 'ML Mountain Pedal', 'PD-M340', '0', '1', 'Silver/Black', 500, 375, 27.568, 62.09, NULL, NULL, 'G', 215.00, 1, 'M', 'M', NULL, 13, 63, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '274c86dc-439e-4469-9de8-7e9bd6455d0d', clock_timestamp()),
(937, 'HL Mountain Pedal', 'PD-M562', '0', '1', 'Silver/Black', 500, 375, 35.9596, 80.99, NULL, NULL, 'G', 185.00, 1, 'M', 'H', NULL, 13, 64, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'a05464e8-6b4d-42b3-a4d6-8683136f4b66', clock_timestamp()),
(938, 'LL Road Pedal', 'PD-R347', '0', '1', 'Silver/Black', 500, 375, 17.9776, 40.49, NULL, NULL, 'G', 189.00, 1, 'R', 'L', NULL, 13, 68, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '2c7dd8c3-4c55-475f-ba58-f4baca520d72', clock_timestamp()),
(939, 'ML Road Pedal', 'PD-R563', '0', '1', 'Silver/Black', 500, 375, 27.568, 62.09, NULL, NULL, 'G', 168.00, 1, 'R', 'M', NULL, 13, 69, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '216ad46f-bc3f-4862-b0e9-2e261e5a6059', clock_timestamp()),
(940, 'HL Road Pedal', 'PD-R853', '0', '1', 'Silver/Black', 500, 375, 35.9596, 80.99, NULL, NULL, 'G', 149.00, 1, 'R', 'H', NULL, 13, 70, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '44e96967-ab99-41ed-8b41-5bc70a5ca1a9', clock_timestamp()),
(941, 'Touring Pedal', 'PD-T852', '0', '1', 'Silver/Black', 500, 375, 35.9596, 80.99, NULL, NULL, NULL, NULL, 1, 'T', NULL, NULL, 13, 53, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '6967c816-3ebb-45fa-8547-cef00e08573e', clock_timestamp()),
(942, 'ML Mountain Frame-W - Silver, 38', 'FR-M63S-38', '1', '1', 'Silver', 500, 375, 199.3757, 364.09, '38', 'CM', 'LB', 2.73, 2, 'M', 'M', 'W', 12, 15, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'ba3646b0-1487-426e-ab4e-57d42e6f9233', clock_timestamp()),
(943, 'LL Mountain Frame - Black, 40', 'FR-M21B-40', '1', '1', 'Black', 500, 375, 136.785, 249.79, '40', 'CM', 'LB', 2.88, 2, 'M', 'L', 'U', 12, 8, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '3050e4df-2bba-4c2b-bdcc-b4c89972db1c', clock_timestamp()),
(944, 'LL Mountain Frame - Silver, 40', 'FR-M21S-40', '1', '1', 'Silver', 500, 375, 144.5938, 264.05, '40', 'CM', 'LB', 2.88, 2, 'M', 'L', 'U', 12, 8, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '756f862e-40cc-4dfc-b189-716d0dda5ff9', clock_timestamp()),
(945, 'Front Derailleur', 'FD-2342', '1', '1', 'Silver', 500, 375, 40.6216, 91.49, NULL, NULL, 'G', 88.00, 1, NULL, NULL, NULL, 9, 103, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '448e9e7b-9548-4a4c-abb3-853686aa7517', clock_timestamp()),
(946, 'LL Touring Handlebars', 'HB-T721', '1', '1', NULL, 500, 375, 20.464, 46.09, NULL, NULL, NULL, NULL, 1, 'T', 'L', NULL, 4, 47, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'a2f1352e-45d0-42c4-aef3-60033073bb66', clock_timestamp()),
(947, 'HL Touring Handlebars', 'HB-T928', '1', '1', NULL, 500, 375, 40.6571, 91.57, NULL, NULL, NULL, NULL, 1, 'T', 'H', NULL, 4, 48, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'cb524e92-4fa8-4f6c-9993-60796856c654', clock_timestamp()),
(948, 'Front Brakes', 'FB-9873', '0', '1', 'Silver', 500, 375, 47.286, 106.5, NULL, NULL, 'G', 317.00, 1, NULL, NULL, NULL, 6, 102, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'c1813164-1b4b-42d1-9007-4e5f9aee0e19', clock_timestamp()),
(949, 'LL Crankset', 'CS-4759', '1', '1', 'Black', 500, 375, 77.9176, 175.49, NULL, NULL, 'G', 600.00, 1, NULL, 'L', NULL, 8, 99, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '41d47371-4374-46d3-8d61-b07616ec54f0', clock_timestamp()),
(950, 'ML Crankset', 'CS-6583', '1', '1', 'Black', 500, 375, 113.8816, 256.49, NULL, NULL, 'G', 635.00, 1, NULL, 'M', NULL, 8, 100, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'd3a7a02c-a3d5-4a04-9454-0c4e43772b78', clock_timestamp()),
(951, 'HL Crankset', 'CS-9183', '1', '1', 'Black', 500, 375, 179.8156, 404.99, NULL, NULL, 'G', 575.00, 1, NULL, 'H', NULL, 8, 101, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '2c4a8956-7b72-48fe-b028-699e117b1daa', clock_timestamp()),
(952, 'Chain', 'CH-0234', '0', '1', 'Silver', 500, 375, 8.9866, 20.24, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 7, 98, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '5d27e2a5-27ec-4ccb-ba2c-fc980ffe6708', clock_timestamp()),
(953, 'Touring-2000 Blue, 60', 'BK-T44U-60', '1', '1', 'Blue', 100, 75, 755.1508, 1214.85, '60', 'CM', 'LB', 27.90, 4, 'T', 'M', 'U', 3, 35, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'f1bb3957-8d27-47f3-91ec-c71822d11436', clock_timestamp()),
(954, 'Touring-1000 Yellow, 46', 'BK-T79Y-46', '1', '1', 'Yellow', 100, 75, 1481.9379, 2384.07, '46', 'CM', 'LB', 25.13, 4, 'T', 'H', 'U', 3, 34, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '83b77413-8c8a-4af1-93e4-136edb7ff15f', clock_timestamp()),
(955, 'Touring-1000 Yellow, 50', 'BK-T79Y-50', '1', '1', 'Yellow', 100, 75, 1481.9379, 2384.07, '50', 'CM', 'LB', 25.42, 4, 'T', 'H', 'U', 3, 34, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '5ec991ad-8761-4a61-a318-312df3a78604', clock_timestamp()),
(956, 'Touring-1000 Yellow, 54', 'BK-T79Y-54', '1', '1', 'Yellow', 100, 75, 1481.9379, 2384.07, '54', 'CM', 'LB', 25.68, 4, 'T', 'H', 'U', 3, 34, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '1220b0f0-064d-46b7-8507-1fa758b77b9c', clock_timestamp()),
(957, 'Touring-1000 Yellow, 60', 'BK-T79Y-60', '1', '1', 'Yellow', 100, 75, 1481.9379, 2384.07, '60', 'CM', 'LB', 25.90, 4, 'T', 'H', 'U', 3, 34, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'bcd1a5a9-6140-4dc9-9620-689dc7e4c155', clock_timestamp()),
(958, 'Touring-3000 Blue, 54', 'BK-T18U-54', '1', '1', 'Blue', 100, 75, 461.4448, 742.35, '54', 'CM', 'LB', 29.68, 4, 'T', 'L', 'U', 3, 36, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'a3ee6897-52fe-42e4-92ec-7a91e7bb905a', clock_timestamp()),
(959, 'Touring-3000 Blue, 58', 'BK-T18U-58', '1', '1', 'Blue', 100, 75, 461.4448, 742.35, '58', 'CM', 'LB', 29.90, 4, 'T', 'L', 'U', 3, 36, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '23d89cee-9f44-4f3e-b289-63de6ba2b737', clock_timestamp()),
(960, 'Touring-3000 Blue, 62', 'BK-T18U-62', '1', '1', 'Blue', 100, 75, 461.4448, 742.35, '62', 'CM', 'LB', 30.00, 4, 'T', 'L', 'U', 3, 36, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '060192c9-bcd9-4260-b729-d6bcfadfb08e', clock_timestamp()),
(961, 'Touring-3000 Yellow, 44', 'BK-T18Y-44', '1', '1', 'Yellow', 100, 75, 461.4448, 742.35, '44', 'CM', 'LB', 28.77, 4, 'T', 'L', 'U', 3, 36, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '5646c15a-68ad-4234-b328-254706cbccc5', clock_timestamp()),
(962, 'Touring-3000 Yellow, 50', 'BK-T18Y-50', '1', '1', 'Yellow', 100, 75, 461.4448, 742.35, '50', 'CM', 'LB', 29.13, 4, 'T', 'L', 'U', 3, 36, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'df85e805-af87-4fab-a668-c80f2a5b8a69', clock_timestamp()),
(963, 'Touring-3000 Yellow, 54', 'BK-T18Y-54', '1', '1', 'Yellow', 100, 75, 461.4448, 742.35, '54', 'CM', 'LB', 29.42, 4, 'T', 'L', 'U', 3, 36, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '192becd1-f465-4194-88a2-ee57fed3a3c5', clock_timestamp()),
(964, 'Touring-3000 Yellow, 58', 'BK-T18Y-58', '1', '1', 'Yellow', 100, 75, 461.4448, 742.35, '58', 'CM', 'LB', 29.79, 4, 'T', 'L', 'U', 3, 36, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'bed79f64-a53d-44a3-ace8-2baa425a5a54', clock_timestamp()),
(965, 'Touring-3000 Yellow, 62', 'BK-T18Y-62', '1', '1', 'Yellow', 100, 75, 461.4448, 742.35, '62', 'CM', 'LB', 30.00, 4, 'T', 'L', 'U', 3, 36, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'd28b3872-5173-40a4-b12f-655524386cc7', clock_timestamp()),
(966, 'Touring-1000 Blue, 46', 'BK-T79U-46', '1', '1', 'Blue', 100, 75, 1481.9379, 2384.07, '46', 'CM', 'LB', 25.13, 4, 'T', 'H', 'U', 3, 34, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '86990d54-6efb-4c53-9974-6c3b0297e222', clock_timestamp()),
(967, 'Touring-1000 Blue, 50', 'BK-T79U-50', '1', '1', 'Blue', 100, 75, 1481.9379, 2384.07, '50', 'CM', 'LB', 25.42, 4, 'T', 'H', 'U', 3, 34, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '68c0a818-2985-46eb-8255-0fb70919fa24', clock_timestamp()),
(968, 'Touring-1000 Blue, 54', 'BK-T79U-54', '1', '1', 'Blue', 100, 75, 1481.9379, 2384.07, '54', 'CM', 'LB', 25.68, 4, 'T', 'H', 'U', 3, 34, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '12280a8c-7578-4367-ba71-214bcc1e4792', clock_timestamp()),
(969, 'Touring-1000 Blue, 60', 'BK-T79U-60', '1', '1', 'Blue', 100, 75, 1481.9379, 2384.07, '60', 'CM', 'LB', 25.90, 4, 'T', 'H', 'U', 3, 34, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'dd70cf36-449a-43fd-839d-a84ee14c849a', clock_timestamp()),
(970, 'Touring-2000 Blue, 46', 'BK-T44U-46', '1', '1', 'Blue', 100, 75, 755.1508, 1214.85, '46', 'CM', 'LB', 27.13, 4, 'T', 'M', 'U', 3, 35, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'c0009006-715f-4b76-a05a-1a0d3adfb49a', clock_timestamp()),
(971, 'Touring-2000 Blue, 50', 'BK-T44U-50', '1', '1', 'Blue', 100, 75, 755.1508, 1214.85, '50', 'CM', 'LB', 27.42, 4, 'T', 'M', 'U', 3, 35, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '84abda8f-0007-4bca-9a61-b2dea58866c3', clock_timestamp()),
(972, 'Touring-2000 Blue, 54', 'BK-T44U-54', '1', '1', 'Blue', 100, 75, 755.1508, 1214.85, '54', 'CM', 'LB', 27.68, 4, 'T', 'M', 'U', 3, 35, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '6dcfe2a3-3555-44e4-9116-6f6dbe448b8b', clock_timestamp()),
(973, 'Road-350-W Yellow, 40', 'BK-R79Y-40', '1', '1', 'Yellow', 100, 75, 1082.51, 1700.99, '40', 'CM', 'LB', 15.35, 4, 'R', 'M', 'W', 2, 27, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '237b16d9-53f2-4fd4-befe-48209e57aec3', clock_timestamp()),
(974, 'Road-350-W Yellow, 42', 'BK-R79Y-42', '1', '1', 'Yellow', 100, 75, 1082.51, 1700.99, '42', 'CM', 'LB', 15.77, 4, 'R', 'M', 'W', 2, 27, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '80bd3f8b-42c7-43d8-91f5-9fb6175287af', clock_timestamp()),
(975, 'Road-350-W Yellow, 44', 'BK-R79Y-44', '1', '1', 'Yellow', 100, 75, 1082.51, 1700.99, '44', 'CM', 'LB', 16.13, 4, 'R', 'M', 'W', 2, 27, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '0c61e8af-003d-4e4b-b5b7-02f01a26be26', clock_timestamp()),
(976, 'Road-350-W Yellow, 48', 'BK-R79Y-48', '1', '1', 'Yellow', 100, 75, 1082.51, 1700.99, '48', 'CM', 'LB', 16.42, 4, 'R', 'M', 'W', 2, 27, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'ec4284dc-85fa-44a8-89ec-77fc9b71720a', clock_timestamp()),
(977, 'Road-750 Black, 58', 'BK-R19B-58', '1', '1', 'Black', 100, 75, 343.6496, 539.99, '58', 'CM', 'LB', 20.79, 4, 'R', 'L', 'U', 2, 31, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '87b81a1a-a5b5-43d2-a20d-0230800490b9', clock_timestamp()),
(978, 'Touring-3000 Blue, 44', 'BK-T18U-44', '1', '1', 'Blue', 100, 75, 461.4448, 742.35, '44', 'CM', 'LB', 28.77, 4, 'T', 'L', 'U', 3, 36, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '4f638e15-2ed0-4193-90ce-47da580e01dd', clock_timestamp()),
(979, 'Touring-3000 Blue, 50', 'BK-T18U-50', '1', '1', 'Blue', 100, 75, 461.4448, 742.35, '50', 'CM', 'LB', 29.13, 4, 'T', 'L', 'U', 3, 36, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'de305b62-88fc-465b-b23d-d8c0f7e6d361', clock_timestamp()),
(980, 'Mountain-400-W Silver, 38', 'BK-M38S-38', '1', '1', 'Silver', 100, 75, 419.7784, 769.49, '38', 'CM', 'LB', 26.35, 4, 'M', 'M', 'W', 1, 22, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '7a927632-99a4-4f24-adce-0062d2d113d9', clock_timestamp()),
(981, 'Mountain-400-W Silver, 40', 'BK-M38S-40', '1', '1', 'Silver', 100, 75, 419.7784, 769.49, '40', 'CM', 'LB', 26.77, 4, 'M', 'M', 'W', 1, 22, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '0a72791c-a984-4733-ae4e-2b4373cfd7cd', clock_timestamp()),
(982, 'Mountain-400-W Silver, 42', 'BK-M38S-42', '1', '1', 'Silver', 100, 75, 419.7784, 769.49, '42', 'CM', 'LB', 27.13, 4, 'M', 'M', 'W', 1, 22, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '4ea4fe06-aaea-42d4-a9d9-69f6a9a4a042', clock_timestamp()),
(983, 'Mountain-400-W Silver, 46', 'BK-M38S-46', '1', '1', 'Silver', 100, 75, 419.7784, 769.49, '46', 'CM', 'LB', 27.42, 4, 'M', 'M', 'W', 1, 22, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '0b0c8ee4-ff2d-438e-9cac-464783b86191', clock_timestamp()),
(984, 'Mountain-500 Silver, 40', 'BK-M18S-40', '1', '1', 'Silver', 100, 75, 308.2179, 564.99, '40', 'CM', 'LB', 27.35, 4, 'M', 'L', 'U', 1, 23, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'b96c057b-6416-4851-8d59-bcb37c8e6e51', clock_timestamp()),
(985, 'Mountain-500 Silver, 42', 'BK-M18S-42', '1', '1', 'Silver', 100, 75, 308.2179, 564.99, '42', 'CM', 'LB', 27.77, 4, 'M', 'L', 'U', 1, 23, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'b8d1b5d9-8a39-4097-a04a-56e95559b534', clock_timestamp()),
(986, 'Mountain-500 Silver, 44', 'BK-M18S-44', '1', '1', 'Silver', 100, 75, 308.2179, 564.99, '44', 'CM', 'LB', 28.13, 4, 'M', 'L', 'U', 1, 23, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'e8cec794-e8e2-4312-96a7-4832e573d3fc', clock_timestamp()),
(987, 'Mountain-500 Silver, 48', 'BK-M18S-48', '1', '1', 'Silver', 100, 75, 308.2179, 564.99, '48', 'CM', 'LB', 28.42, 4, 'M', 'L', 'U', 1, 23, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '77ef419f-481f-40b9-bdb9-7e6678e550e3', clock_timestamp()),
(988, 'Mountain-500 Silver, 52', 'BK-M18S-52', '1', '1', 'Silver', 100, 75, 308.2179, 564.99, '52', 'CM', 'LB', 28.68, 4, 'M', 'L', 'U', 1, 23, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'cad60945-183e-4ab3-a70c-3f5bac6bf134', clock_timestamp()),
(989, 'Mountain-500 Black, 40', 'BK-M18B-40', '1', '1', 'Black', 100, 75, 294.5797, 539.99, '40', 'CM', 'LB', 27.35, 4, 'M', 'L', 'U', 1, 23, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '28287157-3f06-487b-8531-bee8a37329e4', clock_timestamp()),
(990, 'Mountain-500 Black, 42', 'BK-M18B-42', '1', '1', 'Black', 100, 75, 294.5797, 539.99, '42', 'CM', 'LB', 27.77, 4, 'M', 'L', 'U', 1, 23, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'f5752c9c-56ba-41a7-83fd-139da28c15fa', clock_timestamp()),
(991, 'Mountain-500 Black, 44', 'BK-M18B-44', '1', '1', 'Black', 100, 75, 294.5797, 539.99, '44', 'CM', 'LB', 28.13, 4, 'M', 'L', 'U', 1, 23, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'c7852127-2fb8-4959-b5a3-de5a8d6445e4', clock_timestamp()),
(992, 'Mountain-500 Black, 48', 'BK-M18B-48', '1', '1', 'Black', 100, 75, 294.5797, 539.99, '48', 'CM', 'LB', 28.42, 4, 'M', 'L', 'U', 1, 23, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '75752e26-a3b6-4264-9b06-f23a4fbdc5a7', clock_timestamp()),
(993, 'Mountain-500 Black, 52', 'BK-M18B-52', '1', '1', 'Black', 100, 75, 294.5797, 539.99, '52', 'CM', 'LB', 28.68, 4, 'M', 'L', 'U', 1, 23, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '69ee3b55-e142-4e4f-aed8-af02978fbe87', clock_timestamp()),
(994, 'LL Bottom Bracket', 'BB-7421', '1', '1', NULL, 500, 375, 23.9716, 53.99, NULL, NULL, 'G', 223.00, 1, NULL, 'L', NULL, 5, 95, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'fa3c65cd-0a22-47e3-bdf6-53f1dc138c43', clock_timestamp()),
(995, 'ML Bottom Bracket', 'BB-8107', '1', '1', NULL, 500, 375, 44.9506, 101.24, NULL, NULL, 'G', 168.00, 1, NULL, 'M', NULL, 5, 96, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '71ab847f-d091-42d6-b735-7b0c2d82fc84', clock_timestamp()),
(996, 'HL Bottom Bracket', 'BB-9108', '1', '1', NULL, 500, 375, 53.9416, 121.49, NULL, NULL, 'G', 170.00, 1, NULL, 'H', NULL, 5, 97, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '230c47c5-08b2-4ce3-b706-69c0bdd62965', clock_timestamp()),
(997, 'Road-750 Black, 44', 'BK-R19B-44', '1', '1', 'Black', 100, 75, 343.6496, 539.99, '44', 'CM', 'LB', 19.77, 4, 'R', 'L', 'U', 2, 31, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '44ce4802-409f-43ab-9b27-ca53421805be', clock_timestamp()),
(998, 'Road-750 Black, 48', 'BK-R19B-48', '1', '1', 'Black', 100, 75, 343.6496, 539.99, '48', 'CM', 'LB', 20.13, 4, 'R', 'L', 'U', 2, 31, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, '3de9a212-1d49-40b6-b10a-f564d981dbde', clock_timestamp()),
(999, 'Road-750 Black, 52', 'BK-R19B-52', '1', '1', 'Black', 100, 75, 343.6496, 539.99, '52', 'CM', 'LB', 20.42, 4, 'R', 'L', 'U', 2, 31, CAST('2013-05-30 00:00:00' AS TIMESTAMP), NULL, NULL, 'ae638923-2b67-4679-b90e-abbab17dca31', clock_timestamp());
-- SET IDENTITY_INSERT [dbo].[Product] OFF;
INSERT INTO bobsusedbookstore_dbo.members (;
    customerid, firstname, lastname, email, phone, registrationdate
) VALUES
(1, 'Alice', 'Cooper', 'alice.cooper@example.com', '1112223333', '2022-06-01'),
(2, 'Bob', 'Marley', 'bob.marley@example.com', '4445556666', '2022-06-02'),
(3, 'Charlie', 'Brown', 'charlie.brown@example.com', '7778889999', '2022-06-03'),
(4, 'David', 'Bowie', 'david.bowie@example.com', '1234567890', '2022-06-04'),
(5, 'Eve', 'Jackson', 'eve.jackson@example.com', '9876543210', '2022-06-05'),
(6, 'Frank', 'Sinatra', 'frank.sinatra@example.com', '5555555555', '2022-06-06'),
(7, 'Grace', 'Kelly', 'grace.kelly@example.com', '1112223333', '2022-06-07'),
(8, 'Harry', 'Potter', 'harry.potter@example.com', '4445556666', '2022-06-08'),
(9, 'Ivy', 'Smith', 'ivy.smith@example.com', '7778889999', '2022-06-09'),
(10, 'Jack', 'Nicholson', 'jack.nicholson@example.com', '1234567890', '2022-06-10'),
(11, 'Kate', 'Winslet', 'kate.winslet@example.com', '9876543210', '2022-06-11'),
(12, 'Leo', 'DiCaprio', 'leo.dicaprio@example.com', '5555555555', '2022-06-12'),
(13, 'Meryl', 'Streep', 'meryl.streep@example.com', '1112223333', '2022-06-13'),
(14, 'Natalie', 'Portman', 'natalie.portman@example.com', '4445556666', '2022-06-14'),
(15, 'Oprah', 'Winfrey', 'oprah.winfrey@example.com', '7778889999', '2022-06-15'),
(16, 'Paul', 'Newman', 'paul.newman@example.com', '1234567890', '2022-06-16'),
(17, 'Queen', 'Elizabeth', 'queen.elizabeth@example.com', '9876543210', '2022-06-17'),
(18, 'Robert', 'DeNiro', 'robert.deniro@example.com', '5555555555', '2022-06-18'),
(19, 'Scarlett', 'Johansson', 'scarlett.johansson@example.com', '1112223333', '2022-06-19'),
(20, 'Tom', 'Hanks', 'tom.hanks@example.com', '4445556666', '2022-06-20');
INSERT INTO bobsusedbookstore_dbo.shopping (;
    orderid, customerid, orderdate, totalamount, status
) VALUES
    (1, 1, '2022-01-10', 100.00, 'Delivered'),
    (2, 2, '2022-02-20', 75.50, 'Shipped'),
    (3, 3, '2022-03-25', 200.75, 'Processing'),
    (4, 4, '2022-04-15', 50.25, 'Pending'),
    (5, 5, '2022-05-30', 125.00, 'Cancelled'),
    (6, 6, '2022-06-05', 80.00, 'Delivered'),
    (7, 7, '2022-06-10', 90.00, 'Refund Requested'),
    (8, 8, '2022-07-01', 120.50, 'Delivered'),
    (9, 9, '2022-07-15', 65.75, 'Shipped'),
    (10, 10, '2022-08-10', 180.25, 'Processing'),
    (11, 11, '2022-08-20', 95.00, 'Pending'),
    (12, 12, '2022-09-05', 110.50, 'Cancelled'),
    (13, 13, '2022-09-15', 75.25, 'Delivered'),
    (14, 14, '2022-10-01', 85.00, 'Shipped'),
    (15, 15, '2022-10-10', 95.75, 'Processing'),
    (16, 16, '2022-11-01', 60.50, 'Pending'),
    (17, 17, '2022-11-15', 125.25, 'Cancelled'),
    (18, 18, '2022-12-01', 90.00, 'Delivered'),
    (19, 19, '2022-12-10', 105.50, 'Shipped'),
    (20, 1, '2022-12-20', 80.75, 'Processing'),
    (21, 2, '2023-01-05', 65.25, 'Pending'),
    (22, 3, '2023-01-15', 110.00, 'Cancelled'),
    (23, 4, '2023-02-01', 95.50, 'Refund Requested'),
    (24, 5, '2023-02-10', 85.75, 'Shipped'),
    (25, 6, '2023-03-01', 120.25, 'Processing'),
    (26, 7, '2023-03-15', 75.00, 'Pending'),
    (27, 8, '2023-04-01', 105.50, 'Cancelled'),
    (28, 9, '2023-04-10', 90.25, 'Delivered'),
    (29, 10, '2023-05-01', 80.00, 'Shipped'),
    (30, 11, '2023-05-15', 95.75, 'Processing'),
    (31, 12, '2023-06-01', 65.50, 'Pending'),
    (32, 13, '2023-06-10', 110.25, 'Cancelled'),
    (33, 14, '2023-07-01', 85.00, 'Delivered'),
    (34, 15, '2023-07-15', 75.50, 'Shipped'),
    (35, 16, '2023-08-01', 100.75, 'Processing'),
    (36, 17, '2023-08-10', 60.25, 'Pending'),
    (37, 18, '2023-09-01', 125.00, 'Cancelled'),
    (38, 19, '2023-09-15', 90.50, 'Refund Requested'),
    (39, 1, '2023-10-01', 105.75, 'Shipped'),
    (40, 2, '2023-10-10', 80.25, 'Processing'),
    (41, 3, '2023-11-01', 95.00, 'Pending'),
    (42, 4, '2023-11-15', 110.50, 'Cancelled'),
    (43, 5, '2023-12-01', 85.25, 'Delivered'),
    (44, 6, '2023-12-10', 75.00, 'Shipped'),
    (45, 7, '2024-01-01', 100.75, 'Processing'),
    (46, 8, '2024-01-15', 65.50, 'Pending'),
    (47, 9, '2024-02-01', 120.25, 'Cancelled'),
    (48, 10, '2024-02-10', 90.00, 'Delivered'),
    (49, 11, '2024-03-01', 105.50, 'Shipped'),
    (50, 12, '2024-03-15', 80.75, 'Processing'),
    (51, 13, '2024-04-01', 95.25, 'Pending'),
    (52, 14, '2024-04-10', 110.00, 'Cancelled'),
    (53, 15, '2024-05-01', 85.50, 'Delivered'),
    (54, 16, '2024-05-15', 75.75, 'Shipped'),
    (55, 17, '2024-06-01', 100.25, 'Processing'),
    (56, 18, '2024-06-10', 60.00, 'Pending'),
    (57, 19, '2024-07-01', 125.50, 'Cancelled'),
    (58, 1, '2024-07-15', 90.25, 'Delivered'),
    (59, 2, '2024-08-01', 105.00, 'Shipped'),
    (60, 3, '2024-08-10', 80.75, 'Processing'),
    (61, 4, '2024-09-01', 95.50, 'Pending'),
    (62, 5, '2024-09-15', 110.25, 'Cancelled'),
    (63, 6, '2024-10-01', 85.00, 'Delivered'),
    (64, 7, '2024-10-10', 75.50, 'Shipped'),
    (65, 8, '2024-11-01', 100.75, 'Processing'),
    (66, 9, '2024-11-15', 65.25, 'Pending'),
    (67, 10, '2024-12-01', 120.00, 'Cancelled'),
    (68, 11, '2024-12-10', 90.50, 'Delivered'),
    (69, 12, '2025-01-01', 105.75, 'Shipped'),
    (70, 13, '2025-01-15', 80.25, 'Processing'),
    (71, 14, '2025-02-01', 95.00, 'Pending'),
    (72, 15, '2025-02-10', 110.50, 'Cancelled'),
    (73, 16, '2025-03-01', 85.25, 'Delivered'),
    (74, 17, '2025-03-15', 75.00, 'Shipped'),
    (75, 18, '2025-04-01', 100.75, 'Processing'),
    (76, 19, '2025-04-10', 65.50, 'Pending'),
    (77, 1, '2025-05-01', 120.25, 'Cancelled'),
    (78, 2, '2025-05-15', 90.00, 'Delivered'),
    (79, 3, '2025-06-01', 105.50, 'Shipped'),
    (80, 4, '2025-06-10', 80.75, 'Processing'),
    (81, 5, '2025-07-01', 95.25, 'Pending'),
    (82, 6, '2025-07-15', 110.00, 'Cancelled'),
    (83, 7, '2025-08-01', 85.50, 'Delivered'),
    (84, 8, '2025-08-10', 75.75, 'Shipped'),
    (85, 9, '2025-09-01', 100.25, 'Processing'),
    (86, 10, '2025-09-15', 60.00, 'Pending'),
    (87, 11, '2025-10-01', 125.50, 'Cancelled'),
    (88, 12, '2025-10-10', 90.25, 'Delivered'),
    (89, 13, '2025-11-01', 105.00, 'Shipped'),
    (90, 14, '2025-11-15', 80.75, 'Processing'),
    (91, 15, '2025-12-01', 95.50, 'Pending'),
    (92, 16, '2025-12-10', 110.25, 'Cancelled'),
    (93, 17, '2026-01-01', 85.00, 'Delivered'),
    (94, 18, '2026-01-15', 75.50, 'Shipped'),
    (95, 19, '2026-02-01', 100.75, 'Processing');
INSERT INTO bobsusedbookstore_dbo.coupons (;
    ticketid, customerid, orderid, issuedescription, createddate, resolveddate, status, osuser
) VALUES 
(1, 1, 1, 'Item was damaged during shipping', '2022-01-15', '2022-01-20', 'Closed', CURRENT_USER),
(2, 2, 2, 'Order not received yet', '2022-02-25', NULL, 'Open', CURRENT_USER),
(3, 3, 3, 'Wrong item shipped', '2022-03-28', '2022-04-01', 'Closed', CURRENT_USER),
(4, 4, 4, 'Order placed by mistake', '2022-04-16', NULL, 'Open', CURRENT_USER),
(5, 5, 5, 'Change of mind', '2022-05-31', '2022-06-02', 'Closed', CURRENT_USER),
(6, 6, 6, 'Missing parts', '2022-06-10', NULL, 'Open', CURRENT_USER),
(7, 7, 7, 'Defective product', '2022-07-05', '2022-07-12', 'Closed', CURRENT_USER),
(8, 8, 8, 'Late delivery', '2022-08-22', NULL, 'Open', CURRENT_USER),
(9, 9, 9, 'Incorrect order', '2022-09-03', '2022-09-08', 'Closed', CURRENT_USER),
(10, 10, 10, 'Damaged packaging', '2022-10-18', NULL, 'Open', CURRENT_USER),
(11, 11, 11, 'Missing accessories', '2022-11-25', '2022-12-02', 'Closed', CURRENT_USER),
(12, 12, 12, 'Delivery address issue', '2022-12-15', NULL, 'Open', CURRENT_USER),
(13, 13, 13, 'Product not as described', '2023-01-10', NULL, 'Open', CURRENT_USER),
(14, 14, 14, 'Item out of stock', '2023-02-03', '2023-02-08', 'Closed', CURRENT_USER),
(15, 15, 15, 'Billing error', '2023-03-20', NULL, 'Open', CURRENT_USER),
(16, 16, 16, 'Warranty claim', '2023-04-12', NULL, 'Open', CURRENT_USER),
(17, 17, 17, 'Refund request', '2023-05-05', '2023-05-10', 'Closed', CURRENT_USER),
(18, 18, 18, 'Exchange request', '2023-06-22', NULL, 'Open', CURRENT_USER),
(19, 19, 19, 'Delivery delay', '2023-07-15', NULL, 'Open', CURRENT_USER),
(20, 10, 20, 'Technical support needed', '2023-08-08', '2023-08-12', 'Closed', CURRENT_USER),
(21, 11, 21, 'Product compatibility issue', '2023-09-25', NULL, 'Open', CURRENT_USER),
(22, 12, 22, 'Incorrect pricing', '2023-10-18', '2023-10-22', 'Closed', CURRENT_USER),
(23, 13, 23, 'Defective software', '2023-11-10', NULL, 'Open', CURRENT_USER),
(24, 14, 24, 'Shipping cost dispute', '2023-12-03', '2023-12-08', 'Closed', CURRENT_USER),
(25, 15, 25, 'Return policy issue', '2024-01-20', NULL, 'Open', CURRENT_USER),
(26, 16, 26, 'Damaged during transit', '2024-02-12', '2024-02-18', 'Closed', CURRENT_USER),
(27, 17, 27, 'Incorrect quantity received', '2024-03-05', NULL, 'Open', CURRENT_USER),
(28, 18, 28, 'Unauthorized purchase', '2024-04-22', '2024-04-27', 'Closed', CURRENT_USER),
(29, 19, 29, 'Subscription cancellation', '2024-05-15', NULL, 'Open', CURRENT_USER),
(30, 10, 30, 'Installation assistance needed', '2024-06-08', '2024-06-13', 'Closed', CURRENT_USER),
(31, 1, 31, 'Warranty expired', '2024-07-25', NULL, 'Open', CURRENT_USER),
(32, 2, 32, 'Product recall', '2024-08-18', '2024-08-23', 'Closed', CURRENT_USER),
(33, 3, 33, 'Delivery to wrong address', '2024-09-10', NULL, 'Open', CURRENT_USER),
(34, 4, 34, 'Duplicate order', '2024-10-03', '2024-10-08', 'Closed', CURRENT_USER),
(35, 5, 35, 'Missing user manual', '2024-11-20', NULL, 'Open', CURRENT_USER),
(36, 6, 36, 'Damaged during assembly', '2024-12-13', '2024-12-18', 'Closed', CURRENT_USER),
(37, 7, 37, 'Incorrect model received', '2025-01-05', NULL, 'Open', CURRENT_USER),
(38, 8, 38, 'Payment issue', '2025-02-22', '2025-02-27', 'Closed', CURRENT_USER),
(39, 9, 39, 'Missing parts for installation', '2025-03-17', NULL, 'Open', CURRENT_USER),
(40, 10, 40, 'Product defect', '2025-04-09', '2025-04-14', 'Closed', CURRENT_USER),
(41, 11, 41, 'Delayed shipping', '2025-05-26', NULL, 'Open', CURRENT_USER),
(42, 12, 42, 'Accessory not included', '2025-06-19', '2025-06-24', 'Closed', CURRENT_USER),
(43, 13, 43, 'Incorrect color received', '2025-07-12', NULL, 'Open', CURRENT_USER),
(44, 14, 44, 'Damaged during installation', '2025-08-04', '2025-08-09', 'Closed', CURRENT_USER),
(45, 15, 45, 'Refund processing delay', '2025-09-21', NULL, 'Open', CURRENT_USER),
(46, 16, 46, 'Product compatibility question', '2025-10-14', '2025-10-19', 'Closed', CURRENT_USER),
(47, 17, 47, 'Incorrect size received', '2025-11-06', NULL, 'Open', CURRENT_USER),
(48, 18, 48, 'Unauthorized charge', '2025-12-23', '2025-12-28', 'Closed', CURRENT_USER),
(49, 19, 49, 'Delivery address change', '2026-01-16', NULL, 'Open', CURRENT_USER),
(50, 10, 50, 'Missing promotional item', '2026-02-08', '2026-02-13', 'Closed', CURRENT_USER),
(51, 1, 51, 'Incorrect product description', '2026-03-27', NULL, 'Open', CURRENT_USER),
(52, 2, 52, 'Damaged during return', '2026-04-19', '2026-04-24', 'Closed', CURRENT_USER),
(53, 3, 53, 'Unsatisfactory customer service', '2026-05-12', NULL, 'Open', CURRENT_USER),
(54, 4, 54, 'Product discontinued', '2026-06-04', '2026-06-09', 'Closed', CURRENT_USER);
INSERT INTO bobsusedbookstore_dbo.productsaleregions (;
    regionid, regionname
) VALUES
    ('1', 'North America'),
    ('2', 'Europe'),
    ('3', 'Asia'),
    ('4', 'South America'),
    ('5', 'Africa'),
    ('6', 'Australia'),
    ('7', 'Middle East'),
    ('8', 'Central America'),
    ('9', 'Eastern Europe'),
    ('10', 'Western Europe');
INSERT INTO bobsusedbookstore_dbo.productsales (;
    saleid, productid, saledate, quantity, unitprice, totalamount, customerid, saleprice, regionid
) VALUES
    ('334', '229', '2004-07-24', 3, 399.99, 3142.85, 385, 416.03, 8),
    ('335', '219', '2023-08-24', 1, 1299.73, 1267.45, 336, 1425.85, 5),
    ('336', '247', '2024-09-01', 3, 339.99, 336.62, 362, 361.74, 8),
    ('337', '257', '2024-06-20', 2, 84.95, 733.41, 233, 83.68, 4),
    ('338', '218', '2024-09-26', 9, 1388.89, 8497.62, 748, 1459.98, 1),
    ('339', '220', '2023-05-15', 4, 899.99, 3599.96, 400, 912.00, 2),
    ('340', '221', '2024-02-28', 2, 1199.99, 2399.98, 401, 1224.00, 3),
    ('341', '222', '2022-11-30', 6, 499.99, 2999.94, 402, 528.00, 4),
    ('342', '223', '2023-09-01', 3, 699.99, 2099.97, 403, 720.00, 5),
    ('343', '224', '2024-04-15', 5, 399.99, 1999.95, 404, 416.00, 6),
    ('344', '225', '2022-12-25', 8, 249.99, 1999.92, 405, 264.00, 7),
    ('345', '226', '2023-07-10', 7, 349.99, 2449.93, 406, 368.00, 8),
    ('346', '227', '2024-03-20', 4, 599.99, 2399.96, 407, 624.00, 9),
    ('347', '228', '2022-10-05', 9, 199.99, 1799.91, 408, 216.00, 10),
    ('348', '229', '2023-06-18', 6, 399.99, 2399.94, 409, 416.00, 1);