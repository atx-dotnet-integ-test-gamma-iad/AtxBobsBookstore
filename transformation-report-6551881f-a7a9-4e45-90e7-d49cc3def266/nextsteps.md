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

Perform a full solution build to confirm there are no build-time issues:

```bash
dotnet build --configuration Release
```

Ensure the output shows zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding unit tests for the core logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

---

## 4. Verify Data Layer

Since `Bookstore.Data` handles data access, verify the following:

- **Database provider**: Confirm the correct EF Core provider (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql`, or `Sqlite`) is referenced and configured.
- **Migrations**: If Entity Framework Core is used, check that existing migrations are intact and apply them against a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- **Connection strings**: Confirm that connection strings in `appsettings.json` are correct for the target environment.

---

## 5. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:
- The application starts without runtime exceptions.
- Pages or API endpoints load as expected.
- Database reads and writes function correctly.
- Any authentication or session handling works as intended.

---

## 6. Review `appsettings.json` and Environment Configuration

Cross-platform .NET uses `appsettings.json` and environment variables for configuration. Verify:

- Any previously used `Web.config` or `App.config` values have been migrated to `appsettings.json`.
- Environment-specific settings (e.g., `appsettings.Development.json`) are in place.
- Secrets are not stored in source-controlled files; use `dotnet user-secrets` for local development:

```bash
dotnet user-secrets init --project Bookstore.Web
dotnet user-secrets set "ConnectionStrings:Default" "your_connection_string"
```

---

## 7. Check for Platform-Specific Code

Review the codebase for any APIs that were available in .NET Framework but are not available or behave differently in cross-platform .NET, including:

- `System.Web` references (should have been removed).
- Windows-specific APIs such as the registry, `System.Drawing` (GDI+), or COM interop.
- Any use of `HttpContext` that may need to be updated to use `IHttpContextAccessor`.

---

## 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required assets, configuration files, and binaries are present before deploying to the target environment.