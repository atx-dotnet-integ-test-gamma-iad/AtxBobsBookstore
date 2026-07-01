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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific Dependencies

Inspect `Bookstore.Data` and `Bookstore.Web` for any dependencies that are Windows-only, such as:

- `System.Web` references
- Windows Registry access
- COM interop
- `Microsoft.Web.Infrastructure`

These will not function on Linux or macOS and will require replacement or removal.

---

## 5. Database and Data Layer Validation

If `Bookstore.Data` uses Entity Framework, verify the following:

- The EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Any existing migrations are compatible with EF Core.
- Run a migration check:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit Tests

If a test project exists in the solution, execute the tests to verify core logic remains intact after migration.

```bash
dotnet test
```

Review test results for any failures that may indicate behavioral regressions introduced during the transformation.

---

## 7. Run the Web Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

Navigate to the application in a browser and manually verify the following:

- Pages load without HTTP 500 errors.
- Data is retrieved and displayed correctly from `Bookstore.Data`.
- Any forms or user interactions function as expected.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` contains all necessary configuration that may have previously existed in `Web.config` or `App.config`, including:

- Connection strings
- Logging configuration
- Application-specific settings

`Web.config` and `App.config` are not used in cross-platform .NET applications. All configuration should be migrated to `appsettings.json` or environment variables.

---

## 9. Validate Middleware and HTTP Pipeline

If `Bookstore.Web` was previously an ASP.NET MVC or Web Forms project, confirm that the middleware pipeline in `Program.cs` or `Startup.cs` is correctly configured for ASP.NET Core, including:

- Routing (`app.MapControllers()` or `app.MapDefaultControllerRoute()`)
- Static files (`app.UseStaticFiles()`)
- Authentication and authorization middleware, if applicable

---

## 10. Test on Target Platforms

If cross-platform support is a goal, run and validate the application on each intended target operating system (Windows, Linux, macOS) to surface any platform-specific runtime issues that would not appear during compilation.