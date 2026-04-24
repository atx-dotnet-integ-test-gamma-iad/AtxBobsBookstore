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

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents via NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended modern .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

For the web project, confirm it uses:

```xml
<TargetFramework>net8.0</TargetFramework>
```

---

## 4. Validate the Data Layer

Since `Bookstore.Data` depends on `Bookstore.Domain`, verify the following:

- Entity Framework (or whichever ORM is in use) is referencing a compatible .NET package, such as `Microsoft.EntityFrameworkCore` instead of the legacy `EntityFramework` package.
- Any database migrations are up to date. Run the following if using EF Core:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, add a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate that business logic and data access behavior remain correct after migration:

```bash
dotnet test --configuration Release
```

Review the test results for any failures that may indicate behavioral differences between the legacy .NET Framework and the new .NET runtime.

---

## 6. Run the Application Locally

Start the web application locally to verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Confirm the following:
- The application starts without runtime exceptions.
- All pages and routes load correctly.
- Database connectivity is functioning.
- Any authentication or session handling works as expected.

---

## 7. Check for Runtime-Only Issues

Some issues do not surface at compile time. Manually test the following areas:

- **Configuration**: Ensure `appsettings.json` is properly structured and replaces any legacy `Web.config` or `App.config` values.
- **Connection Strings**: Verify connection strings are correctly defined in `appsettings.json` and are being read by the application.
- **Static Files**: Confirm that CSS, JavaScript, and image assets are served correctly.
- **Dependency Injection**: Verify all services are registered in `Program.cs` or `Startup.cs` and resolve without errors at runtime.

---

## 8. Review Removed or Changed APIs

Cross-reference any usages of APIs that were removed or significantly changed between .NET Framework and modern .NET. Key areas to check include:

- `System.Web` references, which are not available in modern .NET and should be replaced with ASP.NET Core equivalents.
- `HttpContext` usage patterns.
- Any use of `BinaryFormatter`, which is disabled by default in .NET 5+.

The [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) can assist in identifying remaining compatibility concerns.