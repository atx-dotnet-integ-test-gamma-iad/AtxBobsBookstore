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

Verify that no warnings or errors are reported during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review the test results for any failures that may have been introduced during the migration.

### 4. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects.

### 5. Check for Removed or Changed APIs

Review the code in each project for any use of APIs that were available in .NET Framework but have changed behavior or limited support in cross-platform .NET. Pay particular attention to:

- `System.Web` references, which are not available in cross-platform .NET
- Windows-specific APIs such as the registry or certain `System.Drawing` features
- Any third-party libraries that may not have cross-platform compatible versions

### 6. Run the Application Locally

Start the `Bookstore.Web` project and verify that the application runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate through the application and confirm that core functionality, including data access through `Bookstore.Data` and domain logic in `Bookstore.Domain`, behaves correctly.

### 7. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework or another data access library, confirm that:

- The connection string is correctly configured for the target environment
- Any pending migrations are applied:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Review Configuration Files

Confirm that `appsettings.json` and any environment-specific configuration files contain the correct values. Settings that were previously stored in `Web.config` or `App.config` should have been migrated to the appropriate `appsettings.json` structure.