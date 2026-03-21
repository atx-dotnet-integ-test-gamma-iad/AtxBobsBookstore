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

Review the output for any warnings related to package compatibility or version conflicts. Address any packages that may have been targeting the old .NET Framework and have not been updated to a compatible .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly:
- Nullable reference type warnings
- Obsolete API usage
- Platform compatibility warnings

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Verify the following:

- `appsettings.json` contains all necessary configuration values previously held in `Web.config`, including connection strings and application settings.
- `appsettings.Development.json` is present and contains environment-specific overrides where appropriate.
- Any `<connectionStrings>` or `<appSettings>` entries from the old `Web.config` have been migrated correctly.

---

## 4. Verify the Data Layer

Since `Bookstore.Data` depends on `Bookstore.Domain`, validate the data layer carefully:

- Confirm that Entity Framework (or whichever ORM is in use) has been updated to a compatible version for cross-platform .NET.
- If using Entity Framework Core, verify that migrations are present and up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to a local development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually verify the following:
- The application starts without exceptions.
- Pages load and render correctly.
- Database connectivity is functional (e.g., data is retrieved and displayed).
- Any authentication or authorization mechanisms behave as expected.

---

## 6. Execute Existing Tests

If the solution contains a test project, run all tests to validate that existing functionality has not regressed.

```bash
dotnet test
```

Review the test results for any failures. Pay particular attention to:
- Tests that interact with the database or external services, as connection behavior may differ.
- Tests that relied on `HttpContext` or other ASP.NET-specific APIs that have changed in cross-platform .NET.

---

## 7. Check for Runtime Compatibility Issues

Some issues do not surface at build time. Review the following areas manually:

- **Session and State Management**: Ensure session configuration in `Program.cs` or `Startup.cs` is correct.
- **Static Files**: Confirm that static files (CSS, JS, images) are being served correctly from the `wwwroot` folder.
- **Dependency Injection**: Verify that all services are registered in the DI container, as .NET Framework projects may have used different patterns such as Unity or Autofac that require explicit migration.
- **Logging**: Confirm that logging is configured correctly using `Microsoft.Extensions.Logging` or a compatible third-party provider.

---

## 8. Publish the Application

Once the application has been validated locally, publish it to a target directory for deployment.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory to ensure all required files, including static assets and configuration files, are present before deploying to the target environment.