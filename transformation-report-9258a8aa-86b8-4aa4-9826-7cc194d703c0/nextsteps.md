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

The steps below describe how to validate, test, and deploy the migrated solution.

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

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting a consistent framework version to avoid interoperability issues.

---

## 4. Check for Windows-Specific Dependencies

Review the dependencies in each project for any packages or APIs that are Windows-only. Common areas to check include:

- **`Bookstore.Data`**: Verify that the database provider (e.g., Entity Framework Core) is configured for cross-platform use. If SQL Server is used, confirm the connection string and provider are compatible.
- **`Bookstore.Web`**: Check that no Windows-specific middleware or authentication providers (e.g., Windows Authentication, MSMQ) are in use unless explicitly required.
- **`Bookstore.Domain`**: This layer is typically platform-agnostic, but confirm no platform-specific serialization or file path logic exists.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider adding one targeting the `Bookstore.Domain` and `Bookstore.Data` projects to establish a baseline before further changes are made.

---

## 6. Validate Database Migrations

If Entity Framework Core is used in `Bookstore.Data`, verify that existing migrations are compatible with the new framework version:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or inconsistent, generate a new migration to reflect the current model state:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

Apply the migrations to a development database to confirm they execute without errors:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the web application and verify it runs correctly on the local development machine:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, managing inventory) to confirm end-to-end functionality.

---

## 8. Test on a Non-Windows Platform (If Required)

If cross-platform support is a requirement, run the application on a Linux or macOS environment to confirm there are no platform-specific runtime issues. Pay particular attention to:

- File path separators
- Case-sensitive file and directory references
- Any remaining use of `System.Windows` or `Microsoft.Win32` namespaces

---

## 9. Review Configuration Files

Confirm that `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) are present and correctly structured. Verify that connection strings and any other environment-specific values are accurate for the target environment.