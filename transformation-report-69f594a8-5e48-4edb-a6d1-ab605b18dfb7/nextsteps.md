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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages are flagged, consider updating them to versions compatible with the current .NET target framework.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Confirm that all three projects build without errors or warnings. Pay particular attention to any warnings about obsolete APIs or platform compatibility, as these may indicate areas that require further attention.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all projects. Mismatched target frameworks between `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web` can cause runtime issues even when the build succeeds.

---

## 4. Run Unit and Integration Tests

If the solution contains a test project, execute the tests to verify that existing functionality has not been broken during the migration.

```bash
dotnet test --configuration Release --verbosity normal
```

If no test project currently exists, consider adding one to cover critical paths in `Bookstore.Domain` and `Bookstore.Data` before proceeding further.

---

## 5. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify that:

- The connection string in `appsettings.json` (or equivalent) is correctly configured for the target environment.
- Any pending migrations are applied.

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Web Application Locally

Start the web application and verify it runs correctly on the local development machine.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application URL shown in the terminal output and manually verify that core functionality — such as browsing, searching, and any data-driven pages — works as expected.

---

## 7. Check for Windows-Specific Dependencies

Even when a build succeeds, there may be runtime dependencies that are Windows-specific. Review the following areas:

- **File paths**: Ensure no hardcoded backslash (`\`) path separators exist. Use `Path.Combine()` instead.
- **Registry access**: Remove or replace any `Microsoft.Win32.Registry` usage.
- **Windows Authentication**: If the application previously used Windows Authentication, confirm the intended authentication mechanism for the cross-platform environment.

---

## 8. Review Logging and Configuration

Confirm that the application's configuration and logging setup aligns with the cross-platform .NET conventions.

- Configuration should use `appsettings.json` and `appsettings.{Environment}.json`.
- Logging should be configured via `Microsoft.Extensions.Logging` rather than any legacy logging framework unless it has been explicitly confirmed as cross-platform compatible.

---

## 9. Publish the Application

Once local validation is complete, publish the application for the target environment.

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target server or hosting environment.