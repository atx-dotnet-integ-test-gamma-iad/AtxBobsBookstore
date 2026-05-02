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

Check the output for any warnings that, while non-fatal, may indicate compatibility concerns with the new target framework.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

### 4. Check for Windows-Specific Dependencies

Inspect each project's `.csproj` for any NuGet packages or references that are Windows-only. Common examples include:

- `Microsoft.Web.Infrastructure`
- `System.Web` references
- Any package with a `windows` target framework condition

If found, replace them with their cross-platform equivalents.

### 5. Run Unit Tests

If the solution contains a test project, execute the tests to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences in the new runtime.

### 6. Run the Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually exercise core application flows such as browsing, searching, and any data access operations to confirm that `Bookstore.Data` and `Bookstore.Domain` are functioning correctly end-to-end.

### 7. Verify Database Connectivity and Migrations

If the project uses Entity Framework Core, confirm that migrations are up to date and the database schema is compatible:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations are missing or out of date, add or apply them as needed:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Review Configuration Files

Confirm that `appsettings.json` contains all configuration values that were previously in `Web.config` or `App.config`, including:

- Connection strings
- Application settings
- Logging configuration

### 9. Test on a Non-Windows Platform

Since the goal of the transformation is cross-platform compatibility, run the application on Linux or macOS if possible, or within a non-Windows environment, to confirm there are no hidden platform-specific dependencies remaining.