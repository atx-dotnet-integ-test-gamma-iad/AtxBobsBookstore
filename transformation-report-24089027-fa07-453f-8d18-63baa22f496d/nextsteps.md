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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check their respective NuGet pages for .NET-compatible alternatives.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is still targeting `net48`, `netcoreapp3.1`, or another outdated framework, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, verify that no Windows-only APIs or libraries remain in use. Common areas to inspect include:

- **`Bookstore.Data`**: Check for any use of `System.Data.SqlClient`. If present, replace it with `Microsoft.Data.SqlClient`, which is cross-platform.
- **`Bookstore.Web`**: Confirm that no references to `System.Web` remain. These are not available in cross-platform .NET.
- **Configuration**: Ensure `Web.config` or `App.config` usage has been replaced with `appsettings.json` and the `Microsoft.Extensions.Configuration` stack.

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and exercise the core functionality, such as browsing books, to confirm the application behaves as expected.

---

## 6. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date and the database connection is functional.

Check that the connection string in `appsettings.json` is correctly configured, then apply any pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If Entity Framework migrations do not exist yet, consider generating an initial migration from the current model:

```bash
dotnet ef migrations add InitialCreate --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 7. Execute Unit and Integration Tests

If the solution contains test projects, run them to validate that business logic and data access behavior remain correct after migration.

```bash
dotnet test
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework and modern .NET runtimes.

---

## 8. Cross-Platform Validation

Since the goal of the migration is cross-platform support, run the application on a non-Windows operating system (Linux or macOS) to confirm there are no platform-specific runtime issues. Pay particular attention to:

- File path separators
- Case-sensitive file system behavior on Linux
- Any P/Invoke or COM interop calls that would not function outside of Windows

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required assets, configuration files, and binaries are present.