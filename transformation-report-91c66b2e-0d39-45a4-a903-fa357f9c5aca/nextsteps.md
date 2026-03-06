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

Verify that no warnings or errors appear during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output and confirm that all three projects report a successful build with zero errors.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not been broken during the migration:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failing tests, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas manually:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. Verify your connection strings in `appsettings.json` are correct for the target environment.
- **Domain logic**: Exercise the core domain functionality through the UI or API endpoints to confirm results match the legacy application.
- **Web layer**: Navigate through the application pages or endpoints and verify that routing, views, and responses behave as expected.

### 5. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` as the primary configuration mechanism. Confirm that:

- All configuration values previously in `Web.config` have been moved to `appsettings.json` or environment variables.
- Any configuration transforms that existed for different environments (e.g., `Web.Release.config`) have been replaced with the appropriate `appsettings.{Environment}.json` files.

### 6. Check for Platform-Specific API Usage

Even without build errors, some APIs behave differently or are unsupported on non-Windows platforms. Review the code in all three projects for usage of:

- `System.Web` APIs (these are not available in cross-platform .NET)
- Windows Registry access
- Windows-specific file path assumptions (e.g., backslash separators)
- Any third-party libraries that may still target .NET Framework only

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to assist with this review if needed.

### 7. Validate the Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and currently supported version of .NET.

### 8. Review Entity Framework or Data Access Layer

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core package is referenced (e.g., `Microsoft.EntityFrameworkCore`), not the legacy `EntityFramework` package.
- Any database migrations are present and up to date.
- Run a migration check with:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```