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

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects. A mismatch between projects can cause runtime issues even when the build succeeds.

### 4. Run Unit Tests

If the solution contains a test project, execute the tests with:

```bash
dotnet test
```

If no test project currently exists, consider adding one to cover core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data`.

### 5. Verify Data Layer

In `Bookstore.Data`, check the following:

- If Entity Framework Core is in use, confirm the correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Run any pending migrations or verify that the database schema is compatible:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that connection strings in `appsettings.json` are correct for the target environment.

### 6. Run the Web Application Locally

Start the web application to verify it runs as expected:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the displayed local URL and exercise the primary application workflows, such as browsing, searching, and any data entry features, to confirm end-to-end functionality.

### 7. Check for Windows-Specific APIs

Even with a successful build, runtime failures can occur if the code references Windows-specific APIs that are not available on Linux or macOS. Review the codebase for usage of:

- `Microsoft.Win32` namespaces
- Windows registry access
- Windows-specific file path assumptions (e.g., hardcoded backslashes)

Use the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to assist with this review.

### 8. Review Removed or Changed APIs

If the original project targeted .NET Framework, certain APIs may have been removed or have behavioral differences in cross-platform .NET. Review the [.NET Upgrade Assistant compatibility reports](https://learn.microsoft.com/en-us/dotnet/core/porting/) and address any flagged items.

### 9. Validate Configuration and Middleware

In `Bookstore.Web`, confirm that:

- `Program.cs` or `Startup.cs` is correctly structured for the target .NET version.
- Middleware registration order is correct.
- Any `web.config` settings that were relevant have been migrated to `appsettings.json` or equivalent configuration sources.