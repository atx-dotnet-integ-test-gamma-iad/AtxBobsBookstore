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

Review the output for any warnings that may indicate compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Review Runtime Dependencies

Check for any dependencies that may have relied on Windows-specific APIs or libraries, such as:

- `System.Web` usage
- Windows Registry access
- COM interop
- `HttpContext` or `HttpRuntime` from the legacy ASP.NET pipeline

These will not cause build errors but may cause runtime failures on non-Windows platforms.

### 5. Run the Application Locally

Start the application locally and perform manual smoke testing of core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Test the following areas at a minimum:

- Application startup and homepage load
- Database connectivity via `Bookstore.Data`
- Domain logic correctness via `Bookstore.Domain`
- Any authentication or session management features

### 6. Verify Database Migrations

If the project uses Entity Framework, confirm that migrations are compatible with the new runtime:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj
```

If you are targeting a different database provider than before (for example, moving away from SQL Server LocalDB), update the connection string in your configuration file accordingly and run:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj
```

### 7. Review Configuration Files

Ensure that `appsettings.json` (and environment-specific variants such as `appsettings.Production.json`) contain all configuration values that were previously stored in `Web.config` or `App.config`. Common items to check include:

- Connection strings
- Application settings keys
- Logging configuration
- Authentication settings

### 8. Check Target Framework Compatibility

Open each `.csproj` file and confirm the `TargetFramework` value is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all expected assemblies and static assets are present.