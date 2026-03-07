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

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences between the legacy .NET Framework version and the new cross-platform .NET version.

### 4. Verify Data Layer Functionality

Since `Bookstore.Data` handles data access, confirm the following:

- The correct database provider NuGet package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql.EntityFrameworkCore.PostgreSQL`, etc.).
- Connection strings in `appsettings.json` are correctly configured for the target environment.
- Any database migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

### 5. Review Configuration Files

Check that `appsettings.json` (and `appsettings.Development.json`) contain all settings that were previously in `Web.config` or `App.config`. Common items to verify include:

- Connection strings
- Logging configuration
- Application-specific settings

### 6. Run the Web Application Locally

Start the application locally to perform a manual smoke test:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and verify that core pages and features load and function correctly.

### 7. Check for Removed or Changed APIs

Review the code for any use of APIs that existed in .NET Framework but have changed behavior or limited support in cross-platform .NET, including:

- `System.Web` references (these are not available in cross-platform .NET)
- `HttpContext` usage patterns
- Windows-specific APIs such as the Registry or WCF server-side components
- Any third-party libraries that may not have cross-platform compatible versions

### 8. Publish the Application

Once validation is complete, produce a published output to confirm the application packages correctly:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present before deploying to the target environment.