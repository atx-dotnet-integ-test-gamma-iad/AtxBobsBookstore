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

Some APIs available in .NET Framework are not present or have changed in cross-platform .NET. Review the following areas manually:

- **`System.Web` usage**: This namespace is not available in cross-platform .NET. If any code references it, those areas will need to be rewritten using ASP.NET Core equivalents.
- **`HttpContext`**: Ensure it is accessed via dependency injection rather than `HttpContext.Current`.
- **Configuration**: Verify that `Web.config` or `App.config` based configuration has been migrated to `appsettings.json` and the `IConfiguration` pattern.
- **Entity Framework**: If the project uses Entity Framework, confirm it has been updated to Entity Framework Core and that migrations are compatible.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core logic.

```bash
dotnet test
```

If no test project exists, consider manually verifying key domain and data layer operations by running the application and exercising primary workflows.

---

## 6. Run the Application Locally

Start the web application locally to confirm it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following at runtime:

- The application starts without exceptions.
- Database connectivity functions correctly (if applicable).
- Key pages and routes load as expected.
- Static files (CSS, JavaScript, images) are served correctly.

---

## 7. Verify Database Migrations

If the project uses Entity Framework Core, confirm that the database schema is up to date.

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations do not exist yet, generate an initial migration from the current model:

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Review Middleware and Startup Configuration

In ASP.NET Core, application configuration is handled in `Program.cs` (and optionally `Startup.cs` in older templates). Confirm the following are configured correctly:

- Authentication and authorization middleware.
- Routing configuration.
- Static file middleware.
- Any custom HTTP modules or handlers from the original project have been converted to ASP.NET Core middleware.

---

## 9. Test on Target Operating System

Since the goal of the migration is cross-platform compatibility, run the application on the intended non-Windows operating system (e.g., Linux or macOS) if applicable, and verify behavior is consistent with the Windows environment.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Pay attention to:

- **File path casing**: Linux file systems are case-sensitive.
- **Path separators**: Use `Path.Combine` rather than hardcoded backslashes.
- **Windows-specific APIs**: Confirm none are in use.