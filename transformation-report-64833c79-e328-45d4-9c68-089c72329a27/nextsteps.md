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

Review the output for any warnings related to package compatibility or deprecated packages that may need to be updated.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider writing tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Data Layer Functionality

Since `Bookstore.Data` handles data access, confirm the following:

- Connection strings in configuration files (e.g., `appsettings.json`) are correct and pointing to the intended database.
- Any Entity Framework Core migrations are up to date. Run the following to apply pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If the project previously used Entity Framework 6 (EF6) and was migrated to EF Core, verify that queries, relationships, and migrations produce the same results as the original implementation.

---

## 5. Run the Web Application Locally

Start the `Bookstore.Web` project locally and manually verify core application flows:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:

- The application starts without runtime exceptions.
- All pages and API endpoints load correctly.
- Database reads and writes function as expected.
- Any authentication or authorization mechanisms work as intended.

---

## 6. Review Configuration Files

Cross-platform .NET handles configuration differently than legacy .NET Framework projects. Verify the following in `appsettings.json` and `appsettings.Development.json`:

- All previously used `Web.config` or `App.config` values have been migrated to the appropriate `appsettings.json` entries.
- Environment-specific settings are correctly separated between `appsettings.json` and `appsettings.Development.json`.
- Any connection strings, API keys, or other sensitive values are handled using the appropriate configuration providers or secrets management tooling (e.g., `dotnet user-secrets` for local development).

---

## 7. Check for Platform-Specific Code

Review the codebase for any remaining Windows-specific APIs or libraries that may not function correctly on Linux or macOS if cross-platform support is required. Common areas to check include:

- File path handling (use `Path.Combine` rather than hardcoded separators).
- Registry access, which is not available on non-Windows platforms.
- Windows-specific authentication mechanisms such as Windows Authentication or NTLM.

---

## 8. Review Target Framework

Confirm that all three projects are targeting the intended .NET version by inspecting each `.csproj` file:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure the target framework is consistent across all projects and aligns with your intended support and maintenance requirements.