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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting a build:

```bash
dotnet restore
```

Verify that no warnings or errors are reported during the restore process.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not cause outright build failures.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently in cross-platform .NET compared to .NET Framework. Pay particular attention to:

- **`Bookstore.Data`**: Verify that Entity Framework or any data access library is using the correct cross-platform compatible version (e.g., EF Core rather than EF 6 for .NET Framework).
- **`Bookstore.Web`**: Confirm that any middleware, authentication, or HTTP pipeline configuration has been updated to use ASP.NET Core conventions.
- **`Bookstore.Domain`**: Check that no types rely on assemblies that are not available in cross-platform .NET (e.g., `System.Web`).

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing basic smoke tests for critical paths in `Bookstore.Domain` and `Bookstore.Data` before proceeding.

---

## 6. Validate Database Migrations

If `Bookstore.Data` uses Entity Framework Core with migrations, verify the migration state is consistent:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of date, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Application Locally

Start the web application locally to confirm it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and verify that core functionality such as browsing, data retrieval, and any authentication flows work as expected.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) contain the correct connection strings and application settings. Legacy `Web.config` or `App.config` values should have been migrated to `appsettings.json`. Confirm no required values are missing.

---

## 9. Test on Target Operating Systems

Since the goal of the migration is cross-platform support, run the application on each intended operating system (e.g., Windows, Linux, macOS) to identify any platform-specific runtime issues that would not surface during a build.

```bash
dotnet run --project Bookstore.Web
```

Pay attention to file path handling, case sensitivity on Linux, and any OS-specific dependencies.