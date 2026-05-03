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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a currently supported version of .NET (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If an older or end-of-life version is present (e.g., `net6.0`), consider updating to a long-term support (LTS) release.

---

## 4. Verify Entity Framework Core Configuration

Since this is a data-driven bookstore application, confirm that `Bookstore.Data` is using **Entity Framework Core** rather than the legacy `System.Data.Entity` (EF6).

- Check that `Microsoft.EntityFrameworkCore` and the appropriate database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) are referenced.
- Confirm that `DbContext` and `DbSet<T>` usages compile and behave as expected.
- Run any pending migrations or verify the schema is up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Check for Windows-Specific APIs

Cross-platform .NET does not support certain Windows-only APIs (e.g., `System.Web`, `HttpContext` from the old ASP.NET pipeline, registry access). Search the codebase for any remaining references:

```bash
grep -r "System.Web" .
grep -r "Microsoft.Win32" .
```

Replace or remove any identified usages with cross-platform alternatives.

---

## 6. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and exercise the primary workflows (browsing books, managing inventory, etc.).
- Check the console output and application logs for any runtime exceptions or unhandled errors.

---

## 7. Execute Unit and Integration Tests

If a test project exists in the solution, run all tests to validate that business logic and data access behavior are intact after migration.

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests and determine whether they indicate a regression introduced during migration or a test that requires updating to reflect new API behavior.

---

## 8. Validate Configuration Files

Ensure that `appsettings.json` (and environment-specific variants such as `appsettings.Production.json`) contain the correct values, particularly:

- **Connection strings** — confirm they point to the correct database and use a format compatible with the new provider.
- **Logging configuration** — verify log levels are set appropriately.
- **Any secrets** — confirm sensitive values are not hardcoded and are instead managed via environment variables or the .NET Secret Manager.

---

## 9. Publish the Application

Once the application has been validated locally, publish it to a self-contained or framework-dependent deployment package.

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj \
  --configuration Release \
  --output ./publish
```

Review the contents of the `./publish` directory and deploy them to the target hosting environment (e.g., IIS, Azure App Service, or a Linux server with the .NET runtime installed).