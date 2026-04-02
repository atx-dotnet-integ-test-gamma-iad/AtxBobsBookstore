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

The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite:

```bash
dotnet test --configuration Release
```

If no test projects currently exist, it is worth creating basic tests that cover:

- Domain model logic in `Bookstore.Domain`
- Data access operations in `Bookstore.Data` (using an in-memory database provider if applicable)
- Key HTTP endpoints in `Bookstore.Web`

---

## 4. Verify Database Connectivity and Migrations

If `Bookstore.Data` uses Entity Framework Core, confirm that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

Apply the migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Validate Runtime Behavior

Start the web application locally and verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following at runtime:

- Application starts without exceptions
- Database connections are established successfully
- Key pages and routes load as expected
- Any authentication or authorization flows behave correctly

Review the application logs for runtime warnings or errors that would not have appeared at build time.

---

## 6. Review Configuration Files

Inspect `appsettings.json` and `appsettings.Production.json` in `Bookstore.Web` to confirm:

- Connection strings are correct for the target environment
- Any legacy `Web.config` or `App.config` values have been properly migrated to the new configuration system
- Environment-specific settings are separated appropriately

---

## 7. Check for Removed or Changed APIs

Cross-platform .NET removes certain APIs that were available in .NET Framework. Use the .NET Upgrade Analyzer or review the Microsoft API compatibility documentation to confirm that no runtime-only incompatibilities exist, particularly in:

- `Bookstore.Data` for any data access patterns
- `Bookstore.Web` for any HTTP pipeline or session handling code

You can run the compatibility analyzer with:

```bash
dotnet add package Microsoft.DotNet.UpgradeAssistant.Extensions.Default.Analyzers
dotnet build
```

Review any analyzer diagnostics that are produced.