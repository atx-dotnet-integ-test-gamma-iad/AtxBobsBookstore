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

Address any warnings that surface, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the tests to verify that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release
```

Review the test output carefully. Any failing tests should be investigated before proceeding further. If no test projects currently exist, consider adding tests for the core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data`.

---

## 4. Verify Database Connectivity and Migrations

Since the solution includes a `Bookstore.Data` project, verify that any Entity Framework Core (or other ORM) configuration is correct for the target environment.

- Confirm the connection string in `appsettings.json` (or environment-specific variants) points to the correct database.
- If using Entity Framework Core, check that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to confirm it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and verify that key functionality such as data retrieval, form submissions, and page rendering work as expected.

---

## 6. Review Configuration Files

Cross-platform .NET handles configuration differently than legacy .NET Framework projects. Verify the following:

- `appsettings.json` contains all necessary configuration values that were previously in `Web.config` or `App.config`.
- Environment-specific settings are placed in `appsettings.Development.json` or `appsettings.Production.json` as appropriate.
- Any file paths used in the application use `Path.Combine` or equivalent cross-platform methods rather than hardcoded backslashes.

---

## 7. Check for Platform-Specific API Usage

Review the codebase for any remaining Windows-specific APIs that may not function correctly on Linux or macOS if cross-platform deployment is intended. Common areas to check include:

- Registry access
- Windows-specific authentication (e.g., Windows Identity, NTLM)
- COM interop
- `System.Drawing` usage (consider migrating to a cross-platform alternative such as `SkiaSharp` if applicable)

---

## 8. Publish the Application

Once validation is complete, publish the application to the target environment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target server or hosting environment.