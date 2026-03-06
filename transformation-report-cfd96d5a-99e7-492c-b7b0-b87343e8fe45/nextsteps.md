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

The following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check their NuGet pages for recommended replacements compatible with the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues beyond what was reported.

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay attention to any warnings about obsolete APIs, as these may cause issues in future .NET versions.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Confirm the following:

- `appsettings.json` exists in `Bookstore.Web` and contains the correct connection strings and application settings that were previously in `Web.config`.
- Environment-specific configuration files (e.g., `appsettings.Development.json`) are present if needed.
- Any configuration transformations previously handled by `Web.config` transforms have been migrated to the appropriate `appsettings.{Environment}.json` files.

---

## 4. Verify Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm the following:

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) is referenced and up to date.
- Connection strings in `appsettings.json` match the expected format for the provider in use.
- If migrations are used, run the following to verify the migration state:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, user authentication if applicable) to confirm baseline functionality.

---

## 6. Check for Platform-Specific Code

Search the codebase for any APIs that were Windows-specific in .NET Framework and may not be available cross-platform. Common areas to check include:

- Use of `System.Web` namespaces — these are not available in .NET Core or later.
- Windows Registry access (`Microsoft.Win32.Registry`).
- Windows-specific authentication mechanisms (e.g., Windows Authentication requires additional configuration on non-Windows hosts).
- File path separators — use `Path.Combine` and `Path.DirectorySeparatorChar` rather than hardcoded backslashes.

---

## 7. Execute Unit and Integration Tests

If the solution contains test projects, run them to validate that existing logic behaves correctly after migration.

```bash
dotnet test
```

Review any failing tests carefully. Failures may indicate behavioral differences between .NET Framework and the new target framework rather than bugs in the original code.

---

## 8. Validate Static Assets and Middleware

In `Bookstore.Web`, confirm the following:

- Static files (CSS, JavaScript, images) are served correctly. In cross-platform .NET, static files must reside in the `wwwroot` folder and the `UseStaticFiles()` middleware must be registered in `Program.cs` or `Startup.cs`.
- Any HTTP modules or HTTP handlers from the original `Web.config` have been replaced with the equivalent ASP.NET Core middleware registered in the request pipeline.

---

## 9. Review Logging Configuration

Ensure that logging is configured appropriately. Cross-platform .NET uses `Microsoft.Extensions.Logging`. Confirm that:

- A logging provider (e.g., Console, Debug, or a third-party provider) is registered.
- Log levels are set correctly in `appsettings.json` under the `"Logging"` section.

---

## 10. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present, including `appsettings.json` and any other runtime dependencies.