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

Perform a full solution build to confirm there are no errors or warnings that may have been missed:

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported modern .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, review the projects for any remaining Windows-specific APIs or libraries. Pay particular attention to:

- `Bookstore.Data` — Check for any use of `System.Data` providers or ORM configurations that may rely on Windows-specific connection strings or registry access.
- `Bookstore.Web` — Check for any use of `HttpContext.Current`, `System.Web`, or Windows Authentication configurations that are not supported on cross-platform .NET.

---

## 5. Run the Application Locally

Start the web application to verify it runs correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the URL shown in the console output and verify that core pages and functionality load as expected.

---

## 6. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify that any pending migrations are applied:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Confirm that the database schema matches expectations and that basic read/write operations function correctly.

---

## 7. Execute Unit Tests

If the solution contains a test project, run all tests to validate business logic and data access behavior:

```bash
dotnet test
```

Review any failing tests and determine whether they indicate regressions introduced during the migration or pre-existing issues.

---

## 8. Review Configuration Files

Inspect `appsettings.json` and `appsettings.Production.json` in `Bookstore.Web` to confirm:

- Connection strings are correct for the target environment.
- Any configuration previously stored in `Web.config` or `App.config` has been properly migrated to the new configuration system.
- Sensitive values are not hardcoded and are instead managed via environment variables or a secrets manager.

---

## 9. Test on a Non-Windows Platform (Optional but Recommended)

Since the goal is cross-platform compatibility, consider running the application on Linux or macOS to confirm there are no hidden platform-specific dependencies:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Any `PlatformNotSupportedException` or runtime errors at this stage would indicate remaining platform-specific code that needs to be addressed.