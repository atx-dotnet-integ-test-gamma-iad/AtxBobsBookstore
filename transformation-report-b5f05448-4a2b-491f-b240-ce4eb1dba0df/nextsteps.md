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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that may indicate compatibility concerns, even if they do not prevent compilation.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker unless there is a specific reason.

### 4. Check for Windows-Specific Dependencies

Review the project files and source code for any remaining Windows-specific APIs or packages, such as:

- `System.Web` references
- `Microsoft.Web.*` packages
- Registry access (`Microsoft.Win32.Registry`)
- Windows-only NuGet packages

These will compile but may fail at runtime on non-Windows platforms.

### 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate runtime behavior:

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic integration or smoke tests that exercise the primary data access and domain logic paths.

### 6. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate to the application in a browser and exercise the main workflows, such as browsing, searching, and any data entry forms, to confirm end-to-end functionality.

### 7. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, confirm that:

- The connection string in `appsettings.json` is valid for the target environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- The EF Core provider package matches the database being used (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql.EntityFrameworkCore.PostgreSQL`).

### 8. Review Configuration and Secrets

Confirm that configuration previously stored in `Web.config` or `App.config` has been correctly migrated to `appsettings.json` or environment variables, and that no sensitive values are hardcoded in source files.

### 9. Test on a Non-Windows Platform (Optional but Recommended)

If cross-platform support is a goal, run the application on Linux or macOS to surface any platform-specific runtime issues that would not appear during Windows-based testing:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Observe logs and error output for any `PlatformNotSupportedException` or similar runtime exceptions.