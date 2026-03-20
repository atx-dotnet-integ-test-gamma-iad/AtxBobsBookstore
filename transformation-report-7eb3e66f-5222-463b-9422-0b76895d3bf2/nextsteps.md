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

Address any warnings that surface, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas of the code that may behave differently under cross-platform .NET compared to .NET Framework.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that business logic and data access behavior remain correct after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding tests for the core logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

Since `Bookstore.Data` is present, confirm that any Entity Framework Core migrations are up to date and compatible with the target database:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Ensure the connection string in `appsettings.json` points to the correct database instance for your environment.

---

## 5. Validate Runtime Behavior of the Web Project

Start the web application locally and verify that pages and endpoints respond as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following areas manually or through automated tests:

- All routes resolve correctly
- Authentication and authorization behave as expected
- Data reads and writes function correctly against the database
- Static assets (CSS, JavaScript, images) are served properly

---

## 6. Review Platform-Specific Code

Search the codebase for any APIs or patterns that were available in .NET Framework but may behave differently or require alternatives in cross-platform .NET:

- `System.Web` references (should have been removed during transformation)
- `HttpContext` usage outside of controllers or middleware
- Windows-specific APIs such as the registry, Windows identity impersonation, or COM interop
- Any use of `BinaryFormatter`, which is disabled by default in modern .NET

Address any remaining usages by replacing them with their cross-platform equivalents.

---

## 7. Review Configuration System

.NET Framework projects often rely on `Web.config` or `App.config`. Confirm that all configuration values have been migrated to `appsettings.json` or environment variables, and that the application reads them using `IConfiguration` correctly.

---

## 8. Publish the Application

Once validation is complete, publish the application to a target folder:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the output directory to confirm all required files, including runtime dependencies and static assets, are present before deploying to the target environment.