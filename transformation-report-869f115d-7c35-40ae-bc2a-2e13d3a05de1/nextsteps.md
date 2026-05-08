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

Verify that all three projects build without warnings or errors. Pay particular attention to:

- Any `NETSDK` warnings about target framework compatibility
- Obsolete API usage warnings that may indicate areas needing further modernization

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Confirm the following:

- `appsettings.json` exists in `Bookstore.Web` and contains the necessary configuration (connection strings, app settings, etc.)
- Any environment-specific settings are handled via `appsettings.Development.json` or environment variables
- `Web.config` transforms or `system.web` sections have been removed or migrated appropriately

---

## 4. Verify Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm that:

- The correct version of Entity Framework (EF Core is recommended for cross-platform .NET) is being used
- Database migrations exist and are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations are missing or outdated, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the URL shown in the console output (typically `https://localhost:5001` or `http://localhost:5000`)
- Walk through the core application flows (browsing, searching, and any CRUD operations related to books) to confirm expected behavior

---

## 6. Execute Unit and Integration Tests

If a test project exists in the solution, run all tests to validate business logic and data access behavior.

```bash
dotnet test
```

Review the test results for any failures that may indicate runtime behavioral differences introduced by the migration. Common issues include:

- Changes in `System.Text.Json` serialization behavior compared to `Newtonsoft.Json`
- Differences in middleware ordering in ASP.NET Core vs. ASP.NET MVC
- Case sensitivity differences when running on Linux

---

## 7. Check for Platform-Specific Code

Since this is now a cross-platform application, review the codebase for any remaining Windows-specific dependencies:

- Use of `Microsoft.Win32` registry APIs
- Windows-only file path assumptions (e.g., hardcoded backslashes)
- Any P/Invoke calls to Windows DLLs
- Use of `System.Drawing` (GDI+), which has limited cross-platform support — consider replacing with `SkiaSharp` or `ImageSharp` if applicable

---

## 8. Publish the Application

Once validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets and configuration files.