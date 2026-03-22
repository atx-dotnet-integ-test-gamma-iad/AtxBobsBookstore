# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

The following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly:

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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review the test output for any failures or skipped tests that may indicate behavioral differences introduced during migration.

---

## 4. Verify Data Layer (`Bookstore.Data`)

- Confirm that the database provider package (e.g., Entity Framework Core) is the correct version for your target .NET version.
- If the project uses Entity Framework, verify that migrations are present and up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to a test database to confirm schema integrity:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Verify Domain Layer (`Bookstore.Domain`)

- Review domain models and business logic for any use of APIs that may behave differently on cross-platform .NET compared to .NET Framework.
- Pay particular attention to any use of `System.Drawing`, `System.Web`, or other namespaces that have limited or no support outside of Windows.

---

## 6. Verify Web Layer (`Bookstore.Web`)

- Confirm that the `Bookstore.Web` project targets the correct framework moniker (e.g., `net8.0`).
- Check `Program.cs` and `Startup.cs` (if present) to ensure middleware and service registration are compatible with the current ASP.NET Core version.
- Review `appsettings.json` to confirm connection strings and configuration values are correct for your environment.
- Run the web application locally:

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and manually verify core functionality such as browsing, authentication, and data retrieval.

---

## 7. Review Configuration and Environment Settings

- Ensure environment-specific settings (development, staging, production) are correctly defined in `appsettings.{Environment}.json`.
- Confirm that any secrets previously stored in `Web.config` have been migrated to `appsettings.json`, environment variables, or the .NET Secret Manager.

---

## 8. Check for Windows-Specific Dependencies

Run the .NET Upgrade Assistant compatibility analyzer or review the project manually for any remaining references to Windows-only APIs:

```bash
dotnet-analyze --project Bookstore.Web
```

Address any platform-specific code paths that may cause runtime failures on non-Windows operating systems.

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assets, configuration files, and binaries are present before deploying to your target environment.