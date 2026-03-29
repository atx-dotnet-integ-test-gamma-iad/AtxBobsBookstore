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

The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Verify the following:

- `appsettings.json` contains all necessary configuration values previously held in `Web.config` (connection strings, app settings, etc.).
- `appsettings.Development.json` is present for environment-specific overrides.
- Any `<connectionStrings>` or `<appSettings>` entries from the old `Web.config` have been migrated to the appropriate `appsettings.json` structure.

---

## 4. Verify the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework (or whichever ORM is in use) is using the correct provider for cross-platform .NET (e.g., `Microsoft.EntityFrameworkCore` instead of `System.Data.Entity`).
- Run any pending migrations or verify the database schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and exercise the primary workflows (browsing books, user authentication if present, data entry, etc.).
- Check the console output and application logs for any runtime exceptions or unhandled errors.

---

## 6. Check for Platform-Specific Code

Search the solution for any APIs or patterns that were Windows-specific and may not function correctly on Linux or macOS:

- `Registry` access (`Microsoft.Win32.Registry`)
- Windows-specific file paths using backslashes (prefer `Path.Combine` instead)
- `System.Drawing` usage (consider replacing with a cross-platform alternative such as `SkiaSharp` or `ImageSharp`)
- Windows Authentication or IIS-specific middleware

---

## 7. Execute Unit and Integration Tests

If a test project exists in the solution, run all tests to validate business logic and data access behavior.

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to the migration or pre-existing issues.

---

## 8. Validate Middleware and HTTP Pipeline

In cross-platform ASP.NET Core, the HTTP pipeline is configured in `Program.cs` (and optionally `Startup.cs`). Confirm the following are correctly registered:

- Authentication and authorization middleware
- Static file serving (`UseStaticFiles`)
- Routing (`UseRouting`, `MapControllers`, `MapRazorPages`, etc.)
- Any custom HTTP modules or handlers from the old project have been converted to ASP.NET Core middleware

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.