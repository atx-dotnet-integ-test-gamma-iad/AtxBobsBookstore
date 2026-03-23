# Migration Report: MS SQL Server to PostgreSQL
## BobsBookstore Application

### Migration Summary

| Metric | Value |
|--------|-------|
| Migration Date | 2026-03-23 |
| Source Database | Microsoft SQL Server 2019 (BobsUsedBookStore) |
| Target Database | PostgreSQL 13 |
| Source Framework | .NET 8.0 with ADO.NET |
| Target Framework | .NET 8.0 with Npgsql |
| Total SQL Statements | 11 |
| DMS Conversion Successes | 10 (including 2 simplified EXEC statements) |
| DMS Conversion Failures | 1 (CREATE PROCEDURE) |
| Manual Conversions | 1 |
| Build Status | **SUCCESS** (0 errors) |

### DMS Tool Configuration

- **Migration Project ARN**: `arn:aws:dms:us-east-1:812756961751:migration-project:XHQ6HWG6R5HVREIQZZEZRV7WFI`
- **Database Name**: `BobsUsedBookStore`
- **Schema Name**: `dbo`
- **Target Schema**: `bobsusedbookstore_dbo` (DMS-assigned)

### SQL Statement Conversion Details

#### Application Code Statements (5)

| # | Location | Original SQL | Converted SQL | Method |
|---|----------|-------------|---------------|--------|
| 1 | AuthorsController.cs - EditUsingStoredProcedure | `EXEC [dbo].[uspUpdateAuthorPersonalInfo] ...` | `CALL bobsusedbookstore_dbo.uspupdateauthorpersonalinfo(...)` | DMS_TOOL |
| 2 | AuthorsController.cs - FindAllAuthorsEmbeddedSql | `SELECT * FROM dbo.Author` | `SELECT * FROM bobsusedbookstore_dbo.author;` | DMS_TOOL |
| 3 | AuthorsController.cs - DeleteAuthorEmbeddedSql | `EXEC [dbo].[uspDeleteAuthor] ...` | `CALL bobsusedbookstore_dbo.uspdeleteauthor(...)` | DMS_TOOL |
| 4 | AuthorsController.cs - SelectAuthorsByHireYear | `SELECT ... CONVERT ... DATEDIFF ... GETDATE()` | `SELECT ... aws_sqlserver_ext functions ...` | DMS_TOOL |
| 5 | ProductsController.cs - FindAllProducts | `EXEC [dbo].[uspGetProductData]` | `CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => ...)` | DMS_TOOL |

#### Database Schema Statements (6)

| # | Location | Type | Method |
|---|----------|------|--------|
| 6 | db/bobsusedbooks.sql | CREATE TABLE Members | DMS_TOOL |
| 7 | db/bobsusedbooks.sql | CREATE TABLE Author | DMS_TOOL |
| 8 | db/adven.sql | CREATE PROCEDURE uspUpdateAuthorPersonalInfo | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| 9 | db/adven-data.sql | INSERT INTO Author | DMS_TOOL |
| 10 | db/adven.sql | CREATE VIEW VwTopMembers | DMS_TOOL |
| 11 | db/adven.sql | SELECT from Product | DMS_TOOL |

### DMS Failure Details

| # | Statement | DMS Error | Manual Conversion |
|---|-----------|-----------|-------------------|
| 8 | CREATE PROCEDURE [dbo].[uspUpdateAuthorPersonalInfo] | "Statement definition is not valid" | Converted to CREATE OR REPLACE FUNCTION with plpgsql, lowercase schema objects |

### SQL Equivalency Validation Results

| Metric | Value |
|--------|-------|
| Statements Processed | 11 |
| Equivalent | 0 |
| Not Equivalent | 0 |
| Error | 11 |
| Tool Error | All statements returned `'uniqueID'` error from sql-equivalency tool |

**Note**: The SQL Equivalency tool (sql-equivalency___validate_sql_equivalence) returned a systematic `'uniqueID'` error for all 11 statement pairs. Even trivial queries like `SELECT 1` produced the same error. This is a tool-level issue, not related to the quality of the conversions. All results are documented in `sql_equivalency_validation_report.json`.

