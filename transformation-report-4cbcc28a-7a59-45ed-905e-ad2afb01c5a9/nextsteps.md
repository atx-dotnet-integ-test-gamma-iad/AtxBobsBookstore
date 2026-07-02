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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build context:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 4. Run Unit Tests

If the solution contains a test project, execute the test suite to verify that business logic and data access behavior remain correct after the migration:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing basic tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

### 5. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Connection strings in `appsettings.json` are valid and accessible from the new runtime environment.
- Run any pending migrations to ensure the database schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application's key pages and features to confirm that functionality is intact. Pay particular attention to:

- Pages or controllers that interact with the database through `Bookstore.Data`
- Any areas that rely on domain logic from `Bookstore.Domain`
- Static file serving and routing behavior

### 7. Review Removed Windows-Specific Dependencies

Check that no references to Windows-specific APIs remain. Search the codebase for usages of the following, which are not supported cross-platform:

- `System.Web`
- `Microsoft.Web.*`
- Windows Registry access
- Windows-specific file path assumptions (e.g., hardcoded backslashes)

Use `Path.Combine` for file paths and ensure path separators are handled in a platform-neutral way.

### 8. Review Configuration and Middleware (Bookstore.Web)

If the project was migrated from ASP.NET (Framework) to ASP.NET Core, confirm the following in `Bookstore.Web`:

- `Program.cs` or `Startup.cs` correctly configures services and middleware.
- Authentication, authorization, and session middleware are configured using ASP.NET Core equivalents.
- Any `HttpContext`, `HttpRequest`, or `HttpResponse` usages have been updated to their ASP.NET Core counterparts.

## Deployment

### 1. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

### 2. Verify the Published Output

Inspect the `./publish` directory to confirm all required files are present, including configuration files and static assets.

### 3. Test the Published Output

Run the published output directly to confirm it behaves consistently with the development build:

```bash
dotnet ./publish/Bookstore.Web.dll
```