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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues beyond what was reported.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas of the code that may behave differently under modern .NET.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed during the migration.

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider writing tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Data Layer Functionality

Since `Bookstore.Data` handles data access, confirm the following:

- The database connection strings in your configuration files (e.g., `appsettings.json`) are correct and accessible from the new runtime environment.
- If Entity Framework is used, verify that migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If there are pending migrations or the migration history does not align, generate a new migration or update the database schema accordingly:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application to confirm it runs correctly in a local environment.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually verify that core functionality such as browsing, searching, and any data-driven pages work as expected.

---

## 6. Review Configuration Files

Check that `appsettings.json` and any environment-specific configuration files (e.g., `appsettings.Development.json`) are properly structured for .NET. Pay attention to:

- Connection strings
- Logging configuration
- Any settings that were previously stored in `Web.config` or `App.config` that may need to be manually migrated to the new JSON-based configuration system.

---

## 7. Check for Platform-Specific API Usage

Review the codebase for any APIs that were available in .NET Framework but are absent or behave differently in cross-platform .NET. Common areas to check include:

- `System.Web` references, which are not available in modern .NET
- Windows-specific APIs such as the registry or certain file path assumptions
- Any third-party libraries that may still target .NET Framework only

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to identify remaining compatibility concerns if needed.

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory to ensure all required assets, configuration files, and binaries are present before deploying to the target environment.