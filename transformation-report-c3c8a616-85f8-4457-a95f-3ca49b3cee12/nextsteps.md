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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-blocking, may indicate areas that need attention, such as nullable reference type warnings or obsolete API usage.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Entity Framework Migrations (if applicable)

Since the solution includes a `Bookstore.Data` project, it likely uses Entity Framework. Verify that your migrations are compatible with the current EF Core version by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If you were previously using EF 6 (Entity Framework 6) and have migrated to EF Core, be aware that there are API and behavior differences that may require manual adjustments to your `DbContext`, model configurations, and queries.

### 5. Run the Web Application Locally

Start the web application locally to validate runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and test core functionality, including:

- Database connectivity and data retrieval
- Any authentication or authorization flows
- Form submissions and data writes
- Static file serving (CSS, JavaScript, images)

### 6. Review `web.config` vs `appsettings.json`

If the original project used `web.config` for configuration (connection strings, app settings), confirm that all relevant values have been moved to `appsettings.json` or `appsettings.Production.json`. The legacy `web.config` is not used for application configuration in cross-platform .NET.

### 7. Check for Windows-Specific APIs

Review the codebase for any remaining usage of Windows-specific APIs that may not be available on Linux or macOS. Common examples include:

- `System.Web` namespace references
- Windows Registry access
- Windows-specific file path assumptions (backslashes, drive letters)

You can use the [.NET Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to assist with identifying platform-specific code.

### 8. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid compatibility issues between them.