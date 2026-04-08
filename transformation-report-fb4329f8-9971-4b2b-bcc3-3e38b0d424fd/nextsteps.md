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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly around:
- Nullable reference types
- Obsolete API usage
- Platform compatibility analyzers (CA1416 or similar)

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Verify the following:

- `appsettings.json` contains all necessary configuration values previously held in `Web.config` (connection strings, app settings, etc.).
- `appsettings.Development.json` is present and contains environment-specific overrides.
- Any connection strings in `Bookstore.Data` are correctly referencing the new configuration system via `IConfiguration`.

---

## 4. Verify Entity Framework or Data Layer

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core provider package is installed (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Migrations are present and up to date. Run the following to check:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations need to be applied to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

Navigate to the URL shown in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and manually verify that core pages and features load correctly.

---

## 6. Check for Runtime Errors

While running the application locally, test the following areas:

- All primary routes and pages render without exceptions.
- Database read and write operations function correctly.
- Any authentication or authorization mechanisms behave as expected.
- Static files (CSS, JavaScript, images) are served correctly.

Review the console output and any log files for unhandled exceptions or warnings during these tests.

---

## 7. Run Automated Tests (If Applicable)

If the solution contains test projects, execute them to validate business logic and data layer behavior.

```bash
dotnet test
```

Review the test results for any failures that may indicate behavioral differences introduced during the migration.

---

## 8. Validate Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid compatibility issues between assemblies.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present, including static assets and configuration files.