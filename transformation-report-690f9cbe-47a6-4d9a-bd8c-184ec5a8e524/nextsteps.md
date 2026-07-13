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

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 4. Run Unit Tests

If the solution contains a test project, execute the tests to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences between .NET Framework and modern .NET.

### 5. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, confirm the following:

- The connection string in `appsettings.json` (or equivalent configuration) is valid and points to the correct database.
- Any Entity Framework migrations are up to date. Run the following if applicable:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the EF Core provider being used (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is compatible with the target framework version.

### 6. Run the Web Application Locally

Start the web application to verify it runs correctly end to end:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, data retrieval) to confirm runtime behavior is correct.

### 7. Check for Removed or Changed APIs

Modern .NET removed several APIs that were available in .NET Framework. Review the code in each project for usage of the following common problem areas:

- `System.Web` namespace — not available in modern .NET; should be replaced with `Microsoft.AspNetCore` equivalents.
- `ConfigurationManager` — replaced by `Microsoft.Extensions.Configuration`.
- `HttpContext.Current` — replaced by injected `IHttpContextAccessor`.
- Binary serialization (`BinaryFormatter`) — removed in .NET 9 and disabled by default in earlier versions.

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.ApiCompat` tooling to surface any remaining compatibility issues:

```bash
dotnet tool install -g upgrade-assistant
upgrade-assistant analyze Bookstore.Web
```

### 8. Review Logging and Configuration

Confirm that logging and configuration have been migrated away from any .NET Framework-specific mechanisms:

- Logging should use `Microsoft.Extensions.Logging`.
- Configuration should use `Microsoft.Extensions.Configuration` with `appsettings.json`.

### 9. Test on Target Platform

If cross-platform support is a goal, run the application on the intended non-Windows platform (Linux or macOS) to surface any platform-specific issues such as:

- File path separator differences (`\` vs `/`).
- Case-sensitive file system behavior on Linux.
- Windows-only APIs or P/Invoke calls.