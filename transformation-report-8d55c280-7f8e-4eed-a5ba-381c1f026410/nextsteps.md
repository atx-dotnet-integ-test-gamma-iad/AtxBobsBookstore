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

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Windows-Specific Dependencies

Inspect each project for any NuGet packages or APIs that are Windows-only. Common examples include:

- `Microsoft.Web.Infrastructure`
- `System.Web.*` namespaces
- Windows Registry access
- COM interop

Use the .NET Upgrade Assistant compatibility analyzer or the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify any remaining platform-specific calls.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the tests to verify that business logic and data access behavior remain correct after migration.

```bash
dotnet test --configuration Release
```

Review test results for any failures that may indicate behavioral differences between the legacy framework and the new target framework.

---

## 6. Validate the Web Application Locally

Run the `Bookstore.Web` project locally and manually verify core functionality.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas:

- Application startup without exceptions
- Database connectivity via `Bookstore.Data`
- Domain logic correctness via `Bookstore.Domain`
- All primary routes and pages load as expected
- Any authentication or authorization flows behave correctly

---

## 7. Verify Database Migrations

If the project uses Entity Framework Core, confirm that migrations are up to date and can be applied to the target database.

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations are missing or out of date, add a new migration and apply it.

```bash
dotnet ef migrations add PostMigration --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj

dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Review Configuration Files

Confirm that `appsettings.json` (and environment-specific variants such as `appsettings.Production.json`) contain all required configuration values, including:

- Connection strings
- Logging settings
- Any application-specific configuration keys that were previously stored in `Web.config` or `App.config`

Legacy `Web.config` or `App.config` values are not automatically read by .NET applications and must be migrated to `appsettings.json` or environment variables.

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment package.

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory before deploying to the target environment.