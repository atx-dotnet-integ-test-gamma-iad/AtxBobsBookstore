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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are still present, consider replacing them with their .NET-compatible equivalents.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

- Verify that `appsettings.json` (and any environment-specific variants such as `appsettings.Development.json`) contain the correct connection strings and application settings that were previously in `Web.config` or `App.config`.
- Confirm that any configuration values that were stored in `<appSettings>` or `<connectionStrings>` sections have been properly migrated to the new configuration system.

---

## 4. Verify Entity Framework or Data Layer

Since the solution contains a `Bookstore.Data` project, confirm the following:

- The correct version of Entity Framework (EF Core) is referenced.
- The `DbContext` configuration is using the new `OnConfiguring` or `AddDbContext` pattern appropriate for .NET.
- If migrations are used, run the following to verify the migration state:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If the database schema needs to be updated:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to verify runtime behavior.

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

- Navigate through the application and verify that core functionality such as browsing, searching, and any data operations work as expected.
- Check the console output and application logs for any runtime exceptions or unhandled errors.

---

## 6. Execute Automated Tests

If the solution contains test projects, run them to validate business logic and data access behavior.

```bash
dotnet test
```

If no automated tests exist, consider writing basic integration or unit tests for the `Bookstore.Domain` and `Bookstore.Data` layers to establish a baseline before deploying.

---

## 7. Inspect Static Assets and Middleware

For the `Bookstore.Web` project:

- Confirm that static files (CSS, JavaScript, images) are being served correctly via the `UseStaticFiles` middleware.
- Verify that any HTTP modules or HTTP handlers from the legacy project have been replaced with the equivalent ASP.NET Core middleware.
- Check that authentication and authorization configurations have been correctly migrated.

---

## 8. Publish the Application

Once local validation is complete, publish the application to a target folder for deployment.

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all necessary files, including configuration files and static assets, are present before deploying to the target environment.