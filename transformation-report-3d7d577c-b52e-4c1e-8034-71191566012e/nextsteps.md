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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check NuGet for updated versions compatible with the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues beyond what was reported.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without errors or unexpected warnings.

---

## 3. Review Configuration Files

Cross-platform .NET projects handle configuration differently than legacy .NET Framework projects.

- Confirm that `appsettings.json` (and `appsettings.Development.json` if present) contains the correct connection strings and application settings that were previously in `Web.config` or `App.config`.
- Verify that any environment-specific configuration values are correctly set.
- Check that `Bookstore.Data` is pointing to the correct database provider and connection string.

---

## 4. Verify the Database Layer

Since `Bookstore.Data` handles data access, confirm the following:

- If Entity Framework is used, verify the correct EF Core version is referenced and that the `DbContext` is properly configured.
- Run any pending migrations to ensure the database schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If the project uses a database initializer or seed data, confirm it executes correctly on startup.

---

## 5. Run the Application Locally

Start the web application locally to perform a basic smoke test.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application URL shown in the console output.
- Verify that the home page loads without errors.
- Test core functionality such as browsing, searching, and any data-driven pages to confirm the data layer is functioning correctly.

---

## 6. Run Existing Tests

If the solution contains test projects, run them to validate that existing behavior has been preserved after the migration.

```bash
dotnet test
```

Review the test results for any failures. Failures may indicate behavioral differences introduced by the migration to cross-platform .NET that require attention.

---

## 7. Check for Platform-Specific Code

Review the codebase for any APIs or libraries that were available in .NET Framework but are not available or behave differently in cross-platform .NET. Common areas to check include:

- `System.Web` references, which are not available in cross-platform .NET and should have been replaced during transformation.
- Windows-specific APIs such as the registry, Windows Identity, or COM interop.
- Any third-party libraries that may still target .NET Framework only.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tool to identify any remaining compatibility concerns.

---

## 8. Validate Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting a consistent and supported version of .NET.

---

## 9. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets and configuration files.