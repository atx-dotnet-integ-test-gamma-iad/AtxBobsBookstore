# BobsBookstore Migration Summary Report
## Microsoft SQL Server to PostgreSQL Migration

### Migration Overview
- **Application**: BobsBookstore .NET ADO Application
- **Source Database**: Microsoft SQL Server 2019
- **Target Database**: PostgreSQL 13
- **Migration Date**: 2026-03-05
- **DMS Migration Project**: arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI

---

## 1. SQL Statement Processing Summary

| # | Statement | Source File | Method | DMS Status | Conversion Method |
|---|-----------|------------|--------|------------|-------------------|
| 1 | EXEC uspUpdateAuthorPersonalInfo | AuthorsController.cs | EditUsingStoredProcedure | FAILED | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| 2 | SELECT * FROM [dbo].[Author] | AuthorsController.cs | FindAllAuthorsEmbeddedSql | SUCCESS | DMS_TOOL |
| 3 | EXEC uspDeleteAuthor | AuthorsController.cs | DeleteAuthorEmbeddedSql | FAILED | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| 4 | SELECT with FORMAT/DATEDIFF/GETDATE/DATEPART | AuthorsController.cs | SelectAuthorsByHireYear | SUCCESS | DMS_TOOL (GenAI-assisted) |
| 5 | EXEC uspGetProductData | ProductsController.cs | FindAllProducts | SUCCESS | DMS_TOOL |

### DMS Conversion Statistics
- **Total SQL statements processed**: 5
- **Successfully converted by DMS**: 3 (Statements 2, 4, 5)
- **DMS failures requiring manual conversion**: 2 (Statements 1, 3)
- **DMS failure reason**: "Statement definition is not valid." - DECLARE/EXEC multi-statement blocks not supported

### DMS Schema Mapping
- **Original schema**: [dbo]
- **DMS converted schema**: bobsusedbookstore_dbo
- **Note**: DMS derived the schema from the database name "BobsUsedBookStore" → "bobsusedbookstore_dbo"

---

## 2. SQL Equivalency Validation Summary

| # | Statement | Equivalency Status | Tool Output |
|---|-----------|-------------------|-------------|
| 1 | uspUpdateAuthorPersonalInfo | ERROR | Service-level 'uniqueID' error |
| 2 | SELECT * FROM Author | ERROR | Service-level 'uniqueID' error |
| 3 | uspDeleteAuthor | ERROR | Service-level 'uniqueID' error |
| 4 | Complex SELECT | ERROR | Service-level 'uniqueID' error |
| 5 | uspGetProductData | ERROR | Service-level 'uniqueID' error |

### Equivalency Validation Statistics
- **Total statements validated**: 5
- **Equivalent**: 0
- **Non-equivalent**: 0
- **Equivalency errors**: 5
- **Note**: All 5 statements returned ERROR from the SQL Equivalency tool with "'uniqueID'" error. This is a service-level configuration issue, not statement-specific. A trivial "SELECT 1" also failed with the same error. All equivalency statuses are from the tool output only - no agent judgment was applied.

---

## 3. Package Dependency Status

| Package | Status |
|---------|--------|
| Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0 | ✅ Present in Bookstore.Data.csproj |
| Npgsql.EntityFrameworkCore.PostgreSQL 8.0.0 | ✅ Present in Bookstore.Web.csproj |
| Microsoft.Data.SqlClient | ✅ NOT present (removed) |
| System.Data.SqlClient | ✅ NOT present (removed) |
| Microsoft.EntityFrameworkCore.SqlServer | ✅ NOT present (removed) |

---

## 4. Database Access Code Status

| Component | File | Status |
|-----------|------|--------|
| ApplicationDbContext | ApplicationDbContext.cs | ✅ Uses Npgsql.EntityFrameworkCore.PostgreSQL, Npgsql.EnableLegacyTimestampBehavior, lowercase column mappings |
| Connection String Builder | ServicesSetup.cs | ✅ Uses NpgsqlConnectionStringBuilder with Host, Port, Database, Username, Password |
| DB Context Configuration | ServicesSetup.cs | ✅ Uses UseNpgsql() |
| Author Parameters | AuthorsController.cs | ✅ Uses NpgsqlParameter for all 7 parameter usages |
| Product Queries | ProductsController.cs | ✅ Uses Npgsql import, SqlQueryRaw with PostgreSQL syntax |
| SqlConnection references | All .cs files | ✅ None found |
| SqlCommand references | All .cs files | ✅ None found |
| SqlDataReader references | All .cs files | ✅ None found |

