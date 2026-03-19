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

## Validation and Testing

### 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay particular attention to any warnings about obsolete APIs or framework-specific code that may have been carried over from the legacy project.

### 3. Run Unit Tests

If the solution contains test projects, execute them to confirm existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review test results and address any failures that may indicate behavioral differences introduced by the migration.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas manually:

- Application startup and routing
- Database connectivity from `Bookstore.Data` (confirm connection strings are correctly configured for the new environment)
- Domain logic in `Bookstore.Domain` behaves as expected through the UI or API endpoints

### 5. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) to ensure:

- Connection strings are valid and updated for the target environment
- Any configuration keys that were previously in `Web.config` or `App.config` have been correctly migrated to the new configuration system

### 6. Check for Platform-Specific Code

Search the codebase for any remaining usage of Windows-specific APIs or libraries that may not be compatible with cross-platform .NET:

```bash
grep -rn "System.Web" app/
grep -rn "Registry" app/
grep -rn "System.Drawing" app/
```

Replace or remove any identified platform-specific dependencies as needed.

### 7. Review Entity Framework or Data Access Layer

If `Bookstore.Data` uses Entity Framework, confirm the correct provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or another provider) and that any pending migrations are applied:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Validate Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects to avoid inter-project compatibility issues.