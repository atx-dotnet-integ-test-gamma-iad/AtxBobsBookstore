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

Perform a full build to confirm there are no compilation issues:

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

Ensure no project is still referencing `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Review each project's NuGet package references for any packages that are Windows-only. Common examples include:

- `Microsoft.Web.Infrastructure`
- `System.Web.*`
- Packages targeting `net4x` only

Use the following command to inspect resolved packages:

```bash
dotnet list package
```

Replace or remove any packages that do not support cross-platform .NET.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review the test output for any failures that may indicate behavioral differences introduced by the migration.

---

## 6. Run the Application Locally

Start the `Bookstore.Web` project locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas at a minimum:

- Application startup with no runtime exceptions
- Database connectivity via `Bookstore.Data`
- Domain logic correctness via `Bookstore.Domain`
- All primary routes and pages load as expected

---

## 7. Validate Database Migrations

If the project uses Entity Framework Core, verify that all migrations are up to date and compatible with the new framework version:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj
```

If migrations are missing or out of date, add a new migration and apply it to a test database:

```bash
dotnet ef migrations add PostMigration --project app/Bookstore.Data/Bookstore.Data.csproj
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj
```

---

## 8. Review Configuration Files

Confirm that `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) are present and correctly configured. Pay particular attention to:

- Connection strings
- Any paths that may have been hardcoded using Windows-style separators (`\` vs `/`)
- Authentication or authorization settings

---

## 9. Test on a Non-Windows Platform

Since the goal of the migration is cross-platform support, validate the application on Linux or macOS if possible:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Confirm there are no platform-specific runtime errors that were not caught during the build phase.

---

## 10. Publish the Application

Once all validation steps pass, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and verify all required assets, configuration files, and binaries are present before deploying to the target environment.