### Static Code Migration Summary

#### Package References
- ✅ `Npgsql.EntityFrameworkCore.PostgreSQL` v8.0.0 in Bookstore.Data.csproj
- ✅ `Npgsql.EntityFrameworkCore.PostgreSQL` v8.0.0 in Bookstore.Web.csproj
- ✅ No `Microsoft.Data.SqlClient` references
- ✅ No `System.Data.SqlClient` references
- ✅ No `Microsoft.EntityFrameworkCore.SqlServer` references

#### ADO.NET Class Replacements
- ✅ All `SqlParameter` → `NpgsqlParameter`
- ✅ All `using Npgsql;` imports present
- ✅ No remaining SQL Server ADO.NET classes

#### Connection String
- ✅ `UseNpgsql()` in ServicesSetup.cs
- ✅ `NpgsqlConnectionStringBuilder` used
- ✅ Host/Port/Database/Username/Password format (PostgreSQL)

#### EF Core Configuration
- ✅ `Npgsql.EnableLegacyTimestampBehavior` switch set
- ✅ All entities use `bobsusedbookstore_dbo` schema
- ✅ All column mappings use lowercase PostgreSQL convention

### Files Modified

| File | Changes |
|------|---------|
| app/Bookstore.Web/Controllers/AuthorsController.cs | Updated 4 SQL statements with DMS output, schema to bobsusedbookstore_dbo |
| app/Bookstore.Web/Controllers/ProductsController.cs | Updated 1 SQL statement with DMS output, schema to bobsusedbookstore_dbo |
| app/Bookstore.Data/ApplicationDbContext.cs | Updated 11 schema references to bobsusedbookstore_dbo |
| app/Bookstore.Domain/Addresses/Address.cs | Schema attribute updated |
| app/Bookstore.Domain/Authors/Author.cs | Schema attribute updated |
| app/Bookstore.Domain/Books/Book.cs | Schema attribute updated |
| app/Bookstore.Domain/Carts/ShoppingCart.cs | Schema attribute updated |
| app/Bookstore.Domain/Carts/ShoppingCartItem.cs | Schema attribute updated |
| app/Bookstore.Domain/Customers/Customer.cs | Schema attribute updated |
| app/Bookstore.Domain/Offers/Offer.cs | Schema attribute updated |
| app/Bookstore.Domain/Orders/Order.cs | Schema attribute updated |
| app/Bookstore.Domain/Orders/OrderItem.cs | Schema attribute updated |
| app/Bookstore.Domain/Products/Product.cs | Schema attribute updated |
| app/Bookstore.Domain/ReferenceData/ReferenceDataItem.cs | Schema attribute updated |
| extracted_statements.sql | Updated with DMS conversion results |
| converted_statements.sql | Updated with DMS-converted SQL statements |
| sql_equivalency_validation_report.json | Generated with all 11 statement pairs |
| migration_report.md | This report |

### Remaining Issues / Manual Review Items

1. **SQL Equivalency Tool Error**: The sql-equivalency tool returned systematic errors for all statements. Manual review of equivalency is recommended.
2. **aws_sqlserver_ext Extension**: Statement 4 (SelectAuthorsByHireYear) uses `aws_sqlserver_ext` extension functions from DMS. Ensure this extension is installed on the target PostgreSQL database.
3. **Statement 5 Cursor Parameter**: DMS converted `EXEC [dbo].[uspGetProductData]` to `CALL bobsusedbookstore_dbo.uspgetproductdata(par_my_cursor => uspgetproductdata$par_my_cursor)` which requires the stored procedure to be created with a cursor parameter. Verify this matches the migrated stored procedure signature.
4. **Order Table Name**: The `Order` entity uses `ToTable("Order", "bobsusedbookstore_dbo")` with capital "O". This was preserved from the original code as the database table may require this exact casing.

### Build Verification

```
Build succeeded.
    0 Error(s)
    156 Warning(s)
Time Elapsed 00:00:02.37
```
