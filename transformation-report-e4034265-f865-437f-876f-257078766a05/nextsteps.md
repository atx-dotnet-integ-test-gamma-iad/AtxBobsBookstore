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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Runtime Configuration

Check the following configuration files for correctness in the context of cross-platform .NET:

- **`appsettings.json`** – Ensure connection strings and environment-specific settings are correct. The old `Web.config` or `App.config` values should have been migrated here.
- **`Program.cs` / `Startup.cs`** – Confirm that middleware, services, and the request pipeline are configured as expected for ASP.NET Core.
- **Entity Framework configuration** – If `Bookstore.Data` uses Entity Framework, verify that the correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) and that migrations are up to date.

---

## 4. Run Database Migrations

If Entity Framework Core is used in `Bookstore.Data`, verify that existing migrations are compatible and apply them to your target database:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations were not carried over from the legacy project, create an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run Existing Tests

If the solution contains a test project, execute the tests to validate core functionality:

```bash
dotnet test
```

Review any failing tests. Failures may indicate behavioral differences between .NET Framework and cross-platform .NET, particularly around:

- Globalization and culture handling
- File path separators
- Reflection behavior
- HTTP client usage

---

## 6. Manual Smoke Testing

Run the web application locally and manually verify critical functionality:

```bash
dotnet run --project Bookstore.Web
```

Test the following areas at a minimum:

- Application startup with no unhandled exceptions
- Database connectivity and data retrieval
- Core user-facing pages and workflows (e.g., browsing, searching, and purchasing books)
- Authentication and authorization flows, if applicable

---

## 7. Review Removed or Changed APIs

Cross-platform .NET does not support certain .NET Framework APIs. Review the code in all three projects for usage of the following, which are commonly problematic after migration:

- `System.Web` namespaces – These are not available in ASP.NET Core.
- `HttpContext.Current` – Replace with injected `IHttpContextAccessor`.
- `ConfigurationManager` – Replace with `IConfiguration` from `Microsoft.Extensions.Configuration`.
- Binary serialization (`BinaryFormatter`) – This is disabled by default and should be replaced with a supported serialization approach.

---

## 8. Target Framework Verification

Open each `.csproj` file and confirm the `TargetFramework` element is set to the intended version:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid compatibility issues between them.