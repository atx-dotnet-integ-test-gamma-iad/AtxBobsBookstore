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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate compatibility issues, even if the build succeeds.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not been broken during the migration:

```bash
dotnet test --configuration Release
```

Review the test results and address any failing tests before proceeding.

### 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas at a minimum:

- Application startup completes without exceptions
- Database connectivity works as expected through `Bookstore.Data`
- Domain logic in `Bookstore.Domain` behaves correctly end-to-end
- All major routes and pages in `Bookstore.Web` load and respond correctly

### 5. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 6. Check for Removed or Changed APIs

Cross-platform .NET removes or changes certain APIs that were available in .NET Framework. Review the following areas:

- Any usage of `System.Web` namespaces, which are not available in cross-platform .NET
- `HttpContext` and related types, which should now come from `Microsoft.AspNetCore.Http`
- Configuration access patterns, which should use `Microsoft.Extensions.Configuration` rather than `System.Configuration.ConfigurationManager`
- Any Windows-specific APIs such as the registry, WMI, or Windows identity APIs that may not behave the same on non-Windows platforms

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to assist with this review if needed.

### 7. Validate Data Layer

If `Bookstore.Data` uses Entity Framework, confirm the version in use:

- If it was migrated from Entity Framework 6, verify whether the project now targets **EF Core** and that all migrations are intact
- Run the following to verify the database schema is up to date:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Review Configuration Files

Ensure that `appsettings.json` contains all necessary configuration values that were previously stored in `Web.config` or `App.config`. Common entries to verify include:

- Connection strings
- Application-specific settings
- Logging configuration

### 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all expected files are present before deploying to the target environment.