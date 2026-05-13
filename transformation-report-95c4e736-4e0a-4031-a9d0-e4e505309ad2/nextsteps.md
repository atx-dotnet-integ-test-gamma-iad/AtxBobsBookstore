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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Resolve any warnings that could indicate runtime issues, such as nullable reference warnings, obsolete API usage, or platform compatibility warnings.

---

## 3. Verify Project Target Frameworks

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other .NET Framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Review all three projects for any remaining dependencies that are Windows-only, such as:

- `System.Web` references
- Windows Registry access
- COM interop
- `HttpContext` usage patterns from ASP.NET (non-Core)

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package to identify platform-specific calls.

---

## 5. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and exercise the core functionality, including:

- Browsing the bookstore catalog
- Any data access operations (reads and writes via `Bookstore.Data`)
- Domain logic validation through `Bookstore.Domain`

Check the console output and application logs for any runtime exceptions or unhandled errors.

---

## 6. Validate Data Access Layer

Since `Bookstore.Data` handles persistence, verify the following:

- The database connection string in `appsettings.json` (or equivalent configuration) is correctly configured for the target environment.
- Entity Framework Core (if used) migrations are up to date. Run the following if applicable:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- If the project previously used Entity Framework 6 (EF6), confirm it has been migrated to EF Core and that all queries function as expected.

---

## 7. Execute Unit and Integration Tests

If the solution contains a test project, run all tests to confirm existing functionality is preserved.

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to migration-related changes or pre-existing issues. Pay particular attention to tests covering `Bookstore.Domain` logic and `Bookstore.Data` repository methods.

---

## 8. Review Configuration Files

Confirm that configuration has been migrated away from `Web.config` or `App.config` to the ASP.NET Core configuration system.

- Connection strings, app settings, and environment-specific values should reside in `appsettings.json` and `appsettings.{Environment}.json`.
- Sensitive values should be managed using User Secrets locally:

```bash
dotnet user-secrets init --project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to verify the output is correct.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all required files, assemblies, and static assets are present.