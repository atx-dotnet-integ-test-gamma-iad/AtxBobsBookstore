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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target a consistent framework version to avoid inter-project compatibility issues.

---

## 4. Run Unit and Integration Tests

If the solution contains a test project, execute the tests to verify that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test project currently exists, consider writing tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 5. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify that:

- The connection string in `appsettings.json` is correct for the target environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- The EF Core provider being used (e.g., SQL Server, SQLite, PostgreSQL) is compatible with the target .NET version.

---

## 6. Run the Web Application Locally

Start the web application to confirm it runs correctly on the local machine:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the displayed local URL and verify that:

- Pages load without runtime exceptions.
- Data is retrieved and displayed correctly from the database.
- Any authentication or authorization flows function as expected.

---

## 7. Review Removed Windows-Specific Dependencies

Check that no APIs or packages that were previously available only on .NET Framework remain in use. Common areas to review include:

- `System.Web` references (should be replaced with ASP.NET Core equivalents).
- Windows registry access or Windows-specific file paths.
- Any third-party libraries that have not yet released a .NET-compatible version.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) if a deeper audit is needed.

---

## 8. Test on a Non-Windows Operating System (Optional but Recommended)

Since the goal of the migration is cross-platform compatibility, validate the application on Linux or macOS if possible:

```bash
dotnet run --project Bookstore.Web
```

This will surface any remaining platform-specific assumptions in file paths, casing sensitivity, or OS-level APIs.