# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages are flagged, consider updating them to versions compatible with the current .NET target framework.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay particular attention to any warnings about obsolete APIs, as these may indicate areas that require further modernization.

---

## 3. Review Configuration Files

Cross-platform .NET projects handle configuration differently than legacy .NET Framework projects. Verify the following:

- `appsettings.json` is present in `Bookstore.Web` and contains the correct connection strings and application settings.
- Any configuration that previously relied on `Web.config` or `App.config` has been migrated to `appsettings.json` or environment variables.
- The `Startup.cs` or `Program.cs` file correctly registers services, middleware, and the database context.

---

## 4. Verify the Data Layer

Since `Bookstore.Data` depends on `Bookstore.Domain`, confirm the following:

- The Entity Framework (or whichever ORM is in use) context is correctly configured for the target database provider (e.g., SQL Server, SQLite).
- Any pending migrations are present and up to date. Run the following to check migration status:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, add or update them:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run Automated Tests

If the solution contains a test project, execute the test suite to validate that existing functionality behaves as expected after migration.

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to migration issues or pre-existing defects.

If no test project exists, consider writing integration tests that cover the primary data access and web layer interactions before deploying.

---

## 6. Run the Application Locally

Start the web application locally to perform manual validation.

```bash
dotnet run --project Bookstore.Web
```

Verify the following at runtime:

- The application starts without exceptions.
- Database connectivity is functional.
- Core application routes and pages load correctly.
- Any authentication or authorization mechanisms function as expected.

---

## 7. Check for Platform-Specific Code

Search the solution for any remaining platform-specific APIs that may not be supported on Linux or macOS if cross-platform deployment is intended. Common areas to check include:

- Windows Registry access
- `System.Web` namespace references
- Windows-specific file path assumptions (e.g., hardcoded backslashes)
- COM interop usage

Use the .NET Upgrade Assistant compatibility analyzer or the following command to surface potential issues:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

---

## 8. Publish the Application

Once local validation is complete, publish the application for deployment.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.