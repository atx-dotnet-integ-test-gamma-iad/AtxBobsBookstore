# Migration Report: Microsoft SQL Server to PostgreSQL

## BobsBookstore Application Migration

**Date:** 2026-03-04
**Application:** BobsBookstore (.NET 8.0 Web Application)
**Source Database:** Microsoft SQL Server
**Target Database:** PostgreSQL
**Migration Tool:** AWS Database Migration Service (DMS) MCP Tool
**Equivalency Tool:** SQL Equivalency MCP Tool

---

## 1. Executive Summary

| Metric | Count |
|--------|-------|
| Total SQL statements processed | 5 |
| Successfully converted by DMS MCP tool | 0 |
| Requiring manual intervention after DMS failure | 5 |
| Validated as EQUIVALENT by SQL Equivalency tool | 0 |
| Validated as NOT_EQUIVALENT | 0 |
| With equivalency validation ERRORS | 5 |

**DMS Tool Status:** All 5 statements failed with error "Metadata model creation failed: The selected objects were not found."
**Manual Conversion Rule Applied:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
**SQL Equivalency Tool Status:** All 5 equivalency checks returned ERROR with "'uniqueID'" error.
**Note:** Equivalency status is determined SOLELY by the SQL Equivalency tool output, NOT by agent judgment.

---

## 2. Detailed SQL Statement Listing

### Statement 1: Edit Author Using Stored Procedure

| Field | Value |
|-------|-------|
| Source File | `AuthorsController.cs` |
| Method | `EditUsingStoredProcedure` |
| Line | ~163 |
| Original SQL | `SELECT * FROM uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);` |
| Converted SQL | `SELECT * FROM uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);` |
| DMS Status | FAILED |
| DMS Error | Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"} |
| Conversion Method | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| Equivalency Status | ERROR |
| Equivalency Tool Output | {"equivalence_status": "ERROR", "error": "'uniqueID'", "timestamp": "2026-03-04T16:37:21.417068"} |

### Statement 2: Find All Authors

| Field | Value |
|-------|-------|
| Source File | `AuthorsController.cs` |
| Method | `FindAllAuthorsEmbeddedSql` |
| Line | ~187 |
| Original SQL | `SELECT * FROM author` |
| Converted SQL | `SELECT * FROM author` |
| DMS Status | FAILED |
| DMS Error | Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"} |
| Conversion Method | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| Equivalency Status | ERROR |
| Equivalency Tool Output | {"equivalence_status": "ERROR", "error": "'uniqueID'", "timestamp": "2026-03-04T16:37:31.532217"} |

### Statement 3: Delete Author Using Stored Procedure

| Field | Value |
|-------|-------|
| Source File | `AuthorsController.cs` |
| Method | `DeleteAuthorEmbeddedSql` |
| Line | ~208 |
| Original SQL | `SELECT * FROM uspdeleteauthor(@BusinessEntityID);` |
| Converted SQL | `SELECT * FROM uspdeleteauthor(@BusinessEntityID);` |
| DMS Status | FAILED |
| DMS Error | Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"} |
| Conversion Method | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| Equivalency Status | ERROR |
| Equivalency Tool Output | {"equivalence_status": "ERROR", "error": "'uniqueID'", "timestamp": "2026-03-04T16:37:44.028466"} |

### Statement 4: Select Authors By Hire Year with Age Calculation

| Field | Value |
|-------|-------|
| Source File | `AuthorsController.cs` |
| Method | `SelectAuthorsByHireYear` |
| Line | ~228 |
| Original SQL | `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM NOW())::INT - EXTRACT(YEAR FROM birthdate)::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;` |
| Converted SQL | `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM NOW())::INT - EXTRACT(YEAR FROM birthdate)::INT AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;` |
| DMS Status | FAILED |
| DMS Error | Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"} |
| Conversion Method | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| Equivalency Status | ERROR |
| Equivalency Tool Output | {"equivalence_status": "ERROR", "error": "'uniqueID'", "timestamp": "2026-03-04T16:37:55.212127"} |

### Statement 5: Get All Product Data Using Stored Procedure

| Field | Value |
|-------|-------|
| Source File | `ProductsController.cs` |
| Method | `FindAllProducts` |
| Line | ~34 |
| Original SQL | `SELECT * FROM uspgetproductdata();` |
| Converted SQL | `SELECT * FROM uspgetproductdata();` |
| DMS Status | FAILED |
| DMS Error | Metadata model creation failed: {'error': "Metadata model creation failed: {'default_error_details': {'message': 'The selected objects were not found.'}}"} |
| Conversion Method | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| Equivalency Status | ERROR |
| Equivalency Tool Output | {"equivalence_status": "ERROR", "error": "'uniqueID'", "timestamp": "2026-03-04T16:38:04.627129"} |

