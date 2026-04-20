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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another .NET Framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific Dependencies

Inspect `Bookstore.Data` and `Bookstore.Web` for any NuGet packages or APIs that are Windows-only, such as:

- `System.Web` (not available in cross-platform .NET)
- Windows Registry access
- COM interop components

Replace or remove any such dependencies with cross-platform alternatives.

---

## 5. Database and Data Layer Validation

If `Bookstore.Data` uses Entity Framework, verify the following:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Any pending migrations are up to date.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply migrations to the target database if needed:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite to confirm existing functionality is preserved after migration.

```bash
dotnet test
```

Review any failing tests to determine whether they are caused by behavioral differences between .NET Framework and cross-platform .NET.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project and verify it runs correctly on the local machine.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Confirm the following:

- The application starts without runtime exceptions.
- All pages and API endpoints respond as expected.
- Database connectivity is functioning correctly.
- Static assets (CSS, JavaScript, images) are served properly.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` contains all necessary configuration values that may have previously resided in `Web.config` or `App.config`. Common entries to verify include:

- Connection strings
- Logging configuration
- Application-specific settings

`Web.config` and `App.config` are not used by cross-platform .NET applications in the same way and should not be relied upon for runtime configuration.

---

## 9. Validate on a Non-Windows Platform (Optional)

If cross-platform compatibility is a goal, run the application on Linux or macOS to confirm there are no remaining platform-specific dependencies.

```bash
dotnet run --project Bookstore.Web
```

Address any `PlatformNotSupportedException` or similar runtime errors that surface during this step.