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

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite:

```bash
dotnet test --configuration Release
```

If no test projects currently exist, consider adding tests for the core logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

Since `Bookstore.Data` is present, confirm that any Entity Framework Core migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

Apply the migrations to your target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL shown in the terminal output and manually verify that core functionality such as browsing, searching, and any data-driven pages work correctly.

---

## 6. Review Configuration Files

Check `appsettings.json` and `appsettings.Development.json` in `Bookstore.Web` to confirm the following:

- Connection strings are correct for the target environment.
- Any configuration keys that were previously stored in `Web.config` have been properly migrated to the new `appsettings.json` format.
- Logging, authentication, and any third-party service settings are correctly defined.

---

## 7. Check for Platform-Specific Code

Review the codebase for any APIs or libraries that were available in .NET Framework but may behave differently or require alternatives in cross-platform .NET. Common areas to inspect include:

- `System.Web` references, which are not available in cross-platform .NET.
- Windows-specific APIs such as the registry or certain cryptography providers.
- Any use of `HttpContext` that may need to be updated to use the ASP.NET Core equivalents.

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify remaining compatibility concerns if needed.

---

## 8. Validate on Target Operating System

If the intent is to run this application on Linux or macOS, test the application explicitly on that platform to catch any remaining OS-specific issues:

```bash
dotnet run --project Bookstore.Web
```

Pay particular attention to file path separators, case-sensitive file systems, and any Windows-only dependencies.