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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents via NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Runtime Behavior

### 3.1 Check Configuration Files

- Confirm that `appsettings.json` (and `appsettings.Development.json`) are present in `Bookstore.Web` and contain the correct connection strings and application settings.
- Ensure any settings that were previously in `Web.config` or `App.config` have been properly migrated to the new configuration system.

### 3.2 Database Connectivity

If `Bookstore.Data` uses Entity Framework, verify the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Run any pending migrations or verify the database schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 4. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and exercise the primary workflows (browsing books, user authentication if applicable, etc.).
- Check the console output and application logs for any unhandled exceptions or missing middleware registrations.

---

## 5. Execute Unit and Integration Tests

If a test project exists in the solution, run the tests to validate core logic:

```bash
dotnet test
```

- Review test results for any failures that may indicate behavioral regressions introduced during migration.
- Pay particular attention to tests covering `Bookstore.Domain` logic and `Bookstore.Data` repository methods, as these layers are most likely to be affected by ORM or API changes.

---

## 6. Review Platform-Specific Code

Search the codebase for any APIs that were available in .NET Framework but may behave differently or require alternatives in cross-platform .NET:

- `System.Web` references — these are not available in cross-platform .NET and must be replaced with ASP.NET Core equivalents.
- `HttpContext`, `HttpRequest`, and `HttpResponse` usages — confirm they reference `Microsoft.AspNetCore.Http` types.
- Any use of `ConfigurationManager` — this should be replaced with `IConfiguration` from `Microsoft.Extensions.Configuration`.

---

## 7. Review Project Target Frameworks

Open each `.csproj` file and confirm the `TargetFramework` element is set to a supported cross-platform version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0-windows</TargetFramework>
```

Avoid `net8.0-windows` unless Windows-specific APIs are explicitly required, as it limits cross-platform portability.

---

## 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assets, static files, and configuration files are present before deploying to the target environment.