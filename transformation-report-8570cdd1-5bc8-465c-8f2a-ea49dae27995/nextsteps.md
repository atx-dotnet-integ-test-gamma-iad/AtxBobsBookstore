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

Perform a full solution build to confirm there are no compile-time issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET across all projects (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

Mixing target frameworks between projects can cause runtime compatibility issues even when the build succeeds.

---

## 4. Run Unit Tests

If the solution contains test projects, execute them to validate that the core logic has not been broken during migration.

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether failures are due to migration-related changes or pre-existing issues.

---

## 5. Validate Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` likely contains data access logic, verify the following:

- Connection strings in `appsettings.json` or `appsettings.Development.json` are correctly configured for the target environment.
- If Entity Framework Core is used, confirm that migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application locally to perform manual validation.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that:

- Pages load without errors.
- Data is read from and written to the database correctly.
- Any authentication or authorization flows behave as expected.

---

## 7. Check for Removed or Changed APIs

Cross-platform .NET removes certain APIs that were available in .NET Framework. Review the following areas manually:

- Any usage of `System.Web` namespaces, which are not available in cross-platform .NET.
- `HttpContext` usage outside of the request pipeline.
- Any Windows-specific APIs such as the registry, WCF, or `System.Drawing` (unless the appropriate NuGet compatibility packages have been added).

The [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) can assist in identifying remaining compatibility concerns.

---

## 8. Review Configuration Migration

Confirm that configuration previously handled by `Web.config` has been correctly moved to `appsettings.json`. Key areas to check include:

- Connection strings
- Application settings
- Custom error pages
- HTTP handlers or modules (these must be replaced with ASP.NET Core middleware)

---

## 9. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets and configuration files.