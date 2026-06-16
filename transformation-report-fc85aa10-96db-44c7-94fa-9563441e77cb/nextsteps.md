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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, as some warnings may indicate runtime issues that do not surface at compile time.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to an appropriate and supported version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Avoid targeting `net6.0` or `net7.0` as these are out of support. Prefer `net8.0` or later.

---

## 4. Check for Windows-Specific APIs

Even without build errors, some APIs that compiled successfully may be Windows-only at runtime. Search the codebase for usages of the following and verify cross-platform compatibility:

- `System.Web` namespaces
- `Microsoft.Win32` registry access
- Windows file path assumptions (e.g., backslashes)
- `HttpContext` usage outside of ASP.NET Core's dependency injection model

Use the [.NET Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to assist with this.

---

## 5. Database and Data Layer Validation

If `Bookstore.Data` uses Entity Framework, verify the following:

- Confirm the project references `Microsoft.EntityFrameworkCore` and the appropriate database provider (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- If the project previously used Entity Framework 6 (EF6), ensure it has been migrated to EF Core, as EF6 does not fully support cross-platform .NET.
- Run any pending migrations to confirm they apply cleanly:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Verify the connection string in `appsettings.json` is correct for your target environment.

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime exceptions:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing books, managing inventory, or any other core features, to confirm expected behavior.

---

## 7. Run Existing Tests

If the solution contains test projects, execute them to validate that existing functionality has not regressed:

```bash
dotnet test
```

Review the test output for any failures. Pay particular attention to integration tests that interact with the database or file system, as these are most likely to surface cross-platform issues.

---

## 8. Review Configuration

Legacy .NET Framework projects used `Web.config` and `App.config` for configuration. Cross-platform .NET uses `appsettings.json`. Confirm the following:

- All connection strings have been moved to `appsettings.json`.
- Any `<appSettings>` or `<connectionStrings>` entries from `Web.config` have been migrated.
- Environment-specific settings use `appsettings.{Environment}.json` where appropriate.

---

## 9. Validate Static Files and Middleware

If `Bookstore.Web` is an ASP.NET Core application, confirm the middleware pipeline in `Program.cs` or `Startup.cs` is correctly configured:

- `app.UseStaticFiles()` is present if the application serves static assets.
- Authentication and authorization middleware are registered in the correct order.
- Any custom HTTP modules or handlers from the legacy project have been converted to ASP.NET Core middleware.