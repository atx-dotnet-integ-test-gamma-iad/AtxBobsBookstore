# EF Migration Transformation Audit Report

**Project:** BobsBookstore  
**Date:** Migration transformation pass  
**EF Version:** EF Core 8.0 (net8.0)  
**Source Provider:** Microsoft SQL Server (MSSQL)  
**Target Provider:** PostgreSQL (Npgsql 8.0.0)  

---

## 1. Scope of Investigation

The following locations were inspected for EF migration files:

| Location | Files Found | Migrations Folder Present |
|----------|-------------|---------------------------|
| `app/Bookstore.Data/` | 20 files (see listing below) | **No** |
| `app/Bookstore.Web/` | 100+ files (see listing below) | **No** |

### Patterns Searched For
- `Migrations/` folder at any depth
- `*Migration.cs` files
- `*DbContextModelSnapshot.cs` files
- `migrationBuilder.*` call sites
- `IMigration` interface implementations

---

## 2. Findings: No Migration Files Exist

**CONFIRMED:** Zero EF Core migration files are present anywhere in the Bookstore solution.

Neither `Bookstore.Data` nor `Bookstore.Web` contains a `Migrations/` directory or any file matching standard EF Core migration naming conventions (`YYYYMMDDHHMMSS_<MigrationName>.cs`, `<ProjectName>DbContextModelSnapshot.cs`, etc.).

---

## 3. Schema Creation Strategy in Use

The project uses **`Database.EnsureCreatedAsync()`** (not EF migrations) to create the database schema at application startup.

**Location:** `app/Bookstore.Web/Startup/MiddlewareSetup.cs` — lines 44–47

```csharp
// Create the database
using (var scope = app.Services.CreateAsyncScope())
{
    await scope.ServiceProvider.GetService<ApplicationDbContext>()!.Database.EnsureCreatedAsync();
}
```

### What `EnsureCreatedAsync()` Does
- Reads all entity type configurations registered in `ApplicationDbContext.OnModelCreating()`
- Generates and executes DDL (`CREATE TABLE`, `CREATE INDEX`, etc.) directly against the target database
- Skips the migration history table (`__EFMigrationsHistory`) entirely
- Is idempotent — does nothing if the schema already exists

This approach means **the DbContext's `OnModelCreating` configuration is the sole source of truth for the PostgreSQL schema** — no migration files are needed or expected.

---

## 4. DbContext Configuration Status

`ApplicationDbContext.cs` has already been transformed for PostgreSQL. Key evidence:

| Check | Status |
|-------|--------|
| `using Npgsql.EntityFrameworkCore.PostgreSQL;` present | ✅ Yes |
| `Npgsql.EnableLegacyTimestampBehavior` switch set | ✅ Yes |
| All `entity.ToTable(...)` calls use lowercase names | ✅ Yes |
| Schema is `"bobsbookstore_dbo"` (PostgreSQL-compatible) | ✅ Yes |
| All `HasColumnName(...)` values are lowercase | ✅ Yes |
| No SQL Server–specific annotations (`SqlServer:Identity`) | ✅ None found |

### Tables Registered in OnModelCreating

| Entity Class | Table Name | Schema |
|---|---|---|
| `Address` | `address` | `bobsbookstore_dbo` |
| `Book` | `book` | `bobsbookstore_dbo` |
| `Customer` | `customer` | `bobsbookstore_dbo` |
| `Order` | `Order` | `bobsbookstore_dbo` |
| `ShoppingCart` | `shoppingcart` | `bobsbookstore_dbo` |
| `ShoppingCartItem` | `shoppingcartitem` | `bobsbookstore_dbo` |
| `OrderItem` | `orderitem` | `bobsbookstore_dbo` |
| `Offer` | `offer` | `bobsbookstore_dbo` |
| `Author` | `author` | `bobsbookstore_dbo` |
| `Product` | `product` | `bobsbookstore_dbo` |
| `ReferenceDataItem` | `referencedata` | `bobsbookstore_dbo` |

---

## 5. Project File Verification

### Bookstore.Data.csproj — NuGet Package References

| Package | Version | Role |
|---------|---------|------|
| `Npgsql.EntityFrameworkCore.PostgreSQL` | 8.0.0 | PostgreSQL EF Core provider ✅ |
| `Microsoft.EntityFrameworkCore` | 8.0.10 | EF Core base |
| `Microsoft.EntityFrameworkCore.Design` | 8.0.10 | Design-time tooling |
| `Microsoft.EntityFrameworkCore.Tools` | 8.0.10 | CLI tools (dotnet-ef) |

> No `Microsoft.EntityFrameworkCore.SqlServer` package reference — SQL Server provider has been removed. ✅

### Bookstore.Web.csproj — NuGet Package References

| Package | Version | Role |
|---------|---------|------|
| `Npgsql.EntityFrameworkCore.PostgreSQL` | 8.0.0 | PostgreSQL EF Core provider ✅ |
| `Microsoft.EntityFrameworkCore.Tools` | 8.0.10 | CLI tools |

> No `Microsoft.EntityFrameworkCore.SqlServer` package reference. ✅

---

## 6. Migration Transformation Decision

| Question | Answer |
|----------|--------|
| Were any migration files found? | **No** |
| Are any migration files expected? | **No** — `EnsureCreatedAsync()` is used |
| Were any files transformed? | **No** — nothing to transform |
| Is any follow-up action required? | **No** — schema is derived from DbContext |

**Conclusion:** No EF migration transformation work is required for this project. The PostgreSQL schema will be created automatically at runtime by `EnsureCreatedAsync()` based on the entity configurations already present in `ApplicationDbContext.OnModelCreating()`.

---

## 7. Validation Checklist

- [x] `Bookstore.Data/` directory tree inspected — no `Migrations/` folder
- [x] `Bookstore.Web/` directory tree inspected — no `Migrations/` folder
- [x] `MiddlewareSetup.cs` read — `EnsureCreatedAsync()` confirmed as schema strategy
- [x] `ApplicationDbContext.cs` read — Npgsql provider confirmed, no SQL Server artifacts
- [x] `Bookstore.Data.csproj` read — no SqlServer package reference
- [x] `Bookstore.Web.csproj` read — no SqlServer package reference
- [x] Zero migration files to transform
- [x] Report written

---

*Report generated by EF Migration Transformation Agent*
