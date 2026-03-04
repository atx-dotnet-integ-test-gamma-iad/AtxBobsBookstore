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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check for updated versions on [NuGet.org](https://www.nuget.org) and update the `.csproj` references accordingly.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay particular attention to any warnings about nullable reference types, obsolete APIs, or target framework compatibility, as these can indicate areas that may cause runtime issues.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET across all projects (for example, `net8.0`). Mismatched target frameworks between projects can cause subtle runtime issues even when the build succeeds.

---

## 4. Verify Configuration Files

Check that `appsettings.json` and any environment-specific configuration files (e.g., `appsettings.Development.json`) are present in `Bookstore.Web` and contain the correct values, including:

- Database connection strings
- Any API keys or service endpoints
- Logging configuration

If the legacy project used `Web.config` or `App.config`, confirm that all relevant settings have been migrated to the appropriate `appsettings.json` structure.

---

## 5. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Migrations are present and up to date.

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If no migrations exist and the project uses a code-first approach, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application locally to verify basic functionality:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the URL shown in the console output and manually test the primary workflows of the application, such as browsing, searching, and any data entry forms.

---

## 7. Run Automated Tests

If the solution includes a test project, execute the test suite to confirm existing behavior is preserved:

```bash
dotnet test
```

Review any failing tests carefully. Failures may indicate behavioral differences introduced by the migration to cross-platform .NET, such as changes in string handling, file path separators, or culture-sensitive operations.

---

## 8. Check for Platform-Specific Code

Search the codebase for any APIs or patterns that were Windows-specific in the legacy project and may not behave correctly on other platforms. Common areas to check include:

- File path construction (use `Path.Combine` rather than hardcoded backslashes)
- Registry access (`Microsoft.Win32.Registry`)
- Windows Authentication or IIS-specific middleware
- `System.Drawing` usage (replaced by alternatives such as `SkiaSharp` or `ImageSharp` on non-Windows platforms)

---

## 9. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.