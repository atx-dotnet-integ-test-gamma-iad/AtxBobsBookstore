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

Perform a full solution build to confirm the absence of errors in a clean build context:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Ensure consistency across all three projects.

### 4. Run Unit Tests

If the solution contains a test project, execute the tests to verify that business logic and data access behavior remain intact after migration:

```bash
dotnet test
```

If no test project currently exists, consider adding one to cover critical paths in `Bookstore.Domain` and `Bookstore.Data`.

### 5. Verify Database Connectivity

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- Connection strings in `appsettings.json` are correct for the target environment.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

- If the project was previously using `System.Data.SqlClient`, confirm it has been replaced with `Microsoft.Data.SqlClient`, which is the supported package on cross-platform .NET.

### 6. Run the Web Application Locally

Start the `Bookstore.Web` project and verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following:

- The application starts without runtime exceptions.
- All routes and pages load correctly.
- Any static assets (CSS, JavaScript) are served properly.
- Authentication or session handling, if present, functions as expected.

### 7. Check for Removed or Changed APIs

Review the code for any usage of APIs that were available in .NET Framework but behave differently or require replacement in cross-platform .NET. Common areas to check include:

- `System.Web` references, which are not available in cross-platform .NET and should have been replaced with ASP.NET Core equivalents.
- `ConfigurationManager`, which should be replaced with `Microsoft.Extensions.Configuration`.
- `HttpContext.Current`, which should be replaced with injected `IHttpContextAccessor`.

### 8. Review Application Configuration

Confirm that `appsettings.json` contains all configuration values that were previously stored in `Web.config` or `App.config`. Verify environment-specific settings are handled using `appsettings.Development.json` or environment variables where appropriate.

### 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present, then deploy the output to the target environment.