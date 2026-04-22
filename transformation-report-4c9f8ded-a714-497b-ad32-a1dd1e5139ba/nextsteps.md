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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs, as these may indicate areas that need attention.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding unit tests for the core logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

---

## 4. Verify Runtime Behavior

Start the web application locally and manually verify key functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas at a minimum:

- Application startup completes without exceptions
- Database connectivity works as expected (check connection strings in `appsettings.json`)
- Core user-facing pages and features load and function correctly
- Any authentication or authorization flows behave as before

---

## 5. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` for application configuration. Confirm that:

- All relevant settings from the legacy `Web.config` or `App.config` have been migrated to `appsettings.json`
- Environment-specific configuration (e.g., `appsettings.Development.json`) is in place
- Connection strings are correct and accessible in the new configuration system via `IConfiguration`

---

## 6. Check for Platform-Specific Code

Review the codebase for any remaining Windows-specific APIs or dependencies that may cause issues on non-Windows platforms:

- References to `System.Web` (should have been removed during transformation)
- Windows Registry access
- Windows-specific file path assumptions (use `Path.Combine` throughout)
- Any P/Invoke calls targeting Windows-only libraries

---

## 7. Validate Data Layer

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`)
- Migrations are present and up to date by running:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- Apply any pending migrations to a test database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present.