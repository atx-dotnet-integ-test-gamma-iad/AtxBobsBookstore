# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, as some warnings may indicate compatibility concerns that could cause runtime issues.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting an older version such as `net6.0` or `net7.0`, consider updating to `net8.0` as those versions have reached or are approaching end of life.

---

## 4. Check for Removed or Changed APIs

Some APIs available in .NET Framework are not present or have changed in cross-platform .NET. Review the following areas specific to a Bookstore-style web application:

- **Entity Framework**: Confirm the project has migrated from `EntityFramework` (EF6) to `Microsoft.EntityFrameworkCore`. EF6 has limited support on cross-platform .NET.
- **System.Web**: This namespace is not available in cross-platform .NET. Any remaining references should have been replaced with `Microsoft.AspNetCore` equivalents.
- **Configuration**: Ensure `System.Configuration.ConfigurationManager` usage has been replaced with `Microsoft.Extensions.Configuration` and `appsettings.json`.
- **HTTP Handlers and Modules**: These do not exist in ASP.NET Core. Verify they have been replaced with middleware.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) if you need a more thorough API compatibility check.

---

## 5. Run Database Migrations

If the project uses Entity Framework Core, verify that migrations are in place and up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

Apply migrations to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually verify the following:

- Pages load without errors
- Database reads and writes function correctly
- Authentication and authorization behave as expected
- Any file or static asset references resolve correctly

Check the console output and application logs for any runtime exceptions or warnings.

---

## 7. Execute Automated Tests

If the solution contains test projects, run them to validate business logic and data layer behavior:

```bash
dotnet test
```

Review the test results for any failures. If tests were written against .NET Framework-specific behavior, they may require updates to run correctly under cross-platform .NET.

If no automated tests exist, consider adding unit tests for the `Bookstore.Domain` and `Bookstore.Data` projects as a baseline for future changes.

---

## 8. Validate Cross-Platform Behavior (If Applicable)

If the application is intended to run on Linux or macOS, verify the following:

- **File paths**: Ensure no hardcoded Windows-style paths (e.g., `C:\`) exist in configuration or code. Use `Path.Combine` for path construction.
- **Case sensitivity**: Linux file systems are case-sensitive. Verify that file references, view names, and static asset paths use consistent casing.
- **Windows-specific APIs**: Confirm no calls to Windows Registry, COM interop, or other Windows-only APIs remain.