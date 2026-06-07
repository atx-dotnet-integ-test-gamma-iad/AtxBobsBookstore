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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific Dependencies

Even without build errors, some NuGet packages or APIs may be Windows-specific and will fail at runtime on non-Windows platforms. Review the dependencies in each `.csproj` for packages that:

- Reference `Microsoft.Win32.*`
- Use `System.Drawing.Common` (requires additional configuration on Linux/macOS)
- Depend on COM interop or Windows Registry access

Use the .NET Upgrade Assistant compatibility analyzer or the `dotnet-compatibility` tool to surface any runtime compatibility concerns.

```bash
dotnet tool install -g dotnet-compatibility
```

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to validate that core functionality is intact after migration.

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether they are caused by migration-related changes or pre-existing issues.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The EF Core provider package matches the target database (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql.EntityFrameworkCore.PostgreSQL`).
- Migrations are up to date. Run the following to check:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations are missing or outdated, add a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project locally and verify that the application loads and functions as expected.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following manually:

- Application starts without runtime exceptions
- All pages or API endpoints respond correctly
- Database read and write operations function as expected
- Authentication and authorization (if applicable) behave correctly

---

## 8. Review Configuration Files

Ensure that `appsettings.json` and `appsettings.{Environment}.json` contain all required configuration values that were previously stored in `Web.config` or `App.config`. Common items to verify:

- Connection strings
- Application-specific settings
- Logging configuration

Legacy `Web.config` transforms are not supported in .NET and must be replaced with the `appsettings.json` pattern or environment variables.

---

## 9. Verify Static Files and Bundling

If the web project previously used ASP.NET Bundling and Minification (`System.Web.Optimization`), confirm that it has been replaced with a supported alternative such as:

- `WebOptimizer`
- Manual bundling via a build tool (e.g., npm scripts)
- The built-in static file middleware in ASP.NET Core

---

## 10. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.