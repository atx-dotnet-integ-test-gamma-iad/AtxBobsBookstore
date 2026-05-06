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

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not been broken during the migration:

```bash
dotnet test --configuration Release
```

Review the test results and address any failing tests before proceeding.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and behaves as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually test the following areas at a minimum:

- Application startup and home page loading
- Database connectivity through `Bookstore.Data` (check connection strings in `appsettings.json` or `appsettings.Development.json`)
- Core domain logic in `Bookstore.Domain` by exercising the relevant UI flows

### 5. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the traditional sense. Confirm that:

- Connection strings have been moved to `appsettings.json`
- Any environment-specific settings are placed in `appsettings.{Environment}.json`
- The `ASPNETCORE_ENVIRONMENT` environment variable is set appropriately for your local environment

### 6. Check Entity Framework Migrations (if applicable)

If `Bookstore.Data` uses Entity Framework, verify that migrations are compatible with the new runtime:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the database schema needs to be updated, run:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 7. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element references the intended version of .NET (for example, `net8.0`). Ensure all three projects target a consistent framework version to avoid interoperability issues.

### 8. Address Any Remaining Warnings

Even without build errors, review the full build output for warnings related to:

- Nullable reference types
- Obsolete API usage
- Platform compatibility attributes

Resolving these warnings will improve the long-term maintainability of the migrated solution.