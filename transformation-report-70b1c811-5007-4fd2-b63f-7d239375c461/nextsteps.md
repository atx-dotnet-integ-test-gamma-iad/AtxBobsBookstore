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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding with any builds or tests.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, as some warnings may indicate compatibility concerns that could surface at runtime.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific APIs

Even without build errors, the code may reference APIs that only function on Windows. Run the .NET compatibility analyzer to surface any such issues.

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

Pay particular attention to:
- `System.Web` references (not supported on cross-platform .NET)
- Windows Registry access
- Windows-specific file path assumptions (e.g., backslashes)
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

---

## 5. Validate the Data Layer (`Bookstore.Data`)

If the project uses Entity Framework, confirm the version being used is Entity Framework Core and not the legacy Entity Framework 6.

- Check that `DbContext` and related classes are using `Microsoft.EntityFrameworkCore` namespaces.
- Run any existing database migrations to verify they apply cleanly:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests to verify functional correctness after migration.

```bash
dotnet test --configuration Release --verbosity normal
```

If no tests currently exist, consider writing tests that cover the core domain logic in `Bookstore.Domain` and the data access logic in `Bookstore.Data` before proceeding to deployment.

---

## 7. Run the Application Locally

Start the web application locally and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Manually verify the following:
- Application starts without exceptions in the console output.
- All pages load and render correctly.
- Database read and write operations function as expected.
- Authentication and authorization flows work if applicable.
- Static files (CSS, JavaScript, images) are served correctly.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` contains all necessary configuration that may have previously resided in `Web.config` or `App.config`.

- Connection strings
- Logging configuration
- Application-specific settings

Confirm that environment-specific overrides (e.g., `appsettings.Development.json`) are in place where needed.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is production-ready.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present, including static assets and configuration files.