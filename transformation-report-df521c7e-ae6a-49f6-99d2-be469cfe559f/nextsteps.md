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

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, consider updating them to their latest stable versions using:

```bash
dotnet list package --outdated
dotnet add package <PackageName>
```

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a currently supported version of .NET, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting an older or end-of-life version (e.g., `net6.0`, `net5.0`, `netcoreapp3.1`), update it accordingly and re-run the restore and build steps.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, verify that no Windows-specific APIs or libraries remain in use that would break cross-platform compatibility. Common areas to check include:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Communication Foundation (WCF)** server-side components
- **System.Drawing** (use `System.Drawing.Common` with caution on non-Windows platforms)
- **Windows Authentication** configurations in `Bookstore.Web`

Use the .NET Compatibility Analyzer if needed:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

---

## 5. Validate the Data Layer

In `Bookstore.Data`, confirm the following:

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql`, or `Sqlite`) is correctly referenced and compatible with the target framework.
- Any existing migrations are still valid by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations are out of sync or missing, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application URL shown in the console output and manually verify that core functionality works as expected, including:

- Page rendering
- Database read and write operations
- Any authentication or authorization flows

---

## 7. Execute Existing Tests

If the solution contains a test project, run all tests to confirm no regressions were introduced during the migration.

```bash
dotnet test --configuration Release
```

Review the test output for any failures and address them before proceeding. If no tests currently exist, consider adding unit tests for the `Bookstore.Domain` layer and integration tests for `Bookstore.Data` as a baseline.

---

## 8. Review Configuration Files

Confirm that `appsettings.json` and any environment-specific configuration files (e.g., `appsettings.Development.json`) are present in `Bookstore.Web` and contain valid settings, particularly:

- Connection strings
- Logging configuration
- Any application-specific settings previously stored in `Web.config` or `App.config`

If `Web.config` or `App.config` entries were not automatically migrated, transfer the relevant settings manually to `appsettings.json`.

---

## 9. Publish the Application

Once the application has been validated locally, publish it for deployment.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all necessary files are present before deploying to the target environment.