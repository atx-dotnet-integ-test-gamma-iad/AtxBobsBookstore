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

## Validation and Testing

### 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or version conflicts, particularly for packages that may have been updated during the transformation.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Ensure consistency across all projects.

### 4. Run Unit Tests

If the solution contains test projects, execute them with:

```bash
dotnet test
```

Review test results to confirm that business logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` behave as expected after the migration.

### 5. Verify Database Connectivity

Since `Bookstore.Data` handles data access, confirm that:

- The connection string in `appsettings.json` is valid and points to the correct database.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, apply them with:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, user authentication if applicable) to confirm runtime behavior is correct.

### 7. Review Platform-Specific Code

Manually inspect the codebase for any APIs or libraries that were previously Windows-specific. Common areas to check include:

- File path handling (use `Path.Combine` rather than hardcoded separators).
- Registry access (`Microsoft.Win32.Registry`), which is not available on Linux or macOS.
- Windows-specific authentication mechanisms such as Windows Identity or NTLM.

### 8. Check `appsettings.json` and Configuration

Confirm that all configuration values previously stored in `Web.config` or `App.config` have been correctly migrated to `appsettings.json` or `appsettings.{Environment}.json`. Pay particular attention to:

- Connection strings
- Application-specific keys or settings
- Logging configuration

### 9. Validate Middleware and Startup Configuration

In `Bookstore.Web`, review `Program.cs` (and `Startup.cs` if present) to ensure that all middleware, services, and dependency injection registrations are correct and complete. Compare against the original `Global.asax` or `Startup` configuration if available.