# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

The following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Runtime Configuration

Check the following configuration files for correctness in the context of cross-platform .NET:

- **`appsettings.json`** – Ensure connection strings, logging settings, and any environment-specific values are correctly defined.
- **`Program.cs`** – Confirm the application startup and host builder configuration aligns with the current .NET hosting model.
- **`Bookstore.Data`** – If Entity Framework Core is in use, verify that the correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`) and that migrations are up to date.

---

## 4. Run Database Migrations

If the project uses Entity Framework Core, verify that existing migrations are compatible with the new runtime. Apply migrations against a development database to confirm schema integrity.

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations do not exist yet or need to be regenerated:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, adding to cart, user authentication if applicable) to confirm expected behavior.

---

## 6. Execute Unit and Integration Tests

If a test project exists in the solution, run all tests to validate that business logic and data access behavior are functioning correctly after the migration.

```bash
dotnet test
```

Review any failing tests and determine whether failures are caused by migration-related changes or pre-existing issues.

---

## 7. Review Removed or Changed APIs

Cross-platform .NET does not support certain APIs that were available in .NET Framework. Review the following areas manually:

- **`System.Web` references** – These are not available in .NET. Ensure all usages have been replaced with ASP.NET Core equivalents.
- **`HttpContext` and session handling** – Confirm these are accessed via dependency injection rather than static accessors.
- **Configuration** – Ensure `ConfigurationManager` has been replaced with `IConfiguration`.
- **Windows-specific APIs** – If any Windows-only libraries were used (e.g., for file paths or registry access), verify they have been replaced or conditionally compiled.

---

## 8. Test on Target Platforms

Since the goal is cross-platform support, validate the application runs correctly on each intended target operating system (e.g., Windows, Linux, macOS) by running the application in each environment if possible.

```bash
dotnet publish --configuration Release --runtime linux-x64 --self-contained false
```

Adjust the `--runtime` flag as appropriate for your target platform.