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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs introduced during the migration.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review the test results carefully. Any failing tests may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

---

## 4. Verify Entity Framework or Data Layer

Since the solution includes a `Bookstore.Data` project, verify that the data layer is functioning correctly:

- Confirm that the correct EF Core packages are referenced (e.g., `Microsoft.EntityFrameworkCore`).
- If the project uses database migrations, run the following to apply them against a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that connection strings in `appsettings.json` are correctly configured for the target environment.

---

## 5. Run the Web Application Locally

Start the web application locally to perform a manual smoke test:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that:

- Pages load without errors.
- Data is read from and written to the database correctly.
- Any authentication or session-based functionality works as expected.

---

## 6. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` for application configuration. Confirm that:

- All configuration has been moved to `appsettings.json` or environment variables.
- Any `Web.config` transforms or `app.config` entries from the legacy project have been accounted for.
- Logging configuration is correctly set up, typically via `appsettings.json` using the `Logging` section.

---

## 7. Check for Platform-Specific API Usage

Run the .NET Upgrade Analyzer or review the code manually for any remaining usage of Windows-specific APIs that may not be available cross-platform. Common areas to check include:

- `System.Drawing` (replaced by cross-platform alternatives such as `SkiaSharp` or `ImageSharp`).
- Registry access via `Microsoft.Win32.Registry`.
- Windows-specific authentication mechanisms.

You can use the following command to check for compatibility warnings:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

---

## 8. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.