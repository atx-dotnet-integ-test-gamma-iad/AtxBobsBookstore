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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the transformation.

---

## 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review the test results carefully. Any failing tests should be investigated to determine whether they indicate a regression introduced by the migration or a pre-existing issue.

---

## 4. Verify Entity Framework Core Configuration

Since the solution includes a `Bookstore.Data` project, confirm that the Entity Framework Core setup is correct:

- Verify that the `DbContext` is properly configured in `Program.cs` or `Startup.cs` using `AddDbContext`.
- Confirm the correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Run the following command to check that existing migrations are compatible with the current model:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If the model has changed during migration, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

Apply the migration to the database:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 5. Review Configuration Files

- Confirm that `appsettings.json` and `appsettings.Development.json` contain the correct connection strings and application settings.
- If the legacy project used `Web.config` or `App.config`, verify that all relevant settings have been moved to `appsettings.json` and are being read via `IConfiguration`.

---

## 6. Run the Application Locally

Start the web application locally to perform a manual smoke test:

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that core functionality such as page rendering, data retrieval, and form submissions work as expected.

---

## 7. Check for Platform-Specific Code

Review the codebase for any remaining Windows-specific APIs or dependencies that may cause issues on Linux or macOS if cross-platform support is required. Common areas to check include:

- File path separators — use `Path.Combine` rather than hardcoded backslashes.
- Registry access — not available on non-Windows platforms.
- Windows Authentication — requires additional configuration on non-Windows hosts.

---

## 8. Review Target Framework

Confirm that all projects are targeting the intended .NET version by inspecting each `.csproj` file for the `<TargetFramework>` element, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web`.