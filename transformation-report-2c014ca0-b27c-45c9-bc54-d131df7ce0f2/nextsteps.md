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

Perform a full solution build to confirm the absence of any compilation errors:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Check for Runtime Compatibility Issues

Some APIs behave differently or are unavailable on cross-platform .NET even when the project compiles successfully. Pay attention to the following areas:

- **File system paths**: Ensure no hardcoded Windows-style paths (e.g., `C:\`) exist in configuration files or code.
- **Registry access**: `Microsoft.Win32.Registry` is not supported on Linux or macOS.
- **Windows-specific APIs**: Any usage of `System.Drawing`, WCF server-side components, or `System.Web` should be reviewed and replaced with cross-platform alternatives.
- **Configuration**: Confirm that `web.config` or `app.config` settings have been migrated to `appsettings.json` or equivalent.
- **Entity Framework**: If `Bookstore.Data` uses Entity Framework, confirm the correct version (EF Core) is referenced and that migrations are compatible.

### 5. Run the Application Locally

Start the application using the .NET CLI:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following:

- The application starts without exceptions.
- Database connectivity functions correctly (check connection strings in configuration).
- Core application workflows, such as browsing, searching, and managing books, operate as expected.

### 6. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element targets the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If a newer LTS version of .NET is available and desired, update the target framework and re-run the build and test steps above.

### 7. Review Nullable Reference Types

Cross-platform .NET projects often enable nullable reference type analysis by default:

```xml
<Nullable>enable</Nullable>
```

If this is enabled, review any resulting warnings to prevent potential `NullReferenceException` occurrences at runtime.