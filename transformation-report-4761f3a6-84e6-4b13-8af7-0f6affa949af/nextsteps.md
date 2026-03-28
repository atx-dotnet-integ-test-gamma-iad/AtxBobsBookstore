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

The steps below describe how to validate, test, and deploy the migrated solution.

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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the transformation.

---

## 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review the test output for any failures. If tests were previously written against .NET Framework-specific behavior (e.g., `HttpContext`, `ConfigurationManager`), they may require updates to work correctly under cross-platform .NET.

---

## 4. Verify Data Layer (`Bookstore.Data`)

- Confirm that the database provider configured in `Bookstore.Data` is compatible with cross-platform .NET. For example, if Entity Framework is used, ensure it has been migrated from `EntityFramework` (EF6) to `Microsoft.EntityFrameworkCore`.
- If EF Core is now in use, verify that any pending migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to a local or development database to confirm schema compatibility:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Verify Domain Layer (`Bookstore.Domain`)

- Review domain models and business logic for any reliance on types or namespaces that were specific to .NET Framework, such as `System.Web` or `System.Runtime.Remoting`.
- Confirm that all referenced assemblies resolve correctly under the target .NET version.

---

## 6. Verify Web Layer (`Bookstore.Web`)

- If the project was migrated from ASP.NET (System.Web) to ASP.NET Core, confirm the following:
  - `Program.cs` and `Startup.cs` (or the combined minimal hosting model) are correctly configured.
  - Middleware, routing, and dependency injection are set up appropriately.
  - Authentication and authorization configurations have been updated to use ASP.NET Core equivalents.
  - Any `Web.config` settings have been moved to `appsettings.json` or environment variables.
- Run the web application locally:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that core pages and functionality load as expected.

---

## 7. Cross-Platform Validation

Since the goal of this transformation is cross-platform compatibility, test the application on a non-Windows operating system (Linux or macOS) if possible:

- File path handling should use `Path.Combine` rather than hardcoded backslashes.
- Any use of the Windows registry or Windows-specific APIs should be identified and replaced.
- Confirm that the database connection strings do not rely on Windows Authentication if the target deployment environment is Linux-based.

---

## 8. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If the project is targeting `net8.0` or later, consider enabling nullable reference types and addressing any resulting warnings:

```xml
<Nullable>enable</Nullable>
```

---

## 9. Review Deprecated or Removed APIs

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.ApiCompat` tooling to identify any remaining usage of APIs that are unavailable or behave differently in cross-platform .NET:

```bash
dotnet tool install -g dotnet-apicompat
```

Address any flagged incompatibilities before proceeding to production deployment.