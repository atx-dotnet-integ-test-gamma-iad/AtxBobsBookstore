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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no errors or warnings introduced at compile time:

```bash
dotnet build --configuration Release
```

Address any warnings that may indicate compatibility issues, such as obsolete API usage or nullable reference warnings, as these can surface runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute all tests to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before deploying.

---

## 4. Verify Database Connectivity

Since the solution includes a `Bookstore.Data` project, confirm that the data layer connects correctly to the target database:

- Check the connection string in `appsettings.json` or `appsettings.Production.json` within `Bookstore.Web`.
- If Entity Framework Core is in use, verify that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to perform a manual smoke test:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that core functionality such as browsing, searching, and any data-driven pages are working as expected.

---

## 6. Review Configuration for Environment Differences

Cross-platform .NET may surface configuration differences that were previously handled by the Windows environment. Review the following:

- File path separators — replace any hardcoded backslashes (`\`) with `Path.Combine()` or forward slashes where applicable.
- Environment-specific settings — confirm that `appsettings.json` and environment variable overrides are correctly structured for the target environment.
- Any Windows-specific APIs or libraries that may have been carried over — check for `PlatformNotSupportedException` at runtime if certain features are exercised.

---

## 7. Publish the Application

Once local validation is complete, publish the application to the target runtime:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assets, configuration files, and dependencies are present before deploying to the target server or hosting environment.