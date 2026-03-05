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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs introduced during the migration.

---

## 3. Validate the Domain Layer

Since `Bookstore.Domain` is the most foundational project, verify its logic is intact:

- Review all domain models and ensure their properties and relationships are correct.
- If unit tests exist for the domain layer, run them specifically:

```bash
dotnet test --filter "Project=Bookstore.Domain"
```

---

## 4. Validate the Data Layer

The `Bookstore.Data` project likely contains database access logic such as Entity Framework Core contexts and migrations. Perform the following checks:

- Confirm the correct EF Core provider is referenced (e.g., SQL Server, SQLite).
- Verify the connection string in configuration files (`appsettings.json`) is correct for your target environment.
- If using Entity Framework Core, confirm migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data
```

- Apply migrations to a test database to confirm schema integrity:

```bash
dotnet ef database update --project app/Bookstore.Data
```

---

## 5. Validate the Web Layer

For the `Bookstore.Web` project:

- Confirm `Program.cs` and any startup configuration follows the current .NET minimal hosting model or the explicit `Startup` class pattern, whichever was used post-migration.
- Check that middleware registrations, dependency injection bindings, and routing configurations are correct.
- Run the application locally:

```bash
dotnet run --project app/Bookstore.Web
```

- Navigate to the application in a browser and verify core pages and functionality load without errors.

---

## 6. Run All Tests

If a test project exists in the solution, execute the full test suite:

```bash
dotnet test
```

Review test results for any failures that may indicate behavioral regressions introduced during the migration.

---

## 7. Review Configuration Files

- Ensure `appsettings.json` and `appsettings.Development.json` contain all required configuration keys that were previously in `Web.config` or `App.config`.
- Confirm any environment-specific settings are properly handled using the `IConfiguration` system.

---

## 8. Check for Removed Windows-Specific APIs

Even without build errors, runtime issues can arise from APIs that were available in .NET Framework but behave differently or are absent in cross-platform .NET. Review the code for usage of:

- `System.Web` namespaces (these should have been fully replaced)
- Windows Registry access
- Windows-specific file path assumptions (e.g., backslash separators)
- `HttpContext.Current` (replaced by injected `IHttpContextAccessor`)

---

## 9. Target Framework Verification

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported .NET version.