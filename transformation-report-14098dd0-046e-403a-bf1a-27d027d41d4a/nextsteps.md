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

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 4. Check for Windows-Specific APIs

Even without build errors, some APIs may have been carried over from the legacy project that only function correctly on Windows. Review the code in each project for usage of:

- `System.Web` namespaces
- Windows registry access
- Windows-specific file path assumptions (e.g., hardcoded backslashes)
- `HttpContext` usage patterns specific to ASP.NET (non-Core)

### 5. Database and Data Layer Validation

In `Bookstore.Data`, verify the following:

- The database provider configured (e.g., Entity Framework Core) is compatible with the target platform.
- Connection strings in `appsettings.json` are correct and accessible in the new environment.
- Run any pending migrations if Entity Framework Core is in use:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 6. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing books, to confirm end-to-end functionality.

### 7. Run Existing Tests

If the solution contains a test project, execute the test suite to validate business logic and data access behavior:

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to the migration or pre-existing issues.

### 8. Review Middleware and Configuration

In `Bookstore.Web`, confirm that the `Program.cs` or `Startup.cs` configuration is consistent with ASP.NET Core conventions, including:

- Middleware registration order (authentication, routing, static files, etc.)
- Configuration providers (`appsettings.json`, environment variables)
- Dependency injection registrations for services defined in `Bookstore.Domain` and `Bookstore.Data`

### 9. Static Files and Assets

Verify that static assets (CSS, JavaScript, images) are located under the `wwwroot` folder and are being served correctly when the application runs.

### 10. Deployment

Once local validation is complete, publish the application using the following command:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to your target hosting environment and confirm the application starts and operates correctly there.