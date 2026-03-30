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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not cause outright build failures.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review test output for any failures or skipped tests that may indicate behavioral differences between the legacy framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas manually:

- **Routing**: Confirm all existing routes resolve correctly.
- **Database connectivity**: Verify that `Bookstore.Data` connects to the database and that Entity Framework migrations (if applicable) are up to date. Run `dotnet ef database update` if migrations are present.
- **Static assets**: Confirm that CSS, JavaScript, and image assets are served correctly.
- **Authentication/Authorization**: If the application uses any auth middleware, test login and protected routes.

### 5. Check for Removed or Changed APIs

Review the code in each project for any use of APIs that existed in .NET Framework but behave differently or have been removed in cross-platform .NET. Common areas to inspect include:

- `System.Web` references (these are not available in cross-platform .NET)
- `ConfigurationManager` usage (should be replaced with `Microsoft.Extensions.Configuration`)
- `HttpContext` and related types (ensure they come from `Microsoft.AspNetCore.Http`)
- Any Windows-specific APIs such as the registry, WCF server-side components, or `System.Drawing` (GDI+)

### 6. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 7. Publish the Application

Once validation is complete, publish the application to confirm the output is self-contained and correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all required files are present before deploying to the target environment.