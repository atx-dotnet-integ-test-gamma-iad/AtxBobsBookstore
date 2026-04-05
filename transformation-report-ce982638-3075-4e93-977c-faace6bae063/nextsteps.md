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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

For the web project, confirm it references `Microsoft.AspNetCore.App` or the appropriate ASP.NET Core framework reference rather than any legacy `System.Web` assemblies.

---

## 4. Check for Removed or Incompatible APIs

Search the codebase for any APIs that are not available in cross-platform .NET. Common problem areas when migrating from .NET Framework include:

- `System.Web` references (should be replaced with ASP.NET Core equivalents)
- `ConfigurationManager` (replace with `Microsoft.Extensions.Configuration`)
- `HttpContext.Current` (use dependency-injected `IHttpContextAccessor`)
- Windows-only APIs such as the registry or certain `System.Drawing` features

You can use the [.NET Upgrade Assistant](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify remaining issues.

---

## 5. Run Existing Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --logger "console;verbosity=normal"
```

Review any failing tests carefully. Failures may indicate behavioral differences between .NET Framework and modern .NET that require code adjustments.

---

## 6. Validate Data Layer

Since `Bookstore.Data` handles data access, verify the following:

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or another provider) is compatible with the target framework version.
- Any database migrations are up to date. Run the following if using Entity Framework Core:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply pending migrations to a development database before testing:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the web application and perform manual validation of core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Test the following areas at a minimum:

- Application startup with no unhandled exceptions
- Database connectivity and basic data retrieval
- Key user-facing pages and workflows
- Authentication and authorization flows, if applicable

---

## 8. Review Application Configuration

Confirm that `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) contain all configuration values that were previously held in `Web.config` or `App.config`. Pay particular attention to:

- Connection strings
- Application-specific settings
- Logging configuration

---

## 9. Address Runtime Warnings

Even with a clean build, runtime behavior can differ. Monitor the application logs during local testing for warnings or errors that indicate further adjustments are needed.