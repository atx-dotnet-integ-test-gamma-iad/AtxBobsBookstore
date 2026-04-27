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

Address any warnings that may surface, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review the test output carefully. Any failing tests should be investigated to determine whether they represent regressions introduced during migration or pre-existing issues.

---

## 4. Verify Entity Framework Core Migrations (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, confirm that your migrations are compatible with the version of EF Core now being used:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If the database schema needs to be updated, apply the migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:
- The application starts without exceptions.
- All pages and routes load correctly.
- Database reads and writes function as expected.
- Any authentication or authorization flows work correctly.

---

## 6. Review Configuration Files

Ensure that `appsettings.json` and any environment-specific configuration files (e.g., `appsettings.Development.json`) have been correctly migrated. Pay particular attention to:

- Connection strings
- Any API keys or external service endpoints
- Logging configuration

If the original project used `Web.config`, confirm that all relevant settings have been moved to `appsettings.json` or the appropriate .NET configuration provider.

---

## 7. Check for Platform-Specific Code

Review the codebase for any remaining Windows-specific APIs or dependencies that may not function correctly on Linux or macOS if cross-platform support is a requirement. Common areas to check include:

- File path separators (use `Path.Combine` rather than hardcoded separators)
- Registry access
- Windows Authentication

---

## 8. Publish the Application

Once validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all necessary files are present before deploying to the target environment.