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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no issues beyond what was reported:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute all tests to verify that existing functionality has not been broken by the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding tests for critical paths in `Bookstore.Domain` and `Bookstore.Data` before proceeding further.

---

## 4. Verify Data Layer Behavior

Since `Bookstore.Data` handles data access, confirm the following:

- The correct database provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql.EntityFrameworkCore.PostgreSQL`, etc.).
- Connection strings in `appsettings.json` are correctly configured for the target environment.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application URL shown in the console output.
- Test core user-facing functionality such as browsing, searching, and any authentication flows.
- Check the console and application logs for runtime exceptions or unhandled errors.

---

## 6. Review Configuration Files

Confirm that the following configuration concerns have been addressed:

- `appsettings.json` and `appsettings.Production.json` contain the correct values for the target environment.
- Any configuration that previously relied on `Web.config` or `App.config` has been moved to the appropriate `appsettings.json` structure or environment variables.
- Secrets such as connection strings or API keys are not hardcoded and are managed through environment variables or a secrets manager.

---

## 7. Check for Platform-Specific Code

Since this was a cross-platform migration, review the codebase for any remaining Windows-specific dependencies:

- References to `System.Web` (not supported on .NET Core/.NET 5+).
- Use of the Windows Registry (`Microsoft.Win32.Registry`).
- File path separators hardcoded as `\` instead of using `Path.Combine` or `Path.DirectorySeparatorChar`.
- Any P/Invoke calls targeting Windows-only native libraries.

Run the following to check for platform compatibility warnings using the .NET Compatibility Analyzer:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

---

## 8. Publish the Application

Once the application has been validated locally, publish it for deployment:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.