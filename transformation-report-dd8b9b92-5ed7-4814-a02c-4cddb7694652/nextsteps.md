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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

- Review any failing tests carefully, as failures may point to behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.
- Pay particular attention to tests covering data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`.

---

## 4. Verify Database Connectivity and Migrations

Since the solution includes a `Bookstore.Data` project, confirm that database access is functioning correctly:

- If Entity Framework Core is being used, verify that your connection strings in `appsettings.json` are correct for your target environment.
- Apply any pending migrations to your database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If the project previously used Entity Framework 6 (EF6), confirm that it has been migrated to EF Core, as EF6 does not fully support cross-platform .NET.

---

## 5. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application's key pages and features.
- Check the console output and application logs for any runtime exceptions or warnings.
- Verify that HTTP request routing, middleware, and authentication (if applicable) behave as expected.

---

## 6. Review Configuration Files

Cross-platform .NET uses `appsettings.json` rather than `Web.config` or `App.config`. Confirm the following:

- All connection strings have been moved to `appsettings.json`.
- Any environment-specific settings are handled via `appsettings.{Environment}.json` or environment variables.
- If any `Web.config` transforms were used previously, ensure equivalent configuration is now handled through the .NET configuration system.

---

## 7. Check for Platform-Specific API Usage

Review the codebase for any APIs that were available in .NET Framework but are unavailable or behave differently in cross-platform .NET:

- `System.Web` namespace usage should be fully replaced with ASP.NET Core equivalents.
- Windows-specific APIs (e.g., registry access, Windows identity impersonation) may require alternative implementations if the application is intended to run on non-Windows platforms.
- Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify remaining compatibility concerns.

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to your target environment.