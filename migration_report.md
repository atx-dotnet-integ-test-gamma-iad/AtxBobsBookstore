# Migration Report: Microsoft SQL Server to PostgreSQL
## BobsBookstore Application

**Migration Date:** 2026-03-04  
**Source Database:** Microsoft SQL Server 2019  
**Target Database:** PostgreSQL 13  
**Application Framework:** .NET 8.0 with ADO.NET / Entity Framework Core  

---

## 1. Summary

| Metric | Count |
|--------|-------|
| Total SQL statements processed | 5 |
| Successfully converted by DMS MCP tool | 0 |
| Requiring manual intervention (DMS failure) | 5 |
| Validated as EQUIVALENT by SQL Equivalency tool | 0 |
| Validated as NOT_EQUIVALENT by SQL Equivalency tool | 0 |
| With equivalency validation ERROR | 5 |

### DMS Tool Status
All 5 SQL statements were passed to the DMS MCP tool (`dms-mcp___statement_conversion_tool`) with:
- `migration_project_identifier`: `XHQ6HWG6R5HVREIQZZEZRV7WFI`
- `schema_name`: `dbo`

All 5 calls failed with **AccessDeniedException**: The IAM role is not authorized to perform `dms:StartMetadataModelCreation` on the migration project resource.

Per the transformation definition requirements, manual conversion was applied with lowercase schema object naming for PostgreSQL compatibility. All statements were already in PostgreSQL-compatible syntax with lowercase names, so the converted statements are identical to the originals.

### SQL Equivalency Tool Status
All 5 statement pairs were validated through the SQL Equivalency MCP tool (`sql-equivalency___validate_sql_equivalence`). All returned ERROR with `'uniqueID'` - a service-side error. Per the TD: "If sql-equivalency___validate_sql_equivalence returns an error, mark the equivalency status as ERROR."

---

## 2. Detailed Statement Listing

### Statement 1: FindAllAuthorsEmbeddedSql

| Field | Value |
|-------|-------|
| **Source File** | `app/Bookstore.Web/Controllers/AuthorsController.cs` |
| **Method** | `FindAllAuthorsEmbeddedSql()` |
| **Line (approx)** | 194 |
| **Original Statement** | `SELECT * FROM author` |
| **DMS Output** | ERROR: AccessDeniedException - not authorized to perform dms:StartMetadataModelCreation |
| **Converted Statement** | `SELECT * FROM author` |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR |
| **Equivalency Tool Output** | `{"equivalence_status": "ERROR", "error": "'uniqueID'"}` |

### Statement 2: EditUsingStoredProcedure

| Field | Value |
|-------|-------|
| **Source File** | `app/Bookstore.Web/Controllers/AuthorsController.cs` |
| **Method** | `EditUsingStoredProcedure()` |
| **Line (approx)** | 160 |
| **Original Statement** | `SELECT * FROM uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);` |
| **DMS Output** | ERROR: AccessDeniedException - not authorized to perform dms:StartMetadataModelCreation |
| **Converted Statement** | `SELECT * FROM uspupdateauthorpersonalinfo(@BusinessEntityID, @NationalIDNumber, @BirthDate, @MaritalStatus, @Gender);` |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR |
| **Equivalency Tool Output** | `{"equivalence_status": "ERROR", "error": "'uniqueID'"}` |

### Statement 3: DeleteAuthorEmbeddedSql

| Field | Value |
|-------|-------|
| **Source File** | `app/Bookstore.Web/Controllers/AuthorsController.cs` |
| **Method** | `DeleteAuthorEmbeddedSql()` |
| **Line (approx)** | 213 |
| **Original Statement** | `SELECT * FROM uspdeleteauthor(@BusinessEntityID);` |
| **DMS Output** | ERROR: AccessDeniedException - not authorized to perform dms:StartMetadataModelCreation |
| **Converted Statement** | `SELECT * FROM uspdeleteauthor(@BusinessEntityID);` |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR |
| **Equivalency Tool Output** | `{"equivalence_status": "ERROR", "error": "'uniqueID'"}` |

### Statement 4: SelectAuthorsByHireYear

| Field | Value |
|-------|-------|
| **Source File** | `app/Bookstore.Web/Controllers/AuthorsController.cs` |
| **Method** | `SelectAuthorsByHireYear()` |
| **Line (approx)** | 228 |
| **Original Statement** | `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birthdate) AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;` |
| **DMS Output** | ERROR: AccessDeniedException - not authorized to perform dms:StartMetadataModelCreation |
| **Converted Statement** | `SELECT businessentityid, TO_CHAR(modifieddate, 'YYYY-MM-DD HH24:MI:SS') AS formattedmodifieddate, EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birthdate) AS age FROM author WHERE EXTRACT(YEAR FROM hiredate) = @HireDate;` |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR |
| **Equivalency Tool Output** | `{"equivalence_status": "ERROR", "error": "'uniqueID'"}` |

### Statement 5: FindAllProducts

