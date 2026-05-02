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

The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are still present, consider replacing them with their .NET-compatible equivalents.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build output shows zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

- Verify that `appsettings.json` (and `appsettings.Development.json`) in `Bookstore.Web` contains the correct connection strings and application settings that were previously in `Web.config` or `App.config`.
- Confirm that any environment-specific configuration is handled using the `IConfiguration` system rather than `ConfigurationManager`, which is a common migration concern.

---

## 4. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Run any pending migrations or verify the database schema is up to date.

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and exercise the primary workflows (browsing books, user authentication if applicable, etc.).
- Check the console output and application logs for any runtime exceptions or unhandled errors.

---

## 6. Execute Unit and Integration Tests

If the solution contains a test project, run all tests to validate business logic and data access behavior.

```bash
dotnet test
```

- Review test results for any failures that may indicate behavioral differences introduced by the migration.
- Pay particular attention to tests covering `Bookstore.Domain` logic and `Bookstore.Data` repository or context behavior.

---

## 7. Validate Static Assets and Middleware

In `Bookstore.Web`, confirm the following:

- Static files (CSS, JavaScript, images) are served correctly. These should be located under the `wwwroot` folder.
- Middleware configuration in `Program.cs` or `Startup.cs` is correct, including routing, authentication, and error handling middleware.
- Any HTTP modules or HTTP handlers from the legacy project have been replaced with the appropriate ASP.NET Core middleware equivalents.

---

## 8. Check for Platform-Specific Code

Review the codebase for any remaining Windows-specific APIs or dependencies that may cause issues on non-Windows platforms if cross-platform deployment is intended. Tools such as the .NET Upgrade Assistant or the Platform Compatibility Analyzer can assist with this.

```bash
dotnet build /p:EnableNETAnalyzers=true
```

---

## 9. Publish the Application

Once validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.