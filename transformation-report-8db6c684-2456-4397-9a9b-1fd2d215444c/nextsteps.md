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

If the solution contains a test project, execute the tests to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider adding one targeting critical areas such as domain logic in `Bookstore.Domain` and data access in `Bookstore.Data`.

### 5. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify that:

- The connection string in `appsettings.json` is valid for the target environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- The EF Core provider being used (e.g., SQL Server, SQLite, PostgreSQL) is compatible with the target .NET version.

### 6. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm expected behavior.

### 7. Review Removed or Changed APIs

Cross-platform .NET removes certain APIs that were available in .NET Framework. Manually review the code in each project for usage of the following common problem areas:

- `System.Web` namespaces (not available in .NET Core/5+)
- `HttpContext` usage outside of ASP.NET Core's dependency injection model
- Windows-specific APIs such as the registry or certain `System.Drawing` features
- `ConfigurationManager` (replaced by `Microsoft.Extensions.Configuration`)

Even if the build succeeds, runtime exceptions can surface from these areas.

### 8. Check Middleware and Startup Configuration (Bookstore.Web)

If the project was migrated from ASP.NET MVC (.NET Framework) to ASP.NET Core, confirm that:

- `Program.cs` or `Startup.cs` correctly registers all required services.
- Authentication, authorization, and session middleware are configured in the correct order.
- Any HTTP modules or HTTP handlers from the legacy project have been replaced with ASP.NET Core middleware equivalents.

### 9. Deployment

Once local validation is complete, publish the application using:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and deploy to the target environment according to your hosting setup (IIS, Kestrel, Linux host, etc.). Ensure the target server has the appropriate .NET runtime installed.