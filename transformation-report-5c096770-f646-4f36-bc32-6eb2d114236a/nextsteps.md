# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

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

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported cross-platform .NET version, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly and re-run the build.

---

## 4. Check for Removed or Changed APIs

Even when a project builds successfully, some APIs available in .NET Framework may behave differently or have been replaced in cross-platform .NET. Pay particular attention to:

- `System.Web` usages — this namespace is not available in cross-platform .NET. Any remaining references should be replaced with ASP.NET Core equivalents.
- `HttpContext`, `HttpRequest`, and `HttpResponse` — ensure these are sourced from `Microsoft.AspNetCore.Http`.
- Entity Framework — confirm the project is using `Microsoft.EntityFrameworkCore` and not the legacy `System.Data.Entity` namespace.
- Configuration — ensure `System.Configuration.ConfigurationManager` has been replaced with `Microsoft.Extensions.Configuration`.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core logic.

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether failures are caused by behavioral differences in the new runtime or by test setup issues related to the migration.

---

## 6. Run the Application Locally

Start the web application locally to verify runtime behavior.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following areas:

- Application startup and routing
- Database connectivity through `Bookstore.Data`
- Domain logic execution through `Bookstore.Domain`
- Any pages or API endpoints that interact with data

---

## 7. Verify Database Connectivity

If the project uses Entity Framework Core, confirm that the connection string in `appsettings.json` is correctly configured for the target database.

```json
"ConnectionStrings": {
  "DefaultConnection": "Server=...;Database=...;User Id=...;Password=...;"
}
```

Run any pending migrations to ensure the database schema is up to date.

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Review Middleware and Startup Configuration

In `Bookstore.Web`, review `Program.cs` (and `Startup.cs` if present) to confirm that middleware is registered correctly for cross-platform ASP.NET Core. Ensure the following are configured as needed:

- Authentication and authorization middleware
- Static file serving
- Routing
- Dependency injection registrations for services defined in `Bookstore.Domain` and `Bookstore.Data`

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is self-contained and correct.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required files are present before deploying to the target environment.