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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Verify the following:

- `appsettings.json` contains all necessary configuration values previously held in `Web.config`, including connection strings and application settings.
- Environment-specific configuration files (e.g., `appsettings.Development.json`) are in place where needed.
- Any `<connectionStrings>` or `<appSettings>` entries from the old `Web.config` have been migrated appropriately.

---

## 4. Verify Entity Framework or Data Access Layer

Since `Bookstore.Data` is present, confirm the data access layer is functioning correctly:

- If using Entity Framework Core, verify that migrations are present and up to date.
- Run the following to apply any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If the database schema has not changed, confirm that the connection string in `appsettings.json` points to the correct database instance.

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the URL shown in the console output (typically `https://localhost:5001` or `http://localhost:5000`).
- Exercise the primary workflows of the application, such as browsing, searching, and any data entry forms, to confirm end-to-end functionality.

---

## 6. Run Existing Tests

If the solution contains test projects, execute them to validate that existing functionality has not regressed.

```bash
dotnet test
```

Review the test results and investigate any failures. Pay particular attention to tests that interact with the database or external dependencies, as these may require updated configuration for the new environment.

---

## 7. Check for Platform-Specific Code

Search the codebase for any APIs that were available in .NET Framework but are not available or behave differently in cross-platform .NET. Common areas to check include:

- `System.Web` references, which are not available in cross-platform .NET.
- Windows Registry access (`Microsoft.Win32.Registry`).
- `AppDomain` usage patterns that differ between runtimes.
- Any P/Invoke calls or native interop that may be OS-specific.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify remaining issues.

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory to ensure all necessary files, including static assets and configuration files, are present before deploying to the target environment.