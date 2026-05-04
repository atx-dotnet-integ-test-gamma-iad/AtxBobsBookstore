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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or `netcoreapp3.1` or similar outdated monikers, update them accordingly.

---

## 4. Check for Removed or Changed APIs

Even without build errors, runtime issues can arise from APIs that changed behavior between .NET Framework and modern .NET. Pay particular attention to:

- `System.Web` usages — this namespace is not available in modern .NET. If `Bookstore.Web` previously relied on `System.Web`, confirm it has been replaced with ASP.NET Core equivalents.
- `HttpContext`, `HttpRequest`, and `HttpResponse` — ensure these are the ASP.NET Core versions.
- Configuration — confirm that `web.config`-based configuration has been replaced with `appsettings.json` and the `Microsoft.Extensions.Configuration` APIs.
- Entity Framework — if the project uses Entity Framework, confirm it has been migrated to Entity Framework Core and that migrations are up to date.

---

## 5. Run Unit Tests

If the solution contains a test project, run the tests to validate core logic.

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing basic tests for the domain and data layers to verify expected behavior before deploying.

---

## 6. Run the Application Locally

Start the web application locally to confirm it runs without runtime exceptions.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate through the application and exercise the primary workflows such as browsing, searching, and any data entry forms to confirm they function as expected.

---

## 7. Review Database Connectivity

If `Bookstore.Data` uses a database, verify the connection string in `appsettings.json` is correctly configured for the target environment.

If Entity Framework Core is in use, confirm that the database schema is in sync with the current model by running:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Review Middleware and Startup Configuration

In ASP.NET Core, application startup is handled through `Program.cs` and optionally `Startup.cs`. Confirm the middleware pipeline is configured correctly, including:

- Authentication and authorization middleware
- Static file serving
- Routing
- Exception handling

---

## 9. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before copying them to the target server.