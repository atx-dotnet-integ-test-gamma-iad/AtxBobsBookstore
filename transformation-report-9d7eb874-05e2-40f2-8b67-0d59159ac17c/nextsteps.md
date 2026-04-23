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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, consider updating them to versions that explicitly support the target .NET version.

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

Even without build errors, runtime failures can occur due to APIs that were removed or had behavioral changes between .NET Framework and modern .NET. Pay particular attention to:

- `System.Web` usages — this namespace is not available in modern .NET. Confirm all references have been replaced with ASP.NET Core equivalents.
- `HttpContext`, `HttpRequest`, and `HttpResponse` — verify these are using the `Microsoft.AspNetCore.Http` versions.
- `ConfigurationManager` — this should be replaced with `Microsoft.Extensions.Configuration`.
- Entity Framework — if the project uses EF6, confirm whether it has been migrated to EF Core, as EF6 has limited support on non-Windows platforms.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core logic:

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic tests for the domain and data layers to verify expected behavior after migration.

---

## 6. Run the Application Locally

Start the web application locally and verify it runs without runtime errors:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate through the application and exercise the main features, checking the console output and logs for any runtime exceptions or warnings.

---

## 7. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify that:

- The connection string in `appsettings.json` is correct for the target environment.
- Migrations are up to date by running:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Review `appsettings.json`

Confirm that configuration values previously stored in `Web.config` or `App.config` have been correctly moved to `appsettings.json` and that the application reads them using `IConfiguration`.

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and deploy it to the target server or hosting environment according to your infrastructure requirements.