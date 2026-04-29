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

Verify that no warnings or errors are reported during the restore process.

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

Review the test results and investigate any failures, as they may indicate behavioral differences introduced during the migration.

### 4. Verify Runtime Behavior

Start the web application and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas at a minimum:

- The application starts without runtime exceptions.
- Database connectivity works as expected through `Bookstore.Data`.
- Domain logic in `Bookstore.Domain` produces correct results.
- All major routes and pages in `Bookstore.Web` load and function correctly.

### 5. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 6. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently in modern .NET compared to .NET Framework. Pay particular attention to:

- `System.Web` usages, which are not available in cross-platform .NET and may have been replaced with ASP.NET Core equivalents.
- Any configuration system code that previously relied on `ConfigurationManager`, which should now use `Microsoft.Extensions.Configuration`.
- Entity Framework usage in `Bookstore.Data`, ensuring it has been migrated to EF Core if applicable and that migrations are up to date.

### 7. Review Application Configuration

Confirm that `appsettings.json` (or equivalent) contains all necessary configuration values that were previously stored in `Web.config` or `App.config`. Run the application and verify that connection strings and application settings are read correctly at runtime.

### 8. Validate Data Layer

If `Bookstore.Data` uses Entity Framework Core, verify that the database schema is in sync with the current model:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to a test database before pointing the application at a production database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```