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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check their respective NuGet pages for recommended replacements targeting the current .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

Cross-platform .NET projects handle configuration differently than legacy .NET Framework projects. Verify the following:

- `appsettings.json` is present in `Bookstore.Web` and contains the correct connection strings and application settings.
- Any settings previously stored in `Web.config` or `App.config` have been migrated to `appsettings.json` or `appsettings.{Environment}.json`.
- Environment-specific configuration (e.g., `appsettings.Development.json`) is in place where needed.

---

## 4. Verify the Data Layer

Since `Bookstore.Data` depends on `Bookstore.Domain`, confirm the following:

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) is referenced and up to date.
- Any existing migrations are present under a `Migrations` folder.
- If migrations are missing or outdated, regenerate them:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application URL shown in the console output.
- Walk through the core user flows (e.g., browsing books, adding to cart, checkout if applicable) to confirm expected behavior.
- Check the console and any log output for unhandled exceptions or warnings.

---

## 6. Execute Unit and Integration Tests

If the solution contains a test project, run all tests to validate business logic and data access behavior.

```bash
dotnet test
```

- Review any failing tests and determine whether failures are due to migration issues or pre-existing problems.
- Pay particular attention to tests covering `Bookstore.Domain` logic and `Bookstore.Data` repository methods, as these are foundational to the application.

---

## 7. Validate Static Assets and Middleware

For `Bookstore.Web`, confirm the following:

- Static files (CSS, JavaScript, images) are served correctly. These should be located under the `wwwroot` folder.
- Middleware configuration in `Program.cs` or `Startup.cs` includes calls to `UseStaticFiles()`, `UseRouting()`, and `UseAuthorization()` where applicable.
- Any HTTP modules or HTTP handlers from the legacy project have been replaced with the appropriate ASP.NET Core middleware.

---

## 8. Check for Platform-Specific Code

Search the codebase for any APIs that may not be supported cross-platform:

- File path separators: use `Path.Combine` rather than hardcoded backslashes.
- Registry access (`Microsoft.Win32.Registry`) is Windows-only and should be replaced or conditionally compiled.
- Any use of `System.Web` namespace references should have been fully removed during transformation.

You can use the .NET Upgrade Assistant compatibility analyzer or the following command to check for platform compatibility warnings:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` folder to confirm all required files are present, including `appsettings.json` and any static assets.