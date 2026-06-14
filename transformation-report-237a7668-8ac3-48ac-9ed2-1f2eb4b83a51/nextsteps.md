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

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, consider updating them to versions that explicitly target `net6.0` or later.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that the build output reports zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, such as `net6.0`, `net7.0`, or `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

Also confirm that any `<TargetFrameworkVersion>` or `<TargetFrameworkIdentifier>` remnants from the legacy `.NET Framework` project format have been removed.

---

## 4. Check for Windows-Specific Dependencies

Inspect `Bookstore.Data` and `Bookstore.Web` for any remaining references to Windows-only APIs or libraries, such as:

- `System.Web`
- `Microsoft.Web.Infrastructure`
- Windows Registry access
- COM interop

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify platform-specific calls if needed.

---

## 5. Validate the Data Layer

If `Bookstore.Data` uses Entity Framework, confirm the correct version is referenced:

- **Entity Framework Core** should be used in place of **Entity Framework 6** for full cross-platform support.

Run any existing database migrations to verify they apply cleanly:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and any data entry forms, to confirm end-to-end functionality.

---

## 7. Execute Unit Tests

If the solution contains a test project, run all tests to confirm no regressions were introduced during the migration:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests and determine whether the failures are due to migration-related changes or pre-existing issues.

---

## 8. Review Configuration Files

Confirm that `appsettings.json` (and `appsettings.Development.json`) contains all configuration values that were previously held in `Web.config` or `App.config`, including:

- Connection strings
- Application settings
- Logging configuration

The legacy `<connectionStrings>` and `<appSettings>` sections from `Web.config` should now be represented in the JSON configuration format:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information"
    }
  }
}
```

---

## 9. Validate on a Non-Windows Platform (Optional)

If cross-platform support is a requirement, run the application on Linux or macOS to confirm there are no platform-specific runtime failures:

```bash
dotnet run --project Bookstore.Web
```

Address any `PlatformNotSupportedException` or similar runtime errors that surface during this step.