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

Review the build output and confirm that all three projects report a successful build.

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

- **Database connectivity**: Confirm that `Bookstore.Data` can connect to the database and that any Entity Framework migrations are up to date. Run `dotnet ef database update` if migrations are pending.
- **Application pages and routes**: Navigate through the application and verify that all pages load without errors.
- **Data operations**: Test create, read, update, and delete operations to confirm that the data layer functions correctly.
- **Configuration**: Verify that `appsettings.json` contains all required configuration values that were previously in `Web.config` or `App.config`, such as connection strings and application settings.

### 5. Review Removed Windows-Specific APIs

Cross-platform .NET does not support certain Windows-specific APIs that were available in .NET Framework. Manually review the codebase for any usage of the following, which may fail at runtime even if they compile successfully:

- `System.Web` namespaces (these should have been replaced during transformation)
- Windows Registry access (`Microsoft.Win32.Registry`)
- Windows-specific file path assumptions
- `System.Drawing` (GDI+) without the `System.Drawing.Common` NuGet package

### 6. Check Target Framework

Open each `.csproj` file and confirm the `TargetFramework` value is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all projects.

### 7. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected files are present before deploying to the target environment.