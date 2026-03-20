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

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release
```

Review test results carefully. Pay attention to any tests that were previously passing in the legacy project but are now failing, as these may indicate behavioral differences introduced during migration.

---

## 4. Verify Entity Framework Core Migrations (If Applicable)

Since the solution includes a `Bookstore.Data` project, it likely uses Entity Framework. Verify the following:

- Confirm that the correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Check that existing migrations are compatible with EF Core by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If the database schema needs to be updated, apply migrations with:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Validate Runtime Behavior

Run the web application locally and verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following areas manually:

- Application startup and routing
- Database connectivity and data retrieval
- Any authentication or authorization flows
- Static file serving (CSS, JavaScript, images)

---

## 6. Review Configuration Files

Inspect `appsettings.json` and `appsettings.Production.json` in `Bookstore.Web` to confirm:

- Connection strings are correct for the target environment.
- Any configuration keys that previously existed in `Web.config` have been properly migrated to the new configuration system.
- Environment-specific settings are correctly separated.

---

## 7. Check for Removed or Changed APIs

Review the codebase for any usage of APIs that existed in .NET Framework but behave differently or are absent in cross-platform .NET. Common areas to check include:

- `System.Web` references (should be fully removed)
- `HttpContext` usage patterns
- `ConfigurationManager` replaced by `IConfiguration`
- Windows-specific APIs that may not function on non-Windows platforms

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to surface any remaining compatibility concerns:

```bash
dotnet tool install -g dotnet-compatibility
```

---

## 8. Publish the Application

Once validation is complete, publish the application to a target folder:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the output directory to confirm all necessary files, including runtime dependencies and static assets, are present before deploying to the target environment.