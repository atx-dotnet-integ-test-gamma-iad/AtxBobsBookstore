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

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures. Pay particular attention to tests covering data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`, as these layers are most likely to be affected by framework differences.

---

## 4. Verify Database Connectivity and Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that your database migrations are up to date and compatible with the new framework version:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations need to be applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Confirm that the connection string in `appsettings.json` is correctly configured for the target environment.

---

## 5. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Walk through the core application workflows, such as browsing, searching, and managing books, to confirm that behavior matches the pre-migration state.

---

## 6. Review Configuration Files

Check the following configuration-related items:

- Confirm that `appsettings.json` and `appsettings.Development.json` contain all required keys that were previously in `Web.config` or `App.config`.
- Verify that any environment-specific settings are correctly separated using the ASP.NET Core configuration system.
- Ensure that authentication, authorization, and middleware configurations in `Program.cs` or `Startup.cs` are complete and correct.

---

## 7. Check for Platform-Specific Code

Review the codebase for any remaining Windows-specific APIs or libraries that may not be supported on Linux or macOS if cross-platform support is a requirement. Common areas to check include:

- File path handling (use `Path.Combine` rather than hardcoded separators)
- Registry access
- Windows Authentication or IIS-specific middleware

---

## 8. Publish the Application

Once validation is complete, publish the application to the target deployment directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm that all required static assets, configuration files, and binaries are present before deploying to the target environment.