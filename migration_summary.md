# SQL Server to PostgreSQL Migration Summary

## Overview
Migration of BobsBookstore .NET ADO application from Microsoft SQL Server to PostgreSQL.

## Migration Statistics

| Metric | Count |
|--------|-------|
| Total SQL statements processed | 20 |
| DMS MCP tool conversions attempted | 20 |
| DMS MCP tool conversions successful | 0 |
| DMS MCP tool conversions failed | 20 |
| Manual conversions (DMS failure) | 20 |
| Equivalency validations attempted | 20 |
| Equivalency status: EQUIVALENT | 0 |
| Equivalency status: NOT_EQUIVALENT | 0 |
| Equivalency status: ERROR | 20 |

## DMS Tool Status
All 20 DMS conversion attempts failed with the same error:
```
Metadata model creation failed: No objects were found according to the specified selection rules.
```
This is a persistent configuration issue with the DMS migration project's metadata model. All 20 statements were attempted through the DMS MCP tool (dms-mcp___statement_conversion_tool) with parameters:
- migration_project_identifier: arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI
- database_name: BobsBookstore
- schema_name: dbo
- region: us-east-1
- server_name: 172.31.93.178

Manual conversions were applied following the DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA policy.

## Equivalency Tool Status
All 20 equivalency validation attempts returned ERROR with:
```
{"equivalence_status": "ERROR", "error": "'uniqueID'"}
```
This is a persistent infrastructure issue with the SQL Equivalency tool. All 20 statement pairs were individually attempted through the sql-equivalency___validate_sql_equivalence tool (error on one does not affect others). No agent judgment was used to determine equivalency - all statuses come exclusively from the tool output.

## Complete Statement Listing

| # | Source File | Original (MS SQL) | Converted (PostgreSQL) | DMS Status | Equivalency |
|---|-----------|-------------------|----------------------|------------|-------------|
| 1 | AuthorsController.cs | EXEC uspUpdateAuthorPersonalInfo | SELECT dbo.uspupdateauthorpersonalinfo() | FAILED | ERROR |
| 2 | AuthorsController.cs | SELECT * FROM [dbo].[Author] | SELECT * FROM bobsbookstore_dbo.author | FAILED | ERROR |
| 3 | AuthorsController.cs | EXEC uspDeleteAuthor | SELECT dbo.uspdeleteauthor() | FAILED | ERROR |
| 4 | AuthorsController.cs | SELECT with CONVERT/DATEDIFF | SELECT with TO_CHAR/EXTRACT/AGE | FAILED | ERROR |
| 5 | ProductsController.cs | EXEC uspGetProductData | SELECT * FROM dbo.uspgetproductdata() | FAILED | ERROR |
| 6 | db/adven.sql | CREATE TABLE [dbo].[Author] | CREATE TABLE dbo.author | FAILED | ERROR |
| 7 | db/adven.sql | CREATE TABLE [dbo].[Product] | CREATE TABLE dbo.product | FAILED | ERROR |
| 8 | db/adven.sql | CREATE TABLE [dbo].[Members] | CREATE TABLE dbo.members | FAILED | ERROR |
| 9 | db/adven.sql | CREATE PROCEDURE uspGetProductData | CREATE OR REPLACE FUNCTION dbo.uspgetproductdata() | FAILED | ERROR |
| 10 | db/adven.sql | CREATE PROCEDURE uspUpdateAuthorPersonalInfo | CREATE OR REPLACE FUNCTION dbo.uspupdateauthorpersonalinfo() | FAILED | ERROR |
| 11 | db/adven.sql | CREATE PROCEDURE uspDeleteAuthor | CREATE OR REPLACE FUNCTION dbo.uspdeleteauthor() | FAILED | ERROR |
| 12 | db/adven.sql | CREATE FUNCTION ufnGetAccountingEndDate | CREATE OR REPLACE FUNCTION dbo.ufngetaccountingenddate() | FAILED | ERROR |
| 13 | db/adven.sql | CREATE VIEW VwTopMembers | CREATE VIEW dbo.vwtopmembers | FAILED | ERROR |
| 14 | db/adven-data.sql | INSERT INTO [dbo].[Author] | INSERT INTO dbo.author | FAILED | ERROR |
| 15 | db/adven-data.sql | SET IDENTITY_INSERT + INSERT INTO [dbo].[Product] | INSERT INTO dbo.product | FAILED | ERROR |
| 16 | db/bobsusedbooks.sql | CREATE TABLE [dbo].[Coupons] | CREATE TABLE dbo.coupons | FAILED | ERROR |
| 17 | db/bobsusedbooks.sql | CREATE VIEW VwOpenCoupons | CREATE VIEW dbo.vwopencoupons | FAILED | ERROR |
| 18 | db/bobsusedbooks.sql | CREATE PROCEDURE uspGetTopRegion | CREATE OR REPLACE FUNCTION dbo.uspgettopregion() | FAILED | ERROR |
| 19 | db/bobsusedbooks.sql | CREATE FUNCTION ufnCalculateCustomerLifetimeValue | CREATE OR REPLACE FUNCTION dbo.ufncalculatecustomerlifetimevalue() | FAILED | ERROR |
| 20 | db/bobsusedbooks.sql | CREATE VIEW VwRegionalSales | CREATE VIEW dbo.vwregionalsales | FAILED | ERROR |

