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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages. Address any that appear before proceeding.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or target framework compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another .NET Framework moniker, update it accordingly and re-run the build.

---

## 4. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration.

```bash
dotnet test --configuration Release --verbosity normal
```

Review the test output for any failures. Pay particular attention to tests that cover data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`, as these layers are most likely to be affected by framework differences.

---

## 5. Verify Database Connectivity and Migrations

If `Bookstore.Data` uses Entity Framework Core, confirm that any existing migrations are compatible with the new target framework.

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If migrations are missing or out of date, add a new migration and apply it to the target database.

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data --startup-project app/Bookstore.Web
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing books, to confirm that the data and domain layers are functioning correctly end to end.

---

## 7. Review Configuration Files

Check `appsettings.json` and any environment-specific configuration files in `Bookstore.Web` to ensure connection strings, API keys, and other settings have been carried over correctly from the legacy configuration (e.g., `Web.config`).

If the legacy project used `Web.config` for configuration, confirm those values have been migrated to the `appsettings.json` format, as `Web.config` is not used in cross-platform .NET.

---

## 8. Check for Windows-Specific API Usage

Even without build errors, certain APIs may compile successfully but fail at runtime on non-Windows platforms. Use the .NET Compatibility Analyzer or review the code manually for usage of APIs such as:

- `System.Web` types
- Windows registry access
- Windows-specific file path assumptions

Address any such usages to ensure true cross-platform compatibility.