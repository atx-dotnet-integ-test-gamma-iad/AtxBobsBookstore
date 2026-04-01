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

Review the output for any warnings about deprecated or unlisted packages that may need to be updated.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or `netcoreapp3.1`, update it accordingly and re-run the build.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently in cross-platform .NET compared to .NET Framework. Pay particular attention to:

- **`System.Web` dependencies** — these are not available in .NET. Ensure `Bookstore.Web` has been migrated to ASP.NET Core equivalents.
- **Entity Framework** — confirm that `Bookstore.Data` is using EF Core and not the legacy `System.Data.Entity` namespace.
- **Configuration** — verify that `Web.config` or `App.config` usage has been replaced with `appsettings.json` and `IConfiguration`.
- **Windows-specific APIs** — check for any use of the registry, `System.Drawing`, or other Windows-only libraries that may fail at runtime on non-Windows platforms.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core logic.

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic tests for the domain and data layers to verify expected behavior before proceeding.

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and any data entry features, to confirm end-to-end functionality.

---

## 7. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework Core with migrations, verify the database schema is up to date.

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Confirm that the connection string in `appsettings.json` points to the correct database instance for your environment.

---

## 8. Test on Target Platform

If the goal is cross-platform support, run the application on the intended non-Windows platform (Linux or macOS) to surface any platform-specific runtime issues that would not appear during a Windows build.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check application logs for any `PlatformNotSupportedException` or file path issues caused by differences in path separators or case-sensitive file systems.

---

## 9. Review Publish Output

Publish the application to verify the output is complete and self-contained if required.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all expected assemblies, static assets, and configuration files are present.