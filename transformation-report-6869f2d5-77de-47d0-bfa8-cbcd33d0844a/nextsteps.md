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

If the solution contains any test projects, execute them to verify that existing functionality has not been broken during the migration:

```bash
dotnet test --configuration Release
```

Review test results and address any failing tests before proceeding.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and behaves as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following:

- The application starts without runtime exceptions.
- Database connectivity works as expected through `Bookstore.Data`.
- Core domain logic in `Bookstore.Domain` functions correctly.
- Key application routes and pages load and respond correctly.

### 5. Check Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 6. Review Removed or Changed APIs

Check for any use of Windows-specific or legacy APIs that may have been silently carried over. Pay particular attention to:

- `Bookstore.Data`: Verify that the database provider (e.g., Entity Framework Core) is correctly configured for cross-platform use.
- `Bookstore.Web`: Confirm that middleware, authentication, and configuration setups follow the current .NET conventions.
- `Bookstore.Domain`: Ensure no platform-specific types or libraries are referenced.

### 7. Review Configuration Files

Confirm that `appsettings.json` and any environment-specific configuration files (e.g., `appsettings.Development.json`) are present and correctly structured. Legacy `Web.config` or `App.config` files should no longer be the primary configuration source.

### 8. Validate Data Access Layer

If `Bookstore.Data` uses Entity Framework Core, verify that any pending migrations are applied correctly:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Confirm that the database schema matches the expected state after migration.