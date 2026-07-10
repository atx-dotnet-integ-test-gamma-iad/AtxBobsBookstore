# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

## Validation Steps

### 1. Restore Dependencies

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not cause build failures.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not been broken:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures. Pay particular attention to tests that cover data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`, as these layers are most likely to be affected by a cross-platform migration.

### 4. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that the data layer connects correctly to the target database. Check the following:

- Connection strings in `appsettings.json` or `appsettings.Production.json` are correct for the target environment.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations if needed:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the core workflows, such as browsing, searching, and any data entry features, to confirm end-to-end functionality.

### 6. Review Platform-Specific Code

Even without build errors, review the codebase for any patterns that may cause runtime issues on non-Windows platforms:

- File path separators: replace hardcoded `\` with `Path.Combine` or `Path.DirectorySeparatorChar`.
- Registry access: remove or replace any `Microsoft.Win32.Registry` usage.
- Windows-specific authentication or identity APIs that may not behave identically on Linux or macOS.

### 7. Review Configuration and Environment Variables

Confirm that configuration sources used in `Bookstore.Web` are compatible with the new runtime:

- `appsettings.json` and environment-specific overrides are present.
- Any environment variables expected by the application are documented and set in the target environment.

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Inspect the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.