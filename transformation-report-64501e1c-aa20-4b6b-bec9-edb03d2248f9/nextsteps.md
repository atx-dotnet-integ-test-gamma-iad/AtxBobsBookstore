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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET. Pay particular attention to:

- **`System.Web` references** — This namespace is not available in cross-platform .NET. Any remaining usage in `Bookstore.Web` should be replaced with ASP.NET Core equivalents.
- **`HttpContext`**, **`HttpRequest`**, and **`HttpResponse`** — Ensure these are sourced from `Microsoft.AspNetCore.Http` and not `System.Web`.
- **`ConfigurationManager`** — Replace with `Microsoft.Extensions.Configuration` and `appsettings.json`.
- **Entity Framework** — If the project uses Entity Framework 6, consider whether migration to Entity Framework Core is needed for full cross-platform support.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to verify that existing functionality behaves as expected after migration.

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they indicate a behavioral regression introduced by the migration.

---

## 6. Run the Application Locally

Start the web application locally to perform manual validation.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Verify the following:

- The application starts without runtime exceptions.
- Core pages and routes load correctly.
- Database connectivity functions as expected (check connection strings in `appsettings.json`).
- Any authentication or authorization flows work correctly.

---

## 7. Validate Configuration Files

Ensure that `appsettings.json` (and `appsettings.Production.json` if applicable) contains all necessary configuration values that were previously stored in `Web.config` or `App.config`. Common entries to verify include:

- Database connection strings
- Application-specific settings
- Logging configuration

---

## 8. Publish the Application

Once local validation is complete, publish the application to produce deployment artifacts.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.