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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs introduced during the migration.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure no project is still referencing `net48` or any other Windows-only framework unintentionally.

---

## 4. Check for Windows-Specific Dependencies

Search the codebase for any APIs or packages that are Windows-only, as these will not function on Linux or macOS. Common areas to check include:

- Use of `Microsoft.Win32` namespaces
- Registry access
- Windows-specific file path assumptions (e.g., backslashes)
- Any remaining references to `System.Web`

Use the .NET Upgrade Assistant compatibility analyzer or the `dotnet-compatibility` tool if a more thorough audit is needed:

```bash
dotnet tool install -g dotnet-compatibility
```

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved after migration:

```bash
dotnet test --configuration Release
```

Review test output for any failures that may indicate behavioral differences between the legacy framework and the new target framework.

---

## 6. Validate Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, verify that:

- The connection string in `appsettings.json` is correctly configured for the target environment.
- Entity Framework Core (or whichever ORM is in use) migrations are up to date.

If using Entity Framework Core, apply any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the web application to confirm it runs correctly end-to-end:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that core functionality such as page rendering, data retrieval, and form submissions work as expected.

---

## 8. Test on Target Operating Systems

If cross-platform support is a goal, run the application on each intended operating system (Windows, Linux, macOS) to identify any platform-specific runtime issues that would not surface during a build.

---

## 9. Review Logging and Configuration

Confirm that the application's logging and configuration setup has been updated to use the .NET `ILogger` and `IConfiguration` abstractions rather than any legacy equivalents such as `log4net` or `System.Configuration.ConfigurationManager`, unless those packages have been explicitly retained and verified as compatible.