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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages reference `netstandard` or older `net4x` targets, consider updating them to versions that explicitly support the target framework of your migrated project.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly:
- **Nullable reference type warnings** — These may indicate areas where null safety was not enforced in the legacy code.
- **Obsolete API warnings** — Some APIs used in the original project may be deprecated in newer .NET versions.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Verify the following:

- `appsettings.json` contains all necessary configuration values that were previously in `Web.config`, including connection strings, app settings, and environment-specific values.
- `appsettings.Development.json` exists and is configured for local development.
- Any `<connectionStrings>` or `<appSettings>` entries from the old `Web.config` have been migrated to the appropriate `appsettings.json` structure.

---

## 4. Verify the Data Layer

Since `Bookstore.Data` depends on `Bookstore.Domain`, validate the data layer carefully:

- If Entity Framework is used, confirm the correct version of EF Core is referenced (not EF 6, unless intentional).
- Run any existing database migrations or create a new initial migration if the model has changed:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the `DbContext` is registered correctly in `Program.cs` or `Startup.cs` using `AddDbContext`.

---

## 5. Run the Application Locally

Start the application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, user authentication if present).
- Check the console output and application logs for any runtime exceptions or unhandled errors.
- Verify that static files (CSS, JavaScript, images) are being served correctly. Ensure `app.UseStaticFiles()` is present in the middleware pipeline.

---

## 6. Run Existing Tests

If the solution contains test projects, execute them to validate that existing functionality has not regressed.

```bash
dotnet test
```

Review any failing tests and determine whether the failures are due to:
- Breaking API changes in the new .NET version.
- Configuration or dependency injection differences.
- Changes in behavior of migrated libraries.

---

## 7. Validate Platform-Specific Code

Review the codebase for any code that was written specifically for Windows and may not behave correctly on Linux or macOS:

- **File paths** — Replace hardcoded backslash separators (`\`) with `Path.Combine()` or forward slashes.
- **Registry access** — `Microsoft.Win32.Registry` is not available on non-Windows platforms.
- **Windows Authentication** — If used, confirm the hosting environment supports it or replace with an alternative.
- **`HttpContext.Current`** — This is not available in ASP.NET Core. Ensure it has been replaced with injected `IHttpContextAccessor`.

---

## 8. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment package.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` folder to confirm all required files are present before deploying to the target environment.