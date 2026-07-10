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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages still reference old .NET Framework-specific versions, update them to their cross-platform equivalents using:

```bash
dotnet add <project> package <PackageName>
```

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly:
- Nullable reference type warnings
- Obsolete API usage
- Platform compatibility warnings (CA1416 or similar)

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after the migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no test projects currently exist, consider adding one targeting the `Bookstore.Domain` and `Bookstore.Data` projects, as these contain the core business and data access logic.

---

## 4. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core or another ORM, confirm the following:

- The connection string in `appsettings.json` (or equivalent) is valid and points to the correct database instance.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the `Bookstore.Web` project and verify that it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following at runtime:
- Application starts without exceptions in the console output.
- All pages and API endpoints load correctly.
- Database read and write operations function as expected.
- Any authentication or authorization mechanisms work correctly.

---

## 6. Review Configuration Files

Cross-platform .NET uses `appsettings.json` instead of `Web.config` or `App.config`. Confirm the following:

- All connection strings have been moved to `appsettings.json`.
- Environment-specific settings are separated into `appsettings.Development.json` and `appsettings.Production.json` where appropriate.
- Any configuration keys previously read via `ConfigurationManager` are now accessed through `IConfiguration`.

---

## 7. Check for Platform-Specific Code

Review the codebase for any APIs that may have been available in .NET Framework but are not fully supported cross-platform. Common areas to inspect:

- Use of `System.Drawing` (replace with a library such as `SkiaSharp` if needed).
- Windows Registry access.
- COM interop or P/Invoke calls targeting Windows-only libraries.
- `HttpContext.Current` usage (should be replaced with injected `IHttpContextAccessor`).

Use the .NET Upgrade Assistant compatibility analyzer or the following command to surface compatibility issues:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

---

## 8. Validate Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same major version to avoid inter-project compatibility issues.