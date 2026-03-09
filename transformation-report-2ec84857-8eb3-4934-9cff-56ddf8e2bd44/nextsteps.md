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

## 4. Check for Windows-Specific APIs

Even without build errors, the code may still reference Windows-only APIs that will fail at runtime on non-Windows platforms. Use the .NET Compatibility Analyzer to surface these issues.

```bash
dotnet build /p:EnableNETAnalyzers=true
```

Look for analyzer warnings prefixed with `CA1416` (platform compatibility). Address any Windows-specific calls in `Bookstore.Data` and `Bookstore.Web` as a priority.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to validate that existing functionality is preserved after migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review test output carefully. Failures that did not exist before the migration indicate regressions introduced during the transformation.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework or another data access library, verify the following:

- The connection string in `appsettings.json` is correct for the target environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is compatible with the target framework version.

---

## 7. Run the Web Application Locally

Start the web application to confirm it runs correctly end-to-end.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm runtime behavior is correct. Pay attention to:

- Routing and middleware configuration in `Program.cs` or `Startup.cs`
- Static file serving
- Authentication and authorization flows, if present

---

## 8. Review Configuration Changes

Cross-platform .NET uses `appsettings.json` and environment variables rather than `Web.config` or `App.config`. Confirm that:

- All necessary configuration values have been migrated to `appsettings.json`.
- No legacy `<system.web>` or `<connectionStrings>` sections remain in any `.config` file that the application depends on at runtime.
- Environment-specific overrides use `appsettings.{Environment}.json` files where appropriate.

---

## 9. Test on Target Platform

If the goal is cross-platform execution, run the application on the intended non-Windows platform (e.g., Linux) to catch any remaining platform-specific issues that static analysis may have missed.

```bash
dotnet publish --configuration Release --runtime linux-x64 --self-contained false
```

Then execute the published output on the target machine and verify expected behavior.