---

## 5. Connection String Configuration

| Parameter | Value | Status |
|-----------|-------|--------|
| Host | From AWS Secrets Manager | ✅ PostgreSQL format |
| Port | From AWS Secrets Manager | ✅ PostgreSQL format |
| Database | "postgres" | ✅ PostgreSQL format |
| Username | From AWS Secrets Manager | ✅ PostgreSQL format |
| Password | From AWS Secrets Manager | ✅ PostgreSQL format |

---

## 6. Entity Framework Configuration

| Entity | Table Name | Schema | Status |
|--------|-----------|--------|--------|
| Author | author | bobsbookstore_dbo | ✅ Lowercase with PostgreSQL schema |
| Product | product | bobsbookstore_dbo | ✅ Lowercase with PostgreSQL schema |
| Address | address | bobsbookstore_dbo | ✅ Lowercase with PostgreSQL schema |
| Book | book | bobsbookstore_dbo | ✅ Lowercase with PostgreSQL schema |
| Customer | customer | bobsbookstore_dbo | ✅ Lowercase with PostgreSQL schema |
| Offer | offer | bobsbookstore_dbo | ✅ Lowercase with PostgreSQL schema |
| Order | Order | bobsbookstore_dbo | ✅ PostgreSQL schema |
| OrderItem | orderitem | bobsbookstore_dbo | ✅ Lowercase with PostgreSQL schema |
| ShoppingCart | shoppingcart | bobsbookstore_dbo | ✅ Lowercase with PostgreSQL schema |
| ShoppingCartItem | shoppingcartitem | bobsbookstore_dbo | ✅ Lowercase with PostgreSQL schema |
| ReferenceData | referencedata | bobsbookstore_dbo | ✅ Lowercase with PostgreSQL schema |

---

## 7. Build Verification

- **Build Command**: `dotnet build BobsBookstore.sln`
- **Result**: ✅ Build succeeded
- **Errors**: 0
- **Warnings**: 136 (all pre-existing - Magick.NET vulnerabilities and CS8618 nullable warnings)
- **New warnings introduced**: 0

---

## 8. Issues Requiring Manual Review

1. **SQL Equivalency Validation**: All 5 statement pairs returned ERROR from the SQL Equivalency tool due to a service-level "'uniqueID'" configuration issue. Manual review of converted SQL statements is recommended.

2. **DMS Schema Mapping Discrepancy**: DMS converted [dbo] to `bobsusedbookstore_dbo` (derived from database name "BobsUsedBookStore"), while the existing Entity Framework configuration uses `bobsbookstore_dbo`. The SQL statements in the controllers now use `bobsusedbookstore_dbo` as per DMS output, but EF entity mappings still use `bobsbookstore_dbo`. This needs to be reconciled when deploying to the target database.

3. **Statement 4 - DMS used aws_sqlserver_ext**: DMS converted DATEDIFF to `aws_sqlserver_ext.datediff()`. This requires the `aws_sqlserver_ext` extension to be installed on the target PostgreSQL database. Alternatively, consider replacing with native PostgreSQL: `EXTRACT(YEAR FROM AGE(clock_timestamp(), birthdate))::INT`.

4. **Statement 5 - Stored Procedure Call Pattern**: DMS converted `EXEC [dbo].[uspGetProductData]` to `CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => ...)` but the code uses `SELECT * FROM bobsusedbookstore_dbo.uspgetproductdata()` for compatibility with EF Core's SqlQueryRaw. Verify the stored procedure is defined as a function that returns a result set.

---

## 9. Transformation Artifacts

| Artifact | Location | Description |
|----------|----------|-------------|
| extracted_statements.sql | sourceCode/ | All 5 original MS SQL Server statements |
| converted_statements.sql | sourceCode/ | All 5 converted PostgreSQL statements with conversion method |
| sql_equivalency_validation_report.json | sourceCode/ | Comprehensive equivalency validation report for all 5 pairs |
| migration_summary_report.md | sourceCode/ | This report |
| build.log | sourceCode/ | Latest build output |
