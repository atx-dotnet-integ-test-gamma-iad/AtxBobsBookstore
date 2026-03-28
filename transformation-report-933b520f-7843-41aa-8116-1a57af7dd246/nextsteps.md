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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear during the restore process, particularly around package compatibility or target framework mismatches.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Data Layer Functionality

Since `Bookstore.Data` handles data access, confirm the following:

- Any Entity Framework or database provider packages are targeting a compatible version for cross-platform .NET (e.g., `Microsoft.EntityFrameworkCore` instead of `EntityFramework`).
- Database connection strings in configuration files (`appsettings.json`) are correct and accessible in the new environment.
- Run any available database migrations to ensure the schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Review Configuration Files

Check that the following have been properly migrated from the legacy `Web.config` or `App.config` format to the modern `appsettings.json` format:

- Connection strings
- Application settings
- Logging configuration

### 6. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and exercise the primary workflows.
- Check the console output and application logs for any runtime exceptions or warnings.
- Pay particular attention to areas that rely on Windows-specific APIs, as these may fail at runtime even if the build succeeds.

### 7. Check for Runtime Compatibility Issues

Even with a clean build, certain APIs behave differently or are unavailable on cross-platform .NET. Manually review the codebase for usage of the following:

- `System.Web` namespaces (not available outside of Windows/ASP.NET Framework)
- Windows Registry access
- Windows-specific file path assumptions (e.g., backslash separators)
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

### 8. Review Target Framework

Confirm that all projects are targeting a currently supported version of .NET. Open each `.csproj` file and verify the `<TargetFramework>` value:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project targets an older or out-of-support version (e.g., `net6.0`), consider updating to a long-term support (LTS) release.