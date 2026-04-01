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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider writing tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Data Layer Functionality

Since `Bookstore.Data` handles data access, verify the following:

- **Database provider**: Confirm the correct EF Core provider (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql`, or `Sqlite`) is referenced in the `.csproj` and configured in the application.
- **Migrations**: If Entity Framework Core is used, check that existing migrations are compatible with the new target framework:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- **Apply migrations** to a local or development database to verify schema integrity:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Validate Runtime Behavior of the Web Project

Run the web application locally and verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:

- The application starts without runtime exceptions.
- All routes and pages load as expected.
- Any configuration values previously stored in `Web.config` have been correctly migrated to `appsettings.json`.
- Connection strings are correctly defined and the application can connect to the database.

---

## 6. Review Configuration Files

Ensure that `appsettings.json` and `appsettings.Development.json` contain all necessary configuration that was previously handled by `Web.config` or `App.config`, including:

- Connection strings
- Logging settings
- Application-specific settings

---

## 7. Check for Platform-Specific API Usage

Run the .NET Compatibility Analyzer to identify any remaining platform-specific API calls that may cause issues on non-Windows environments:

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

Address any `CA1416` (platform compatibility) warnings if cross-platform deployment is intended.

---

## 8. Publish the Application

Once validation is complete, publish the application to a target folder:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the output directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.