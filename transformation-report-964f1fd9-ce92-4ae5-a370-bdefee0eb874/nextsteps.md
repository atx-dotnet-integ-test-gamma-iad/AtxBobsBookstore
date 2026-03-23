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

Review the output for any warnings related to package compatibility or version conflicts. Address any packages that may have been marked as deprecated or that target frameworks incompatible with the new target.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues beyond what was reported.

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay particular attention to:

- Any remaining references to Windows-specific APIs (e.g., `System.Web`, `HttpContext` from the old ASP.NET stack)
- Any use of `App.config` or `Web.config` that may need to be migrated to `appsettings.json`

---

## 3. Review Configuration Files

Check that configuration has been properly migrated from `Web.config` or `App.config` to the `appsettings.json` pattern used in modern .NET.

- Connection strings should be present in `appsettings.json` under the `ConnectionStrings` section.
- Any environment-specific settings should be placed in `appsettings.Development.json` or `appsettings.Production.json`.

---

## 4. Verify the Data Layer

Since `Bookstore.Data` depends on `Bookstore.Domain`, validate the data layer first.

- Confirm that Entity Framework (or whichever ORM is in use) is targeting the correct provider package for cross-platform .NET (e.g., `Microsoft.EntityFrameworkCore.SqlServer` instead of `EntityFramework`).
- If migrations are used, verify they are present and up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If the database schema needs to be updated:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and confirm it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and exercise the primary workflows (browsing books, authentication if applicable, etc.).
- Check the console output and application logs for any runtime exceptions.

---

## 6. Execute Existing Tests

If the solution contains test projects, run them to validate that existing behavior has been preserved.

```bash
dotnet test
```

Review the test results for any failures that may indicate behavioral regressions introduced during the migration. If no tests currently exist, consider writing integration tests that cover the primary data access and web layer interactions.

---

## 7. Validate Cross-Platform Behavior

Since the goal of this migration was cross-platform support, verify the application runs correctly on a non-Windows environment if applicable.

- Check for any remaining uses of Windows-specific path separators (`\`) that should be replaced with `Path.Combine` or `Path.DirectorySeparatorChar`.
- Confirm that file I/O, if any, uses cross-platform compatible APIs.
- Verify that any authentication or session middleware is correctly configured for the new ASP.NET Core pipeline.

---

## 8. Review Startup and Middleware Configuration

In the migrated `Bookstore.Web` project, review `Program.cs` (and `Startup.cs` if present) to ensure:

- Services are registered correctly in the dependency injection container.
- Middleware is ordered correctly (e.g., authentication before authorization).
- Static files, routing, and error handling middleware are all present and configured.