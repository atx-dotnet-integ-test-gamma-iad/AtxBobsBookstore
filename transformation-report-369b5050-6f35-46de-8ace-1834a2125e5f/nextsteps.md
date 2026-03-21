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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

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

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results carefully. Any failing tests should be investigated before proceeding further.

---

## 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

At a minimum, confirm the following:

- The application starts without runtime exceptions.
- Database connectivity works as expected through `Bookstore.Data`.
- Domain logic in `Bookstore.Domain` behaves correctly end-to-end.
- All primary routes and pages load without errors.

---

## 5. Review Configuration Files

Check `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, `appsettings.Production.json`) to confirm:

- Connection strings are correct for the target environment.
- Any configuration keys that were previously stored in `Web.config` have been properly migrated to the new configuration system.
- Sensitive values are not hardcoded and are instead sourced from environment variables or a secrets manager.

---

## 6. Validate Entity Framework Migrations

If `Bookstore.Data` uses Entity Framework, verify that migrations are compatible with the migrated project:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the database schema needs to be updated, apply pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 7. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory to confirm all required assemblies, static assets, and configuration files are present before deploying to the target environment.