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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure no project is still referencing `net48` or any other .NET Framework moniker unless intentional.

---

## 4. Check for Removed or Changed APIs

Some APIs available in .NET Framework are not present or have changed in cross-platform .NET. Review the following areas manually:

- **`System.Web` usage**: This namespace is not available in cross-platform .NET. Any references to it in `Bookstore.Web` or elsewhere must be replaced with ASP.NET Core equivalents.
- **`HttpContext`, `HttpRequest`, `HttpResponse`**: Ensure these are sourced from `Microsoft.AspNetCore.Http` rather than `System.Web`.
- **`ConfigurationManager`**: Replace with `Microsoft.Extensions.Configuration` if still in use.
- **`EntityFramework` (v6)**: If the project used EF6, confirm it has been migrated to EF Core and that all `DbContext` configurations, migrations, and queries are compatible.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to validate core functionality.

```bash
dotnet test --configuration Release
```

Review test results and address any failures that may indicate behavioral differences between .NET Framework and cross-platform .NET.

---

## 6. Verify Database Migrations (if applicable)

If `Bookstore.Data` uses Entity Framework Core with migrations, verify the migration state is consistent.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration and apply it to a development database.

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows (browsing books, data retrieval, etc.) to confirm end-to-end functionality.

---

## 8. Review `appsettings.json` Configuration

Confirm that all configuration previously stored in `Web.config` or `App.config` has been correctly migrated to `appsettings.json` or `appsettings.{Environment}.json`. Pay particular attention to:

- Connection strings
- Application-specific settings
- Logging configuration

---

## 9. Validate Cross-Platform Behavior (Optional but Recommended)

If cross-platform support is a goal, run the application on a non-Windows operating system (Linux or macOS) to identify any platform-specific issues such as:

- File path separators (`\` vs `/`)
- Case-sensitive file references
- Windows-only libraries or P/Invoke calls