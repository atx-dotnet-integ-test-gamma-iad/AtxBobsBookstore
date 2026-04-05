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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly around:
- Nullable reference types
- Obsolete API usage
- Platform compatibility analyzers

---

## 3. Verify Project Target Frameworks

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure none of the projects still reference `net48` or any other .NET Framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Even without build errors, some APIs or libraries may only function correctly on Windows. Review the following areas:

- **`Bookstore.Data`**: Confirm that the database provider (e.g., Entity Framework Core) is configured for cross-platform use. If SQL Server LocalDB was used previously, consider switching to a cross-platform alternative for local development such as SQL Server running on Linux or SQLite.
- **`Bookstore.Web`**: Check that no Windows-specific middleware or authentication mechanisms (e.g., Windows Authentication, MSMQ) are in use unless intentionally retained.
- **`Bookstore.Domain`**: Verify no platform-specific file path assumptions (e.g., hardcoded backslashes) exist. Use `Path.Combine` where applicable.

---

## 5. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing basic tests for:
- Domain model validation
- Data layer CRUD operations
- Key web endpoints or controllers

---

## 6. Run the Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following:
- The application starts without runtime exceptions
- Database connectivity is functional (run any pending migrations if using EF Core)
- Core application flows such as browsing, searching, and managing books work correctly

To apply any pending EF Core migrations:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 7. Test on Target Platforms

Since the goal is cross-platform support, validate the application runs correctly on each intended operating system (Windows, Linux, macOS) by repeating steps 5 and 6 on each platform or environment where the application is expected to be hosted.

---

## 8. Review Configuration Files

Ensure `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) are correctly set up and do not contain legacy `Web.config` or `App.config` values that were not migrated. Connection strings and application settings should be validated against the new configuration system.