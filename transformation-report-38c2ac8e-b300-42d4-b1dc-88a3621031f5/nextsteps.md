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

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas of the code that may behave differently under modern .NET.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully. Failures after a migration often point to behavioral differences between .NET Framework and modern .NET, such as changes in:

- `System.Web` dependencies that were replaced or removed
- Serialization behavior (e.g., `Newtonsoft.Json` vs `System.Text.Json`)
- Entity Framework version differences (e.g., EF6 vs EF Core)

---

## 4. Verify Database Connectivity and Migrations

Since the solution includes a `Bookstore.Data` project, confirm that the data layer is functioning correctly.

If using **Entity Framework Core**, check that migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

Apply any pending migrations to a test database:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If the project was migrated from **EF6 to EF Core**, review the following areas manually:
- Lazy loading configuration
- Navigation property behavior
- Any raw SQL queries using `Database.SqlQuery` or `DbSet.SqlQuery`, which have different APIs in EF Core

---

## 5. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Walk through the primary user flows in a browser, such as browsing books, authentication (if present), and any data entry forms. Pay attention to:

- Routing behavior, which may differ if the project moved from ASP.NET MVC to ASP.NET Core MVC
- Authentication and authorization middleware configuration in `Program.cs` or `Startup.cs`
- Static file serving, which requires explicit middleware in ASP.NET Core (`UseStaticFiles`)

---

## 6. Review Configuration Files

Ensure that `appsettings.json` contains all necessary configuration values that were previously held in `Web.config` or `App.config`. Key areas to check:

- Connection strings
- Application-specific settings
- Logging configuration

The `Web.config` transformation system is not used in ASP.NET Core. Environment-specific settings should instead use `appsettings.{Environment}.json` files or environment variables.

---

## 7. Check for Removed or Changed APIs

Review the codebase for any usage of APIs that are absent or altered in modern .NET. Common areas of concern after migrating a bookstore-style application include:

- `HttpContext.Current` — not available in ASP.NET Core; use dependency-injected `IHttpContextAccessor` instead
- `Session` access patterns — require explicit middleware registration in ASP.NET Core
- `System.Web.Mvc` namespaces — replaced by `Microsoft.AspNetCore.Mvc`

The [.NET Upgrade Assistant](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) and the [.NET Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/analyzer-overview) can assist in identifying remaining compatibility issues.

---

## 8. Deploy to a Target Environment

Once local validation is complete, publish the application for deployment:

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and deploy to the target host. Ensure the hosting environment has the appropriate .NET runtime installed. The required runtime version can be confirmed by inspecting the `<TargetFramework>` element in `Bookstore.Web.csproj`.