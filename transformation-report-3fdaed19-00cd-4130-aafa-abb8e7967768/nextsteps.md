# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects (`Bookstore.Data`, `Bookstore.Web`, or `Bookstore.Domain`). The solution compiled cleanly across all projects.

## Validation

### 1. Restore Dependencies

Before running the project, ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or version conflicts, particularly around packages that may have been updated during the transformation.

### 2. Build the Solution

Perform a full solution build to confirm the clean state:

```bash
dotnet build --configuration Release
```

Confirm that the output reports zero errors and review any warnings that may indicate deprecated APIs or compatibility concerns.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests should be investigated before proceeding to deployment.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and behaves as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas manually:

- Application startup and routing
- Database connectivity from `Bookstore.Data` (verify connection strings in `appsettings.json` are correct for the target environment)
- Domain logic in `Bookstore.Domain` behaves as expected through the UI or API endpoints

### 5. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, `appsettings.Production.json`) to ensure:

- Connection strings are valid and point to the correct database instances
- Any legacy `Web.config` or `App.config` values have been properly migrated to the new configuration system
- Environment variables or secrets that were previously managed differently are accounted for

### 6. Check Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element reflects the intended .NET version:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 7. Review Entity Framework Migrations (if applicable)

If `Bookstore.Data` uses Entity Framework, verify that existing migrations are compatible with the new runtime:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj
```

If the database schema needs to be updated:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj
```

### 8. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.