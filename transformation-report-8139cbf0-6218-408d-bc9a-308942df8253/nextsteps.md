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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check their respective NuGet pages for recommended replacements that target the current .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid compatibility mismatches between `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web`.

---

## 4. Check for Windows-Specific Dependencies

Even without build errors, the project may still contain APIs or packages that only function on Windows. Run the .NET compatibility analyzer or review the project for any of the following:

- References to `System.Web` (not available in cross-platform .NET)
- Use of the Windows Registry (`Microsoft.Win32.Registry`)
- Windows Communication Foundation (WCF) server-side components
- Any NuGet packages that list only `net4x` or `windows` as supported targets

Use the following command to check for platform compatibility warnings:

```bash
dotnet build --configuration Release /p:EnableNETAnalyzers=true
```

---

## 5. Run Unit Tests

If the solution contains a test project, execute the test suite to verify that business logic and data access behavior is preserved after migration.

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider writing basic tests for the core logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 6. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The project references `Microsoft.EntityFrameworkCore` and the appropriate database provider (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Connection strings in `appsettings.json` are valid and accessible from the target environment.
- Pending migrations, if any, are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the web application to confirm it runs correctly on the new framework.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL shown in the console output and verify that the application loads and core functionality (browsing, data retrieval, etc.) works as expected.

---

## 8. Review `appsettings.json` and Configuration

Confirm that configuration previously handled by `Web.config` or `App.config` has been correctly migrated to `appsettings.json`. Pay particular attention to:

- Connection strings
- Application-specific settings
- Logging configuration

---

## 9. Publish the Application

Once local validation is complete, publish the application to produce deployment artifacts.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all necessary files are present, then deploy to the target environment.