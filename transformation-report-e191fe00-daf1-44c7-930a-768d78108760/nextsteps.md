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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). For example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects are targeting the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET. Review the following areas:

- **`Bookstore.Data`**: If Entity Framework is used, confirm the project is using `Microsoft.EntityFrameworkCore` rather than `System.Data.Entity`. Run any pending migrations and verify the database context configuration.
- **`Bookstore.Web`**: If this was previously an ASP.NET Web Forms or MVC 5 project, confirm that the routing, middleware pipeline (`Program.cs` / `Startup.cs`), and authentication configuration are correct for ASP.NET Core.
- **`Bookstore.Domain`**: Check for any use of `System.Web` or other Windows-specific namespaces that may have been silently removed or stubbed out.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate business logic and data access behavior.

```bash
dotnet test
```

If no test project exists, consider manually verifying the core domain logic and data layer by writing basic integration or unit tests before proceeding.

---

## 6. Run the Application Locally

Start the web application locally to verify runtime behavior.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following at runtime:

- The application starts without exceptions.
- Database connectivity is functional (check connection strings in `appsettings.json`).
- Core application routes and pages load correctly.
- Authentication and authorization behave as expected.

---

## 7. Validate Configuration Files

Ensure that `appsettings.json` (and `appsettings.Development.json`) contain all necessary configuration values that were previously stored in `Web.config` or `App.config`. Key areas to check:

- Connection strings
- Application settings / feature flags
- Logging configuration
- Authentication settings

---

## 8. Publish the Application

Once local validation is complete, publish the application to verify the output is correct.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.