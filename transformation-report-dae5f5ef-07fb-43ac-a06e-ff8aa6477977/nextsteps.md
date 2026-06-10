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

Run the following command from the root of the solution to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Review Runtime Dependencies

Check for any dependencies that may have worked under .NET Framework but behave differently under cross-platform .NET. Pay particular attention to:

- **Windows-specific APIs** such as the registry, WCF server-side components, or `System.Drawing` (GDI+). These may require replacement packages such as `System.Drawing.Common` or alternative libraries.
- **Database connectivity** in `Bookstore.Data`. Confirm that the Entity Framework version in use is Entity Framework Core and that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is correctly configured.
- **Configuration** in `Bookstore.Web`. Ensure that any `Web.config` or `App.config` settings have been migrated to `appsettings.json` and that `IConfiguration` is used appropriately.

### 5. Run the Application Locally

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Walk through the primary user flows such as browsing, searching, and any data entry features to confirm they function correctly.

### 6. Verify Data Access

Confirm that `Bookstore.Data` connects to the database correctly at runtime. Check that:

- Connection strings in `appsettings.json` are accurate for your target environment.
- Any required database migrations are up to date. If using Entity Framework Core, run:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 7. Check Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element references a current and supported version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If an older version such as `net6.0` is present, consider updating to a long-term support (LTS) release.

### 8. Review Publish Output

Before deploying to a target environment, publish the application and inspect the output for completeness:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify that all expected static assets, configuration files, and binaries are present in the publish folder.

## Deployment

Once local validation is complete and all tests pass, deploy the contents of the publish output folder to your target environment using your standard deployment process. Ensure the target server has the appropriate .NET runtime installed. The required runtime version can be confirmed by checking the `<TargetFramework>` value in the web project file.