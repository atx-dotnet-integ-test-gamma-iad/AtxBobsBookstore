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

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release --verbosity normal
```

- Verify that all previously passing tests continue to pass.
- If tests were written against framework-specific behavior (e.g., `System.Web`, `HttpContext`), review those tests for compatibility with the ASP.NET Core equivalents.

---

## 4. Validate the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework Core (or whichever ORM is in use) migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Verify that connection strings in `appsettings.json` are correctly configured for the target database.

---

## 5. Validate the Domain Layer (`Bookstore.Domain`)

- Review all domain models and ensure no types rely on assemblies that were part of the .NET Framework but are unavailable or changed in cross-platform .NET (e.g., `System.Drawing`, `System.Web`).
- Confirm that any serialization attributes or data annotations still behave as expected under the new runtime.

---

## 6. Validate the Web Layer (`Bookstore.Web`)

- Run the web application locally:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application and verify:
  - Routing behaves as expected.
  - Authentication and authorization flows work correctly.
  - Forms, model binding, and validation function properly.
  - Static files (CSS, JavaScript, images) are served correctly.

- Check `appsettings.json` and `appsettings.Production.json` to ensure all configuration values (connection strings, API keys, logging settings) are present and accurate.

---

## 7. Review Middleware and Startup Configuration

- Open `Program.cs` (or `Startup.cs` if still present) and confirm that all middleware is registered in the correct order.
- Ensure that any custom HTTP modules or HTTP handlers from the legacy project have been properly converted to ASP.NET Core middleware.

---

## 8. Check Logging

- Verify that the logging configuration in `appsettings.json` is set appropriately for both development and production environments.
- Confirm that log output appears as expected when running the application locally.

---

## 9. Prepare for Deployment

- Publish the application using:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

- Review the contents of the `./publish` folder to confirm all necessary files are present.
- Verify that the target runtime environment has the appropriate .NET runtime version installed.
- Confirm that environment-specific configuration (e.g., production connection strings) is supplied via environment variables or a secrets manager rather than being hardcoded.