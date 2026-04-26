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

The steps below describe how to validate, test, and deploy the migrated solution.

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

If any project is still targeting `net48` or `netstandard2.0`, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project, inspect the code and project files for any remaining Windows-specific dependencies, such as:

- `Microsoft.Web.Infrastructure`
- `System.Web.*` namespaces
- Windows Registry access
- COM interop references

These will not function on Linux or macOS and will need to be replaced with cross-platform alternatives.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after migration.

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may indicate behavioral differences between .NET Framework and modern .NET, particularly around:

- Globalization and culture handling
- Reflection behavior
- JSON serialization defaults
- Entity Framework query translation (if applicable)

---

## 6. Validate the Data Layer (`Bookstore.Data`)

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The project references `Microsoft.EntityFrameworkCore` and the appropriate database provider (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Any existing migrations are compatible with EF Core. Legacy EF 6 migrations are **not** compatible with EF Core and will need to be regenerated.

To scaffold a new initial migration if needed:

```bash
dotnet ef migrations add InitialCreate --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Validate the Web Layer (`Bookstore.Web`)

If `Bookstore.Web` was originally an ASP.NET MVC or Web Forms project, confirm the following:

- Web Forms (`*.aspx`) are **not supported** in modern .NET. These pages must be rewritten as Razor Pages or MVC controllers and views.
- `Global.asax` startup logic should be migrated to `Program.cs` and `Startup.cs` (or the minimal hosting model in .NET 6+).
- `Web.config` settings such as connection strings and app settings should be migrated to `appsettings.json`.

Run the web application locally to confirm it starts without errors:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the application in a browser and verify core pages and functionality load correctly.

---

## 8. Test Against the Target Database

Run the application against a real or staging database instance to validate:

- Connection strings in `appsettings.json` are correct.
- Database schema matches the current model.
- CRUD operations function as expected.

---

## 9. Review Logging and Configuration

Ensure that logging is configured using `Microsoft.Extensions.Logging` and that any legacy logging frameworks (e.g., `log4net`, `NLog` configured via `Web.config`) have been updated to use their .NET-compatible configurations or replaced with `Serilog` or the built-in logging abstractions.

---

## 10. Publish the Application

Once all validation steps pass, publish the application to confirm the output is complete and self-contained.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the output directory to ensure all required assets, views, and static files are present before deploying to the target environment.