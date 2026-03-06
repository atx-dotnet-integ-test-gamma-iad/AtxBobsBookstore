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

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `net4x` or older target frameworks exclusively, consider finding their cross-platform equivalents on [NuGet](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET across all projects, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Mixing target frameworks (e.g., one project targeting `net6.0` and another `net8.0`) can cause compatibility issues at runtime.

---

## 4. Check for Windows-Specific Dependencies

Even when a build succeeds, some APIs are Windows-only and will fail at runtime on Linux or macOS. Run the .NET Compatibility Analyzer to surface any such issues:

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

Pay particular attention to any `CA1416` warnings, which indicate platform-specific API usage.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to verify that core logic has not been broken during transformation.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no test projects exist, consider writing basic tests for the `Bookstore.Domain` layer to validate business logic, and integration tests for `Bookstore.Data` to validate database interactions.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify that:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql.EntityFrameworkCore.PostgreSQL`).
- Connection strings in `appsettings.json` are accurate for the target environment.
- Migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm functionality is intact. Review the console output and application logs for any runtime exceptions.

---

## 8. Review Configuration Files

Confirm that `appsettings.json` and `appsettings.Production.json` contain all required configuration values. Legacy projects often stored configuration in `Web.config` or `App.config`, which are not used in cross-platform .NET. Ensure any such values have been migrated to the appropriate `appsettings` files or environment variables.

---

## 9. Publish the Application

Once local validation is complete, publish the application to produce deployment artifacts.

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all required files are present before deploying to the target environment.