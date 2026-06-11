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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check their respective NuGet pages for recommended replacements targeting the current .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility, as these can surface runtime issues even when the build succeeds.

---

## 3. Verify Configuration Files

Check `appsettings.json` and any environment-specific variants (e.g., `appsettings.Development.json`) in `Bookstore.Web` to confirm the following:

- Connection strings are valid and point to the correct database instances.
- Any configuration keys previously stored in `Web.config` have been correctly migrated to the `appsettings.json` format.
- Logging configuration is present and correct.

If the project previously used `Web.config` transforms, ensure that equivalent environment-based configuration is in place using the `IConfiguration` system.

---

## 4. Review Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm the following:

- If Entity Framework is used, verify that the correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Run any pending migrations or verify the database schema is up to date.

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

- If a different data access strategy is used, confirm that connection handling and query execution behave as expected on the target platform.

---

## 5. Run Unit and Integration Tests

If a test project exists in the solution, execute the test suite to validate business logic and data access behavior.

```bash
dotnet test
```

If no tests currently exist, consider writing basic smoke tests for the core domain logic in `Bookstore.Domain` and the data access methods in `Bookstore.Data` before deploying.

---

## 6. Run the Application Locally

Start the web application locally to verify it runs correctly end to end.

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Manually verify the following:

- The application starts without exceptions.
- Key pages and routes load correctly.
- Database reads and writes function as expected.
- Any authentication or authorization flows work correctly.

---

## 7. Check for Platform-Specific Code

Search the codebase for any remaining Windows-specific APIs or dependencies that may not be supported on Linux or macOS if cross-platform deployment is intended. Common areas to check include:

- Use of `System.Drawing` (replace with a supported alternative such as `SkiaSharp` if needed).
- Registry access via `Microsoft.Win32`.
- Windows-only file path assumptions.
- Any P/Invoke calls targeting Windows system libraries.

---

## 8. Review Target Framework

Confirm that all three projects target the intended .NET version by inspecting each `.csproj` file.

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all projects and that the chosen version is a Long-Term Support (LTS) release if long-term stability is a requirement.