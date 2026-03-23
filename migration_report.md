# SQL Server to PostgreSQL Migration Report

## BobsBookstore .NET Application

**Date:** 2026-03-23  
**Migration Type:** Microsoft SQL Server → PostgreSQL  
**Application Framework:** .NET 8.0, ASP.NET Core MVC, Entity Framework Core 8.0  
**Target Database:** PostgreSQL 13  

---

## Executive Summary

This report documents the migration of the BobsBookstore .NET application from Microsoft SQL Server to PostgreSQL. The migration involved converting 5 SQL statements from SQL Server syntax to PostgreSQL syntax, updating stored procedure calls to PostgreSQL function calls, and verifying that all static code dependencies (packages, ADO.NET classes, connection strings) are PostgreSQL-compatible.

---

## SQL Statement Migration Summary

| Metric | Count |
|--------|-------|
| Total SQL statements processed | 5 |
| Successfully converted by DMS MCP tool | 0 |
| Requiring manual intervention (DMS failure) | 5 |
| Validated as equivalent (SQL Equivalency tool) | 0 |
| Validated as non-equivalent | 0 |
| With equivalency validation errors | 5 |

### DMS Tool Status
All 5 SQL statements were passed through the DMS MCP tool (dms-mcp___statement_conversion_tool) with the following configuration:
- **Migration Project ARN:** arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI
- **Database:** BobsBookstore
- **Schema:** dbo
- **Region:** us-east-1

**DMS Error (all statements):** `Metadata model creation failed: No objects were found according to the specified selection rules. Please review your selection rules and try again.`

All statements were manually converted using lowercase schema object names per the transformation definition (`DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA`).

### SQL Equivalency Tool Status
All 5 statement pairs were validated through the SQL Equivalency tool (sql-equivalency___validate_sql_equivalence). All returned ERROR status with `'uniqueID'` error. No agent judgment was used for equivalency determination.

---

## Detailed Statement Conversions

### Statement 1: EditUsingStoredProcedure (AuthorsController.cs:165)
- **Original:** `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspUpdateAuthorPersonalInfo] @BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender;SELECT @rowsAffected;`
- **Converted:** `SELECT * FROM bobsbookstore_dbo.uspupdateauthorpersonalinfo($1, $2, $3, $4, $5);`
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status:** ERROR
- **Parameter Changes:** Named parameters (@Name) → Positional parameters (p1-p5)

### Statement 2: FindAllAuthorsEmbeddedSql (AuthorsController.cs:189)
- **Original:** `SELECT * FROM bobsbookstore_dbo.author`
- **Converted:** `SELECT * FROM bobsbookstore_dbo.author` (unchanged - already PostgreSQL-compatible)
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status:** ERROR

### Statement 3: DeleteAuthorEmbeddedSql (AuthorsController.cs:212)
- **Original:** `DECLARE @rowsAffected INT;EXEC @rowsAffected = [dbo].[uspDeleteAuthor] @BusinessEntityID;SELECT @rowsAffected;`
- **Converted:** `SELECT * FROM bobsbookstore_dbo.uspdeleteauthor($1);`
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status:** ERROR
- **Parameter Changes:** Named parameter (@BusinessEntityID) → Positional parameter (p1)

### Statement 4: SelectAuthorsByHireYear (AuthorsController.cs:232)
- **Original:** `SELECT BusinessEntityID, TO_CHAR(ModifiedDate, 'YYYY-MM-DD HH24:MI:SS') AS FormattedModifiedDate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, BirthDate))::INTEGER AS Age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM HireDate) = $1;`
- **Converted:** `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM AGE(CURRENT_DATE, birthdate))::INTEGER AS age FROM bobsbookstore_dbo.author WHERE EXTRACT(YEAR FROM hiredate) = $1;`
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status:** ERROR
- **Changes:** Column names converted to lowercase for PostgreSQL compatibility

### Statement 5: FindAllProducts (ProductsController.cs:36)
- **Original:** `EXEC [dbo].[uspGetProductData];`
- **Converted:** `SELECT * FROM bobsbookstore_dbo.uspgetproductdata();`
- **Conversion Method:** DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA
- **Equivalency Status:** ERROR

