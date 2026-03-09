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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check [NuGet.org](https://www.nuget.org) for updated versions compatible with your target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, as some warnings may indicate runtime issues that do not surface at compile time.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

- Review any failing tests carefully. A failure may indicate a behavioral difference between the legacy .NET Framework APIs and their cross-platform .NET equivalents.
- Pay particular attention to tests covering data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`.

If no test projects currently exist, consider adding tests for critical paths before deploying.

---

## 4. Verify Entity Framework or Data Access Layer

Since `Bookstore.Data` is present, confirm that your data access layer is functioning correctly:

- If using **Entity Framework Core**, verify that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to a development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that connection strings in `appsettings.json` are correctly configured for the target environment.

---

## 5. Run the Application Locally

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application and test primary user flows such as browsing, searching, and any data entry forms.
- Check the console output and application logs for any runtime exceptions or deprecation warnings.
- Verify that static assets, routing, and middleware behave as expected under the new .NET runtime.

---

## 6. Review Configuration Files

Cross-platform .NET handles configuration differently from .NET Framework. Confirm the following:

- `Web.config` transformations have been replaced with `appsettings.json` and environment-specific variants such as `appsettings.Production.json`.
- Any settings previously stored in `Web.config` under `<appSettings>` or `<connectionStrings>` have been moved to `appsettings.json`.
- Authentication, authorization, and session middleware are configured correctly in `Program.cs` or `Startup.cs`.

---

## 7. Check for Platform-Specific API Usage

Even without build errors, some APIs behave differently or are unavailable on non-Windows platforms. Review the codebase for:

- Use of `System.Web` namespaces, which are not available in cross-platform .NET.
- Windows Registry access or Windows-specific file paths.
- Any P/Invoke calls or COM interop that may not function outside of Windows.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify remaining issues.

---

## 8. Validate Across Target Platforms

If cross-platform support is a goal, test the application on each intended operating system (Windows, Linux, macOS) to surface any platform-specific runtime issues before deploying to production.