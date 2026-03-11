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

Check the output for any warnings that, while non-breaking, may indicate deprecated APIs or framework-specific code that could cause runtime issues.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following areas at runtime:

- **Database connectivity**: Confirm that `Bookstore.Data` can connect to the database and that any Entity Framework migrations or schema expectations are met under the new runtime.
- **Data access operations**: Exercise create, read, update, and delete operations to ensure `Bookstore.Data` and `Bookstore.Domain` interact correctly.
- **Web endpoints**: Navigate through the application's pages and/or API endpoints to confirm responses are correct.
- **Configuration**: Verify that `appsettings.json` (or equivalent) is being read correctly, particularly connection strings and any environment-specific settings that may have previously lived in `Web.config`.

### 5. Review `Web.config` / `App.config` Migrations

If the original project used `Web.config` or `App.config`, confirm that all relevant settings have been moved to `appsettings.json` or the appropriate .NET configuration provider. Pay particular attention to:

- Connection strings
- Custom application settings
- HTTP handlers or modules that may need to be replaced with ASP.NET Core middleware

### 6. Check for Platform-Specific Code

Review the codebase for any APIs that were available in .NET Framework but have limited or no support in cross-platform .NET, such as:

- `System.Web` references
- Windows Registry access
- Windows Communication Foundation (WCF) client/server code
- `AppDomain` usage beyond what is supported in .NET Core and later

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to surface any remaining compatibility concerns.

### 7. Validate Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported framework version.

### 8. Deploy to a Staging Environment

Once local validation is complete, deploy the application to a staging environment that mirrors production. Confirm the following:

- The application starts without errors under the target OS and runtime version.
- Database migrations (if using Entity Framework) run successfully.
- All environment-specific configuration values are correctly applied.
- Logging output is captured and readable.