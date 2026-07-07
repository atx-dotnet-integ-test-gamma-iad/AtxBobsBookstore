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

Ensure the build completes with zero errors and review any warnings that may indicate compatibility concerns.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them with the following command:

```bash
dotnet test --configuration Release --verbosity normal
```

Review the test results carefully. Any failing tests should be investigated to determine whether they are caused by behavioral differences introduced during the migration.

---

## 4. Verify Database Connectivity and Migrations

Since the solution includes a `Bookstore.Data` project, verify that the data layer is functioning correctly:

- Confirm that the connection string in your configuration file (e.g., `appsettings.json`) points to the correct database.
- If the project uses Entity Framework Core, apply any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If the project was migrated from Entity Framework 6, confirm that the migration to EF Core was handled and that all `DbContext` configurations, relationships, and queries behave as expected.

---

## 5. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application and verify that core functionality such as browsing, searching, and managing books works as expected.
- Check the application logs for any runtime exceptions or warnings.

---

## 6. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` for application configuration. Confirm the following:

- All settings previously in `Web.config` or `App.config` have been moved to `appsettings.json` or `appsettings.{Environment}.json`.
- Environment-specific configuration (e.g., development vs. production connection strings) is correctly structured.
- Any configuration sections that relied on `System.Configuration` have been updated to use `Microsoft.Extensions.Configuration`.

---

## 7. Validate Static Files and Razor Views

If `Bookstore.Web` uses Razor views or serves static files:

- Confirm that static files (CSS, JavaScript, images) are located in the `wwwroot` folder.
- Verify that Razor views render correctly and that any Tag Helpers or HTML Helpers function as expected.
- Check that the middleware pipeline in `Program.cs` or `Startup.cs` includes `UseStaticFiles()` and other required middleware.

---

## 8. Publish the Application

Once validation is complete, publish the application to a target folder:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` folder and confirm all required files are present before deploying to the target environment.