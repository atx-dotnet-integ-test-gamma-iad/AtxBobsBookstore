# EF Migration Baseline — BobsBookstore

## Inspection Date
Performed as part of the EF Migration Transformation step (PostgreSQL migration).

## EF Version
EF Core 8.0.10

## Source Provider
Microsoft SQL Server (MSSQL)

## Target Provider
PostgreSQL (Npgsql)

---

## Scan Results

The following project directories were scanned (depth 5) for a `Migrations` folder or any EF migration files (`*_*.cs`, `*ModelSnapshot.cs`):

| Project | Path | Migrations Folder Found |
|---|---|---|
| Bookstore.Data | `app/Bookstore.Data/` | ❌ No |
| Bookstore.Web | `app/Bookstore.Web/` | ❌ No |

**Result: No migration files exist in this codebase.**

---

## Baseline State

The BobsBookstore project follows a **code-first approach without checked-in migrations**. The database schema is managed via:

- `Bookstore.Data/ApplicationDbContext.cs` — DbContext with entity configurations
- `Bookstore.Data/SeedData.cs` — Initial seed data

No `Migrations/` folder is present in any project. This is the confirmed baseline before PostgreSQL migration work.

---

## Action Required After Transformation

Once all entity classes and the `ApplicationDbContext` have been fully transformed for PostgreSQL/Npgsql compatibility, a **fresh initial migration must be generated** using:

```bash
dotnet ef migrations add InitialPostgresSchema \
  --project app/Bookstore.Data \
  --startup-project app/Bookstore.Web
```

This will produce:
- `app/Bookstore.Data/Migrations/<timestamp>_InitialPostgresSchema.cs`
- `app/Bookstore.Data/Migrations/<timestamp>_InitialPostgresSchema.Designer.cs`
- `app/Bookstore.Data/Migrations/ApplicationDbContextModelSnapshot.cs`

The generated migration should then be reviewed to verify:
- All table names use PostgreSQL snake_case conventions
- All column names use PostgreSQL snake_case conventions
- SQL Server-specific annotations (`SqlServer:Identity`) are replaced with Npgsql equivalents (`Npgsql:ValueGenerationStrategy`)
- All SQL Server data types are mapped to PostgreSQL equivalents
- Schema parameter (`schema: "public"`) is present on all table operations

---

## No-Op Confirmation

The EF Migration Transformation step is a **confirmed no-op** for this project.
Zero migration files were found. Zero migration files were transformed.
