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

If the solution contains test projects, execute them with:

```bash
dotnet test
```

Review any failing tests to determine whether they reflect regressions introduced during the migration or pre-existing issues.

### 5. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql.EntityFrameworkCore.PostgreSQL`).
- Connection strings in `appsettings.json` are valid and accessible in the new environment.
- Run any pending migrations to confirm the database schema is in sync:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, authentication if applicable) to confirm expected behavior.

### 7. Check for Windows-Specific APIs

Search the codebase for any APIs that were available in .NET Framework but have limited or no support in cross-platform .NET. Common areas to review include:

- `System.Web` references (should have been replaced with `Microsoft.AspNetCore` equivalents)
- `HttpContext` usage patterns
- Windows Registry access (`Microsoft.Win32.Registry`)
- Any P/Invoke calls targeting Windows-only system libraries

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to assist with this review if needed.

### 8. Test on the Target Platform

If the goal is cross-platform support, run the application on the target non-Windows operating system (Linux or macOS) to surface any remaining platform-specific issues that may not appear during a Windows build.

```bash
dotnet publish --configuration Release --runtime linux-x64 --self-contained false
```

Then execute the published output on the target platform and verify runtime behavior.