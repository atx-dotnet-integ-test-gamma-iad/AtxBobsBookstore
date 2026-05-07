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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, consider updating them to versions that explicitly support your target framework.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or unexpected warnings.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after the migration.

```bash
dotnet test --configuration Release
```

Review the test results for any failures. Pay particular attention to tests that cover:

- Data access logic in `Bookstore.Data`
- Domain model behavior in `Bookstore.Domain`
- HTTP request handling and middleware in `Bookstore.Web`

If no test projects currently exist, consider adding them to establish a baseline for the migrated codebase.

---

## 4. Verify Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Confirm that:

- Application settings have been moved to `appsettings.json` or `appsettings.{Environment}.json`.
- Connection strings are correctly defined and accessible via `IConfiguration`.
- Any environment-specific values (e.g., development vs. production database connections) are properly separated.

---

## 5. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- The `DbContext` is registered correctly in the dependency injection container within `Bookstore.Web`.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually verify that core functionality works, including:

- Page rendering and navigation
- Data retrieval and display
- Any form submissions or write operations

Check the console output and application logs for any runtime exceptions or warnings.

---

## 7. Review Middleware and HTTP Pipeline

In cross-platform .NET, the HTTP pipeline is configured in `Program.cs` (and previously `Startup.cs`). Confirm that:

- Authentication and authorization middleware is correctly ordered.
- Static file serving is configured if the application serves CSS, JavaScript, or image assets.
- Error handling middleware is present for both development and production environments.

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including `appsettings.json` and any static assets.

---

## 9. Confirm Target Framework Compatibility

Verify that the target framework specified in each `.csproj` file is consistent and appropriate for your deployment environment. For example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure the same runtime version is available on the target server or hosting environment.