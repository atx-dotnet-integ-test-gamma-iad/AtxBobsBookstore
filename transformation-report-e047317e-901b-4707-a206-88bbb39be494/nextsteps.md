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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no errors or warnings that may have been missed:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported modern .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, review the projects for any remaining Windows-specific APIs or packages. Common areas to check:

- `Bookstore.Data`: Verify that the database provider (e.g., Entity Framework Core) is configured with a cross-platform compatible provider such as `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql`.
- `Bookstore.Web`: Check that middleware, authentication, and session configuration do not rely on Windows-only libraries such as `System.Web`.
- Any use of `Registry`, `WindowsIdentity`, or Windows file path assumptions (`C:\...`) should be replaced with cross-platform equivalents.

---

## 5. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release
```

If no test projects currently exist, consider adding tests for the core logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before deploying.

---

## 6. Validate Database Migrations

If Entity Framework Core is used in `Bookstore.Data`, verify that existing migrations are compatible with the new setup:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of date, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

Apply migrations to a test database before touching any production data:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Application Locally

Start the web application locally to perform a manual smoke test:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that core functionality such as browsing, authentication, and data retrieval works as expected.

---

## 8. Review Configuration Files

Check `appsettings.json` and `appsettings.Development.json` in `Bookstore.Web` for the following:

- Connection strings are correct and do not reference legacy or environment-specific paths.
- Any configuration previously stored in `Web.config` has been fully migrated to `appsettings.json`.
- Logging, environment settings, and feature flags are properly defined.

---

## 9. Confirm Static Assets and Razor Views

If the web project uses Razor views or static assets, confirm they render correctly when running locally. Pay particular attention to:

- Bundling and minification configuration, which may have changed from the legacy `BundleConfig` approach to a tool such as `libman` or a Node-based pipeline.
- Tag Helpers and Razor syntax compatibility with the current ASP.NET Core version.