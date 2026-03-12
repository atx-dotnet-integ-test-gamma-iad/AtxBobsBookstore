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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs, as these may indicate areas that need attention.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review the test results carefully. Any failing tests should be investigated to determine whether they are caused by behavioral differences in the new framework version or pre-existing issues.

---

## 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Key areas to validate include:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. Check connection strings in `appsettings.json` or `appsettings.Development.json`, as these may have been previously stored in `Web.config` and need to be migrated manually.
- **Domain logic**: Exercise the primary business workflows to confirm `Bookstore.Domain` behaves as expected.
- **Web layer**: Navigate through the application's pages or API endpoints to confirm routing, model binding, and rendering work correctly.

---

## 5. Review Configuration Files

Legacy .NET Framework projects used `Web.config` and `App.config` for configuration. Cross-platform .NET uses `appsettings.json`. Verify the following:

- All connection strings have been moved to `appsettings.json`.
- Any custom configuration sections from `Web.config` have been translated to the appropriate `appsettings.json` structure or `IConfiguration` bindings.
- Environment-specific settings are placed in `appsettings.{Environment}.json` files.

---

## 6. Check for Windows-Specific Dependencies

Even without build errors, certain APIs may fail at runtime on non-Windows platforms. Review the projects for usage of:

- `System.Web` namespaces (should have been removed during transformation)
- Windows Registry access
- Windows-specific file path assumptions
- COM interop or P/Invoke calls targeting Windows libraries

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining platform-specific code.

---

## 7. Validate Entity Framework or Data Access Layer

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core version is referenced (not EF 6, unless intentionally retained).
- Migrations are present and up to date. Run the following to apply any pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) matches the target database.

---

## 8. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.