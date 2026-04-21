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

Review the output for any warnings related to package version mismatches or deprecated packages that may need to be updated.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or target framework compatibility.

---

## 3. Verify Target Frameworks

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker unless there is a specific reason to do so.

---

## 4. Check for Windows-Specific Dependencies

Review the NuGet packages and code in all three projects for any APIs or libraries that are Windows-only. Common areas to check include:

- **`Bookstore.Data`**: Confirm the database provider (e.g., Entity Framework Core) is configured for cross-platform use. If SQL Server is used, ensure the connection string and provider are compatible with the target environment.
- **`Bookstore.Web`**: Check for any use of `System.Web`, Windows Authentication, or MSMQ, which are not available on cross-platform .NET.
- **`Bookstore.Domain`**: Verify no Windows Registry or COM interop calls exist.

---

## 5. Run Database Migrations

If the project uses Entity Framework Core, verify that existing migrations are compatible with the new setup and apply them against a test database.

```bash
dotnet ef migrations list --project app/Bookstore.Data
dotnet ef database update --project app/Bookstore.Data
```

If migrations were generated under the legacy framework, review them for any provider-specific SQL that may need adjustment.

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Navigate through the key areas of the application to confirm:

- Pages load without exceptions
- Database reads and writes function correctly
- Any authentication or authorization flows behave as expected

---

## 7. Execute Existing Tests

If the solution contains test projects, run them to validate that business logic and data access behavior remain correct after the migration.

```bash
dotnet test
```

Review any failing tests to determine whether they indicate a regression introduced during migration or a test that requires updating due to framework differences.

---

## 8. Review Configuration Files

Cross-platform .NET uses `appsettings.json` rather than `Web.config` or `App.config`. Confirm that:

- All connection strings have been moved to `appsettings.json` or environment-specific variants (e.g., `appsettings.Production.json`).
- Any configuration keys previously read via `ConfigurationManager` are now accessed through `IConfiguration`.
- Sensitive values such as connection strings or API keys are not committed to source control and are instead managed through environment variables or a secrets manager.

---

## 9. Publish the Application

Once the application has been validated locally, publish it for deployment.

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.