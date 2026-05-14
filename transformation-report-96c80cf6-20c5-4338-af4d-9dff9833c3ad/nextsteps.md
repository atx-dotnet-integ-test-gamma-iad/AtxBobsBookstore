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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a currently supported version of .NET (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting an older or end-of-life version such as `net5.0` or `net6.0`, update it to a supported long-term support (LTS) release.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, inspect the code and project files for any remaining Windows-specific dependencies that may not be immediately apparent as build errors but could cause runtime failures on non-Windows platforms.

- Look for usage of `Microsoft.Win32`, `System.Windows.Forms`, or registry access APIs.
- Check for any `<RuntimeIdentifier>` or `<PlatformTarget>` settings that restrict the project to Windows.
- Search for P/Invoke calls or COM interop that may not be cross-platform compatible.

---

## 5. Run the Application Locally

Start the `Bookstore.Web` project locally to verify the application runs as expected.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

- Navigate through the application and confirm that core functionality works.
- Check the console output and application logs for any runtime exceptions or warnings.
- Verify that database connectivity through `Bookstore.Data` is functioning correctly.

---

## 6. Validate Data Layer

Confirm that the `Bookstore.Data` project is correctly configured for cross-platform database access.

- If Entity Framework Core is used, verify the correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql.EntityFrameworkCore.PostgreSQL`).
- Run any pending migrations to ensure the database schema is up to date:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- If migrations do not exist yet, consider generating an initial migration:

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 7. Execute Unit and Integration Tests

If a test project exists in the solution, run all tests to verify that business logic in `Bookstore.Domain` and data access in `Bookstore.Data` behave correctly after migration.

```bash
dotnet test
```

Review test results carefully. Failures may indicate behavioral differences between .NET Framework and modern .NET that were not caught at compile time.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) are present and correctly structured. Legacy projects may have relied on `Web.config` or `App.config`, which are not used in the same way in modern .NET.

- Connection strings should be moved to `appsettings.json`.
- Any `<appSettings>` or `<connectionStrings>` entries from `Web.config` should be migrated to the JSON configuration system.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all required files, assets, and dependencies are present.