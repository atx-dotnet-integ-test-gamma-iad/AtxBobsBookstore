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

Verify that no warnings or errors appear during the restore process, particularly around package compatibility or missing packages.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test
```

Review the test results and investigate any failures, as they may indicate behavioral differences introduced by the migration.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following at runtime:

- The application starts without exceptions.
- Database connectivity is functional (if `Bookstore.Data` uses Entity Framework or another ORM, verify migrations are up to date by running `dotnet ef database update` if applicable).
- Core application routes and pages load correctly.
- Any data read/write operations function as expected.

### 5. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 6. Review Removed or Changed APIs

Cross-platform .NET removes certain APIs that were available in .NET Framework. Manually review the following areas:

- Any usage of `System.Web` namespaces, which are not available in cross-platform .NET.
- `HttpContext` usage, which should now come from `Microsoft.AspNetCore.Http`.
- Configuration patterns, which should use `Microsoft.Extensions.Configuration` rather than `System.Configuration.ConfigurationManager` unless the `System.Configuration.ConfigurationManager` NuGet package has been explicitly added.
- Any Windows-specific APIs (registry access, Windows identity, etc.) that may compile but fail at runtime on non-Windows platforms.

### 7. Check Database Migrations

If the project uses Entity Framework Core, verify the migration state is consistent:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to the target database before deploying.

### 8. Review Application Configuration

Confirm that `appsettings.json` (and environment-specific variants such as `appsettings.Production.json`) contain all necessary configuration values that may have previously resided in `web.config` or `app.config`. Connection strings, application settings, and logging configuration should all be accounted for.