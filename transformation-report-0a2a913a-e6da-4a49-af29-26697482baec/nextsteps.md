# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

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

Ensure the build completes with zero errors and review any warnings that may indicate deprecated APIs or framework compatibility concerns.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release --verbosity normal
```

Review the test results carefully. Any failing tests should be investigated, as they may indicate behavioral differences introduced during the migration from .NET Framework to cross-platform .NET.

---

## 4. Verify Entity Framework or Data Layer Behavior

Since the solution includes a `Bookstore.Data` project, verify the data layer functions correctly:

- Confirm the correct database provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Sqlite`, etc.).
- If the project uses Entity Framework migrations, verify existing migrations are still valid by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If the schema needs to be updated or re-applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Validate Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following areas specifically:

- Application startup and routing
- Database connectivity and data retrieval
- Any authentication or session-based functionality, as these areas can behave differently on cross-platform .NET
- Static file serving and view rendering if Razor views are used

---

## 6. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) to confirm:

- Connection strings are correct for the target environment
- Any configuration keys previously stored in `Web.config` have been properly migrated to `appsettings.json`
- Environment variables or secrets are handled appropriately using `IConfiguration`

---

## 7. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that were removed or significantly changed in cross-platform .NET. Common areas to check include:

- `System.Web` references, which are not available outside of ASP.NET on .NET Framework
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core
- Any use of `ConfigurationManager`, which should be replaced with `IConfiguration`

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) if further API compatibility analysis is needed.

---

## 8. Target Framework Verification

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported version of .NET.