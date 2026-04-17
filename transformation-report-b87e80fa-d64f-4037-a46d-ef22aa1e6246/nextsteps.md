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

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly and re-run the build.

---

## 4. Check for Windows-Specific APIs

Even when a project builds successfully, it may still contain APIs that only function on Windows. Run the .NET compatibility analyzer to surface any such usages.

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

Pay particular attention to any `CA1416` platform compatibility warnings, which indicate calls to Windows-only APIs.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to validate that business logic and data access behavior remain correct after migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no test projects currently exist, consider adding unit tests for the core logic in `Bookstore.Domain` and `Bookstore.Data` before proceeding further.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify that:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql.EntityFrameworkCore.PostgreSQL`).
- Migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to a local or development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the web application and verify it runs correctly on the local machine.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL printed in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and exercise the main application workflows to confirm expected behavior.

---

## 8. Review Configuration Files

Confirm that `appsettings.json` and `appsettings.Development.json` contain the correct configuration values for the new environment. Legacy `Web.config` or `App.config` entries are not read by .NET applications and must be migrated to the `appsettings.json` structure or environment variables if they have not been already.

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment package.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected assets are present before deploying to the target environment.