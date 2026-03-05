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

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, consider updating them to versions that explicitly support the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Even without build errors, runtime issues can arise from APIs that are Windows-only. Use the .NET Compatibility Analyzer to surface these:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

Look for `CA1416` warnings, which indicate platform-specific API usage. Any such APIs in `Bookstore.Data` or `Bookstore.Domain` should be replaced with cross-platform alternatives.

---

## 5. Review Configuration Files

- Confirm that `appsettings.json` in `Bookstore.Web` contains the correct connection strings and application settings for the new environment.
- If the original project used `Web.config` or `App.config`, verify that all relevant settings have been migrated to `appsettings.json` or environment variables.
- Check that any configuration transformations previously handled by `Web.config` transforms are now handled via `appsettings.{Environment}.json` files.

---

## 6. Database Migration Check

If the project uses Entity Framework, verify that existing migrations are compatible with the updated version of EF Core:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or inconsistent, generate a new migration to reflect the current model state:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

Apply the migration to a test database before using it in any shared environment:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to validate functional correctness:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no tests currently exist, consider writing tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 8. Run the Application Locally

Start the web application locally to verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, including any pages or endpoints that interact with the database.

---

## 9. Validate Cross-Platform Behavior

If the intent is to run the application on Linux or macOS, test the application on the target operating system directly. Pay particular attention to:

- **File path separators**: Ensure no hardcoded backslashes (`\`) are used in path construction. Use `Path.Combine` instead.
- **Case sensitivity**: Linux file systems are case-sensitive. Verify that file references, view names, and static asset paths use consistent casing.
- **Cryptography and certificate handling**: Some certificate and encryption APIs behave differently outside of Windows.