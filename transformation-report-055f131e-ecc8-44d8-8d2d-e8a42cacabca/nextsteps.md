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

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

- Verify that `appsettings.json` (and any environment-specific variants such as `appsettings.Development.json`) are present in `Bookstore.Web` and contain the correct configuration values, including connection strings.
- Confirm that any configuration previously stored in `Web.config` or `App.config` has been properly migrated to the `appsettings.json` structure or the appropriate .NET configuration provider.

---

## 4. Verify Database Connectivity

If the project uses Entity Framework, confirm the following:

- The connection string in `appsettings.json` points to the correct database instance.
- Any pending migrations are applied:

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

Navigate to the URL indicated in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and confirm the application loads correctly.

---

## 6. Execute Unit and Integration Tests

If a test project exists in the solution, run all tests to confirm existing functionality has not regressed.

```bash
dotnet test
```

Review the test results for any failures. Pay particular attention to tests that exercise data access logic in `Bookstore.Data` or domain logic in `Bookstore.Domain`, as these layers are most likely to be affected by a framework migration.

---

## 7. Validate Runtime Behavior

Manually verify the following areas of the application:

- All primary user-facing pages load without errors.
- Data is correctly read from and written to the database.
- Any authentication or authorization mechanisms function as expected.
- Static assets (CSS, JavaScript, images) are served correctly.

---

## 8. Publish the Application

Once validation is complete, publish the application to a target directory.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, then deploy the output to your target hosting environment.