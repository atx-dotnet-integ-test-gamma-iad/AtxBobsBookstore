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

Perform a full solution build to confirm the absence of errors in a clean build context:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 4. Run Unit Tests

If the solution contains test projects, execute them to verify that business logic and data access behavior remain intact after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework APIs and their cross-platform equivalents.

### 5. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework or another ORM, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Any existing migrations are compatible with EF Core. If migrating from EF6, migrations may need to be regenerated:

```bash
dotnet ef migrations add InitialMigration
dotnet ef database update
```

- Connection strings in `appsettings.json` are correctly configured for the target environment.

### 6. Check for Windows-Specific APIs

Search the codebase for any APIs that were available in .NET Framework but are not supported or behave differently in cross-platform .NET. Common areas to review include:

- `System.Web` references (should be replaced with ASP.NET Core equivalents)
- `ConfigurationManager` (should be replaced with `Microsoft.Extensions.Configuration`)
- Windows Registry access or WCF service references
- `HttpContext.Current` usage

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify remaining compatibility issues.

### 7. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core application flows:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Test the following at a minimum:

- Application startup without exceptions
- Database read and write operations
- Any authentication or authorization flows
- Static file serving

### 8. Review Logging and Configuration

Confirm that the application's logging and configuration setup follows ASP.NET Core conventions using `appsettings.json` and `ILogger<T>`, replacing any legacy `log4net`, `NLog`, or `Web.config`-based configurations that may not have been fully migrated.

## Deployment

Once all validation steps above pass without errors or unexpected behavior:

1. Publish the application using:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

2. Verify the contents of the `./publish` directory contain all expected assemblies and static assets.
3. Deploy the contents of the publish output to your target hosting environment, ensuring the correct .NET runtime version is installed on the host.