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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific Dependencies

Inspect each project for any NuGet packages or APIs that are Windows-only. Common examples include:

- `System.Drawing.Common` (requires additional configuration on Linux/macOS in .NET 6+)
- `Microsoft.Win32` namespace usage
- COM interop references

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `<PlatformCompatibilityAnalyzer>` to surface these issues if they are not immediately visible.

---

## 5. Database and Data Layer Validation

Since the solution contains a `Bookstore.Data` project, verify the following:

- If Entity Framework Core is in use, confirm the correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Run any pending migrations or verify the schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If the project previously used Entity Framework 6 (EF6), confirm it has been migrated to EF Core, as EF6 does not fully support cross-platform .NET.

---

## 6. Run Unit and Integration Tests

If test projects exist in the solution, execute them to verify functional correctness after migration:

```bash
dotnet test --configuration Release
```

Review test output for any failures that may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project locally to validate runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Verify the following:

- The application starts without runtime exceptions.
- All pages and API endpoints respond as expected.
- Database connectivity is functioning correctly.
- Authentication and session handling (if applicable) behave correctly under the new runtime.

---

## 8. Review Configuration Files

Cross-platform .NET uses `appsettings.json` rather than `Web.config` or `App.config` for most configuration. Confirm that:

- Connection strings have been moved to `appsettings.json` or environment variables.
- Any `Web.config` transforms or `system.web` configuration sections have been replaced with their ASP.NET Core equivalents in `Program.cs` or `Startup.cs`.
- The `appsettings.json` file is included in the project output.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.