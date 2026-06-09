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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay particular attention to:
- Any remaining references to `System.Web` or other Windows-only namespaces.
- Any use of `App.config` or `Web.config` that may need to be migrated to `appsettings.json`.

---

## 3. Review Configuration Files

Cross-platform .NET uses `appsettings.json` instead of `Web.config` or `App.config`. Confirm the following:

- `Bookstore.Web` has a valid `appsettings.json` with connection strings and application settings.
- Any configuration previously in `Web.config` (e.g., connection strings, app settings, HTTP handlers) has been moved appropriately.
- `Startup.cs` or `Program.cs` is correctly wiring up configuration, services, and middleware.

---

## 4. Verify the Data Layer

In `Bookstore.Data`, confirm the following:

- The database context (e.g., Entity Framework `DbContext`) is registered correctly in the dependency injection container.
- Connection strings in `appsettings.json` match what the data layer expects.
- Any database migrations are up to date. Run the following to apply pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations do not exist yet, generate an initial migration:

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

Check the following at runtime:
- The application starts without exceptions.
- Database connectivity is established.
- Core pages and routes load correctly.
- Any authentication or authorization middleware behaves as expected.

---

## 6. Execute Unit and Integration Tests

If the solution contains test projects, run them to validate business logic and data access behavior.

```bash
dotnet test
```

Review test results for any failures that may indicate behavioral regressions introduced during migration. If no tests currently exist, consider writing tests for the core domain logic in `Bookstore.Domain` and the data access methods in `Bookstore.Data`.

---

## 7. Validate Runtime Behavior

Manually verify the following areas of the application:

- **CRUD operations**: Create, read, update, and delete operations for books and related entities function correctly.
- **Routing**: All expected URLs resolve to the correct controllers and views.
- **Error handling**: Custom error pages or middleware handle exceptions gracefully.
- **Logging**: Confirm that logging (e.g., via `ILogger`) is configured and producing output as expected.

---

## 8. Publish the Application

Once validation is complete, publish the application to a target directory.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` folder to confirm all required files are present, including static assets, configuration files, and binaries. Deploy the contents of this folder to your target hosting environment (e.g., IIS, Azure App Service, or a Linux server with the .NET runtime installed).