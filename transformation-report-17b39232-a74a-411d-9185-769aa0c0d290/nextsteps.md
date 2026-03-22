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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build output shows zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Windows-Specific Dependencies

Inspect `Bookstore.Data` and `Bookstore.Web` for any dependencies that are Windows-only, such as:

- `System.Web` references
- Windows Registry access
- COM interop
- `Microsoft.Web.Infrastructure`

If any are found, replace them with cross-platform equivalents or remove them if they are no longer needed.

---

## 5. Review Entity Framework or Data Access Configuration

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Any migrations are present and up to date.
- The connection string is configured via `appsettings.json` rather than `Web.config` or `App.config`.

Run any pending migrations if applicable:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Validate Application Configuration

Confirm that `Bookstore.Web` uses `appsettings.json` for configuration rather than the legacy `Web.config` file. Verify that:

- Connection strings are present and correct.
- Any environment-specific settings are separated into `appsettings.Development.json` or similar files.
- The `Web.config` file, if still present, does not contain application settings that are being actively used.

---

## 7. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing books, to confirm that the data layer and domain logic are functioning correctly.

---

## 8. Run Existing Tests

If the solution contains any test projects, execute them to validate that existing behavior has been preserved after the migration.

```bash
dotnet test
```

Review the test results for any failures that may indicate behavioral regressions introduced during the transformation.

---

## 9. Publish the Application

Once the application has been validated locally, publish it to a self-contained or framework-dependent deployment package.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.