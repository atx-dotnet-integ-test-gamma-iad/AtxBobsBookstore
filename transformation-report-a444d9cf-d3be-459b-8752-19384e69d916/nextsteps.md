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

Review the output for any warnings related to missing packages or version conflicts.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors.

### 3. Run Unit Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release
```

Review the test results to confirm that existing functionality has not regressed during the migration.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and behaves as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following at runtime:

- The application starts without exceptions.
- Database connectivity works as expected through `Bookstore.Data`.
- Domain logic in `Bookstore.Domain` functions correctly end-to-end.
- All routes and pages in `Bookstore.Web` are accessible and return expected results.

### 5. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same framework version to avoid compatibility issues.

### 6. Check for Windows-Specific APIs

Even without build errors, there may be runtime dependencies on Windows-specific APIs that do not surface until execution. Review the code in each project for usage of:

- `System.Web` namespaces
- Windows registry access
- Windows-specific file path assumptions (e.g., backslashes)
- Platform-specific interop or COM references

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package to identify any remaining platform-specific concerns.

### 7. Review Configuration

If the project previously used `Web.config` or `App.config`, confirm that configuration has been migrated to `appsettings.json` and that values such as connection strings and application settings are correctly defined and read at runtime.

### 8. Test on Target Platform

If the goal is cross-platform support, run the application on the intended non-Windows platform (Linux or macOS) to surface any platform-specific runtime issues that would not appear on Windows.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Confirm the application starts and all core functionality works on that platform.