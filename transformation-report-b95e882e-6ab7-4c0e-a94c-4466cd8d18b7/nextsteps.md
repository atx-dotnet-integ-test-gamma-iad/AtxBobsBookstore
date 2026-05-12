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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review the test results for any failures that may indicate behavioral differences between the legacy .NET Framework version and the new cross-platform .NET version.

---

## 4. Validate the Data Layer

Since `Bookstore.Data` handles data access, verify the following:

- **Database Migrations**: If Entity Framework Core is in use, confirm that existing migrations are compatible. Run the following to apply migrations against a test database:

  ```bash
  dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
  ```

- **Connection Strings**: Confirm that connection strings in `appsettings.json` are correctly configured for the target environment and are no longer referencing any Windows-specific data sources (e.g., SQL Server using Windows Authentication may require adjustment on non-Windows hosts).

---

## 5. Validate the Domain Layer

Review `Bookstore.Domain` for any types or patterns that relied on .NET Framework-specific behavior, such as:

- `System.Web` references (these are not available in cross-platform .NET)
- Serialization attributes from `System.Runtime.Serialization` that may behave differently
- Any use of `AppDomain` or `AppContext` that may need adjustment

---

## 6. Validate the Web Layer

For `Bookstore.Web`, perform the following checks:

- **Startup Configuration**: Confirm that `Program.cs` and any middleware configuration follow the ASP.NET Core conventions appropriate for the target .NET version.
- **Static Files**: Verify that static assets (CSS, JS, images) are located under `wwwroot` and are being served correctly.
- **Authentication/Authorization**: If the legacy project used ASP.NET Membership or Forms Authentication, confirm these have been replaced with ASP.NET Core Identity or an equivalent mechanism.
- **Configuration**: Ensure `appsettings.json` contains all settings previously held in `Web.config`, including connection strings, logging configuration, and any custom application settings.

---

## 7. Run the Application Locally

Start the application locally and perform manual smoke testing:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the core workflows of the application (browsing books, user authentication, data persistence) to confirm expected behavior.

---

## 8. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is still targeting `net48` or another legacy moniker, update it accordingly and rebuild.

---

## 9. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the output directory to confirm all required assemblies, configuration files, and static assets are present before deploying to the target environment.