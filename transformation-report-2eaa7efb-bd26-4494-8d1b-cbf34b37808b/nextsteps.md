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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

### 2. Build the Solution

Confirm the solution builds cleanly:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting a consistent and supported version of .NET.

### 5. Verify Runtime Behavior

Start the web application locally and manually exercise core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Pay particular attention to the following areas, which commonly surface issues after migration:

- **Database connectivity**: Confirm that `Bookstore.Data` connects and queries correctly. If Entity Framework is in use, verify that migrations are compatible with the new runtime.
- **Configuration**: Check that `appsettings.json` is correctly replacing any legacy `Web.config` or `App.config` entries, including connection strings and application settings.
- **Authentication and Authorization**: If any authentication middleware was in use, confirm it has been correctly mapped to the ASP.NET Core equivalents.
- **Static files and routing**: Verify that pages, routes, and static assets resolve correctly in the browser.

### 6. Check for Removed or Changed APIs

Review the code in each project for use of APIs that existed in .NET Framework but have been removed or altered in cross-platform .NET. The [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) can assist with identifying these.

Common areas to check include:

- `System.Web` references, which are not available in cross-platform .NET
- `HttpContext` usage patterns
- Any Windows-specific APIs if cross-platform support is required

### 7. Review Dependency Versions

Confirm that all third-party NuGet packages referenced in the projects have versions that support the new target framework. Outdated packages may compile without errors but behave incorrectly at runtime.

```bash
dotnet list package --outdated
```

Update packages as appropriate after reviewing their changelogs for breaking changes.