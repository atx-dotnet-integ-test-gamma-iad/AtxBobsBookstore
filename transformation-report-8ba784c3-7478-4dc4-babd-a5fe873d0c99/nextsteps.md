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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific Dependencies

Inspect `Bookstore.Data` and `Bookstore.Web` for any dependencies that are Windows-only, such as:

- `System.Web` references
- Windows Registry access
- COM interop
- `Microsoft.Web.Infrastructure`

Replace or remove any such dependencies to ensure true cross-platform compatibility.

---

## 5. Database and Entity Framework Migrations

If `Bookstore.Data` uses Entity Framework, verify the following:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Existing migrations are compatible with EF Core. Legacy EF 6 migrations are not directly compatible and may need to be regenerated:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Configuration Migration

If the project previously used `Web.config` or `App.config`, confirm that configuration has been moved to `appsettings.json`. Verify that connection strings, app settings, and environment-specific values are correctly represented:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  }
}
```

---

## 7. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release
```

Review test results for any failures that may indicate behavioral differences introduced by the migration.

---

## 8. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Manually verify the following:

- Application starts without exceptions.
- Pages load and render correctly.
- Database reads and writes function as expected.
- Authentication and authorization behave correctly, if applicable.

---

## 9. Cross-Platform Validation

If cross-platform support is a requirement, run and test the application on a non-Windows operating system (Linux or macOS) to surface any remaining platform-specific issues that may not appear during a Windows build.

---

## 10. Review Deprecated or Replaced APIs

Use the .NET Upgrade Assistant or the Roslyn analyzers to identify any API usage that is deprecated in modern .NET. Run the following if the Upgrade Assistant is installed:

```bash
upgrade-assistant analyze ./Bookstore.sln
```

Address any flagged items before considering the migration complete.