# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are present, consider replacing them with their .NET-compatible equivalents.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects — `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web` — build without warnings or errors.

---

## 3. Review Configuration Files

Check `appsettings.json` (and any environment-specific variants such as `appsettings.Development.json`) in `Bookstore.Web` to confirm the following:

- Connection strings are correctly formatted for the target database provider (e.g., SQL Server, SQLite).
- Any configuration keys that were previously in `Web.config` or `App.config` have been properly migrated to the new configuration system.
- Environment-specific settings are placed in the appropriate `appsettings.{Environment}.json` file.

---

## 4. Verify Entity Framework or Data Access Layer

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Migrations are present and up to date. Run the following to apply migrations to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

- If no migrations exist and a code-first approach is used, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 5. Run Unit and Integration Tests

If a test project exists in the solution, execute the test suite to confirm that core business logic in `Bookstore.Domain` and data access behavior in `Bookstore.Data` function as expected.

```bash
dotnet test
```

Review any failing tests and determine whether they are caused by behavioral differences in the new runtime or by incomplete migration of dependencies.

---

## 6. Run the Application Locally

Start the web application locally to perform manual validation.

```bash
dotnet run --project app/Bookstore.Web
```

Confirm the following:

- The application starts without runtime exceptions.
- All pages and routes load correctly.
- Database read and write operations function as expected.
- Authentication and authorization (if applicable) behave correctly.

---

## 7. Check for Removed or Changed APIs

Cross-platform .NET does not support certain APIs that were available in .NET Framework. Review the following areas:

- **`System.Web` dependencies**: These are not available in .NET Core or later. Ensure all usages have been replaced with ASP.NET Core equivalents.
- **`HttpContext`**: Access patterns have changed. Confirm `IHttpContextAccessor` is used where needed.
- **`ConfigurationManager`**: This has been replaced by `IConfiguration`. Verify no direct calls to `ConfigurationManager` remain.
- **Windows-specific APIs**: If the application previously relied on Windows-only features (e.g., Windows Authentication, COM interop), confirm that cross-platform alternatives have been implemented or that the deployment target is Windows.

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to identify any remaining incompatible API usages.

---

## 8. Validate Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.