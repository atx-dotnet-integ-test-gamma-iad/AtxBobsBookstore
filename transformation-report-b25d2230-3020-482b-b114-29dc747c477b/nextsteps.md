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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is still targeting `net48` or another legacy framework, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Windows-Specific Dependencies

Inspect `Bookstore.Data` and `Bookstore.Web` for any dependencies that are Windows-only, such as:

- `System.Web` references
- Windows Registry access
- COM interop
- MSMQ or WCF components

These will not function on non-Windows platforms and will require replacement or conditional compilation guards if cross-platform support is required.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after migration.

```bash
dotnet test --configuration Release
```

Review any failing tests carefully. Failures may indicate behavioral differences between .NET Framework and modern .NET, particularly around:

- Globalization and encoding defaults
- `HttpContext` and web-related abstractions
- Entity Framework query translation (if applicable)

---

## 6. Validate the Data Layer

Since `Bookstore.Data` handles data access, verify the following:

- **Database provider packages** are updated. For example, if using Entity Framework, confirm `Microsoft.EntityFrameworkCore` and the appropriate provider (e.g., `Npgsql`, `Microsoft.EntityFrameworkCore.SqlServer`) are referenced.
- **Migrations** are up to date. Run the following if using EF Core:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- **Connection strings** in `appsettings.json` are correctly configured for the target environment.

---

## 7. Validate the Web Layer

For `Bookstore.Web`, confirm the following:

- The project uses `Microsoft.AspNetCore.*` packages rather than `System.Web`.
- `Program.cs` and `Startup.cs` (or the combined `Program.cs` in minimal hosting model) are correctly structured for ASP.NET Core.
- Static files, routing, and middleware are configured properly.

Run the application locally to perform a basic smoke test:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the application in a browser and verify that core pages and functionality load without errors.

---

## 8. Review Configuration Files

Ensure the following configuration concerns are addressed:

- `web.config` is no longer the primary configuration source. Settings should be migrated to `appsettings.json`.
- Environment-specific configuration files (e.g., `appsettings.Development.json`) are in place.
- Any `<appSettings>` or `<connectionStrings>` entries from the old `web.config` have been moved appropriately.

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present, including static assets and configuration files.