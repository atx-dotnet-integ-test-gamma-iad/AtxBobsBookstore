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

Review the output for any warnings that may indicate compatibility concerns, even if the build succeeds.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not been broken during the migration:

```bash
dotnet test --configuration Release
```

Review the test results and address any failing tests before proceeding.

### 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas specifically, as they are common points of failure after a cross-platform migration:

- **Database connectivity**: Confirm that `Bookstore.Data` can connect to the database and that Entity Framework migrations (if applicable) are up to date. Run `dotnet ef database update` if needed.
- **Configuration**: Verify that `appsettings.json` contains all necessary configuration values that may have previously existed in `Web.config` or `App.config`.
- **Static files and routing**: Confirm that pages, routes, and static assets load correctly in the browser.
- **Authentication and authorization**: If the application uses any authentication middleware, verify that login and access control behave as expected.

### 5. Check for Platform-Specific API Usage

Even without build errors, some APIs may behave differently on non-Windows platforms. Review the code in each project for usage of the following and test on your target platform:

- `System.Drawing` (GDI+ is not fully supported on Linux/macOS without additional packages)
- Windows Registry access
- File path separators (use `Path.Combine` rather than hardcoded `\` characters)
- Windows-specific authentication schemes such as NTLM or Windows Authentication

### 6. Review Target Framework

Confirm that all three projects are targeting the intended .NET version by inspecting each `.csproj` file:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all projects to avoid inter-project compatibility issues.

### 7. Review Deprecated or Removed APIs

Check for any use of APIs that were available in .NET Framework but have been removed or altered in modern .NET. The [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) can assist with identifying these if not already used during the transformation.