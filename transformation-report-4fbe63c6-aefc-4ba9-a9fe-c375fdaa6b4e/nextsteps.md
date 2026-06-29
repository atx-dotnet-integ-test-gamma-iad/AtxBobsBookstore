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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, consider finding their cross-platform equivalents on [NuGet](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release --verbosity normal
```

If no tests currently exist, consider writing tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before deploying.

---

## 4. Verify Data Layer Functionality

Since `Bookstore.Data` handles data access, confirm the following:

- Connection strings in `appsettings.json` (or equivalent configuration) are correctly configured for the target environment.
- Any Entity Framework migrations are up to date. If using EF Core, run:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to verify it runs correctly end-to-end:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL indicated in the console output and manually verify that core application flows (browsing, data retrieval, etc.) function as expected.

---

## 6. Review Configuration and Environment Settings

Cross-platform .NET uses `appsettings.json` and environment variables rather than `Web.config` or `App.config`. Confirm the following:

- All previously used `Web.config` settings have been migrated to `appsettings.json`.
- Environment-specific settings are handled via `appsettings.{Environment}.json` or environment variables.
- Any Windows-specific APIs or libraries that may have been present in the legacy project have been replaced with cross-platform alternatives.

---

## 7. Publish the Application

Once local validation is complete, publish the application to the target deployment location:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, then deploy to the target server or hosting environment.