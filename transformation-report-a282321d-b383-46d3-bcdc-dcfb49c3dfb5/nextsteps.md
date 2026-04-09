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

Verify that no warnings or errors appear during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm the absence of any compilation errors:

```bash
dotnet build --configuration Release
```

Review the build output and confirm that all three projects report a successful build.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not been broken during the migration:

```bash
dotnet test --configuration Release
```

Review the test results and address any failing tests before proceeding.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and behaves as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following:

- The application starts without runtime exceptions.
- Database connectivity functions correctly, particularly any Entity Framework migrations or data seeding logic in `Bookstore.Data`.
- Core domain logic in `Bookstore.Domain` behaves as expected through the UI or API endpoints.

### 5. Check Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element references the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects.

### 6. Review Removed Windows-Specific APIs

Search the codebase for any APIs that may have been silently retained but are not fully supported on non-Windows platforms. Common areas to check include:

- `System.Web` namespace references
- Windows Registry access
- Windows-specific file path assumptions (e.g., hardcoded backslashes)
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to assist with this review if needed.

### 7. Validate Database Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that all migrations are present and up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply migrations to a local database and confirm the schema is correct:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Test on Target Platform

If the goal is cross-platform support, run the application on the target non-Windows operating system (Linux or macOS) to confirm there are no platform-specific runtime issues that would not surface during a Windows build.