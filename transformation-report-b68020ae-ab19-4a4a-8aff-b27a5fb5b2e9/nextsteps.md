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

Run a full solution build to confirm the absence of errors:

```bash
dotnet build --configuration Release
```

Review the output and confirm that all three projects report a successful build.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not been broken during migration:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failing tests.

### 4. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects.

### 5. Check for Removed or Replaced APIs

Review the code in each project for any usage of APIs that were available in .NET Framework but have been removed or changed in modern .NET. Common areas to check include:

- `System.Web` references, which are not available in modern .NET and should be replaced with `Microsoft.AspNetCore` equivalents.
- `ConfigurationManager`, which should be replaced with `Microsoft.Extensions.Configuration`.
- `EntityFramework` (non-Core), which should be migrated to `Microsoft.EntityFrameworkCore`.

### 6. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing books, to confirm expected behavior.

### 7. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, confirm that:

- The connection string in `appsettings.json` is correctly configured for the target database.
- Any pending migrations are applied:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Review Logging and Configuration

Confirm that logging and application configuration have been migrated from any legacy `Web.config` or `App.config` files to the `appsettings.json` pattern used in modern .NET.

### 9. Test on Target Operating Systems

Since the goal of this migration is cross-platform support, run and validate the application on each operating system you intend to support, such as Linux and macOS, in addition to Windows. Pay particular attention to file path handling and any platform-specific dependencies.