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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test output for any failures. If tests were written against .NET Framework-specific behavior (e.g., `HttpContext`, `ConfigurationManager`), they may require updates to work correctly under cross-platform .NET.

---

## 4. Verify Configuration Files

Check that `appsettings.json` (and any environment-specific variants such as `appsettings.Development.json`) are correctly configured. Legacy projects often relied on `Web.config` or `App.config`, which may not have been fully migrated. Confirm the following:

- Connection strings are present and correct in `appsettings.json`.
- Any configuration keys previously in `Web.config` have been moved to `appsettings.json`.
- The `Startup.cs` or `Program.cs` correctly reads from the new configuration system via `IConfiguration`.

---

## 5. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework, confirm the database context is correctly configured:

- Run any pending migrations:
  ```bash
  dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
  ```
- If no migrations exist, verify the database schema matches the current model.

---

## 6. Run the Application Locally

Start the web application locally to confirm it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, user authentication if applicable) to identify any runtime issues that would not surface at compile time.

---

## 7. Review Platform-Specific Code

Search the codebase for any APIs or patterns that were specific to .NET Framework and may not behave identically on cross-platform .NET:

- `System.Web` references (these are not available in cross-platform .NET).
- Windows Registry access.
- `AppDomain` usage beyond what is supported.
- File path separators hardcoded as `\` instead of using `Path.Combine` or `Path.DirectorySeparatorChar`.

Address any identified issues before proceeding to a production deployment.

---

## 8. Test on the Target Operating System

If the intended production environment is Linux or macOS, run the application on that operating system to catch any remaining platform-specific issues, particularly around file I/O, casing sensitivity, and path handling.