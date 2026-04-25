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

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, consider updating them to versions that are compatible with the current .NET target framework.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay particular attention to any warnings about obsolete APIs, as these may become errors in future .NET versions.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all projects. Mismatched target frameworks between `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web` can cause runtime issues even when the build succeeds.

---

## 4. Check for Windows-Specific APIs

Even when a project builds successfully, it may still contain calls to Windows-specific APIs that will fail on Linux or macOS at runtime. Use the .NET Compatibility Analyzer or the following command to check:

```bash
dotnet build /p:PlatformTarget=AnyCPU
```

Additionally, search the codebase for usages of APIs such as:
- `Microsoft.Win32` registry access
- `System.Windows.Forms` or `System.Drawing` (non-cross-platform variants)
- Windows-specific file path assumptions (e.g., hardcoded backslashes)

Replace any such usages with cross-platform equivalents where applicable.

---

## 5. Run Existing Tests

If the solution contains a test project, run all tests to validate that behavior has not changed during the migration.

```bash
dotnet test --configuration Release
```

Review the test results carefully. Any failing tests should be investigated to determine whether they represent regressions introduced during the migration or pre-existing issues.

If no test project currently exists, consider writing integration and unit tests for the core logic in `Bookstore.Domain` and `Bookstore.Data` before deploying.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core or another ORM, verify the following:

- The connection string in `appsettings.json` (or equivalent) is correct for the target environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql`) is compatible with the target .NET version.

---

## 7. Run the Application Locally

Start the web application locally to perform a manual smoke test.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that core functionality works as expected, including:

- Page rendering
- Data retrieval and display
- Any forms or user input flows

---

## 8. Verify Configuration and Environment Settings

Check that `appsettings.json` and any environment-specific configuration files (e.g., `appsettings.Production.json`) are correctly set up. Confirm that sensitive values such as connection strings are not hardcoded and are instead managed through environment variables or a secrets manager appropriate for your environment.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present.