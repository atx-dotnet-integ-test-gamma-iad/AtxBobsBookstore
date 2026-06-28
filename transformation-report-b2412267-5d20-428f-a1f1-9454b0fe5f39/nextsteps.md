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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check [NuGet.org](https://www.nuget.org) for updated versions compatible with the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly:
- Nullable reference type warnings
- Obsolete API usage warnings
- Platform compatibility warnings

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid compatibility issues between them.

---

## 4. Check for Windows-Specific Dependencies

Even when a build succeeds, there may be runtime dependencies that are Windows-specific. Review the following areas:

- **`Bookstore.Data`**: Check if Entity Framework or any database provider is configured with a Windows-only connection string or registry-based configuration.
- **`Bookstore.Web`**: Verify that no `System.Web` references remain. These are not supported on cross-platform .NET.
- **`Bookstore.Domain`**: Check for any use of Windows-specific APIs such as `System.Drawing` (GDI+) or COM interop.

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify remaining platform-specific calls.

---

## 5. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and exercise the core functionality:
- Browse and search for books
- Verify data loads correctly from `Bookstore.Data`
- Confirm domain logic in `Bookstore.Domain` behaves as expected

Check the console output and application logs for any runtime exceptions or warnings.

---

## 6. Validate the Database Connection

If `Bookstore.Data` uses Entity Framework Core, verify the database connection and schema are functioning correctly.

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations are present, confirm they apply cleanly. If the project was previously using Entity Framework 6 (EF6), ensure the migration to EF Core has been handled, as EF6 is not supported on cross-platform .NET.

---

## 7. Execute Unit and Integration Tests

If a test project exists in the solution, run all tests to validate that business logic and data access behave correctly after migration.

```bash
dotnet test
```

Review the test results for any failures. Pay particular attention to tests covering:
- Domain model validation (`Bookstore.Domain`)
- Repository or data access logic (`Bookstore.Data`)
- Controller or middleware behavior (`Bookstore.Web`)

If no tests currently exist, consider adding basic integration tests to cover critical paths before deploying.

---

## 8. Review Configuration Files

Confirm that `appsettings.json` (and `appsettings.Development.json`) are correctly configured. Legacy projects may have relied on `Web.config` or `App.config`, which are not used in the same way in cross-platform .NET.

- Connection strings should be in `appsettings.json`
- Environment-specific settings should use the appropriate `appsettings.{Environment}.json` file
- Secrets should be managed using the [.NET Secret Manager](https://learn.microsoft.com/en-us/aspnet/core/security/app-secrets) for local development

---

## 9. Test on a Non-Windows Platform (Optional but Recommended)

Since the goal of the migration is cross-platform support, validate the application runs correctly on Linux or macOS if those are target deployment environments.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Run this command on the target non-Windows platform and confirm behavior matches the Windows environment.