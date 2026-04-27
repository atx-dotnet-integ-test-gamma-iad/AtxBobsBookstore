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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Verify the following:

- `appsettings.json` contains all necessary configuration values (connection strings, app settings, etc.) that were previously in `Web.config`.
- Environment-specific overrides are handled via `appsettings.{Environment}.json` (e.g., `appsettings.Development.json`).
- Any configuration transforms that existed in the legacy project have been manually replicated.

---

## 4. Verify Database Connectivity (Bookstore.Data)

If the project uses Entity Framework, confirm the following:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Migrations are present and up to date. Run the following to apply migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If no migrations exist and a code-first model is used, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

Navigate to the application in a browser and exercise the primary workflows (browsing books, user authentication if applicable, etc.) to identify any runtime issues that would not surface at compile time.

---

## 6. Check for Runtime Compatibility Issues

Some issues only appear at runtime after migration. Pay attention to the following areas:

- **File paths**: Ensure no hardcoded Windows-style paths (`C:\...`) exist in the codebase. Use `Path.Combine` and `Path.DirectorySeparatorChar` for cross-platform compatibility.
- **Authentication and Authorization**: If the project used `System.Web` membership or role providers, verify these have been replaced with ASP.NET Core Identity or an equivalent.
- **Session and State Management**: Confirm that any session-based logic has been migrated to the ASP.NET Core session middleware.
- **HTTP Context Access**: Usages of `HttpContext.Current` are not valid in ASP.NET Core. Verify these have been replaced with injected `IHttpContextAccessor`.

---

## 7. Execute Unit and Integration Tests

If a test project exists in the solution, run all tests to validate business logic and data access behavior.

```bash
dotnet test
```

Review any failing tests and determine whether the failures are due to migration issues or pre-existing problems.

---

## 8. Publish the Application

Once local validation is complete, publish the application to a target directory to prepare for deployment.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all expected static assets, views, and configuration files are present.