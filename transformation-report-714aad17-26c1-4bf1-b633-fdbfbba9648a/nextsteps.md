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

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review the test results for any failures that may indicate behavioral regressions introduced during the migration.

---

## 4. Validate the Data Layer

Since `Bookstore.Data` likely contains database access logic (e.g., Entity Framework Core), verify the following:

- **Connection strings** in `appsettings.json` or `appsettings.Development.json` are correctly configured for the target environment.
- If Entity Framework is used, confirm that migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If the schema needs to be updated, apply migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and verify that core functionality works as expected.
- Check application startup logs for any runtime errors or misconfigurations.
- Verify that environment-specific configuration (e.g., `appsettings.Development.json`) is loading correctly.

---

## 6. Review Middleware and Startup Configuration

Open `Program.cs` (or `Startup.cs` if still present) in `Bookstore.Web` and confirm the following:

- Middleware is registered in the correct order.
- Services such as dependency injection registrations, authentication, and authorization are correctly configured for the new hosting model.
- Any legacy `HttpModule` or `HttpHandler` equivalents have been properly replaced with ASP.NET Core middleware.

---

## 7. Check for Platform-Specific Code

Search the solution for any remaining Windows-specific APIs or packages that may cause issues on non-Windows platforms:

- Look for usages of `Microsoft.Win32`, `System.Drawing`, or COM interop.
- Replace or abstract any platform-specific implementations as needed.

---

## 8. Publish the Application

Once local validation is complete, publish the application to a target folder:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.