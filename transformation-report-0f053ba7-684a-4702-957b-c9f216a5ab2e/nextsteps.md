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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages that may need attention.

### 2. Build the Solution

Perform a full solution build to confirm the clean state:

```bash
dotnet build --configuration Release
```

Confirm that the output reports zero errors and review any warnings that may indicate compatibility concerns.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that business logic and data access behavior is preserved after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review test output carefully. Any failing tests may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Database Connectivity

Since `Bookstore.Data` is present, verify that any Entity Framework Core migrations or database configurations are functioning correctly:

```bash
dotnet ef dbcontext info --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations exist, confirm they are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If the database schema needs to be applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL shown in the console output and manually verify that core application functionality works, including any pages that interact with the domain and data layers.

### 6. Review Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 7. Review Removed Windows-Specific APIs

Cross-platform .NET does not support certain Windows-specific APIs. Search the codebase for any usage of the following that may have been silently carried over:

- `System.Web` namespaces
- `HttpContext` from `System.Web` (should now be `Microsoft.AspNetCore.Http`)
- Windows Registry access
- `System.Drawing` (requires additional native dependencies on Linux/macOS)

Address any findings by replacing them with supported cross-platform equivalents.

### 8. Review Configuration Files

Confirm that `appsettings.json` contains all necessary configuration values that were previously stored in `Web.config` or `App.config`, including connection strings and application settings.

### 9. Publish the Application

Once validation is complete, publish the application to confirm a clean release output:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.