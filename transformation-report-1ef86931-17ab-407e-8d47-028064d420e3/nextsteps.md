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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

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

Verify that all three projects build without warnings or errors. Pay attention to any nullable reference warnings or obsolete API usages that may have been introduced during the transformation.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them with:

```bash
dotnet test
```

If no test projects currently exist, consider adding unit tests for the core logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` to establish a baseline for correctness.

---

## 4. Validate the Data Layer

Since `Bookstore.Data` likely depends on Entity Framework or another ORM, verify the following:

- The correct database provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Any database migrations are present and up to date. Run the following to check migration status:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations are missing or outdated, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Validate Application Configuration

Open `appsettings.json` in `Bookstore.Web` and confirm the following:

- Connection strings are correct and point to the intended database.
- Any configuration keys that were previously stored in `Web.config` have been properly migrated to `appsettings.json`.
- Environment-specific settings are placed in `appsettings.Development.json` or `appsettings.Production.json` as appropriate.

---

## 6. Run the Web Application Locally

Start the application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the URL printed in the console output (typically `https://localhost:5001` or `http://localhost:5000`).
- Exercise the main workflows of the application, such as browsing, searching, and managing books, to confirm that core functionality is intact.
- Check the console and browser developer tools for any runtime exceptions or missing static assets.

---

## 7. Review Middleware and Startup Configuration

In `Bookstore.Web`, review `Program.cs` (and `Startup.cs` if present) to ensure:

- Middleware is registered in the correct order (e.g., `UseAuthentication` before `UseAuthorization`).
- Static files, routing, and session middleware are configured correctly.
- Any legacy `HttpModule` or `HttpHandler` equivalents have been replaced with the appropriate ASP.NET Core middleware.

---

## 8. Check for Platform-Specific Code

Search the solution for any remaining Windows-specific APIs that may not be supported cross-platform:

- `System.Web` references should no longer be present.
- Registry access, Windows-specific file paths, or COM interop calls should be replaced with cross-platform alternatives.
- Run or test the application on the target non-Windows platform if cross-platform support is a requirement.

---

## 9. Review Logging

Confirm that logging is configured in `Program.cs` using the built-in `Microsoft.Extensions.Logging` infrastructure or a compatible third-party provider such as Serilog or NLog. Remove any legacy logging frameworks that were used in the original project if they are no longer needed.

---

## 10. Publish the Application

Once validation is complete, publish the application using:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required files, static assets, and configuration files are present before deploying to the target environment.