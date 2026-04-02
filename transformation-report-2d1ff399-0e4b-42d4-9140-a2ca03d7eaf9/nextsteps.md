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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

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
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is still targeting `net48` or another legacy framework, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect each project for any remaining Windows-specific APIs or packages. Common areas to check include:

- `System.Web` references (should be replaced with `Microsoft.AspNetCore.*`)
- Windows Registry access
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core
- Any P/Invoke calls targeting Windows-only libraries

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package to identify remaining platform-specific code.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any test failures carefully. Failures may indicate behavioral differences between .NET Framework and modern .NET, particularly around:

- Serialization (`System.Text.Json` vs `Newtonsoft.Json`)
- Entity Framework Core vs Entity Framework 6 query behavior
- Middleware and request pipeline differences in ASP.NET Core

---

## 6. Validate the Data Layer (`Bookstore.Data`)

If the project uses Entity Framework, confirm the following:

- The project references `Microsoft.EntityFrameworkCore` and the appropriate database provider (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Any existing migrations are compatible with EF Core. Legacy EF6 migrations are **not** compatible and will need to be regenerated.

To regenerate migrations if needed:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the web application and manually verify core functionality.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following at runtime:

- Application starts without exceptions
- Routing behaves as expected
- Database connectivity is functional
- Authentication and authorization (if present) work correctly
- Static files are served properly

Review the application logs for any runtime errors or deprecation warnings.

---

## 8. Validate Configuration

ASP.NET Core uses `appsettings.json` rather than `web.config` for most configuration. Confirm that:

- Connection strings have been moved to `appsettings.json` or environment variables
- Any `web.config` transforms have been replicated in the new configuration system
- Sensitive values are not hardcoded and are instead managed via `appsettings.json`, environment variables, or a secrets manager

---

## 9. Publish the Application

Once local validation is complete, publish the application to verify the output is correct.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all expected files are present, including static assets and configuration files.