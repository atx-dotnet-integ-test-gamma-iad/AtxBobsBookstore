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

Review the output for any warnings that may indicate compatibility concerns, even if they are not hard errors.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences introduced by the migration.

### 4. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 5. Check for Removed or Changed APIs

Review the code in each project for use of any APIs that were available in .NET Framework but have changed or been removed in modern .NET. Pay particular attention to:

- `System.Web` references, which are not available in cross-platform .NET
- Windows-specific APIs such as the registry or certain `System.Drawing` features
- Any third-party NuGet packages that may still target .NET Framework only

### 6. Run the Application Locally

Start the `Bookstore.Web` project locally and manually exercise the main workflows of the application:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Verify that:

- The application starts without runtime exceptions
- Database connectivity through `Bookstore.Data` functions correctly
- Domain logic in `Bookstore.Domain` produces expected results

### 7. Verify Database Migrations

If the project uses Entity Framework Core, confirm that all migrations are present and up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj
```

Apply any pending migrations to a test database and verify the schema is correct:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj
```

### 8. Review Configuration Files

Confirm that `appsettings.json` and any environment-specific configuration files contain the correct values for the new environment. Connection strings and other settings previously stored in `Web.config` or `App.config` should now reside in `appsettings.json`.