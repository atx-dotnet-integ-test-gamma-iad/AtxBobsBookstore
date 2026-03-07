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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET across all projects, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Mixing target frameworks (e.g., `net6.0` in one project and `net8.0` in another) can cause compatibility issues at runtime.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect the codebase for any APIs or libraries that are Windows-only. Common areas to check include:

- `System.Web` references (not available in .NET Core/5+)
- Windows Registry access (`Microsoft.Win32.Registry`)
- COM interop or P/Invoke calls targeting Windows DLLs
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify platform-specific code paths.

---

## 5. Validate the Data Layer (`Bookstore.Data`)

If the project uses Entity Framework, confirm the following:

- The project references `Microsoft.EntityFrameworkCore` and the appropriate database provider (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Any existing migrations are compatible with EF Core. Legacy EF6 migrations are **not** compatible with EF Core and will need to be regenerated.

To verify the database context and migrations:

```bash
dotnet ef dbcontext info --project Bookstore.Data
dotnet ef migrations list --project Bookstore.Data
```

If migrations need to be recreated:

```bash
dotnet ef migrations add InitialCreate --project Bookstore.Data
dotnet ef database update --project Bookstore.Data
```

---

## 6. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

Navigate to the application in a browser and exercise the primary user flows, such as browsing books, searching, and any authentication flows if present. Check the console output and application logs for exceptions or warnings.

---

## 7. Execute Existing Tests

If the solution contains a test project, run all tests to confirm existing functionality has not regressed.

```bash
dotnet test
```

Review the test results for any failures. Pay particular attention to tests that interact with the database or external services, as connection strings and configuration sources may have changed (e.g., from `Web.config` to `appsettings.json`).

---

## 8. Validate Configuration Migration

In .NET, configuration is handled through `appsettings.json` rather than `Web.config` or `App.config`. Confirm the following:

- Connection strings previously in `Web.config` have been moved to `appsettings.json`.
- Any application settings (e.g., API keys, feature flags) have been transferred.
- Environment-specific overrides are handled using `appsettings.Development.json` or environment variables.

Example `appsettings.json` structure:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=...;Database=Bookstore;..."
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information"
    }
  }
}
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.