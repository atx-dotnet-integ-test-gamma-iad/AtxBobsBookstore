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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `netcoreapp3.x`, `net5.0`, or `net6.0`, update it to `net8.0` and re-run the restore and build steps.

---

## 4. Check for Removed or Changed APIs

Even when a project builds successfully, runtime failures can occur due to APIs that were removed or changed between .NET Framework and modern .NET. Review the following areas:

- **`System.Web` usage**: This namespace is not available in modern .NET. Any remaining references should be replaced with ASP.NET Core equivalents.
- **`HttpContext`**, **`HttpRequest`**, and **`HttpResponse`**: Confirm these are sourced from `Microsoft.AspNetCore.Http` and not `System.Web`.
- **Entity Framework**: If `Bookstore.Data` uses Entity Framework, confirm it has been migrated to Entity Framework Core and that the correct provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is referenced.
- **Configuration**: Confirm that `System.Configuration.ConfigurationManager` usage has been replaced with `Microsoft.Extensions.Configuration`.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to validate core logic.

```bash
dotnet test
```

If no test projects exist, consider manually verifying the key domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data`.

---

## 6. Run the Application Locally

Start the web application locally to verify it runs as expected.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following:

- The application starts without exceptions.
- All pages or API endpoints load correctly.
- Database connectivity works as expected (check connection strings in `appsettings.json`).
- Any static files, views, or Razor pages render correctly.

---

## 7. Validate Configuration Files

Ensure that configuration previously stored in `Web.config` or `App.config` has been correctly migrated to `appsettings.json`.

- Connection strings should be present under the `"ConnectionStrings"` section.
- Application settings should be moved to appropriate sections in `appsettings.json`.
- Environment-specific overrides should use `appsettings.Development.json` or `appsettings.Production.json`.

---

## 8. Review Middleware and Startup Configuration

In `Bookstore.Web`, review `Program.cs` (and `Startup.cs` if present) to confirm:

- Middleware is registered in the correct order.
- Services such as database contexts, repositories, and domain services are registered in the dependency injection container.
- Authentication and authorization middleware, if applicable, is configured correctly.

---

## 9. Publish the Application

Once local validation is complete, publish the application to verify the output is correct.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets and configuration files.