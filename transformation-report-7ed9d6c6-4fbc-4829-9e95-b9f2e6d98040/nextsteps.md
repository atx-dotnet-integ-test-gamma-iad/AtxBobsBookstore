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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Windows-Specific Dependencies

Inspect the `Bookstore.Data` and `Bookstore.Web` projects for any remaining Windows-specific dependencies, such as:

- `System.Web` references
- Windows Registry access
- COM interop
- `Microsoft.Web.Infrastructure`

These will not function on Linux or macOS and will need to be replaced with cross-platform equivalents.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after the migration.

```bash
dotnet test --configuration Release
```

Review test results carefully. Failures may indicate behavioral differences between the legacy .NET Framework and the new .NET runtime.

---

## 6. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core package is referenced (e.g., `Microsoft.EntityFrameworkCore`), not the legacy `EntityFramework` package.
- Any database migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

- Connection strings in `appsettings.json` are correct for the target environment.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project and verify that it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and exercise the primary workflows to confirm that pages load correctly and data operations function as expected.

---

## 8. Review Configuration Migration

Confirm that any settings previously stored in `Web.config` or `App.config` have been correctly moved to `appsettings.json`. Pay particular attention to:

- Connection strings
- Application-specific keys
- Authentication or authorization settings

---

## 9. Validate on Target Operating System

If the goal is cross-platform deployment, run the application on the intended target OS (Linux or macOS) to surface any remaining platform-specific issues that may not appear on Windows.

```bash
dotnet publish --configuration Release --runtime linux-x64 --self-contained false
```

Test the published output on the target system before proceeding to a production environment.