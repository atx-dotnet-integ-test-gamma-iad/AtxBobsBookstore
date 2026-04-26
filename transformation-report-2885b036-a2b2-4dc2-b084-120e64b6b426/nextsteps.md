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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting `net6.0` or `net7.0`, consider updating to `net8.0` as those versions have reached or are approaching end of life.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, verify that no Windows-only APIs are being used unintentionally. Run the compatibility analyzer:

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

Pay attention to any `CA1416` platform compatibility warnings, which indicate calls to Windows-specific APIs that would fail on Linux or macOS.

---

## 5. Run the Application Locally

Start the `Bookstore.Web` project and verify the application runs as expected.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Manually verify the following:
- The application starts without exceptions.
- All pages or API endpoints load correctly.
- Database connectivity works as expected (see step 6).

---

## 6. Validate Data Layer and Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, confirm that migrations are up to date and the database schema is correct.

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to your development database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the project previously used a different ORM or raw ADO.NET with `System.Data`, verify that the connection strings in `appsettings.json` are correct and that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql`) is referenced.

---

## 7. Execute Automated Tests

If the solution contains test projects, run them to verify that existing functionality has not regressed.

```bash
dotnet test
```

Review the test results for any failures. Failures may indicate behavioral differences between .NET Framework and modern .NET that need to be addressed, such as changes in serialization, globalization, or HTTP client behavior.

---

## 8. Review Configuration and Middleware

For `Bookstore.Web`, confirm that the application configuration has been correctly migrated from `Web.config` to `appsettings.json`. Key areas to check:

- Connection strings
- Application settings
- Authentication and authorization configuration
- Any custom HTTP handlers or modules, which must be rewritten as ASP.NET Core middleware

---

## 9. Publish the Application

Once validation is complete, publish the application to a target directory.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm that all required assets, static files, and configuration files are present before deploying to the target environment.