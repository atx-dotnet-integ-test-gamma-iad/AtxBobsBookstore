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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net472` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect the projects for any APIs or packages that are Windows-only. Common areas to check include:

- **`Bookstore.Data`**: Verify that the data access layer (e.g., Entity Framework Core) is using a cross-platform database provider. If `System.Data.SqlClient` is present, consider replacing it with `Microsoft.Data.SqlClient`.
- **`Bookstore.Web`**: Confirm that no Windows-specific middleware or authentication mechanisms (e.g., Windows Authentication, MSMQ) are in use unless intentionally required.
- **`Bookstore.Domain`**: This layer is typically platform-agnostic, but verify there are no references to `System.Web` or other legacy namespaces.

---

## 5. Run the Application Locally

Start the web application to verify it runs correctly in the new runtime.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing books, managing inventory, or any other core features, to confirm expected behavior.

---

## 6. Verify Database Connectivity

If the application uses Entity Framework Core, verify that migrations are up to date and the database schema is consistent.

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations are missing or out of sync, generate a new migration and apply it.

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data --startup-project app/Bookstore.Web
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 7. Execute Existing Tests

If the solution contains test projects, run them to validate that business logic and data access behavior remain correct after migration.

```bash
dotnet test
```

Review the test output for any failures. Pay particular attention to tests covering data access, domain logic, and any integration points.

---

## 8. Validate Configuration Files

Confirm that `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) are correctly structured and contain the necessary connection strings and application settings. The legacy `Web.config` and `App.config` files are not used in modern .NET and their relevant settings should have been migrated to `appsettings.json`.

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.