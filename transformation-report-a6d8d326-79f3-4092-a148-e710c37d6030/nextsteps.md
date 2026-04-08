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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check their respective NuGet pages for recommended replacements that target the current .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or unexpected warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element references the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure consistency across all three projects so there are no version mismatches between dependencies.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs that existed in .NET Framework may behave differently or have been replaced in cross-platform .NET. Areas to review include:

- **`Bookstore.Data`**: If Entity Framework is used, confirm the project is using EF Core rather than EF 6. Verify that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is present and configured correctly in the `DbContext`.
- **`Bookstore.Web`**: If this was previously an ASP.NET Web Forms or ASP.NET MVC (.NET Framework) project, confirm that it has been migrated to ASP.NET Core. Check `Program.cs` and `Startup.cs` (or the combined `Program.cs` in .NET 6+) for correct middleware and service registration.
- **Configuration**: Confirm that any usage of `System.Configuration.ConfigurationManager` has been replaced with `Microsoft.Extensions.Configuration` and that `appsettings.json` is present and correctly structured.
- **`HttpContext`**: Verify that any access to `HttpContext` uses the ASP.NET Core approach via dependency injection (`IHttpContextAccessor`) rather than the static `HttpContext.Current`.

---

## 5. Run the Application Locally

Start the web application locally to verify runtime behavior.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the URL printed in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and manually verify core functionality such as:

- Application startup without exceptions
- Database connectivity (if applicable)
- Core page rendering and navigation

---

## 6. Check Application Logs

Review the console output and any configured log sinks for runtime exceptions or warnings that would not surface as build errors. Pay particular attention to:

- Database migration or connection errors
- Missing configuration values
- Middleware ordering issues in the request pipeline

---

## 7. Run Existing Tests

If the solution contains test projects, execute them to validate that existing behavior has been preserved.

```bash
dotnet test
```

Review any failing tests to determine whether they indicate a genuine regression or a test that requires updating due to API changes in cross-platform .NET.

---

## 8. Validate the Database Layer

If the application uses Entity Framework Core, apply or verify any pending migrations against a development database.

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Confirm that the schema is created correctly and that basic CRUD operations function as expected.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct before deploying to a target environment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all required files, static assets, and configuration files are present.