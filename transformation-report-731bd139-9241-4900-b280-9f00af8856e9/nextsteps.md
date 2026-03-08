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

Verify that all three projects build without warnings or errors. Pay particular attention to any warnings about obsolete APIs or nullable reference types, as these may indicate areas that need attention.

### 3. Run Unit Tests

If the solution contains test projects, execute them to confirm existing functionality is intact:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests that previously passed may indicate a behavioral difference introduced during the migration.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas specifically:

- **Database connectivity**: Confirm that `Bookstore.Data` can connect to the database and that any Entity Framework migrations are compatible with the new runtime. Run `dotnet ef database update` if migrations need to be applied.
- **Domain logic**: Exercise the primary business workflows to confirm that `Bookstore.Domain` behaves as expected.
- **Web layer**: Navigate through the application routes, forms, and any API endpoints to confirm responses are correct.

### 5. Check Target Framework Compatibility

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 6. Review Removed or Changed APIs

Cross-platform .NET removes certain APIs that were available in .NET Framework. Check the following:

- Any use of `System.Web` namespaces, which are not available in cross-platform .NET and must be replaced with ASP.NET Core equivalents.
- `ConfigurationManager` usage should be replaced with `Microsoft.Extensions.Configuration`.
- `HttpContext.Current` should be replaced with injected `IHttpContextAccessor`.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.UpgradeAssistant` tool to identify any remaining compatibility issues:

```bash
dotnet tool install -g upgrade-assistant
upgrade-assistant analyze ./Bookstore.sln
```

### 7. Validate Configuration Files

Confirm that `appsettings.json` contains all configuration values that were previously in `Web.config` or `App.config`, including connection strings and application settings. Ensure environment-specific overrides such as `appsettings.Development.json` are in place where needed.

### 8. Publish a Release Build

Once all validation steps pass, produce a published output to confirm the application can be deployed:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assets, views, and static files are present.