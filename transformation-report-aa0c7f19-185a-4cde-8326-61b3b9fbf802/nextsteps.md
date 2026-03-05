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

Review the output for any warnings related to package compatibility or version conflicts, particularly for packages that may have changed between .NET Framework and modern .NET.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all projects so there are no unexpected compatibility mismatches.

### 4. Database and Data Layer Validation

Since `Bookstore.Data` is present, verify the following:

- If Entity Framework is used, confirm the correct EF Core package is referenced (e.g., `Microsoft.EntityFrameworkCore`), not the legacy `EntityFramework` package.
- Run any existing migrations or verify the database schema is still compatible:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If connection strings were previously stored in `Web.config`, confirm they have been moved to `appsettings.json` in `Bookstore.Web`.

### 5. Configuration Migration

Check that the following have been moved from `Web.config` or `App.config` to `appsettings.json`:

- Connection strings
- Application settings
- Any environment-specific configuration values

Confirm that `Bookstore.Web` reads configuration using `IConfiguration` rather than `ConfigurationManager`.

### 6. Run the Application Locally

Start the web application using the .NET CLI:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the URL shown in the console output and verify that the application loads and core functionality works as expected.

### 7. Run Existing Tests

If a test project exists in the solution, execute the test suite:

```bash
dotnet test
```

Review the results and address any failing tests that may indicate behavioral differences between the legacy .NET Framework version and the new cross-platform .NET version.

### 8. Check for Windows-Specific APIs

Search the codebase for any APIs that were available in .NET Framework but are not supported or behave differently in cross-platform .NET, such as:

- `System.Web` references
- `HttpContext` usage outside of the ASP.NET Core request pipeline
- Windows registry access
- COM interop

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining compatibility concerns.

### 9. Test on Target Platform

If the goal is cross-platform support, run and validate the application on the target operating system (Linux or macOS) to surface any platform-specific issues that would not appear on Windows.