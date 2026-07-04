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

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review the test results and address any failing tests before proceeding.

### 4. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects.

### 5. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that were available in .NET Framework but have changed or been removed in modern .NET. Pay particular attention to:

- `System.Web` references, which are not available in cross-platform .NET
- `HttpContext` and related ASP.NET types in `Bookstore.Web`
- Any Windows-specific APIs such as the registry, WCF server-side components, or `System.Drawing` (without a compatible replacement)

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to assist with this review.

### 6. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework or another data access layer, verify that:

- The correct EF Core packages are referenced (e.g., `Microsoft.EntityFrameworkCore`)
- Connection strings in `appsettings.json` are correctly configured
- Migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

### 7. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate to the application in a browser and confirm that key pages load, data is retrieved correctly, and no runtime exceptions occur.

### 8. Review Configuration Files

Confirm that `appsettings.json` contains all settings previously held in `Web.config` or `App.config`, including:

- Connection strings
- Application settings
- Logging configuration

The `Web.config` and `App.config` files are not used in cross-platform .NET applications.

### 9. Verify Logging and Error Handling

Ensure that the logging framework is properly configured in `Program.cs` or `Startup.cs`. Cross-platform .NET uses `Microsoft.Extensions.Logging` by default. If the legacy project used `log4net` or `NLog`, confirm that the appropriate provider package is installed and configured.