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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Confirm that all three projects build without warnings or errors. Pay particular attention to any warnings about nullable reference types or obsolete APIs, as these may indicate areas that need attention even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not been broken during the migration:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures. Test failures after a migration often point to behavioral differences between the legacy .NET Framework and modern .NET.

### 4. Verify Entity Framework or Data Access Layer

Since the solution includes a `Bookstore.Data` project, verify that the data access layer functions correctly:

- Confirm the correct version of Entity Framework (Core) is referenced and compatible with the target .NET version.
- If the project uses EF Core migrations, run the following to verify the migration state:

```bash
dotnet ef migrations list --project app/Bookstore.Data
```

- If migrations are missing or out of sync, consider running:

```bash
dotnet ef database update --project app/Bookstore.Data
```

### 5. Run the Web Application Locally

Start the `Bookstore.Web` project locally to validate runtime behavior:

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

- Navigate through the application and verify that core functionality such as browsing, data retrieval, and any forms or submissions work as expected.
- Check the console output for any runtime exceptions or middleware configuration issues.
- Verify that configuration files such as `appsettings.json` are correctly set up and that any values previously stored in `Web.config` have been properly migrated.

### 6. Review Configuration Migration

Confirm that settings previously defined in `Web.config` or `App.config` have been moved to `appsettings.json` or environment variables, which is the standard approach in modern .NET. Key areas to check include:

- Connection strings
- Application settings
- Authentication configuration
- Logging configuration

### 7. Check for Platform-Specific API Usage

Review the codebase for any remaining usage of Windows-specific or .NET Framework-specific APIs that may not be available cross-platform. Common areas include:

- `System.Web` references (should be fully removed)
- Windows Registry access
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

You can use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining compatibility concerns.

### 8. Test on Target Platforms

If cross-platform support is a goal, run and validate the application on each intended target operating system (e.g., Linux, macOS) to catch any platform-specific runtime issues that would not surface on Windows alone.