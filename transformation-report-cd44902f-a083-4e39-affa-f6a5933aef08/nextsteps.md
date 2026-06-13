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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay particular attention to any warnings about obsolete APIs or platform compatibility, as these can indicate areas that may cause runtime issues even if the build succeeds.

### 3. Run Unit Tests

If the solution contains test projects, execute them to confirm existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests that previously passed may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the web application locally and exercise its core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas manually:

- **Database connectivity**: Confirm that `Bookstore.Data` can connect to the database and that migrations or schema initialization complete without errors. If Entity Framework is in use, run `dotnet ef database update` to apply any pending migrations.
- **Domain logic**: Verify that business rules in `Bookstore.Domain` behave as expected through the UI or API endpoints.
- **Web layer**: Navigate through the application pages or API routes to confirm routing, model binding, and rendering work correctly.

### 5. Check for Windows-Specific API Usage

Even without build errors, some APIs that compiled successfully may not behave correctly on non-Windows platforms. Review the codebase for usage of the following:

- `System.Web` namespaces (not available in cross-platform .NET)
- Windows Registry access
- Windows-specific file path assumptions (e.g., backslash separators)
- COM interop or P/Invoke calls targeting Windows libraries

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining platform-specific dependencies.

### 6. Review Configuration Files

Confirm that configuration has been correctly migrated from `Web.config` or `App.config` to the `appsettings.json` format used by cross-platform .NET:

- Connection strings
- Application settings
- Logging configuration
- Authentication or authorization settings

Ensure that environment-specific configuration files (e.g., `appsettings.Development.json`) are present and correctly structured.

### 7. Target Framework Verification

Open each `.csproj` file and confirm the `<TargetFramework>` element references a current, supported version of .NET (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still targets `net48` or another legacy framework, update the target framework and re-run the build and test steps above.