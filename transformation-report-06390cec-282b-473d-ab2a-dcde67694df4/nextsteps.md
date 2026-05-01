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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or warnings that could indicate runtime issues.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects are targeting the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET. Pay particular attention to the following areas:

- **`Bookstore.Data`**: If Entity Framework is used, confirm the project is using `Microsoft.EntityFrameworkCore` rather than `System.Data.Entity`. Run any pending migrations if applicable:
  ```bash
  dotnet ef database update --project Bookstore.Data
  ```
- **`Bookstore.Web`**: If this was previously an ASP.NET Web Forms or MVC project targeting .NET Framework, verify that all middleware, routing, and authentication configurations have been updated to the ASP.NET Core equivalents.
- **`Bookstore.Domain`**: Check for any use of `System.Configuration.ConfigurationManager` or other .NET Framework-specific libraries that may have been replaced.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate business logic and data access behavior:

```bash
dotnet test
```

If no test project exists, consider manually verifying core domain logic and data access operations before proceeding.

---

## 6. Run the Application Locally

Start the web application locally to confirm it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Verify the following:
- The application starts without runtime exceptions.
- Pages or API endpoints load correctly.
- Database connectivity is functional (check connection strings in `appsettings.json`).
- Authentication and authorization behave as expected.

---

## 7. Review Configuration Files

In .NET Framework projects, configuration was handled via `Web.config` or `App.config`. In cross-platform .NET, this is replaced by `appsettings.json`. Confirm:

- All connection strings have been moved to `appsettings.json`.
- Environment-specific settings are handled using `appsettings.Development.json` or environment variables.
- No sensitive values are hardcoded in configuration files.

---

## 8. Validate Data Access and Database Schema

If the application uses a database, confirm the schema is consistent with what the migrated code expects:

- Run the application against a test or development database.
- Verify that all CRUD operations function correctly.
- If using Entity Framework Core, confirm that the model matches the existing schema or apply migrations as needed.

---

## 9. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets and configuration files.