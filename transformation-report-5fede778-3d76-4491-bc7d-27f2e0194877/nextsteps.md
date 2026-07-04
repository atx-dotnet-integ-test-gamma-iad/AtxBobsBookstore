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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific APIs

Even without build errors, the code may reference Windows-only APIs (e.g., the registry, `System.Drawing`, or certain `System.Web` types) that will fail at runtime on non-Windows platforms.

Use the .NET Compatibility Analyzer to surface these issues:

```bash
dotnet build --configuration Release /p:EnableNETAnalyzers=true
```

Address any `CA1416` platform-compatibility warnings that appear.

---

## 5. Validate the Data Layer

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Any pending migrations are up to date.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply migrations to a local development database to confirm the schema is correct:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If the solution contains a test project, execute all tests to verify that existing behavior is preserved after migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests and determine whether they are caused by behavioral differences in the new framework version.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project and verify it runs correctly on your local machine.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and exercise the primary workflows.
- Check the console output for runtime exceptions or middleware configuration warnings.
- Confirm that `appsettings.json` contains the correct connection strings and configuration values for your environment, as `Web.config` transformations from the legacy project may not have been fully carried over.

---

## 8. Review Configuration Migration

Legacy ASP.NET projects relied on `Web.config`. Cross-platform .NET uses `appsettings.json` and environment variables. Confirm the following have been migrated:

- Connection strings are present in `appsettings.json`.
- Any custom `appSettings` keys have been moved to the appropriate configuration section.
- Authentication, authorization, and session configuration has been re-implemented using the ASP.NET Core middleware pipeline in `Program.cs` or `Startup.cs`.

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment artifact.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected files are present before deploying to the target environment.