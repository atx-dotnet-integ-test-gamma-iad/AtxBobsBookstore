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

- Verify that all previously passing tests continue to pass.
- If tests are failing, compare the behavior against the original legacy project to determine if the failures are pre-existing or introduced by the migration.

---

## 4. Validate the Data Layer (`Bookstore.Data`)

- Confirm that the database provider package (e.g., Entity Framework Core, Dapper) is compatible with the target .NET version.
- If Entity Framework Core is in use, verify that any pending migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data
dotnet ef database update --project Bookstore.Data
```

- Test all database read and write operations to confirm data access behavior is consistent with the legacy version.

---

## 5. Validate the Domain Layer (`Bookstore.Domain`)

- Review all domain models, interfaces, and business logic classes to confirm they behave as expected.
- Pay particular attention to any types that previously relied on `System.Web` or other Windows-specific namespaces, as these would not be available in cross-platform .NET.

---

## 6. Validate the Web Layer (`Bookstore.Web`)

- Run the web application locally:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application and verify that all pages, routes, and API endpoints respond correctly.
- Check the following areas specifically:
  - Authentication and authorization behavior
  - Static file serving (CSS, JavaScript, images)
  - Form submissions and model binding
  - Any HTTP handlers or modules that may have been migrated from `System.Web` to ASP.NET Core middleware

---

## 7. Review Configuration Files

- Confirm that `appsettings.json` contains all necessary configuration values that were previously in `Web.config` or `App.config`.
- Verify that connection strings, application settings, and environment-specific values are correctly defined.
- If environment-specific configuration is needed, ensure `appsettings.Development.json` and `appsettings.Production.json` are properly set up.

---

## 8. Check Logging and Error Handling

- Confirm that the logging framework is configured correctly in `Program.cs` or `Startup.cs`.
- Run the application and intentionally trigger error conditions to verify that exceptions are handled and logged as expected.

---

## 9. Publish the Application

Once validation is complete, publish the application using the following command:

```bash
dotnet publish --configuration Release --output ./publish
```

- Review the contents of the `./publish` directory to confirm all required files are present.
- Deploy the published output to the target hosting environment (e.g., IIS, Linux server, Azure App Service).

---

## 10. Post-Deployment Smoke Test

After deploying to the target environment:

- Verify the application starts without errors by checking the application logs.
- Confirm that the database connection is established successfully.
- Test the critical user-facing workflows to ensure end-to-end functionality is intact.