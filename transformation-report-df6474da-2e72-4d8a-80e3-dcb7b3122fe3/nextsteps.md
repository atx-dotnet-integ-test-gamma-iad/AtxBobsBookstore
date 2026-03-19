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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). For example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 4. Run Unit Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences introduced by the migration.

### 5. Run the Application Locally

Start the web application locally to verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually exercise the key workflows of the application, such as browsing, searching, and any data-driven pages, to confirm that the `Bookstore.Data` and `Bookstore.Domain` layers are functioning correctly end-to-end.

### 6. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, confirm that any migrations are up to date and that the database connection works in the target environment:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If you are using a different data access strategy, verify that connection strings and provider packages are correctly configured in `appsettings.json`.

### 7. Review Removed Windows-Specific APIs

Search the codebase for any APIs that were previously available in .NET Framework but may have changed behavior or been replaced in cross-platform .NET. Common areas to check include:

- `System.Web` references (should be fully replaced by ASP.NET Core equivalents)
- `ConfigurationManager` (should be replaced by `Microsoft.Extensions.Configuration`)
- Windows Registry or file path assumptions using backslashes

### 8. Test on a Non-Windows Platform (Optional but Recommended)

Since the goal is cross-platform compatibility, consider running the application on Linux or macOS to surface any remaining platform-specific assumptions:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Pay attention to file path handling, case sensitivity in file names, and any platform-specific library dependencies.

## Deployment

### 1. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

For a self-contained deployment targeting a specific runtime, add the runtime identifier:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

### 2. Verify the Published Output

Navigate to the `./publish` directory and confirm all expected files are present, including configuration files and static assets.

### 3. Configure the Production Environment

Ensure the following are correctly set in the production environment:

- The `ASPNETCORE_ENVIRONMENT` environment variable is set to `Production`
- Connection strings and sensitive settings are provided via environment variables or a secrets manager rather than `appsettings.json`
- The appropriate ASP.NET Core runtime or hosting bundle is installed on the target server if using a framework-dependent deployment