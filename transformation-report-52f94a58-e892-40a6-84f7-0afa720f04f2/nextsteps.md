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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them now:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider writing tests that cover:

- Domain model logic in `Bookstore.Domain`
- Data access operations in `Bookstore.Data`, including database queries and entity mappings
- Controller actions and middleware behavior in `Bookstore.Web`

---

## 4. Verify Database Connectivity and Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that your migrations are up to date and compatible with the new target framework:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

Apply the migrations to your database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually verify the following:

- Pages load without errors
- Data is retrieved and displayed correctly
- Any forms or write operations function as expected
- Authentication and authorization behave correctly if applicable

Review the console output and application logs for any runtime exceptions or warnings.

---

## 6. Review Configuration Files

Check `appsettings.json` and `appsettings.Production.json` in `Bookstore.Web` to confirm:

- Connection strings are correct for the target environment
- Any legacy `Web.config` or `App.config` values have been properly migrated to the new configuration system
- Environment-specific settings are separated appropriately using the `appsettings.{Environment}.json` pattern

---

## 7. Check for Removed or Changed APIs

Review the code for any use of APIs that were available in .NET Framework but have changed or been removed in cross-platform .NET. Common areas to check include:

- `System.Web` references, which are not available in cross-platform .NET
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core
- Any use of `ConfigurationManager`, which should be replaced with `IConfiguration`
- Windows-specific APIs that may not function on non-Windows platforms

---

## 8. Validate on Target Platform

If the intent is to run the application on Linux or macOS, test the application on that platform explicitly. File path casing, platform-specific APIs, and certain cryptographic behaviors can differ between Windows and non-Windows environments.