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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests should be investigated to determine whether they indicate a regression introduced by the migration or a pre-existing issue.

---

## 4. Verify Entity Framework Core Migrations (if applicable)

Since the solution includes a `Bookstore.Data` project, it likely uses Entity Framework. Confirm that your database context and migrations are compatible with the target version of EF Core:

```bash
dotnet ef dbcontext info --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If migrations exist, verify they are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If the schema needs to be applied to a database:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that core functionality such as routing, data access, and page rendering works as expected.

---

## 6. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` for application configuration. Confirm the following:

- `appsettings.json` and `appsettings.{Environment}.json` contain the correct connection strings and application settings.
- Any environment-specific configuration previously stored in `Web.config` transforms has been moved to the appropriate `appsettings` files or environment variables.
- The `ASPNETCORE_ENVIRONMENT` environment variable is set correctly for each target environment (e.g., `Development`, `Production`).

---

## 7. Check for Platform-Specific API Usage

Review the codebase for any remaining usage of Windows-specific APIs that may not behave correctly on Linux or macOS if cross-platform deployment is intended. Common areas to check include:

- File path separators (use `Path.Combine` rather than hardcoded backslashes)
- Registry access
- Windows-specific authentication mechanisms such as Windows Authentication or NTLM

---

## 8. Publish the Application

Once validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.