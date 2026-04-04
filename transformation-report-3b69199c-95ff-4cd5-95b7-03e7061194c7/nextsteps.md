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

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, consider updating them to versions that are compatible with the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay particular attention to any warnings about obsolete APIs, as these may indicate areas that need attention in future maintenance cycles.

---

## 3. Review Configuration Files

Cross-platform .NET projects handle configuration differently than legacy .NET Framework projects.

- Confirm that `appsettings.json` (and `appsettings.Development.json` if present) in `Bookstore.Web` contains all settings that were previously in `Web.config` or `App.config`.
- Verify that connection strings are correctly defined under the `ConnectionStrings` section in `appsettings.json`.
- Ensure that any environment-specific settings are handled using the `ASPNETCORE_ENVIRONMENT` environment variable rather than config transforms.

---

## 4. Verify the Data Layer

Since `Bookstore.Data` depends on `Bookstore.Domain`, validate the data layer first.

- If the project uses Entity Framework, confirm the correct version is referenced. For cross-platform .NET, this should be **Entity Framework Core**, not the legacy `System.Data.Entity`.
- Run any existing database migrations to confirm they apply cleanly:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, scaffold an initial migration to verify the model is correctly mapped:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application URL shown in the console output.
- Walk through the core application flows (e.g., browsing books, adding to cart, checkout if applicable) to confirm that runtime behavior is correct.
- Check the console output and any log files for unhandled exceptions or warnings.

---

## 6. Execute Existing Tests

If the solution contains test projects, run them to validate that existing functionality has not regressed.

```bash
dotnet test
```

Review the test results and investigate any failures. Failures may indicate areas where behavior changed between the legacy .NET Framework implementation and the new cross-platform .NET runtime.

---

## 7. Validate Static Assets and Middleware

For `Bookstore.Web`, confirm the following:

- Static files (CSS, JavaScript, images) are served correctly. In ASP.NET Core, static files must reside in the `wwwroot` folder and `UseStaticFiles()` must be called in the middleware pipeline.
- Any HTTP handlers or modules from the legacy project (`IHttpHandler`, `IHttpModule`) have been replaced with the equivalent ASP.NET Core middleware.
- Authentication and authorization configuration has been migrated from `Web.config` settings to the ASP.NET Core middleware pipeline in `Program.cs` or `Startup.cs`.

---

## 8. Check for Platform-Specific Code

Search the codebase for any APIs that were available in .NET Framework but are not available or behave differently in cross-platform .NET.

Common areas to check:

- `System.Web` references — these are not available in cross-platform .NET and should have been fully replaced.
- `Registry` access (`Microsoft.Win32.Registry`) — this is Windows-only.
- `System.Drawing` — on non-Windows platforms, this requires the `System.Drawing.Common` package and has known limitations.
- File path separators — use `Path.Combine` and `Path.DirectorySeparatorChar` rather than hardcoded backslashes.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including `appsettings.json` and any static assets.