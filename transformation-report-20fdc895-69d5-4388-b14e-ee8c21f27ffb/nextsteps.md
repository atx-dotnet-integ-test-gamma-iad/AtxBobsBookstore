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

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings that may indicate deprecated APIs or compatibility concerns.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding unit tests for the core logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that your migrations are up to date and compatible with the new target framework:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are present and valid, apply them to your target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Confirm that the connection string in `appsettings.json` (or environment-specific variants) points to the correct database instance.

---

## 5. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and confirm that:

- Pages load without runtime exceptions
- Database reads and writes function correctly
- Any authentication or authorization flows behave as expected

Review the console output and application logs for any runtime warnings or errors.

---

## 6. Review `appsettings.json` and Configuration

Cross-platform .NET no longer relies on `Web.config` for application configuration. Confirm that:

- All connection strings have been moved to `appsettings.json` or environment variables
- Any configuration previously stored in `Web.config` or `App.config` has been migrated to the appropriate .NET configuration provider
- Environment-specific settings (e.g., `appsettings.Development.json`) are correctly structured

---

## 7. Review Static Files and wwwroot

If `Bookstore.Web` serves static assets, confirm that all CSS, JavaScript, and image files are located under the `wwwroot` folder, as this is the expected convention for ASP.NET Core applications.

---

## 8. Validate Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element references a supported, non-end-of-life version of .NET:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy) to confirm your chosen version is still within its support window.