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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release --verbosity normal
```

- Verify all previously passing tests continue to pass.
- If tests were written against .NET Framework-specific behavior (e.g., `System.Web`, `HttpContext`), review and update those tests to use the ASP.NET Core equivalents.

---

## 4. Validate the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework (or whichever ORM is in use) is using the correct cross-platform provider (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Run any pending migrations or verify the database schema is consistent:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Test basic CRUD operations against a local or development database to confirm data access is functioning correctly.

---

## 5. Validate the Domain Layer (`Bookstore.Domain`)

- Review domain models and business logic for any remaining references to `System.Web` or other .NET Framework-specific namespaces.
- Confirm that any serialization, validation attributes, or data annotations are sourced from `System.ComponentModel.DataAnnotations` and are compatible with .NET.

---

## 6. Validate the Web Layer (`Bookstore.Web`)

- Run the web application locally:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application in a browser and verify that:
  - Routing works as expected.
  - Authentication and authorization (if present) function correctly.
  - Static files (CSS, JavaScript, images) are served properly.
  - Forms submit and process data without errors.
- Check `appsettings.json` to confirm connection strings and configuration values are correct for the target environment, replacing any values that were previously stored in `Web.config`.

---

## 7. Review Configuration Migration

- Confirm that all settings previously in `Web.config` or `App.config` have been moved to `appsettings.json` or environment variables.
- Verify that environment-specific configuration (e.g., `appsettings.Development.json`) is set up appropriately.

---

## 8. Check for Runtime Warnings

After running the application, review the console output and application logs for:

- Deprecation warnings.
- Missing middleware registrations.
- Unhandled exceptions related to platform differences.

Address any issues found before considering the migration complete.