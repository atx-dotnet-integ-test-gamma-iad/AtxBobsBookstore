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

Check the output for any warnings that, while non-fatal, may indicate compatibility concerns with the new target framework.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 4. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether the failures are due to the migration or pre-existing issues.

### 5. Run the Web Application Locally

Start the `Bookstore.Web` project locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas specifically:
- Application startup without exceptions
- Database connectivity through `Bookstore.Data`
- Domain logic behavior through `Bookstore.Domain`
- All primary routes and pages load without errors

### 6. Review Windows-Specific APIs

Even without build errors, certain APIs may have been available on .NET Framework but behave differently or throw `PlatformNotSupportedException` at runtime on non-Windows platforms. Search the codebase for usages of the following and test them explicitly:

- `System.Web` namespaces
- Windows Registry access
- `System.Drawing` (GDI+)
- MSMQ or WCF-based communication
- Windows Authentication or NTLM-specific code

### 7. Verify Database Migrations

If `Bookstore.Data` uses Entity Framework Core, confirm that all migrations are compatible with the new framework version:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj
```

Apply any pending migrations to a test database before deploying to a production environment:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj
```

### 8. Review Configuration Files

Confirm that `appsettings.json` contains all configuration values that were previously held in `Web.config` or `App.config`. Pay particular attention to:

- Connection strings
- Application settings keys
- Authentication configuration
- Logging configuration