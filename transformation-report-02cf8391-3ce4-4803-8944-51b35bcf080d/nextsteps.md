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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear during the restore process, particularly around package compatibility or target framework mismatches.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs, nullable reference issues, or platform compatibility concerns, even if they do not block the build.

### 3. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework unintentionally.

### 4. Check for Windows-Specific Dependencies

Inspect each project's NuGet package references and code for APIs that are Windows-only. Common areas to check include:

- `System.Drawing` (use a cross-platform alternative such as `SkiaSharp` if needed)
- `Microsoft.Win32` registry access
- Any COM interop references
- Windows-specific file path assumptions (e.g., hardcoded backslashes)

### 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core functionality:

```bash
dotnet test --configuration Release
```

Review test output for any failures that may indicate behavioral differences introduced by the migration.

### 6. Run the Web Application Locally

Start the `Bookstore.Web` project and verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Confirm the following:

- The application starts without runtime exceptions
- Database connectivity functions correctly (check connection strings in `appsettings.json` for any legacy SQL Server or provider-specific configurations)
- All pages and routes load as expected
- Static assets are served correctly

### 7. Validate Data Layer

Confirm that `Bookstore.Data` is using a compatible database provider. If Entity Framework Core is in use, verify:

- Migrations are up to date by running:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- The database can be updated without errors:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Test on Target Platform

If the goal is to run on Linux or macOS, execute the above steps on the target operating system to surface any remaining platform-specific issues that may not appear on Windows.