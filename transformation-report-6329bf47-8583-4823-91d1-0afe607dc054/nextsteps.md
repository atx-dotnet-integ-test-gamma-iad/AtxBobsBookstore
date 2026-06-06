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

Verify that no warnings or errors are reported during restoration.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output and confirm that all three projects report a successful build with zero errors.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not been broken during migration:

```bash
dotnet test --configuration Release
```

Review test results and address any failing tests before proceeding.

### 4. Run the Application Locally

Start the `Bookstore.Web` project locally to verify runtime behavior:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually navigate through the application and verify that core functionality works as expected, including any database interactions handled by `Bookstore.Data` and domain logic in `Bookstore.Domain`.

### 5. Verify Database Connectivity and Migrations

If the project uses Entity Framework Core, confirm that your database connection strings are correctly configured in `appsettings.json` or environment variables. Then apply any pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Verify that the database schema is created or updated without errors.

### 6. Check Target Framework Compatibility

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a currently supported version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting an older or end-of-life framework version, update it to a supported release.

### 7. Review Removed or Changed APIs

Cross-platform .NET does not support certain Windows-specific APIs that were available in .NET Framework. Manually review the codebase for any usage of the following and replace or remove them as needed:

- `System.Web` namespaces
- Windows Registry access
- `HttpContext` usage patterns specific to ASP.NET (non-Core)
- Any P/Invoke calls targeting Windows-only system libraries

### 8. Review Configuration and Middleware

If `Bookstore.Web` was previously an ASP.NET Web Forms or MVC (.NET Framework) project, confirm that the middleware pipeline in `Program.cs` or `Startup.cs` is correctly configured for ASP.NET Core, including:

- Authentication and authorization middleware
- Static file serving
- Routing configuration
- Session and cookie handling