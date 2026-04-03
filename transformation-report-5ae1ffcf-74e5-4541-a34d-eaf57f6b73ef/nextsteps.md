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

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent compilation.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is intact:

```bash
dotnet test --configuration Release
```

Review test results and address any failing tests that may have been introduced by the migration.

### 4. Verify Runtime Behavior

Start the web application and confirm it runs as expected on the new platform:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas manually:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. If Entity Framework is used, verify that migrations are up to date by running `dotnet ef database update`.
- **Domain logic**: Exercise the core business logic paths through the UI or via API calls to confirm expected behavior.
- **Web layer**: Navigate through the application pages or endpoints to confirm routing, model binding, and rendering work correctly.

### 5. Review Target Framework Compatibility

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 6. Check for Removed or Changed APIs

Review any use of APIs that were available in .NET Framework but have changed or been removed in modern .NET. Common areas to inspect include:

- `System.Web` references, which are not available in cross-platform .NET
- `HttpContext` and related types, which may have different namespaces or behaviors in ASP.NET Core
- Configuration APIs, which have moved from `System.Configuration` to `Microsoft.Extensions.Configuration`
- Any Windows-specific APIs that may not function on non-Windows platforms

### 7. Review Connection Strings and Configuration

Confirm that connection strings and application settings have been migrated from `Web.config` or `App.config` to `appsettings.json`, and that they are being read correctly at runtime.

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  }
}
```

### 8. Validate NuGet Package Versions

Check that all third-party NuGet packages referenced in the projects have versions compatible with the target .NET framework. Packages that were built for .NET Framework may not be fully compatible. Use the following command to inspect outdated packages:

```bash
dotnet list package --outdated
```

Update packages where necessary and re-run the build and tests.