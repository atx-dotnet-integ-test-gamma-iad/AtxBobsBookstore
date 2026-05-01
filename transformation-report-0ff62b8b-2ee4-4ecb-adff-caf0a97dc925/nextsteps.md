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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects. Mismatched target frameworks can cause runtime issues even when the build succeeds.

### 4. Run Unit Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider adding one targeting critical areas such as domain logic in `Bookstore.Domain` and data access in `Bookstore.Data`.

### 5. Verify Data Access Layer

In `Bookstore.Data`, confirm the following:

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`) is compatible with the new target framework.
- Any database connection strings in configuration files (`appsettings.json`) are correct and accessible in the new environment.
- Run any pending Entity Framework Core migrations if applicable:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the web application to validate runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and exercise the primary workflows (e.g., browsing books, managing inventory) to confirm there are no runtime exceptions.

### 7. Check for Platform-Specific Code

Search the codebase for any APIs that were available in .NET Framework but have changed or been removed in cross-platform .NET. Common areas to review include:

- `System.Web` references (should no longer be present)
- `ConfigurationManager` usage (should be replaced with `Microsoft.Extensions.Configuration`)
- Windows-specific registry or file path assumptions

Use the .NET Upgrade Assistant compatibility analyzer or the following command to surface remaining compatibility issues:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

### 8. Review Application Configuration

Confirm that `appsettings.json` contains all configuration values that were previously in `Web.config` or `App.config`. Pay particular attention to:

- Connection strings
- Application settings keys
- Any environment-specific overrides using `appsettings.Development.json`