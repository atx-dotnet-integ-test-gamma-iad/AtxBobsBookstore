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

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review test results and investigate any failures, as they may indicate behavioral differences introduced during the migration.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas manually:

- Application startup with no unhandled exceptions
- Database connectivity from `Bookstore.Data` (verify connection strings in `appsettings.json` are correct for the target environment)
- Domain logic in `Bookstore.Domain` produces expected results through the UI or API endpoints
- Any authentication or authorization flows that may have changed between the legacy and new framework

### 5. Review Configuration Files

Cross-platform .NET uses `appsettings.json` rather than `Web.config` or `App.config`. Confirm the following:

- All connection strings have been migrated to `appsettings.json`
- Any environment-specific settings are placed in `appsettings.Production.json` or equivalent
- Secrets are not stored in source-controlled configuration files; use `dotnet user-secrets` for local development

```bash
dotnet user-secrets init --project app/Bookstore.Web/Bookstore.Web.csproj
```

### 6. Check Target Framework

Confirm that all projects are targeting the intended .NET version by inspecting each `.csproj` file and verifying the `<TargetFramework>` element is consistent across the solution:

```xml
<TargetFramework>net8.0</TargetFramework>
```

### 7. Review Deprecated or Removed APIs

Even without build errors, some APIs available in .NET Framework may behave differently or have subtle breaking changes in cross-platform .NET. Review the [.NET Upgrade Assistant compatibility analyzer output](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) if it was used during transformation, and address any reported compatibility warnings.

### 8. Publish the Application

Once validation is complete, publish the application using:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm the application runs correctly from the published output:

```bash
dotnet ./publish/Bookstore.Web.dll
```