---

## 3. Package Dependency Changes

### Current State (Already PostgreSQL-Compatible)

| Project | Package | Version | Status |
|---------|---------|---------|--------|
| Bookstore.Web.csproj | Npgsql.EntityFrameworkCore.PostgreSQL | 8.0.0 | Present ✅ |
| Bookstore.Data.csproj | Npgsql.EntityFrameworkCore.PostgreSQL | 8.0.0 | Present ✅ |
| Bookstore.Domain.csproj | (none - pure domain layer) | N/A | Clean ✅ |

### Removed Packages (Already Absent)

| Package | Status |
|---------|--------|
| Microsoft.Data.SqlClient | Not found in any .csproj ✅ |
| System.Data.SqlClient | Not found in any .csproj ✅ |
| Microsoft.EntityFrameworkCore.SqlServer | Not found in any .csproj ✅ |

---

## 4. Connection String Changes

### ServicesSetup.cs

- **DbContext Configuration:** Uses `UseNpgsql(connString)` for EF Core PostgreSQL provider
- **Connection String Builder:** Uses `NpgsqlConnectionStringBuilder` with:
  - `Host` (from Secrets Manager)
  - `Port` (from Secrets Manager)
  - `Database` (hardcoded as "BobsUsedBookStore")
  - `Username` (from Secrets Manager)
  - `Password` (from Secrets Manager)

### appsettings.json

- Connection string key `BookstoreDbDefaultConnection` available for local development
- Production uses AWS Secrets Manager for credentials via `dbsecretsname` parameter

---

## 5. Code Changes

### Using Statement Changes

| File | Using Statement | Status |
|------|----------------|--------|
| AuthorsController.cs | `using Npgsql;` | Present ✅ |
| ProductsController.cs | `using Npgsql;` | Present ✅ |
| ServicesSetup.cs | `using Npgsql;` | Present ✅ |
| All .cs files | `using Microsoft.Data.SqlClient` | Absent ✅ |
| All .cs files | `using System.Data.SqlClient` | Absent ✅ |

### ADO.NET Class Replacements

| SQL Server Class | Npgsql Replacement | Files Using |
|-----------------|-------------------|-------------|
| SqlParameter | NpgsqlParameter | AuthorsController.cs (7 instances), ProductsController.cs (0 instances) |
| SqlConnectionStringBuilder | NpgsqlConnectionStringBuilder | ServicesSetup.cs (1 instance) |
| SqlConnection | NpgsqlConnection | Not used (EF Core manages connections) |
| SqlCommand | NpgsqlCommand | Not used (EF Core ExecuteSqlRawAsync/SqlQueryRaw used) |
| UseSqlServer() | UseNpgsql() | ServicesSetup.cs (1 instance) |

### SQL Syntax

All SQL statements use PostgreSQL-compatible syntax:
- PostgreSQL function calls: `SELECT * FROM function_name(params);`
- PostgreSQL date functions: `TO_CHAR()`, `EXTRACT()`, `NOW()`
- PostgreSQL type casting: `::INT`
- Lowercase schema object names (tables, columns, functions)

---

## 6. Transformation Artifacts

| Artifact | Location | Status |
|----------|----------|--------|
| extracted_statements.sql | sourceCode/extracted_statements.sql | Complete - 5 original SQL statements ✅ |
| converted_statements.sql | sourceCode/converted_statements.sql | Complete - 5 converted SQL statements ✅ |
| sql_equivalency_validation_report.json | sourceCode/sql_equivalency_validation_report.json | Complete - 5 statement pairs with tool results ✅ |
| migration_report.md | sourceCode/migration_report.md | Complete ✅ |

---

## 7. Statements Requiring Manual Review

All 5 statements require manual review due to:
1. DMS tool failure (metadata model creation failed for all statements)
2. SQL Equivalency tool returning ERROR for all statement pairs

**Recommended Actions:**
- Verify DMS migration project configuration and database connectivity
- Manually review each SQL statement pair for logical equivalency
- Test all database operations against the target PostgreSQL database
- Verify stored procedures (`uspupdateauthorpersonalinfo`, `uspdeleteauthor`, `uspgetproductdata`) exist in the PostgreSQL database

---

## 8. Build Status

**Final Build Result:** ✅ SUCCESS
- 0 Errors
- Warnings: Pre-existing Magick.NET vulnerability warnings only (not related to migration)
- All 3 projects build successfully:
  - Bookstore.Domain
  - Bookstore.Data
  - Bookstore.Web
