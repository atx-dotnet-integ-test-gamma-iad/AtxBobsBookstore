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

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Search the codebase for any APIs or packages that are Windows-only, as these would not have caused build errors but could cause runtime failures on non-Windows platforms. Common areas to check include:

- Use of `Microsoft.Win32` or `System.Windows` namespaces
- Registry access
- Windows-specific file path assumptions (e.g., backslashes)
- Any remaining references to `System.Web`

---

## 5. Database Migration Validation (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify that any existing migrations are compatible with the new framework version:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If the database schema needs to be updated, apply migrations against a development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests to validate that the migrated logic behaves as expected:

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider adding one targeting the `Bookstore.Domain` and `Bookstore.Data` projects to cover core business logic and data access.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project and verify it runs correctly on the local development machine:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Confirm the following:

- The application starts without runtime exceptions
- All pages load and render correctly
- Database connectivity is functional
- Any authentication or authorization flows work as expected

---

## 8. Review Configuration Files

Ensure that `appsettings.json` (and environment-specific variants such as `appsettings.Production.json`) contain the correct configuration values. Pay particular attention to:

- Connection strings
- Any settings that previously resided in `Web.config` or `App.config` that may need to be migrated to the new configuration system

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and dependencies are present before deploying to the target environment.