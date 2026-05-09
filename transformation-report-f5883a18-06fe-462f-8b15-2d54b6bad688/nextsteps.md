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

- **`System.Web` usage**: This namespace is not available in cross-platform .NET. If any references remain, they will need to be replaced with ASP.NET Core equivalents.
- **`HttpContext`**, **`HttpRequest`**, **`HttpResponse`**: Ensure these are sourced from `Microsoft.AspNetCore.Http` and not `System.Web`.
- **Configuration**: Confirm that `Web.config` has been replaced with `appsettings.json` and that configuration is wired up via `IConfiguration`.
- **Entity Framework**: If `Bookstore.Data` uses Entity Framework, confirm it has been migrated to Entity Framework Core and that the correct provider package is referenced.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core logic.

```bash
dotnet test
```

If no test project exists, consider writing basic tests for the domain and data layers to verify expected behavior before deploying.

---

## 6. Run the Application Locally

Start the web application locally and verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following at runtime:

- The application starts without exceptions.
- Database connections in `Bookstore.Data` are established correctly.
- Key pages and routes in `Bookstore.Web` load as expected.
- Any middleware configured in `Program.cs` or `Startup.cs` is functioning correctly.

---

## 7. Validate Database Connectivity and Migrations

If Entity Framework Core is used in `Bookstore.Data`, verify that migrations are up to date and the database schema is correct.

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Review Logging and Error Handling

Confirm that logging is configured using `Microsoft.Extensions.Logging` or a compatible provider (e.g., Serilog, NLog). Legacy logging mechanisms from .NET Framework will not function in cross-platform .NET.

---

## 9. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including `appsettings.json` and any static assets.