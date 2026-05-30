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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output and confirm that all three projects report a successful build with zero errors.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and address any failing tests before proceeding.

### 4. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects.

### 5. Check for Removed or Changed APIs

Review any usage of APIs that were available in .NET Framework but have changed or been removed in modern .NET. Pay particular attention to:

- `System.Web` dependencies, which are not available in cross-platform .NET. These should be replaced with `Microsoft.AspNetCore` equivalents.
- `HttpContext`, `HttpRequest`, and `HttpResponse` usages, which have different namespaces and behaviors in ASP.NET Core.
- Any use of `ConfigurationManager`, which should be replaced with `Microsoft.Extensions.Configuration`.

### 6. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework, confirm the correct version is referenced:

- Entity Framework Core should be used in place of the legacy `EntityFramework` package.
- Run any pending migrations or verify the database schema is compatible:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 7. Run the Application Locally

Start the web application locally and navigate through its core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Verify that:
- The application starts without runtime exceptions.
- Core pages and routes load correctly.
- Database read and write operations function as expected.

### 8. Review Application Configuration

Check `appsettings.json` (and `appsettings.Development.json`) in `Bookstore.Web` to confirm that:

- Connection strings are correctly defined.
- Any environment-specific settings have been migrated from `Web.config` or `App.config`.
- Logging configuration is present and appropriate.

### 9. Review Static Files and Middleware

Confirm that static files (CSS, JavaScript, images) are served correctly and that the middleware pipeline in `Program.cs` or `Startup.cs` is configured in the correct order, including:

- `UseStaticFiles()`
- `UseRouting()`
- `UseAuthentication()` and `UseAuthorization()` if applicable
- `UseEndpoints()` or minimal API mappings