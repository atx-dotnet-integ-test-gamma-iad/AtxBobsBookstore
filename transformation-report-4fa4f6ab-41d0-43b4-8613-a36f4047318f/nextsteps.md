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

Verify that no warnings or errors appear during the restore process, particularly around package compatibility or missing package sources.

### 2. Build the Solution

Perform a full solution build to confirm the absence of any build-time issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to confirm that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests that previously passed may indicate a behavioral difference introduced during migration.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Walk through the primary user flows, such as browsing books, managing inventory, and any authentication flows, to confirm they behave as expected.

### 5. Check Data Layer Compatibility

Since `Bookstore.Data` is involved, verify the following:

- **Database Migrations**: If the project uses Entity Framework Core, confirm that existing migrations are compatible with the new target framework. Run the following to check the current migration state:

  ```bash
  dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```

- **Connection Strings**: Confirm that connection strings in `appsettings.json` or environment-specific configuration files are correct and accessible in the new environment.

- **Database Update**: If needed, apply any pending migrations:

  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```

### 6. Review Configuration Files

Inspect `appsettings.json` and any environment-specific variants (`appsettings.Development.json`, `appsettings.Production.json`) to ensure all configuration values are present and correctly formatted for the new hosting model.

### 7. Check for Removed or Changed APIs

Review any use of APIs that were available in the .NET Framework but have changed or been removed in cross-platform .NET. Pay particular attention to:

- `System.Web` references, which are not available in cross-platform .NET
- Windows-specific APIs such as the registry or certain cryptography providers
- Any third-party libraries that may have platform-specific dependencies

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.UpgradeAssistant` tool to surface any remaining compatibility concerns.

### 8. Validate Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element reflects the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0-windows</TargetFramework>
```

Ensure consistency across all projects unless there is a specific reason for them to differ.