# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects in the solution:

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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay attention to any warnings about obsolete APIs or nullable reference types, as these may indicate areas that need attention.

### 3. Run Unit Tests

If the solution contains test projects, execute them with:

```bash
dotnet test
```

Review test results to ensure existing functionality has not regressed during the transformation. If test coverage is low, consider adding tests for critical paths such as data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and behaves as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas manually:

- Application startup and routing
- Database connectivity from `Bookstore.Data` (verify connection strings in `appsettings.json` are correct for the target environment)
- Any pages or API endpoints that interact with `Bookstore.Domain` models

### 5. Review Configuration Files

Cross-platform .NET projects use `appsettings.json` instead of `Web.config` or `App.config`. Confirm that:

- Connection strings have been migrated to `appsettings.json`
- Any environment-specific settings are placed in `appsettings.Development.json` or equivalent
- No legacy configuration references remain in the codebase

### 6. Check for Platform-Specific Code

Search the codebase for any APIs that may have been available in .NET Framework but have limited or no support in cross-platform .NET:

- `System.Web` references
- Windows Registry access
- Windows-only file path assumptions (e.g., hardcoded backslashes)
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.ApiCompat` tool to assist with this review if needed.

### 7. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported framework version.

### 8. Deploy to a Staging Environment

Once local validation is complete, deploy the application to a staging environment that mirrors production:

- Publish the application using:

```bash
dotnet publish --configuration Release --output ./publish
```

- Copy the output to the staging server and run the application to confirm it operates correctly outside of a development context.
- Verify database migrations (if using Entity Framework Core) are applied correctly by running:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```