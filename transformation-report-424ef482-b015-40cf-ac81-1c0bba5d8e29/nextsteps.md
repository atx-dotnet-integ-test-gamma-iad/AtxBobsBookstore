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

The steps below describe how to validate, test, and deploy the migrated solution.

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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET (e.g., `net8.0`). Mixing framework versions across projects can cause runtime issues even when the build succeeds.

Example of what to look for in each `.csproj`:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently in modern .NET compared to .NET Framework. Pay particular attention to:

- **`System.Web` dependencies** — these are not available in cross-platform .NET. Confirm no references remain.
- **Entity Framework** — if `Bookstore.Data` uses EF, confirm it has been migrated to EF Core and that the `DbContext` configuration is correct.
- **Configuration** — `System.Configuration.ConfigurationManager` usage should be replaced with `Microsoft.Extensions.Configuration`.
- **HTTP Context** — any use of `HttpContext.Current` must be replaced with dependency-injected `IHttpContextAccessor`.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the tests to validate core functionality.

```bash
dotnet test
```

Review any failing tests carefully, as they may indicate behavioral differences between .NET Framework and modern .NET.

---

## 6. Validate the Data Layer

In `Bookstore.Data`, verify the following:

- Database connection strings are sourced from `appsettings.json` rather than `web.config` or `app.config`.
- Any EF Core migrations are up to date. Run the following to apply pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If no migrations exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the web application and verify it runs as expected.

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and exercise the primary workflows (browsing books, user authentication if applicable, etc.).
- Check the console output and application logs for any runtime exceptions.

---

## 8. Review `appsettings.json`

Confirm that `Bookstore.Web/appsettings.json` contains all necessary configuration values that were previously stored in `web.config`, including:

- Connection strings
- Application-specific settings
- Logging configuration

---

## 9. Verify Static Files and Middleware

In `Bookstore.Web`, confirm that `Program.cs` (or `Startup.cs`) includes the necessary middleware for serving static files, routing, and authentication if applicable.

```csharp
app.UseStaticFiles();
app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();
```

---

## 10. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present before deploying to the target environment.