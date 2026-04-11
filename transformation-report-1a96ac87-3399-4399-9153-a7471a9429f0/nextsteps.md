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

The following steps outline how to validate, test, and deploy the migrated solution.

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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET (e.g., `net8.0`). Mixing framework versions across projects can cause runtime issues even when the build succeeds.

Example of what to look for:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET. Pay particular attention to:

- **`Bookstore.Data`**: If Entity Framework is used, confirm the EF Core version is compatible and that any database provider packages (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) are updated.
- **`Bookstore.Web`**: If this was previously an ASP.NET MVC or Web Forms project, confirm the middleware pipeline in `Program.cs` or `Startup.cs` is correctly configured for ASP.NET Core.
- **`Bookstore.Domain`**: Verify that any serialization, reflection, or threading APIs still behave as expected under the new runtime.

---

## 5. Run Unit Tests

If the solution contains a test project, run all tests to validate business logic and data access behavior.

```bash
dotnet test
```

If no test project currently exists, consider adding one targeting `Bookstore.Domain` and `Bookstore.Data` to establish a baseline before making further changes.

---

## 6. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify that:

- The connection string in `appsettings.json` is correct for the target environment.
- Migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

If migrations do not exist yet, review whether the schema needs to be created or if an existing database is being targeted.

---

## 7. Run the Application Locally

Start the web application locally to confirm it runs end-to-end.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and verify that core functionality such as page rendering, data retrieval, and form submissions work as expected.

---

## 8. Review `appsettings.json` and Configuration

Modern .NET uses `appsettings.json` and environment-based configuration rather than `Web.config` or `App.config`. Confirm that:

- All connection strings and application settings have been moved to `appsettings.json`.
- Any environment-specific settings are placed in `appsettings.Development.json` or `appsettings.Production.json`.
- Sensitive values are not hardcoded and are instead read from environment variables or a secrets manager.

---

## 9. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, including static assets and configuration files, are present.