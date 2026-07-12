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

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `netstandard` or older `net4x` target frameworks, consider updating them to versions that explicitly support the target framework you are using (e.g., `net6.0`, `net7.0`, or `net8.0`).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly:
- Nullable reference type warnings, which may indicate logic that needs review.
- Obsolete API usage warnings, which may point to APIs that have been removed or changed in modern .NET.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Verify the following:

- `appsettings.json` contains all necessary configuration values previously held in `Web.config`, including connection strings and application settings.
- Any environment-specific configuration (e.g., `appsettings.Development.json`) is present and correct.
- The `Startup.cs` or `Program.cs` file correctly reads from `appsettings.json` using `IConfiguration`.

---

## 4. Verify the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework (or whichever ORM is in use) has been updated to a version compatible with cross-platform .NET.
- If using Entity Framework Core, verify that migrations are present and up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to a local or development database to confirm the schema is correct:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, adding to cart, placing orders, or whatever the core features are).
- Check the console output and application logs for any runtime exceptions or unhandled errors.

---

## 6. Check for Platform-Specific Code

Search the codebase for any APIs or patterns that were Windows-specific and may not behave correctly on Linux or macOS if cross-platform support is required:

- `System.Web` references should no longer be present. If any remain, they need to be replaced with their ASP.NET Core equivalents.
- File path separators: ensure `Path.Combine` is used instead of hardcoded backslashes.
- Registry access, COM interop, or Windows-specific authentication mechanisms should be identified and replaced if cross-platform execution is needed.

---

## 7. Execute Unit and Integration Tests

If the solution contains test projects, run them to validate that existing behavior has been preserved after the migration.

```bash
dotnet test
```

Review any failing tests carefully. Failures may indicate:
- Behavioral differences between .NET Framework and modern .NET.
- Dependencies on APIs that have changed or been removed.
- Configuration or environment assumptions that no longer hold.

---

## 8. Review Logging and Error Handling

- Confirm that logging is configured using `Microsoft.Extensions.Logging` or a compatible provider (e.g., Serilog, NLog).
- Verify that unhandled exceptions are caught and logged appropriately.
- Check that HTTP error pages (404, 500, etc.) are configured correctly in the middleware pipeline.

---

## 9. Validate Static Assets and Views

- Confirm that all Razor views render correctly and that no view-specific dependencies (e.g., tag helpers, view components) are missing.
- Verify that static files (CSS, JavaScript, images) are served correctly. In ASP.NET Core, static files must reside in the `wwwroot` folder and the `UseStaticFiles()` middleware must be present in the pipeline.

---

## 10. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required files are present before deploying to the target environment.