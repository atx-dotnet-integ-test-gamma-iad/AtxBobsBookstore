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

Verify that no warnings or errors appear related to missing or incompatible packages.

### 2. Build the Solution

Perform a full solution build to confirm the absence of any compile-time errors:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate compatibility issues, even if the build succeeds.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Target Framework Compatibility

Open each `.csproj` file and confirm that the `<TargetFramework>` element references a supported cross-platform .NET version, such as `net8.0`. Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 5. Check for Windows-Specific Dependencies

Review the `Bookstore.Data` and `Bookstore.Web` projects for any remaining references to Windows-specific libraries or APIs, such as:

- `System.Web`
- `Microsoft.Web.*`
- Windows Registry access
- Windows-only file path assumptions

These will not function correctly on Linux or macOS.

### 6. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify that:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql.EntityFrameworkCore.PostgreSQL`)
- Any pending migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 7. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the core functionality, including any data access operations, to confirm end-to-end behavior is intact.

### 8. Review Application Configuration

Check `appsettings.json` and `appsettings.Development.json` in `Bookstore.Web` to ensure:

- Connection strings are correct and environment-appropriate
- Any configuration keys previously stored in `Web.config` have been migrated to the appropriate `appsettings.json` entries
- Environment-specific settings are properly separated