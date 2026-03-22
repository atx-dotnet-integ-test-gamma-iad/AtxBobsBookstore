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

Perform a full solution build to confirm there are no errors or warnings:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

Review the test output carefully. Any failing tests should be investigated to determine whether they are caused by behavioral differences in the new target framework.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas at a minimum:

- Application startup and routing
- Database connectivity from `Bookstore.Data` (confirm connection strings are correctly configured for the new environment)
- Domain logic correctness by exercising key workflows through the UI or API endpoints

### 5. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) to confirm:

- Connection strings are valid and point to the correct database instances
- Any settings that were previously in `Web.config` or `App.config` have been correctly migrated to the new configuration system

### 6. Check for Platform-Specific Code

Search the codebase for any APIs that may have been available in .NET Framework but have limited or no support in cross-platform .NET:

- `System.Web` references
- Windows Registry access
- COM interop
- `HttpContext` static access patterns

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to assist with this review if needed.

### 7. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assets, static files, and dependencies are present.