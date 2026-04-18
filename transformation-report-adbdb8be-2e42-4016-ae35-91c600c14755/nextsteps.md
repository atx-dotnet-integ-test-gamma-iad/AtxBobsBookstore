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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure no project still references `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Review each project for any remaining dependencies that are Windows-specific, such as:

- `Microsoft.Win32` APIs
- `System.Web` references
- COM interop components
- Windows Registry access

If any are found, replace them with cross-platform equivalents where possible.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core logic:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing basic tests for the domain and data layers to verify expected behavior before proceeding.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify the following:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Run any pending migrations to confirm the database schema is in the expected state:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that connection strings in `appsettings.json` are correctly configured for the target environment.

---

## 7. Run the Web Application Locally

Start the web application to verify it runs correctly on the local machine:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and manually test the primary workflows, such as browsing, searching, and any data entry forms.

---

## 8. Review Middleware and Configuration (Bookstore.Web)

If the project was migrated from ASP.NET (System.Web) to ASP.NET Core, confirm the following in `Program.cs` or `Startup.cs`:

- Middleware is registered in the correct order (e.g., `UseRouting`, `UseAuthentication`, `UseAuthorization`).
- Static files, session, and any custom HTTP modules have been replaced with their ASP.NET Core equivalents.
- Configuration is loaded correctly via `IConfiguration` rather than `ConfigurationManager` where applicable.

---

## 9. Test on a Non-Windows Platform (Optional but Recommended)

Since the goal of the migration is cross-platform compatibility, consider running the application on Linux or macOS to confirm there are no hidden platform-specific issues:

```bash
dotnet run --project Bookstore.Web
```

Any runtime exceptions related to file path separators, case-sensitive file systems, or missing Windows APIs will surface at this stage.

---

## 10. Review Publish Output

Publish the application to a local folder to verify the output is complete and self-contained if needed:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Inspect the output directory to confirm all required assets, configuration files, and binaries are present.