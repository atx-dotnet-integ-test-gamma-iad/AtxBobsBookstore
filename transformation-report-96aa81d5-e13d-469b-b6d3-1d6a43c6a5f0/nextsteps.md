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

Run a NuGet package restore to confirm all dependencies resolve correctly against the new target framework.

```bash
dotnet restore
```

Review the output for any warnings about package compatibility or deprecated packages that may need to be updated.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate latent issues.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended modern .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target a consistent framework version to avoid runtime compatibility issues.

---

## 4. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that existed in .NET Framework but have been removed or changed in modern .NET. Common areas to check include:

- `System.Web` references (not available in modern .NET; should be replaced with ASP.NET Core equivalents)
- `HttpContext`, `HttpRequest`, and `HttpResponse` usages
- `ConfigurationManager` (replaced by `Microsoft.Extensions.Configuration`)
- `BinaryFormatter` (removed in .NET 9, deprecated in earlier versions)
- Any Windows-only APIs if cross-platform support is required

---

## 5. Review `Bookstore.Data` for Entity Framework Changes

If the project uses Entity Framework, confirm whether it has been migrated from Entity Framework 6 to Entity Framework Core. Key differences to validate:

- The `DbContext` configuration pattern has changed
- Lazy loading requires explicit configuration in EF Core
- Some LINQ query translations behave differently
- Connection string configuration should use `appsettings.json` rather than `App.config` or `Web.config`

Run any existing database migrations to confirm they apply cleanly:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Review `Bookstore.Web` Configuration

In ASP.NET Core, configuration is handled differently from ASP.NET (.NET Framework). Confirm the following:

- `Web.config` has been replaced by `appsettings.json` for application settings
- Middleware is configured in `Program.cs` or `Startup.cs`
- Authentication, authorization, and session configuration have been updated to use ASP.NET Core middleware
- Static files are served via `UseStaticFiles()` middleware

---

## 7. Run Unit Tests

If the solution contains test projects, run them to validate that existing functionality behaves as expected after the migration.

```bash
dotnet test
```

Review any failing tests to determine whether they indicate regressions introduced by the migration or tests that require updating due to API changes.

---

## 8. Manual Smoke Testing

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web
```

Test the following areas at a minimum:

- Application startup without errors
- Database connectivity and data retrieval
- Core user-facing pages and workflows
- Any authentication or authorization flows

---

## 9. Review Runtime Logs

After running the application, review the console output and any log files for runtime exceptions or warnings that did not surface during the build. Pay attention to:

- Unhandled exceptions
- Missing configuration values
- Middleware ordering issues
- Database query failures

---

## 10. Publish the Application

Once validation is complete, publish the application for deployment.

```bash
dotnet publish --configuration Release --output ./publish
```

Confirm the output directory contains all expected files, including the compiled assemblies, `appsettings.json`, and any static web assets.