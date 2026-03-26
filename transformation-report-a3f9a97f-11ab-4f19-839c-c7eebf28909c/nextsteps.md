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

### 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, check the following areas:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly and that queries return expected results. Pay attention to any Entity Framework Core migration differences if the project was previously using EF6.
- **Domain logic**: Verify that business rules in `Bookstore.Domain` produce correct outputs.
- **Web layer**: Navigate through the application pages and confirm that routing, model binding, and rendering work as expected.

### 5. Check Configuration Files

Review `appsettings.json` (and `appsettings.Development.json`) to ensure that:

- Connection strings are correctly defined and point to the intended database.
- Any settings previously stored in `Web.config` or `App.config` have been properly migrated to the new configuration system.

### 6. Review Middleware and Startup Configuration

Open `Program.cs` (or `Startup.cs` if present) in `Bookstore.Web` and confirm that:

- Middleware is registered in the correct order.
- Authentication and authorization, if used, are configured properly.
- Static file serving and routing are set up as expected.

### 7. Target Framework Verification

Open each `.csproj` file and confirm the `<TargetFramework>` element targets the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported version of .NET.

### 8. Check for Removed or Changed APIs

Review the code for any use of APIs that existed in .NET Framework but have changed or been removed in cross-platform .NET. Common areas to check include:

- `System.Web` references (these are not available in cross-platform .NET).
- `HttpContext` usage patterns.
- Any Windows-specific APIs such as the registry or certain cryptography classes.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling if further analysis is needed.