| Field | Value |
|-------|-------|
| **Source File** | `app/Bookstore.Web/Controllers/ProductsController.cs` |
| **Method** | `FindAllProducts()` |
| **Line (approx)** | 36 |
| **Original Statement** | `SELECT * FROM uspgetproductdata();` |
| **DMS Output** | ERROR: AccessDeniedException - not authorized to perform dms:StartMetadataModelCreation |
| **Converted Statement** | `SELECT * FROM uspgetproductdata();` |
| **Conversion Method** | DMS_FAILURE_MANUAL_CONVERSION_WITH_LOWERCASE_SCHEMA |
| **Equivalency Status** | ERROR |
| **Equivalency Tool Output** | `{"equivalence_status": "ERROR", "error": "'uniqueID'"}` |

---

## 3. Package Dependency Changes

### Bookstore.Data.csproj
| Original Package | Replaced With | Version |
|-----------------|---------------|---------|
| Microsoft.EntityFrameworkCore.SqlServer | Npgsql.EntityFrameworkCore.PostgreSQL | 8.0.0 |

**Current state:** Clean - no SQL Server packages remain.

### Bookstore.Web.csproj
| Original Package | Replaced With | Version |
|-----------------|---------------|---------|
| Microsoft.Data.SqlClient | Npgsql | 8.0.0 |
| Microsoft.EntityFrameworkCore.SqlServer | Npgsql.EntityFrameworkCore.PostgreSQL | 8.0.0 |

**Current state:** Clean - no SQL Server packages remain.

### Bookstore.Domain.csproj
**No database packages** - Pure domain model project. No changes needed.

---

## 4. Connection String Changes

### ServicesSetup.cs
The connection string is built using PostgreSQL format:

```csharp
// PostgreSQL connection string format
var partialConnString = $"Host={dbSecrets.Host};Port={dbSecrets.Port};Database=BobsUsedBookStore;";

// Using NpgsqlConnectionStringBuilder (replaces SqlConnectionStringBuilder)
var builder = new NpgsqlConnectionStringBuilder(partialConnString)
{
    Username = dbSecrets.Username,
    Password = dbSecrets.Password
};
```

| SQL Server Format | PostgreSQL Format |
|-------------------|-------------------|
| `Server=` | `Host=` |
| `Database=` | `Database=` (unchanged) |
| `User ID=` | `Username=` |
| `Password=` | `Password=` (unchanged) |
| `SqlConnectionStringBuilder` | `NpgsqlConnectionStringBuilder` |

### Database Context Configuration
```csharp
// Was: option.UseSqlServer(connString)
builder.Services.AddDbContext<ApplicationDbContext>(option => option.UseNpgsql(connString));
```

---

## 5. Code Changes

### ADO.NET Class Replacements

| SQL Server Class | PostgreSQL (Npgsql) Equivalent | Files |
|-----------------|-------------------------------|-------|
| `SqlConnection` | `NpgsqlConnection` (via EF Core) | ServicesSetup.cs |
| `SqlParameter` | `NpgsqlParameter` | AuthorsController.cs |
| `SqlConnectionStringBuilder` | `NpgsqlConnectionStringBuilder` | ServicesSetup.cs |
| `UseSqlServer()` | `UseNpgsql()` | ServicesSetup.cs |

### Import Changes

| File | Old Import | New Import |
|------|-----------|------------|
| AuthorsController.cs | `using Microsoft.Data.SqlClient` | `using Npgsql` |
| ProductsController.cs | `using Microsoft.Data.SqlClient` | `using Npgsql` |
| ServicesSetup.cs | `using Microsoft.Data.SqlClient` | `using Npgsql` |

---

## 6. Artifact Verification

| Artifact | Status | Contents |
|----------|--------|----------|
| `extracted_statements.sql` | ✅ Complete | All 5 original SQL statements with source file and method annotations |
| `converted_statements.sql` | ✅ Complete | All 5 converted PostgreSQL statements with conversion notes |
| `sql_equivalency_validation_report.json` | ✅ Complete | Full report with all 5 statement pairs, DMS failure reasons, equivalency tool output |
| `migration_report.md` | ✅ Complete | This document |

---

## 7. Build Verification

```
Build succeeded.
    110 Warning(s)
    0 Error(s)
```

All warnings are NuGet vulnerability advisories for `Magick.NET-Q8-AnyCPU 13.3.0` package (pre-existing, not related to this migration).

---

## 8. Statements Requiring Manual Review

All 5 statements require manual review because:
1. **DMS conversion failed** for all statements due to IAM permissions (AccessDeniedException)
2. **Equivalency validation returned ERROR** for all statements due to service-side error ('uniqueID')

Manual conversion applied lowercase schema naming rules as specified in the transformation definition. The statements were already in PostgreSQL-compatible syntax with lowercase names, confirming the prior migration was correctly applied. However, formal equivalency validation could not be completed due to the tool errors.

**Recommendation:** Once DMS and SQL Equivalency tool access issues are resolved, re-run all 5 statement conversions and validations to get formal confirmation.
