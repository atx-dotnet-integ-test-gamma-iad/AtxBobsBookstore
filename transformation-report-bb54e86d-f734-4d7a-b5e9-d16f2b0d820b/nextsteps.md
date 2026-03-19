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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting a build:

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

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting `net6.0` or `net7.0`, consider updating to `net8.0` as those versions are either end-of-life or approaching it.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, inspect the code and packages for any Windows-specific APIs, such as:

- `System.Web` references
- Windows Registry access
- COM interop
- `HttpContext` usage patterns specific to ASP.NET (non-Core)

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify remaining platform-specific calls.

---

## 5. Run Existing Tests

If the solution contains test projects, run them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release --logger trx
```

Review the `.trx` output files for any test failures. Pay particular attention to integration tests that may rely on a database connection or file system paths, as these may behave differently across platforms.

---

## 6. Validate the Data Layer (`Bookstore.Data`)

Since `Bookstore.Data` is the most independent project and likely contains database access logic, verify the following:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Any database migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply pending migrations to a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Validate the Web Layer (`Bookstore.Web`)

Run the web application locally and verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:

- Application starts without runtime exceptions.
- Configuration files (`appsettings.json`, `appsettings.Development.json`) are present and correctly structured.
- Any static files, Razor views, or Blazor components render as expected.
- Authentication and authorization middleware, if present, functions correctly.

---

## 8. Verify Configuration and Secrets

Legacy projects often used `Web.config` or `App.config` for configuration. Confirm that all settings have been migrated to `appsettings.json` or environment variables, and that no sensitive values (connection strings, API keys) are hardcoded or left in source control.

---

## 9. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory before deploying to a target environment.