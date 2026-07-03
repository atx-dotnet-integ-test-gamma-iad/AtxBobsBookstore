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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, modern version of .NET (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid cross-project compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect each project for any remaining Windows-specific APIs or packages. Common areas to check:

- **`Bookstore.Data`**: Verify that the database provider (e.g., Entity Framework Core) is configured for cross-platform use. Avoid SQL Server LocalDB in favor of a full SQL Server instance or SQLite for local testing.
- **`Bookstore.Web`**: Check that no Windows-specific middleware or IIS-specific configurations are being used exclusively. Kestrel should be the primary web server.
- **`Bookstore.Domain`**: Review any file path handling to ensure `Path.Combine` is used instead of hardcoded backslashes.

---

## 5. Run Database Migrations

If the project uses Entity Framework Core, verify that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit Tests

If the solution contains a test project, run all tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release
```

Review any failing tests, as they may indicate behavioral differences introduced during the migration.

---

## 7. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Verify the following:

- The application starts without runtime exceptions.
- All pages and routes load correctly.
- Database read and write operations function as expected.
- Authentication and authorization flows work if applicable.

---

## 8. Review Configuration Files

Check `appsettings.json` and `appsettings.Development.json` for any configuration values that may have been carried over from the legacy project and are no longer valid, such as:

- Connection strings referencing Windows-only data sources.
- Paths using Windows-style directory separators.
- Legacy ASP.NET-specific keys that are not applicable to ASP.NET Core.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Inspect the `./publish` directory to ensure all required files, including static assets and configuration files, are present.