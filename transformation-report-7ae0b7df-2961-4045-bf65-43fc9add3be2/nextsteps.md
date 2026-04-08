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

Inspect `Bookstore.Data` and `Bookstore.Web` for any dependencies that are Windows-only, such as:

- `System.Web` references
- Windows Registry access
- COM interop
- `Microsoft.Web.Infrastructure`

These will not function on Linux or macOS and will require replacement with cross-platform equivalents.

---

## 5. Database and Data Layer Validation

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The EF Core version referenced is compatible with the target framework.
- Any pending migrations are up to date.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply migrations against a test database to verify schema correctness:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Existing Tests

If the solution contains a test project, execute the test suite to validate that business logic and data access behavior are preserved after migration.

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether failures are due to migration issues or pre-existing defects.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project and verify core functionality through the browser.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Manually verify the following areas at a minimum:

- Application startup with no runtime exceptions
- Database connectivity and data retrieval
- Core user-facing pages render correctly
- Form submissions and write operations function as expected

---

## 8. Review Configuration Files

Confirm that `appsettings.json` contains all required configuration values that may have previously resided in `Web.config` or `App.config`. Pay particular attention to:

- Connection strings
- Application-specific settings
- Logging configuration

Legacy `Web.config` transformation behavior does not apply in .NET and must be handled through environment-specific `appsettings.{Environment}.json` files or environment variables.

---

## 9. Validate on Target Deployment Platform

If the intended deployment platform is Linux or macOS, run the application on that platform explicitly to surface any remaining platform-specific issues that may not appear on Windows.

```bash
dotnet publish --configuration Release --runtime linux-x64 --self-contained false
```

Test the published output on the target machine or environment before considering the migration complete.