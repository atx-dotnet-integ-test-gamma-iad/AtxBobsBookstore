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

Verify that no warnings or errors appear during the restore process, particularly around package compatibility or target framework mismatches.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test
```

Review test results carefully. Any failing tests may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, confirm that:

- The connection strings in your configuration files (e.g., `appsettings.json`) are correct and accessible from the new runtime environment.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

- If you were previously using Entity Framework 6 (EF6), confirm that the migration to EF Core was handled correctly, as EF Core has API differences that may not surface as build errors but can cause runtime failures.

### 5. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following:

- The application starts without runtime exceptions.
- Key pages and routes load correctly.
- Any authentication or session management behaves as expected.
- Static assets (CSS, JavaScript, images) are served correctly.

### 6. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` as the primary configuration mechanism. Confirm that:

- All necessary settings have been moved to `appsettings.json` or environment variables.
- Any `Web.config` transforms or `configSource` references have been replaced with the appropriate .NET configuration providers.
- Logging configuration has been updated to use the `Microsoft.Extensions.Logging` infrastructure if it has not been already.

### 7. Check for Platform-Specific Code

Review the codebase for any APIs that were available in .NET Framework but are not available or behave differently in cross-platform .NET. Common areas to check include:

- `System.Web` references, which are not available in cross-platform .NET.
- Windows Registry access.
- `AppDomain` usage.
- Any P/Invoke calls targeting Windows-specific libraries.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to assist with this review if needed.

### 8. Test on Target Platforms

If cross-platform support is a goal, run and validate the application on each intended operating system (e.g., Linux, macOS) to surface any remaining platform-specific issues that would not appear when testing on Windows alone.