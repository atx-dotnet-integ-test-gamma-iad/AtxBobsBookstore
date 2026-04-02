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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages are flagged, consider updating them to versions compatible with the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay particular attention to any warnings about obsolete APIs, as these may indicate areas that need further modernization.

---

## 3. Review Configuration Files

Cross-platform .NET projects handle configuration differently from legacy .NET Framework projects. Verify the following:

- `appsettings.json` is present in `Bookstore.Web` and contains the correct connection strings and application settings.
- Any settings that were previously in `Web.config` or `App.config` have been correctly migrated to `appsettings.json` or `appsettings.{Environment}.json`.
- Environment-specific configuration (e.g., `appsettings.Development.json`) is in place where needed.

---

## 4. Verify the Data Layer

Since `Bookstore.Data` depends on `Bookstore.Domain`, confirm the following:

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) is referenced and up to date.
- Any existing migrations are present under the `Migrations` folder.
- If migrations are missing or outdated, run the following to generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to verify it runs as expected.

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the URL shown in the console output (typically `https://localhost:{port}`).
- Confirm that the application loads without runtime errors.
- Check the browser console and application logs for any unhandled exceptions.

---

## 6. Execute Existing Tests

If the solution contains a test project, run all tests to validate that existing functionality has not regressed.

```bash
dotnet test
```

Review the test results and investigate any failures. If no test project exists, consider adding unit tests for the core domain logic in `Bookstore.Domain` and integration tests for `Bookstore.Data`.

---

## 7. Check for Remaining Platform-Specific Code

Search the codebase for any APIs or patterns that were specific to .NET Framework and may not behave correctly on cross-platform .NET:

- `System.Web` references (these are not available in cross-platform .NET).
- `HttpContext` usage outside of the standard ASP.NET Core request pipeline.
- Windows-specific APIs such as the registry, `System.Drawing` (GDI+), or COM interop.
- Any use of `BinaryFormatter`, which is disabled by default in modern .NET.

Use the following command to search for potentially problematic namespaces:

```bash
grep -rn "System.Web" --include="*.cs" .
```

Address any findings before considering the migration complete.

---

## 8. Review Target Framework

Confirm that all projects are targeting the intended .NET version by inspecting each `.csproj` file. For example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is still targeting `net48` or another legacy framework, update the `TargetFramework` property accordingly and re-run the build.