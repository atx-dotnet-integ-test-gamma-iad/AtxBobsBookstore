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

Verify that no warnings or errors appear related to missing or incompatible packages.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 4. Run Unit Tests

If the solution contains a test project, execute the tests to validate that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic tests covering the core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data`.

### 5. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core or another ORM, confirm the following:

- The connection string in `appsettings.json` is valid for the target environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql`) is compatible with the target framework.

### 6. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm runtime behavior is correct.

### 7. Check for Windows-Specific API Usage

Even with a successful build, some APIs may have been available on .NET Framework but behave differently or are unavailable at runtime on non-Windows platforms. Review the codebase for usage of:

- `System.Web` namespaces (should no longer be present)
- Windows Registry access
- Windows-specific file path assumptions (e.g., backslash separators)
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to assist with this review if needed.

### 8. Review Configuration and Middleware (Bookstore.Web)

If the project was migrated from ASP.NET (System.Web) to ASP.NET Core, confirm the following in `Bookstore.Web`:

- `Program.cs` or `Startup.cs` correctly registers services and middleware.
- Authentication, authorization, and session middleware are configured appropriately for ASP.NET Core.
- Any HTTP handlers or modules from the legacy project have been replaced with ASP.NET Core middleware equivalents.

### 9. Validate Logging and Error Handling

Confirm that logging is configured using `Microsoft.Extensions.Logging` or a compatible provider, and that unhandled exceptions are surfaced correctly in the new runtime environment.