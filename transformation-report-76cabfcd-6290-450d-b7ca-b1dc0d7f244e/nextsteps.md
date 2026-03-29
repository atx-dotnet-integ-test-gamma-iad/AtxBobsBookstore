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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check their respective NuGet pages for .NET-compatible replacements.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still targets `net48`, `netcoreapp3.1`, or another EOL framework, update it accordingly.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, verify that no Windows-only APIs or libraries remain in use. Search for the following in your `.csproj` files:

- `<RuntimeIdentifier>win-x64</RuntimeIdentifier>` — remove or broaden if cross-platform support is required
- References to `System.Web`, `Microsoft.Web.*`, or `System.Windows.*` — these are not available on cross-platform .NET and must be replaced

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved after migration.

```bash
dotnet test --configuration Release
```

Review the test output for any failures. Pay particular attention to tests covering data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`, as these layers are most likely to be affected by framework differences.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`)
- Migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project and verify it runs correctly on your local machine.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually verify the core functionality, including any pages that interact with `Bookstore.Data` and `Bookstore.Domain`.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` (and `appsettings.Development.json`) contain the correct configuration values for the new environment. Legacy projects often stored configuration in `Web.config` or `App.config`, which are not used in cross-platform .NET applications.

- Connection strings should be in `appsettings.json` under `"ConnectionStrings"`
- Any environment-specific values should use environment variables or the appropriate `appsettings.{Environment}.json` file

---

## 9. Publish the Application

Once validation is complete, publish the application to a target directory.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.