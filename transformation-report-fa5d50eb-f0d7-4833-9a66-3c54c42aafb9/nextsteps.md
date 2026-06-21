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

Address any warnings that may surface, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no tests currently exist, consider writing basic tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

Since the solution includes a `Bookstore.Data` project, confirm that any Entity Framework Core migrations are up to date and compatible with the target database:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If migrations are missing or outdated, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

Apply pending migrations to the database:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application locally to verify that it runs correctly end-to-end:

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Navigate to the URL indicated in the console output and manually verify that core pages and features load and function as expected.

---

## 6. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files (e.g., `appsettings.Development.json`) in `Bookstore.Web` to confirm the following:

- Connection strings are correct for the target environment.
- Any configuration keys that were previously in `Web.config` or `App.config` have been properly migrated to the new `appsettings.json` format.
- Sensitive values such as connection strings or API keys are stored using the appropriate secrets mechanism (e.g., `dotnet user-secrets` for local development).

---

## 7. Check for Removed or Changed APIs

Review the code in all three projects for usage of any APIs that were available in .NET Framework but have changed or been removed in cross-platform .NET. Common areas to check include:

- `System.Web` references, which are not available in cross-platform .NET.
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core.
- Any use of `BinaryFormatter`, which is disabled by default in modern .NET.
- Windows-specific APIs that may not function on non-Windows platforms.

---

## 8. Validate Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element references the intended modern .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects are targeting the same framework version to avoid compatibility issues between them.