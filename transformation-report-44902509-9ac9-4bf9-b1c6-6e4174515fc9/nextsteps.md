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

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-breaking, may indicate deprecated APIs or patterns that should be addressed.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests that previously passed may indicate a behavioral difference introduced during the migration.

### 4. Verify Entity Framework Migrations (if applicable)

Since the solution includes a `Bookstore.Data` project, it likely uses Entity Framework. Verify that your migrations are compatible with the new runtime:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are not listed correctly or errors occur, you may need to update the `Microsoft.EntityFrameworkCore` package references and ensure the `DbContext` configuration is compatible with the current EF Core version.

If you need to apply migrations to a database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:
- The application starts without runtime exceptions.
- All pages and routes load as expected.
- Database connectivity is functioning correctly.
- Any authentication or authorization flows behave as intended.

### 6. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) to confirm that:

- Connection strings are correctly formatted for the target environment.
- Any configuration keys that were previously in `Web.config` have been properly migrated to the new configuration system.

### 7. Check for Removed or Changed APIs

Review the code in each project for any use of APIs that existed in .NET Framework but have changed or been removed in cross-platform .NET. Common areas to check include:

- `System.Web` references, which are not available in cross-platform .NET.
- `HttpContext` usage patterns, which differ between ASP.NET and ASP.NET Core.
- Any Windows-specific APIs such as the registry, WCF, or MSMQ.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.UpgradeAssistant` tool to surface any remaining compatibility issues if needed.

### 8. Review Target Framework

Confirm that all projects are targeting the intended framework version. Open each `.csproj` file and verify the `<TargetFramework>` element reflects the desired version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting an older or mismatched version, update it accordingly and re-run the build.