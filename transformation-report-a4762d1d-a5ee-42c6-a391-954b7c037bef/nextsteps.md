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

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify existing functionality has not regressed:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no test projects currently exist, consider adding unit tests targeting the `Bookstore.Domain` and `Bookstore.Data` layers as a baseline for future changes.

### 4. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that any database connection strings in `appsettings.json` or `appsettings.Production.json` are updated to reflect the target environment. If Entity Framework Core is in use, verify that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Application Locally

Start the web application and confirm it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL indicated in the console output and verify that the application loads and core functionality behaves correctly.

### 6. Review Configuration Files

Check the following files in `Bookstore.Web` for any values that may still reference legacy .NET Framework-specific settings or Windows-only paths:

- `appsettings.json`
- `appsettings.Development.json`
- `web.config` (if still present, most settings should now be handled by `appsettings.json` or middleware)

### 7. Review Target Framework

Open each `.csproj` file and confirm the `TargetFramework` element is set to the intended cross-platform version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0-windows</TargetFramework>
```

Ensure the `-windows` TFM suffix is only present if Windows-specific APIs are genuinely required, as it limits cross-platform portability.

### 8. Check for Platform-Specific API Usage

Use the .NET Upgrade Assistant compatibility analyzer or the built-in Roslyn analyzers to flag any remaining platform-specific API calls:

```bash
dotnet add package Microsoft.DotNet.PlatformAbstractions
```

Alternatively, enable the platform compatibility analyzer by ensuring the following is set in each `.csproj`:

```xml
<EnableNETAnalyzers>true</EnableNETAnalyzers>
<AnalysisMode>All</AnalysisMode>
```

Then rebuild and review any new diagnostic warnings.