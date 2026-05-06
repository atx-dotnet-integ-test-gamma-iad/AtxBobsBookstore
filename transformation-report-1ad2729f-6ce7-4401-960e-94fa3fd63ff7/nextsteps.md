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

Review the output for any warnings related to package compatibility or version conflicts. Address any packages that may have been targeting the old .NET Framework and verify their cross-platform equivalents are in place.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the build output for any warnings, particularly around obsolete APIs or platform-specific code paths that may have been carried over from the legacy project.

### 3. Review Platform-Specific Code

Even without build errors, inspect the codebase for any remaining platform-specific dependencies that may compile but fail at runtime on non-Windows platforms. Common areas to check include:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows-specific file paths** (hardcoded drive letters or backslashes)
- **`System.Web` references** that may have been shimmed but not fully replaced
- **COM interop** or P/Invoke calls targeting Windows-only libraries

### 4. Run the Application Locally

Start the application and verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate through the application and confirm that core functionality such as browsing, data retrieval, and any form submissions behave correctly.

### 5. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework or another ORM, verify the following:

- The connection string in your configuration file (`appsettings.json`) is correct for your target environment.
- Run any pending migrations if using Entity Framework Core:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- Confirm that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql`, etc.) is appropriate for your target platform.

### 6. Execute Unit and Integration Tests

If the solution contains test projects, run them to validate business logic and data access behavior:

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to the migration itself or pre-existing issues.

### 7. Review Configuration and Middleware

In `Bookstore.Web`, confirm that the following have been correctly migrated:

- `Startup.cs` or `Program.cs` follows the modern .NET hosting model.
- Middleware registrations (authentication, authorization, routing, static files) are present and correctly ordered.
- Any `web.config` settings have been moved to `appsettings.json` or environment variables where applicable.

### 8. Test on a Non-Windows Platform (Optional but Recommended)

If cross-platform support is a goal, run the application on Linux or macOS to surface any remaining platform-specific runtime issues that would not appear during a Windows build.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Observe logs and error output carefully during startup and under normal usage.