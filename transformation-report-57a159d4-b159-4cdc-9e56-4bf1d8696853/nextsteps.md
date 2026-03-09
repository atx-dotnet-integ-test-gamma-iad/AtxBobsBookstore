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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite:

```bash
dotnet test --configuration Release
```

If no test projects currently exist, it is worth adding unit tests for the core logic in `Bookstore.Domain` and integration tests for `Bookstore.Data` to verify database interactions behave as expected on the new runtime.

---

## 4. Verify Database Migrations (if applicable)

If `Bookstore.Data` uses Entity Framework Core, confirm that all migrations are up to date and compatible with the target database:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and confirm that:

- Pages load without exceptions
- Data is read from and written to the database correctly
- Any authentication or authorization flows behave as expected

---

## 6. Review Configuration Files

Check `appsettings.json` and `appsettings.Production.json` in `Bookstore.Web` to ensure:

- Connection strings are correct for the target environment
- Any environment-specific settings that previously lived in `Web.config` have been properly migrated to the new configuration system
- Sensitive values are stored using environment variables or a secrets manager rather than hardcoded in configuration files

---

## 7. Check for Removed or Changed APIs

Cross-platform .NET removes certain APIs that were available in .NET Framework. Use the .NET Upgrade Assistant compatibility analyzer or the following command to surface any remaining compatibility concerns:

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

Pay particular attention to:

- `System.Web` usages, which are not available in cross-platform .NET
- Windows-specific APIs that may not behave correctly on Linux or macOS
- Any third-party libraries that may still target .NET Framework only

---

## 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assets, static files, and configuration files are present before deploying to the target environment.