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

Run the following command from the root of the solution to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

### 2. Build the Solution

Confirm the solution builds cleanly:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs, missing references, or compatibility concerns even if they do not block the build.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 4. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that existed in .NET Framework but have been removed or altered in modern .NET. Common areas to check include:

- `System.Web` references, which are not available in cross-platform .NET
- `HttpContext` and related types, which should now come from `Microsoft.AspNetCore.Http`
- `ConfigurationManager`, which should be replaced with `Microsoft.Extensions.Configuration`
- `AppDomain` members that are no longer supported

### 5. Run Existing Tests

If the solution contains a test project, execute the tests to verify runtime behavior has not changed:

```bash
dotnet test --configuration Release
```

If no tests exist, consider writing basic integration or unit tests for the core domain and data layers before proceeding.

### 6. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that any Entity Framework or data access configuration is compatible with the new runtime. Specifically:

- If using Entity Framework, ensure the package is `Microsoft.EntityFrameworkCore` and not the older `EntityFramework` package
- Verify connection strings in `appsettings.json` are correctly configured
- Run any pending migrations if applicable:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 7. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and confirm that pages load correctly, data is retrieved as expected, and no runtime exceptions occur.

### 8. Review Middleware and Startup Configuration

In `Bookstore.Web`, review the `Program.cs` or `Startup.cs` file to ensure middleware is registered in the correct order and that all services are properly configured using the `Microsoft.Extensions.DependencyInjection` patterns expected by modern ASP.NET Core.

### 9. Check Static Files and Views

Confirm that static assets such as CSS, JavaScript, and images are served correctly, and that any Razor views or pages render without errors. Pay particular attention to any HTML helpers or tag helpers that may have changed between .NET Framework MVC and ASP.NET Core MVC.