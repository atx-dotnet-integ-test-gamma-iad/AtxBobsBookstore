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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test output for any failures. If tests were previously written against .NET Framework-specific behavior (e.g., `HttpContext`, `ConfigurationManager`), they may require updates to align with the cross-platform .NET equivalents.

---

## 4. Validate the Data Layer (`Bookstore.Data`)

- Confirm that the database provider (e.g., Entity Framework Core) is correctly configured in the new project format.
- Check that connection strings are being read from `appsettings.json` rather than `web.config` or `app.config`, as the cross-platform .NET configuration system uses `Microsoft.Extensions.Configuration`.
- If Entity Framework Core is in use, verify that migrations are intact and apply them against a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Validate the Domain Layer (`Bookstore.Domain`)

- Review any domain models or business logic that may have relied on .NET Framework-specific types or assemblies.
- Confirm that all referenced assemblies are available in the target framework (e.g., `.NET 6`, `.NET 7`, or `.NET 8`).

---

## 6. Validate the Web Layer (`Bookstore.Web`)

- Confirm that `Program.cs` and `Startup.cs` (if applicable) are correctly configured for ASP.NET Core.
- Verify that middleware, routing, authentication, and authorization configurations are functioning as expected.
- Check that static files, views (Razor), and any bundling configurations are correctly set up.
- If the original project used `System.Web`, confirm that all usages have been replaced with their ASP.NET Core equivalents.

---

## 7. Run the Application Locally

Start the web application locally and perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application and verify that core functionality works as expected.
- Check application logs for any runtime exceptions that would not appear at compile time.
- Validate database connectivity and that data is being read and written correctly.

---

## 8. Review Configuration Files

- Ensure `appsettings.json` and `appsettings.{Environment}.json` contain all necessary configuration values previously held in `web.config`.
- Confirm that environment-specific settings (e.g., connection strings, API keys) are properly managed and not hardcoded.

---

## 9. Publish the Application

Once local validation is complete, publish the application to verify the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.