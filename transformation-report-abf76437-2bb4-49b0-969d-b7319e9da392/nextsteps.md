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

Review the output for any warnings related to package compatibility or missing packages.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Confirm that all three projects build without errors or warnings.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review test results and investigate any failures, as they may indicate behavioral differences introduced during the migration.

### 4. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that your data access layer is functioning correctly:

- Check that your connection strings in `appsettings.json` are correct for your target environment.
- If the project uses Entity Framework Core, apply any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If the project was migrated from Entity Framework 6, verify that EF Core equivalents are in place for any EF6-specific features such as lazy loading, complex types, or database initializers.

### 5. Run the Application Locally

Start the web application locally to verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application and verify core functionality such as page rendering, form submissions, and data retrieval.
- Check the console output and application logs for any runtime exceptions.

### 6. Review Target Framework

Confirm that all projects are targeting the intended .NET version. Open each `.csproj` file and verify the `<TargetFramework>` element, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects.

### 7. Review Removed or Changed APIs

Cross-platform .NET does not support certain APIs that were available in .NET Framework. Review the following areas manually:

- Any usage of `System.Web` namespaces, which are not available in .NET Core or later.
- `HttpContext` usage patterns that may differ from ASP.NET MVC to ASP.NET Core.
- Any Windows-specific APIs such as the registry, WCF server-side components, or `System.Drawing` (which requires additional packages on non-Windows platforms).

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to identify any remaining incompatible API usage.

### 8. Check Application Configuration

ASP.NET Core uses a different configuration system than ASP.NET. Verify the following:

- `Web.config` settings have been migrated to `appsettings.json` or environment variables where applicable.
- Middleware registration in `Program.cs` or `Startup.cs` correctly replaces any HTTP modules or handlers that existed in the original project.
- Authentication and authorization configurations have been updated to use ASP.NET Core middleware.

### 9. Deploy to Target Environment

Once local validation is complete, publish the application using:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to your target server or hosting environment and verify the application runs correctly in that environment.