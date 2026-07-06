# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

## Validation Steps

### 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or version conflicts, particularly for packages that may have been updated during the transformation.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation errors:

```bash
dotnet build --configuration Release
```

Verify that all three projects build without errors or unexpected warnings.

### 3. Run Unit Tests

If the solution contains test projects, execute the test suite to confirm existing behavior is preserved:

```bash
dotnet test --configuration Release
```

Review test results for any failures that may indicate behavioral regressions introduced during the migration.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and functions as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following areas at a minimum:

- Application startup and home page load
- Database connectivity through `Bookstore.Data` (check connection strings in `appsettings.json` are correct for the target environment)
- Core domain logic in `Bookstore.Domain` behaves as expected through the UI

### 5. Review Configuration Files

Cross-platform .NET uses `appsettings.json` rather than `Web.config` or `App.config`. Confirm the following:

- Connection strings have been migrated to `appsettings.json`
- Any environment-specific settings are present in `appsettings.Development.json` or equivalent
- Authentication, logging, and middleware configurations are correctly set up in `Program.cs` or `Startup.cs`

### 6. Check Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element targets the intended .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects.

### 7. Validate Data Layer

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`)
- Migrations are present and up to date by running:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- Apply migrations to a test database to confirm schema compatibility:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.