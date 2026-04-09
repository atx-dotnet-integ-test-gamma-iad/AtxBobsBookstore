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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting a build:

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages reference `net4x` or `netstandard1.x` targets exclusively, consider finding newer alternatives that support `net6.0` or later.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects compile without warnings or errors. Pay particular attention to:

- Any `CS0618` (obsolete API) warnings that may indicate APIs removed in newer .NET versions.
- Any `NETSDK` warnings related to target framework compatibility.

---

## 3. Review Configuration Files

Check that `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) are present and correctly configured in `Bookstore.Web`. Confirm the following:

- Connection strings previously stored in `Web.config` have been moved to `appsettings.json`.
- Any `<appSettings>` keys from the legacy `Web.config` have been migrated to the appropriate `appsettings.json` structure.
- The `ConfigurationManager` usage, if any, has been replaced with `IConfiguration` from `Microsoft.Extensions.Configuration`.

---

## 4. Verify Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm the following:

- If Entity Framework is in use, verify that the project is using `Microsoft.EntityFrameworkCore` and not the legacy `EntityFramework` (EF6) package, unless EF6 was intentionally retained.
- Run any pending migrations if using EF Core:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the database context is registered correctly in `Program.cs` or `Startup.cs` using `builder.Services.AddDbContext<>()`.

---

## 5. Run Unit Tests

If a test project exists in the solution, execute the test suite:

```bash
dotnet test
```

Review the results for any failing tests that may indicate behavioral regressions introduced during the migration. If no test project exists, consider writing basic integration tests for the data access and domain layers before deploying.

---

## 6. Run the Application Locally

Start the application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following at runtime:

- The application starts without exceptions.
- Database connectivity is functional.
- Core application routes and pages load correctly.
- Any authentication or authorization middleware behaves as expected.

---

## 7. Check for Removed or Changed APIs

Review the code for usage of APIs that were removed or significantly changed between .NET Framework and modern .NET. Common areas to check include:

- `System.Web` references — these are not available in modern .NET and should have been replaced during transformation.
- `HttpContext` usage — ensure it is accessed via dependency injection (`IHttpContextAccessor`) where needed.
- `Thread.Abort()` — this throws a `PlatformNotSupportedException` in modern .NET and should be replaced with cancellation token patterns.
- Binary serialization (`BinaryFormatter`) — this is disabled by default in .NET 5+ and should be replaced with a supported serialization mechanism.

---

## 8. Validate Middleware and Request Pipeline

In `Bookstore.Web`, review `Program.cs` to confirm the middleware pipeline is correctly ordered. A typical order for an ASP.NET Core web application is:

```csharp
app.UseExceptionHandler();
app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers(); // or app.MapRazorPages();
```

Incorrect middleware ordering is a common source of runtime issues that do not produce build errors.