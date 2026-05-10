# BobsBookstore — EF Core PostgreSQL Migration Guide

## Status

No EF Core migration files existed in this project at the time of the SQL Server → PostgreSQL migration.
This folder is intentionally empty except for this README.

The initial migration **must be generated** after all of the following prerequisite steps are complete:

1. `Bookstore.Data.csproj` references `Npgsql.EntityFrameworkCore.PostgreSQL` ✅ (already present, v8.0.0)
2. `ApplicationDbContext` uses `UseNpgsql(...)` ✅ (already updated)
3. All entity classes carry `[Table("...", Schema = "bobsbookstore_dbo")]` and `[Column("...")]` attributes ✅ (already updated)
4. Connection string in the startup project points to a live PostgreSQL instance

---

## How to Generate the Initial Migration

```bash
# From the repository root (where the .sln file lives)
dotnet ef migrations add InitialPostgres \
  --project Bookstore.Data \
  --startup-project Bookstore.Web \
  --output-dir Migrations
```

### Then apply it to the database

```bash
dotnet ef database update \
  --project Bookstore.Data \
  --startup-project Bookstore.Web
```

---

## Expected Schema After Migration

Target PostgreSQL database: `atx-tgt-0c3a037d700c48bba5b5`  
Target schema: **`bobsbookstore_dbo`**

| EF Entity | Table (PostgreSQL) | Schema |
|---|---|---|
| `Address` | `address` | `bobsbookstore_dbo` |
| `Book` | `book` | `bobsbookstore_dbo` |
| `Customer` | `customer` | `bobsbookstore_dbo` |
| `Order` | `Order` | `bobsbookstore_dbo` |
| `OrderItem` | `orderitem` | `bobsbookstore_dbo` |
| `ShoppingCart` | `shoppingcart` | `bobsbookstore_dbo` |
| `ShoppingCartItem` | `shoppingcartitem` | `bobsbookstore_dbo` |
| `Offer` | `offer` | `bobsbookstore_dbo` |
| `Author` | `author` | `bobsbookstore_dbo` |
| `Product` | `product` | `bobsbookstore_dbo` |
| `ReferenceDataItem` | `referencedata` | `bobsbookstore_dbo` |

---

## Post-Generation Verification Checklist

After running `dotnet ef migrations add InitialPostgres`, open the generated
`Migrations/<timestamp>_InitialPostgres.cs` file and confirm:

- [ ] **No `SqlServer:Identity` annotations** — should be `Npgsql:ValueGenerationStrategy` with `IdentityByDefaultColumn`
- [ ] **All `id` columns** use `integer` (not `int`) type with `NpgsqlValueGenerationStrategy.IdentityByDefaultColumn`
- [ ] **All `CreateTable` calls** include `schema: "bobsbookstore_dbo"`
- [ ] **String columns** use `text` or `character varying(n)` — not `nvarchar`
- [ ] **DateTime columns** use `timestamp without time zone` — not `datetime2`
- [ ] **bool columns** (`isactive`, `wanttobuy`) use `boolean` — not `bit`
- [ ] **decimal columns** (`price`, `bookprice`) use `numeric` — not `money`
- [ ] **Enum columns** (`orderstatus`, `offerstatus`, `datatype`) stored as `integer`
- [ ] **`isactive` column on `address`** — verify stored as `integer` (HasConversion<int>() is configured)
- [ ] **`wanttobuy` column on `shoppingcartitem`** — verify stored as `integer` (HasConversion<int>() is configured)
- [ ] **Unique index on `customer.sub`** is present
- [ ] **Foreign keys on `book`** → `referencedata` (publisherid, booktypeid, genreid, conditionid) with `RESTRICT`
- [ ] **Foreign keys on `offer`** → `referencedata` (publisherid, booktypeid, genreid, conditionid) with `RESTRICT`
- [ ] **Foreign key on `order`** → `customer` with `RESTRICT`
- [ ] **Seed data** for `referencedata` (24 rows) and `book` (8 rows) is present in the migration
- [ ] **`ModelSnapshot`** file is generated alongside the migration

---

## Connection String Configuration

Ensure `appsettings.json` (or environment-specific override) in `Bookstore.Web` contains:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=<host>;Port=5432;Database=atx-tgt-0c3a037d700c48bba5b5;Username=<user>;Password=<password>;Search Path=bobsbookstore_dbo"
  }
}
```

> **Tip:** The `Search Path=bobsbookstore_dbo` parameter tells PostgreSQL to resolve unqualified
> table names against the `bobsbookstore_dbo` schema first, which is consistent with how
> the `ApplicationDbContext` maps all entities.

---

## Legacy Timestamp Behaviour

The `ApplicationDbContext` static constructor sets:

```csharp
AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);
```

This means `DateTime` values are written/read as `timestamp without time zone` without UTC
enforcement. This matches the original SQL Server `datetime2` behaviour and ensures that
existing `CreatedOn` / `UpdatedOn` / `DeliveryDate` / `DateOfBirth` / `BirthDate` /
`HireDate` / `ModifiedDate` values round-trip correctly.

---

## Troubleshooting

### `42P06: schema "bobsbookstore_dbo" already exists`
The schema must exist before running the migration. Create it manually or add a
`migrationBuilder.EnsureSchema("bobsbookstore_dbo")` call at the top of `Up()`.
EF Core with Npgsql **will** emit this call automatically when it detects a non-default
schema, so it should be present in the generated file.

### Design-time factory not found
If `dotnet ef` cannot instantiate `ApplicationDbContext` at design time, add an
`IDesignTimeDbContextFactory<ApplicationDbContext>` class to `Bookstore.Data`.
See the Design-Time Factory section below.

### `No startup project`
Always pass `--startup-project Bookstore.Web` (or whichever project wires up the
DI container with the Npgsql connection string).

---

## Design-Time Factory (if needed)

If `dotnet ef migrations add` cannot resolve the connection string from the startup project,
add the following class to `Bookstore.Data`:

```csharp
// Bookstore.Data/ApplicationDbContextFactory.cs
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace Bookstore.Data
{
    public class ApplicationDbContextFactory : IDesignTimeDbContextFactory<ApplicationDbContext>
    {
        public ApplicationDbContext CreateDbContext(string[] args)
        {
            var optionsBuilder = new DbContextOptionsBuilder<ApplicationDbContext>();
            optionsBuilder.UseNpgsql(
                "Host=localhost;Port=5432;Database=bobsbookstore;Username=postgres;Password=postgres;Search Path=bobsbookstore_dbo",
                npgsqlOptions => npgsqlOptions.MigrationsHistoryTable("__EFMigrationsHistory", "bobsbookstore_dbo")
            );
            return new ApplicationDbContext(optionsBuilder.Options);
        }
    }
}
```

> Replace the connection string with your local/CI PostgreSQL credentials.
> The `MigrationsHistoryTable` call places EF Core's migration tracking table
> inside the `bobsbookstore_dbo` schema alongside the application tables.
