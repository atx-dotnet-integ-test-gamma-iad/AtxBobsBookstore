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

Run a NuGet package restore to ensure all dependencies are resolved correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Configuration Files

- Confirm that `appsettings.json` (and `appsettings.Development.json` if applicable) in `Bookstore.Web` contains all configuration values that were previously in `Web.config` or `App.config`.
- Ensure connection strings, logging settings, and any environment-specific values have been correctly migrated.
- Check that `Program.cs` and `Startup.cs` (or the combined `Program.cs` in minimal hosting model) correctly registers all services, middleware, and Entity Framework contexts from `Bookstore.Data` and `Bookstore.Domain`.

---

## 4. Verify Entity Framework Configuration

If the project uses Entity Framework, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- The `DbContext` is registered properly in the dependency injection container.
- Run any pending migrations or verify the schema is up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to validate business logic and data access behavior:

```bash
dotnet test
```

If no tests currently exist, consider writing basic smoke tests for critical paths in `Bookstore.Domain` and `Bookstore.Data` before deploying.

---

## 6. Run the Application Locally

Start the application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web
```

- Navigate through the application and verify that all pages load correctly.
- Test core workflows such as browsing, searching, and any data submission forms.
- Check the console and application logs for runtime exceptions or warnings.

---

## 7. Review Deprecated or Removed APIs

Use the .NET Upgrade Analyzer or review the build output for any usage of APIs that have changed behavior between .NET Framework and modern .NET. Pay particular attention to:

- `System.Web` dependencies, which are not available in modern .NET.
- Any HTTP module or HTTP handler patterns that need to be replaced with ASP.NET Core middleware.
- `ConfigurationManager` usage, which should be replaced with `IConfiguration`.

---

## 8. Publish the Application

Once local validation is complete, publish the application to a target directory:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the output directory to confirm all required files are present before deploying to the target environment.