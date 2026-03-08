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

Perform a full solution build to confirm the error-free state holds outside of the transformation environment:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during this step, particularly those related to nullable reference types or obsolete APIs, as these can indicate subtle compatibility issues.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that business logic and data access behavior remain intact after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding unit tests for the `Bookstore.Domain` layer and integration tests for `Bookstore.Data` before proceeding further.

### 4. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that any Entity Framework Core migrations or database configurations are functioning correctly:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If the project previously used Entity Framework 6, verify that the migration to EF Core was handled correctly, including:
- Context configuration in `OnConfiguring` or `Program.cs`
- Connection string placement in `appsettings.json`
- Any raw SQL queries or stored procedure calls that may behave differently under EF Core

### 5. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:
- Application starts without runtime exceptions
- Pages or API endpoints load as expected
- Database reads and writes function correctly
- Any authentication or session-based features behave as intended

### 6. Review `appsettings.json` and Configuration

Ensure that configuration values previously stored in `Web.config` or `App.config` have been correctly migrated to `appsettings.json`. Pay particular attention to:
- Connection strings
- Application-specific keys
- Environment-specific settings, using `appsettings.Development.json` where appropriate

### 7. Check Target Framework

Confirm that all three projects are targeting the intended .NET version by inspecting each `.csproj` file:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across projects to avoid cross-framework compatibility issues.

### 8. Review Deprecated or Replaced APIs

Search the codebase for any APIs that were available in .NET Framework but have changed behavior or been removed in modern .NET. Common areas to check include:
- `System.Web` usages, which have no direct equivalent in modern .NET
- `HttpContext` access patterns
- `ConfigurationManager`, which should be replaced with `IConfiguration`