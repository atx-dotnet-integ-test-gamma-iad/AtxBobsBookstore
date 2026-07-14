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

## Validation Steps

### 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build context:

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

### 4. Run the Test Suite

If the solution contains a test project, execute the tests to verify runtime behavior has not regressed:

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing integration or unit tests for the core domain and data layers before proceeding to deployment.

### 5. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql.EntityFrameworkCore.PostgreSQL`).
- Connection strings in `appsettings.json` are valid for the target environment.
- Run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the web application and verify it runs as expected on the cross-platform runtime:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm functional correctness.

### 7. Review Removed or Changed APIs

Check for any use of Windows-specific APIs that may have been silently retained. Common areas to audit include:

- `System.Web` references (should be replaced with ASP.NET Core equivalents)
- `HttpContext` usage patterns
- Windows Registry access
- `System.Drawing` (replace with a cross-platform alternative such as `SkiaSharp` if used)

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to assist with this audit if needed.

### 8. Review Configuration and Middleware

In `Bookstore.Web`, confirm that:

- `Program.cs` follows the minimal hosting model appropriate for the target .NET version.
- Middleware registration (authentication, authorization, static files, routing) is complete and correctly ordered.
- Environment-specific `appsettings.{Environment}.json` files are present and correctly configured.