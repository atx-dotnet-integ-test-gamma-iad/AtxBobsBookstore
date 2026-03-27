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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If the projects are targeting `net6.0` or `net7.0`, consider upgrading to `net8.0` as those versions have reached or are approaching end-of-life.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, audit each project for APIs or packages that are Windows-only. Common areas to check include:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Authentication** in `Bookstore.Web`
- **System.Drawing** (not fully cross-platform; consider `SkiaSharp` or `ImageSharp` as alternatives)
- Any P/Invoke calls targeting Windows-specific native libraries

You can use the [.NET Upgrade Assistant](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify these issues.

---

## 5. Validate the Data Layer (`Bookstore.Data`)

If the project uses Entity Framework, confirm the version in use is Entity Framework Core and not the legacy `EntityFramework` (6.x) package, which does not support cross-platform .NET.

```bash
dotnet list package
```

If EF Core is in use, verify your database migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Confirm the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql.EntityFrameworkCore.PostgreSQL`) is compatible with the target framework version.

---

## 6. Run Unit and Integration Tests

If the solution contains test projects, run them to verify that business logic and data access behavior is preserved after migration.

```bash
dotnet test --configuration Release --verbosity normal
```

Pay close attention to any tests that fail due to behavioral differences between .NET Framework and modern .NET, such as:

- Changes in `HttpClient` behavior
- Differences in JSON serialization (`Newtonsoft.Json` vs `System.Text.Json`)
- Culture and encoding defaults

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Test the following areas at minimum:

- Application startup and routing
- Database connectivity and data retrieval
- Authentication and authorization flows
- Any file upload or static asset handling

Check the console output and application logs for runtime exceptions or deprecation warnings that did not surface at build time.

---

## 8. Review `web.config` and `appsettings.json`

In cross-platform .NET, `web.config` is largely replaced by `appsettings.json` and the `Program.cs` / `Startup.cs` configuration pipeline. Confirm that:

- Connection strings have been moved to `appsettings.json`
- Any `<appSettings>` keys from the old `web.config` have been migrated to `appsettings.json`
- Environment-specific configuration uses `appsettings.{Environment}.json` files

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.