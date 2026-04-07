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

The following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check their respective NuGet pages for recommended replacements compatible with the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

Cross-platform .NET projects rely on `appsettings.json` rather than `Web.config` or `App.config`. Verify the following:

- `appsettings.json` and `appsettings.Development.json` exist in `Bookstore.Web` and contain the correct connection strings and application settings.
- Any environment-specific configuration previously held in `Web.config` transforms has been migrated to the appropriate `appsettings.{Environment}.json` files.
- The `Bookstore.Data` project's database connection string is correctly referenced from configuration and not hardcoded.

---

## 4. Verify Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm the following:

- If using Entity Framework Core, verify that the correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Run any pending migrations or verify the database schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If the project uses a different data access strategy, confirm that connection management and query execution behave correctly under the new runtime.

---

## 5. Run Unit and Integration Tests

If the solution contains a test project, execute all tests to validate business logic and data access behavior:

```bash
dotnet test
```

If no test project currently exists, consider writing tests that cover:

- Domain model validation logic in `Bookstore.Domain`
- Repository or data access methods in `Bookstore.Data`
- Key controller actions or middleware in `Bookstore.Web`

---

## 6. Run the Application Locally

Start the web application locally and verify core functionality:

```bash
dotnet run --project Bookstore.Web
```

Manually test the following areas:

- Application startup and home page load
- Database connectivity and data retrieval
- Any authentication or authorization flows
- Form submissions and data writes
- Error handling and logging output

---

## 7. Check Logging and Error Handling

Confirm that logging is configured correctly in `Program.cs` or `Startup.cs` using `Microsoft.Extensions.Logging`. Verify that unhandled exceptions are surfaced appropriately and that log output is visible during local runs.

---

## 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.