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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check their respective NuGet pages for recommended replacements targeting the current .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or warnings that could indicate runtime issues.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Confirm the following:

- Connection strings and application settings have been moved to `appsettings.json` and/or `appsettings.{Environment}.json`.
- Any environment-specific configuration (e.g., development vs. production database connections) is correctly structured using the `Microsoft.Extensions.Configuration` system.
- Sensitive values such as connection strings are not hardcoded and are managed via environment variables or a secrets manager (e.g., `dotnet user-secrets` for local development).

```bash
dotnet user-secrets init --project app/Bookstore.Web
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "your_connection_string"
```

---

## 4. Verify Database Connectivity (Bookstore.Data)

If the project uses Entity Framework Core, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql.EntityFrameworkCore.PostgreSQL`).
- Migrations are present and up to date.

List existing migrations:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If migrations are missing or outdated, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

Apply migrations to the database:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and confirm it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web
```

Navigate to the URL shown in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and verify that the application loads correctly.

---

## 6. Execute Unit and Integration Tests

If the solution contains test projects, run all tests to confirm existing functionality has not regressed during the migration.

```bash
dotnet test
```

Review the test output for any failures. Pay particular attention to tests that cover data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`, as these layers are most likely to be affected by a framework migration.

---

## 7. Check for Removed or Changed APIs

Some .NET Framework APIs are not available or have changed in cross-platform .NET. Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` compatibility shim where needed. You can also run the following to check for known compatibility issues:

```bash
dotnet add package Microsoft.Windows.Compatibility
```

Only add this package if specific Windows-only APIs are required. Prefer cross-platform alternatives where possible.

---

## 8. Publish the Application

Once the application has been validated locally, publish it to prepare for deployment.

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including `appsettings.json` and any static assets.