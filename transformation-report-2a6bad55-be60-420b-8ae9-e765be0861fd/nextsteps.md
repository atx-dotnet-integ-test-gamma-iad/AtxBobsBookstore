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

Perform a full solution build to confirm there are no issues beyond what was reported:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them now:

```bash
dotnet test --configuration Release --verbosity normal
```

- Confirm all previously passing tests still pass.
- If tests reference APIs or libraries that were changed during migration, update those references accordingly.
- Pay particular attention to any tests covering data access logic in `Bookstore.Data`, as database providers and connection string formats can differ between .NET Framework and modern .NET.

---

## 4. Verify Database Connectivity

Since the solution includes a `Bookstore.Data` project, verify that:

- The database connection strings in `appsettings.json` (or equivalent configuration) are correct for the target environment.
- Any Entity Framework migrations are up to date. Run the following if using EF Core:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the correct EF Core database provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).

---

## 5. Review Configuration Files

Modern .NET uses `appsettings.json` instead of `Web.config` or `App.config`. Confirm the following:

- All connection strings have been moved to `appsettings.json`.
- Any application settings previously in `<appSettings>` have been migrated to the appropriate configuration sections.
- Environment-specific overrides are handled via `appsettings.Development.json` or environment variables.

---

## 6. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and exercise the primary workflows (browsing, searching, and any data entry flows).
- Check the console output and application logs for runtime exceptions or deprecation warnings.
- Verify that static assets (CSS, JavaScript, images) are served correctly.

---

## 7. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If the projects are targeting different framework versions, align them to a single consistent version where possible.

---

## 8. Address Nullable Reference Type Warnings

If nullable reference types are enabled (`<Nullable>enable</Nullable>`), review any compiler warnings related to nullability across all three projects. These warnings do not prevent a build but can indicate potential runtime null reference exceptions.

---

## 9. Review Removed Windows-Specific Dependencies

Confirm that no remaining references exist to Windows-only APIs or libraries, such as:

- `System.Web`
- `Microsoft.Web.*` (legacy)
- Windows Registry access
- COM interop components

If any are found, replace them with cross-platform equivalents available in modern .NET.