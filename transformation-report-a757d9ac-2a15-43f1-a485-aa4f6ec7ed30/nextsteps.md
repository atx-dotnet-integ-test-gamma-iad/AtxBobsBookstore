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

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `netframework` target monikers, consider updating them to their .NET-compatible equivalents.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues beyond what was reported.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

### `appsettings.json`
- Confirm that connection strings previously stored in `Web.config` or `App.config` have been correctly migrated to `appsettings.json`.
- Verify that environment-specific settings (e.g., `appsettings.Development.json`) are in place.

### Entity Framework / Database Configuration
- If `Bookstore.Data` uses Entity Framework, confirm the correct provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Check that the `DbContext` is registered properly in the dependency injection container within `Bookstore.Web`.

---

## 4. Run Database Migrations

If the project uses Entity Framework Core migrations, verify the migration history is intact and apply any pending migrations against your target database.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations do not exist yet, consider generating an initial migration from the current model.

---

## 5. Run Unit and Integration Tests

If the solution contains a test project, execute the tests to validate that the core business logic in `Bookstore.Domain` and data access in `Bookstore.Data` behave as expected.

```bash
dotnet test
```

Review any failing tests and determine whether failures are caused by behavioral changes introduced during migration or pre-existing issues.

---

## 6. Run the Application Locally

Start the web application locally to perform manual validation.

```bash
dotnet run --project Bookstore.Web
```

Verify the following:
- The application starts without runtime exceptions.
- Database connectivity is functional.
- Core application routes and pages load correctly.
- Any authentication or authorization mechanisms work as expected.

---

## 7. Check for Removed or Changed APIs

Cross-platform .NET does not include certain APIs that were available in .NET Framework. Review the following areas manually:

- **`System.Web` dependencies**: These are not available in .NET. Ensure all usages have been replaced with ASP.NET Core equivalents.
- **`HttpContext` usage**: Confirm access patterns have been updated to use `IHttpContextAccessor` where needed.
- **`ConfigurationManager`**: Should be replaced with `IConfiguration` via dependency injection.
- **Windows-specific APIs**: Any calls to Windows Registry, `System.Drawing` (GDI+), or WCF client stacks should be reviewed for cross-platform compatibility.

---

## 8. Validate Target Framework

Confirm that all three projects are targeting the intended .NET version by inspecting each `.csproj` file.

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all projects to avoid compatibility issues between assemblies.