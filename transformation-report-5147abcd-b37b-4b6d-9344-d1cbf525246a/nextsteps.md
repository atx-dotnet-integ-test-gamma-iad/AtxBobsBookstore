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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or warnings that could indicate runtime issues.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure consistency across all three projects so there are no framework mismatch issues at runtime.

---

## 4. Check for Windows-Specific APIs

Even without build errors, the code may reference Windows-specific APIs that will fail at runtime on non-Windows platforms. Use the .NET Compatibility Analyzer to surface these issues:

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

Pay particular attention to `Bookstore.Data` if it uses any database drivers or file system paths that may be platform-dependent, and `Bookstore.Web` for any IIS-specific configuration.

---

## 5. Database Migration Validation

If `Bookstore.Data` uses Entity Framework Core, verify that all migrations are up to date and compatible with the new framework version.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are out of date or missing, generate a new migration:

```bash
dotnet ef migrations add PostMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Configuration File Review

Review `appsettings.json` in `Bookstore.Web` to confirm that connection strings, environment-specific settings, and any paths previously stored in `Web.config` or `App.config` have been correctly migrated. The legacy XML-based configuration system is replaced by `appsettings.json` in cross-platform .NET.

---

## 7. Run Unit and Integration Tests

If the solution contains test projects, execute them to validate core functionality:

```bash
dotnet test --configuration Release --logger trx
```

If no test projects exist, consider writing targeted tests for the domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding to deployment.

---

## 8. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and verify that:
- Pages load correctly
- Database reads and writes function as expected
- No runtime exceptions appear in the console output or logs

---

## 9. Review Middleware and HTTP Pipeline

In `Bookstore.Web`, review `Program.cs` (or `Startup.cs` if still present) to ensure the middleware pipeline is correctly configured for cross-platform .NET. Common areas to check include:

- Static file serving (`UseStaticFiles`)
- Authentication and authorization middleware
- Any custom HTTP modules that may have been migrated from the legacy `System.Web` pipeline

---

## 10. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assets, configuration files, and binaries are present before deploying to the target environment.