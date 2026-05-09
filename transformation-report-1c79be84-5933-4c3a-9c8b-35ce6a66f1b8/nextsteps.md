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

Run a NuGet package restore to ensure all dependencies are resolved correctly:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework Monikers

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker unless there is a specific reason to do so.

---

## 4. Check for Windows-Specific Dependencies

Use the .NET Compatibility Analyzer or review the code manually for any APIs that are Windows-only. Common areas to inspect in a Bookstore-style application include:

- `System.Web` references (should be replaced with ASP.NET Core equivalents)
- `HttpContext` usage patterns from the old `System.Web.HttpContext`
- Windows Registry access
- `ConfigurationManager` (should be replaced with `IConfiguration` from `Microsoft.Extensions.Configuration`)

Run the following to surface platform compatibility warnings:

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

---

## 5. Validate the Data Layer

If `Bookstore.Data` uses Entity Framework, confirm the version in use:

- **Entity Framework 6** — limited cross-platform support; consider migrating to **Entity Framework Core**.
- **Entity Framework Core** — verify the correct database provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).

Apply and verify any pending migrations:

```bash
dotnet ef migrations list
dotnet ef database update
```

---

## 6. Run Existing Tests

If the solution contains a test project, execute the test suite to verify that business logic and data access behave as expected after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests and determine whether failures are due to migration-related changes or pre-existing issues.

---

## 7. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Manually navigate through the key areas of the application, such as:

- Book listing and detail pages
- Any authentication or authorization flows
- Data entry and form submission
- Database read and write operations

Check the console output and application logs for any runtime exceptions or deprecation warnings.

---

## 8. Verify Configuration

Confirm that `appsettings.json` (and `appsettings.Development.json`) are present and correctly configured in `Bookstore.Web`. Connection strings and application settings that previously resided in `Web.config` or `App.config` should now be present in these JSON configuration files.

Example structure:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=...;Database=Bookstore;..."
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information"
    }
  }
}
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.