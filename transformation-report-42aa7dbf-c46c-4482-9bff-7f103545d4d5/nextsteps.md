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

Check the output for any warnings that, while non-breaking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 4. Run Unit Tests

If the solution contains a test project, execute the tests to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic integration or unit tests for the core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data`.

### 5. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Connection strings in `appsettings.json` are valid and accessible in the new environment.
- Run any pending migrations to confirm the database schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the web application to verify it runs correctly on the cross-platform runtime:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, managing inventory) to confirm expected behavior.

### 7. Review Removed or Changed APIs

Cross-platform .NET does not support certain Windows-specific APIs that were available in .NET Framework. Review the code for any usage of the following and replace or remove as needed:

- `System.Web` namespaces (largely replaced by `Microsoft.AspNetCore`)
- Windows Registry access (`Microsoft.Win32.Registry`)
- `HttpContext.Current` (use dependency-injected `IHttpContextAccessor` instead)
- `System.Drawing` (consider using a cross-platform alternative such as `SkiaSharp` if image processing is required)

### 8. Check Runtime Behavior on Target OS

If the application is intended to run on Linux or macOS, test it explicitly on those platforms. Pay particular attention to:

- File path separators (use `Path.Combine` rather than hardcoded `\` characters)
- Case-sensitive file system behavior on Linux
- Any platform-specific configuration or environment variable differences