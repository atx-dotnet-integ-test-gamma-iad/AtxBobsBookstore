# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects in the solution:

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

Review the output for any warnings that may indicate deprecated APIs, missing references, or compatibility concerns that did not surface as hard errors.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests should be investigated before proceeding, as they may indicate behavioral differences between the legacy framework and the new target framework.

### 4. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported version of .NET.

### 5. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas manually:

- Application startup and landing page load
- Database connectivity from `Bookstore.Data` (check connection strings in `appsettings.json`)
- Domain logic correctness by exercising key application workflows
- Any pages or endpoints that rely on data access

### 6. Review `appsettings.json` and Configuration

Legacy projects often used `Web.config` or `App.config` for configuration. Confirm that all necessary configuration values have been migrated to `appsettings.json` or `appsettings.{Environment}.json`, including:

- Connection strings
- Application-specific settings
- Logging configuration

### 7. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently in modern .NET. Pay particular attention to:

- `System.Web` usages, which are not available in cross-platform .NET
- Any HTTP pipeline middleware that may have been adapted during transformation
- Entity Framework version differences if `Bookstore.Data` uses EF or EF Core

### 8. Review NuGet Package Versions

Inspect each `.csproj` file to ensure all NuGet packages are referencing current, stable, and compatible versions. Use the following command to identify outdated packages:

```bash
dotnet list package --outdated
```

Update packages where appropriate, and re-run the build and tests after doing so.