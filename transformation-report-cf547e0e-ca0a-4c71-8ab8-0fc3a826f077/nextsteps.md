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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check [NuGet.org](https://www.nuget.org) for updated versions compatible with the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended modern .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid cross-targeting issues.

---

## 4. Check for Removed or Changed APIs

Some APIs available in .NET Framework are not present or have changed in modern .NET. Review the following areas manually:

- **`System.Web` dependencies** — these are not available in modern .NET. Ensure `Bookstore.Web` has been migrated to ASP.NET Core equivalents.
- **Configuration** — `System.Configuration.ConfigurationManager` usage should be replaced with `Microsoft.Extensions.Configuration`.
- **Entity Framework** — if the project uses EF6, consider whether migration to EF Core is needed or if the EF6 compatibility package is in use.

---

## 5. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, searching, any checkout or account features) to confirm they function as expected.

---

## 6. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework or another ORM, confirm the database connection string is correctly configured in `appsettings.json` (not `web.config`, which is a .NET Framework construct):

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=...;Database=...;..."
  }
}
```

Run any pending migrations if using EF Core:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 7. Execute Existing Tests

If the solution contains a test project, run the tests to validate business logic and data access behavior:

```bash
dotnet test
```

Review any failing tests and determine whether the failures are due to migration-related changes or pre-existing issues.

---

## 8. Review Middleware and Startup Configuration

In `Bookstore.Web`, confirm that the ASP.NET Core middleware pipeline is correctly configured in `Program.cs` or `Startup.cs`. Key areas to verify:

- Authentication and authorization middleware is registered in the correct order.
- Static files middleware is present if the application serves CSS, JS, or images.
- Routing is configured correctly for all expected endpoints.

---

## 9. Validate Logging Configuration

Ensure logging is configured through `Microsoft.Extensions.Logging` rather than any .NET Framework-specific logging libraries. Check `appsettings.json` for a `Logging` section:

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information"
    }
  }
}
```

---

## 10. Publish the Application

Once local validation is complete, publish the application to verify the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.