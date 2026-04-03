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

Run a NuGet package restore to ensure all dependencies are resolved correctly:

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

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider writing tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

Since `Bookstore.Data` is present, confirm that any Entity Framework Core (or other ORM) migrations are up to date and compatible with the target runtime:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations need to be applied to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Ensure the connection strings in `appsettings.json` or `appsettings.Development.json` are correctly configured for the target environment.

---

## 5. Run the Application Locally

Start the web application locally to confirm it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and verify that core functionality such as data retrieval, form submissions, and page rendering work as expected.

---

## 6. Review Configuration Files

Check the following configuration areas for any values that may still reference legacy .NET Framework-specific settings:

- `appsettings.json` — Confirm logging, connection strings, and any custom configuration sections are correct.
- `Program.cs` / `Startup.cs` — Verify middleware registration, dependency injection setup, and service configurations are aligned with the cross-platform .NET hosting model.
- Any remaining `web.config` or `app.config` files — These are generally not used in cross-platform .NET and their relevant settings should be migrated to `appsettings.json`.

---

## 7. Validate Target Framework

Confirm that all three projects are targeting the intended .NET version by inspecting each `.csproj` file:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web` to avoid inter-project compatibility issues.

---

## 8. Review Removed or Changed APIs

Cross-platform .NET does not support certain APIs that were available in .NET Framework. Review the following areas manually:

- Any usage of `System.Web` namespaces, which are not available in cross-platform .NET.
- `HttpContext` access patterns, which differ between .NET Framework and cross-platform .NET.
- Any Windows-specific APIs such as the registry, WCF server-side components, or `System.Drawing` (use `SkiaSharp` or `ImageSharp` as alternatives if needed).

The [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) can assist in identifying remaining incompatible API usages.

---

## 9. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assets, configuration files, and binaries are present.