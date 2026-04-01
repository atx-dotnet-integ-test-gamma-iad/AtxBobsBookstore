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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs introduced during the migration.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure consistency across all three projects.

---

## 4. Run Unit Tests

If the solution contains a test project, execute the tests to verify that business logic and data access behavior remain intact after migration:

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider adding one targeting critical areas such as domain logic in `Bookstore.Domain` and data access in `Bookstore.Data`.

---

## 5. Validate Database Connectivity and Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that your migrations are up to date and compatible with the new framework version:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, add a new migration:

```bash
dotnet ef migrations add PostMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the displayed local URL and manually test core functionality such as browsing, searching, and any data entry workflows.

---

## 7. Review Configuration Files

Check `appsettings.json` and `appsettings.Development.json` in `Bookstore.Web` to ensure:

- Connection strings are correct for the target environment.
- Any configuration keys previously stored in `Web.config` have been properly migrated to the new JSON-based configuration system.
- Environment-specific settings are separated appropriately.

---

## 8. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, audit the codebase for any remaining Windows-specific APIs, such as:

- `Microsoft.Win32` namespace usage
- Windows registry access
- Windows-only file path assumptions (e.g., hardcoded backslashes)

Use `Path.Combine` and `Path.DirectorySeparatorChar` where file paths are constructed manually.

---

## 9. Test on a Non-Windows Platform (Optional but Recommended)

To fully validate cross-platform compatibility, run the application on Linux or macOS if the target deployment environment is non-Windows:

```bash
dotnet run --project Bookstore.Web
```

This will surface any remaining platform-specific issues that may not appear on Windows.