## Files Modified

### Application Code Files
1. **app/Bookstore.Web/Controllers/AuthorsController.cs**
   - Converted 4 SQL statements to PostgreSQL syntax
   - Replaced SqlParameter references with NpgsqlParameter
   - Statements: EXEC stored procedure calls → SELECT function calls, column names lowercased

2. **app/Bookstore.Web/Controllers/ProductsController.cs**
   - Converted 1 SQL statement to PostgreSQL syntax
   - Statement: EXEC stored procedure call → SELECT from function

### Package References
3. **app/Bookstore.Web/Bookstore.Web.csproj**
   - Uses Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0

4. **app/Bookstore.Data/Bookstore.Data.csproj**
   - Uses Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0

### Database Configuration
5. **app/Bookstore.Web/Startup/ServicesSetup.cs**
   - Uses NpgsqlConnectionStringBuilder with Host, Port, Database, Username, Password parameters
   - Uses UseNpgsql() for DbContext configuration

6. **app/Bookstore.Data/ApplicationDbContext.cs**
   - Uses Npgsql.EntityFrameworkCore.PostgreSQL
   - Npgsql.EnableLegacyTimestampBehavior is set
   - Entity mappings use lowercase table/column names matching PostgreSQL schema

### Database Schema Files
7. **db/adven.sql** - Converted schema creation script for AdventureWorks-derived objects
8. **db/adven-data.sql** - Converted data insertion scripts
9. **db/bobsusedbooks.sql** - Converted full database creation and data script

## Key Conversion Rules Applied

### Data Type Conversions
| SQL Server | PostgreSQL |
|-----------|-----------|
| NVARCHAR(n) | VARCHAR(n) |
| NCHAR(n) | CHAR(n) |
| DATETIME | TIMESTAMP |
| BIT | BOOLEAN |
| MONEY | NUMERIC(19,4) |
| UNIQUEIDENTIFIER | UUID |
| IDENTITY(1,1) | GENERATED ALWAYS AS IDENTITY |

### Syntax Conversions
| SQL Server | PostgreSQL |
|-----------|-----------|
| [dbo].[ObjectName] | dbo.objectname (lowercase) |
| GETDATE() | CURRENT_TIMESTAMP |
| NEWID() | gen_random_uuid() |
| ISNULL() | COALESCE() |
| CREATE PROCEDURE | CREATE OR REPLACE FUNCTION |
| EXEC procedure | SELECT function() |
| SET NOCOUNT ON | Removed |
| COLLATE clause | Removed |
| ON [PRIMARY] | Removed |
| N'string' | 'string' |
| SqlParameter | NpgsqlParameter |
| CONVERT(VARCHAR, date, 120) | TO_CHAR(date, 'YYYY-MM-DD HH24:MI:SS') |
| DATEDIFF(YEAR, date, GETDATE()) | EXTRACT(YEAR FROM AGE(CURRENT_TIMESTAMP, date)) |
| YEAR(date) | EXTRACT(YEAR FROM date) |
| SELECT TOP 1 | LIMIT 1 |

## Statements Requiring Manual Review
All 20 statements require manual review due to:
1. DMS tool failure on all conversion attempts (infrastructure issue)
2. SQL Equivalency tool returning ERROR for all validation attempts (infrastructure issue)
3. Manual conversions applied with lowercase schema object naming per DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA policy

## Migration Artifacts
1. `sql_equivalency_validation_report.json` - Complete equivalency validation report (20 entries)
2. `extracted_statements.sql` - Catalog of all 20 original MS SQL statements
3. `converted_statements.sql` - Catalog of all 20 converted PostgreSQL statements
4. `migration_summary.md` - This document

## Build Verification
- Final build verified with 0 errors
- Build command: `dotnet build BobsBookstore.sln`
- Only pre-existing warnings present (156 NuGet package vulnerabilities, deprecated API usage)
- No SQL Server references remain in application code
- All imports use Npgsql namespace
- Connection string uses PostgreSQL format (NpgsqlConnectionStringBuilder)
- ApplicationDbContext uses Npgsql.EnableLegacyTimestampBehavior