---

## Static Code and Configuration Verification

### Package Dependencies
| Package | Status |
|---------|--------|
| Npgsql.EntityFrameworkCore.PostgreSQL v8.0.10 | ✅ Present in Bookstore.Data.csproj and Bookstore.Web.csproj |
| Microsoft.Data.SqlClient | ✅ Not referenced in any .csproj |
| System.Data.SqlClient | ✅ Not referenced in any .csproj |
| Microsoft.EntityFrameworkCore.SqlServer | ✅ Not referenced in any .csproj |

### ADO.NET Classes
| Check | Status |
|-------|--------|
| SqlConnection references | ✅ None found |
| SqlCommand references | ✅ None found |
| SqlDataReader references | ✅ None found |
| SqlParameter references | ✅ None found (all use NpgsqlParameter) |
| NpgsqlParameter usage | ✅ Confirmed in AuthorsController.cs and ServicesSetup.cs |

### Connection Strings
| Component | Status |
|-----------|--------|
| ServicesSetup.cs uses UseNpgsql() | ✅ Confirmed |
| NpgsqlConnectionStringBuilder | ✅ Confirmed with Host, Port, Database, Username, Password |
| No SqlConnectionStringBuilder | ✅ Confirmed |

### Imports/Usings
| File | Import | Status |
|------|--------|--------|
| AuthorsController.cs | using Npgsql; | ✅ |
| ProductsController.cs | using Npgsql; | ✅ |
| ServicesSetup.cs | using Npgsql; | ✅ |
| No files | using Microsoft.Data.SqlClient; | ✅ Not present |
| No files | using System.Data.SqlClient; | ✅ Not present |

### ApplicationDbContext
| Check | Status |
|-------|--------|
| Schema: bobsbookstore_dbo | ✅ Confirmed |
| Lowercase column names | ✅ Confirmed (HasColumnName mappings) |
| Entity mappings correct | ✅ Confirmed |

---

## Build Status

**Final Build Result:** ✅ SUCCESS  
- **Errors:** 0  
- **Warnings:** 184 (all pre-existing, none related to migration)

---

## Statements Requiring Manual Review

All 5 converted statements should be reviewed due to:
1. **DMS tool failure** - All conversions were performed manually with lowercase schema mapping
2. **SQL Equivalency tool errors** - All equivalency validations returned ERROR status

**Recommended actions:**
- Verify that PostgreSQL stored procedures/functions (`uspupdateauthorpersonalinfo`, `uspdeleteauthor`, `uspgetproductdata`) exist in the `bobsbookstore_dbo` schema
- Test each converted SQL statement against the actual PostgreSQL database
- Verify that positional parameter binding ($1, $2, etc.) works correctly with Npgsql

---

## Artifacts Generated

| Artifact | Location | Description |
|----------|----------|-------------|
| extracted_statements.sql | Project root | Complete catalog of all original SQL statements |
| converted_statements.sql | Project root | All original and converted statement pairs |
| sql_equivalency_validation_report.json | Project root | Comprehensive equivalency validation report |
| migration_report.md | Project root | This migration report |

---

## Files Modified

1. `app/Bookstore.Web/Controllers/AuthorsController.cs` - 4 SQL statements converted
2. `app/Bookstore.Web/Controllers/ProductsController.cs` - 1 SQL statement converted

## Files Not Modified (Already PostgreSQL-Compatible)

1. `app/Bookstore.Data/Bookstore.Data.csproj` - Already uses Npgsql.EntityFrameworkCore.PostgreSQL
2. `app/Bookstore.Web/Bookstore.Web.csproj` - Already uses Npgsql.EntityFrameworkCore.PostgreSQL
3. `app/Bookstore.Domain/Bookstore.Domain.csproj` - No database-specific dependencies
4. `app/Bookstore.Web/Startup/ServicesSetup.cs` - Already uses UseNpgsql() and NpgsqlConnectionStringBuilder
5. `app/Bookstore.Data/ApplicationDbContext.cs` - Already configured with lowercase column names and bobsbookstore_dbo schema
