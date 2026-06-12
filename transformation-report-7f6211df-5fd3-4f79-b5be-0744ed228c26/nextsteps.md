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

The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check their NuGet pages for recommended replacements compatible with the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without errors or warnings that could indicate runtime issues.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the traditional sense. Confirm the following:

- Connection strings and application settings have been moved to `appsettings.json` in `Bookstore.Web`.
- Environment-specific overrides are handled via `appsettings.Development.json` or environment variables.
- Any `Web.config` transforms that were previously in place have been replicated in the new configuration system.

---

## 4. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- The connection string in `appsettings.json` points to a valid and accessible database.
- Run any pending migrations to ensure the schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and verify it runs as expected on the local machine.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL shown in the terminal output (typically `https://localhost:5001` or `http://localhost:5000`) and confirm the application loads correctly.

---

## 6. Execute Unit and Integration Tests

If a test project exists in the solution, run all tests to validate business logic and data access behavior.

```bash
dotnet test
```

Review the test results for any failures that may indicate behavioral differences introduced during the migration. Pay particular attention to:

- Data access logic in `Bookstore.Data`
- Domain model behavior in `Bookstore.Domain`
- Any middleware or request pipeline logic in `Bookstore.Web`

---

## 7. Check for Platform-Specific Code

Search the codebase for any APIs or libraries that may have been available in .NET Framework but are not fully supported in cross-platform .NET. Common areas to check include:

- Use of `System.Web` namespaces (these are not available in cross-platform .NET)
- Windows-specific registry or file path assumptions
- Any P/Invoke calls or native library dependencies

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling if a thorough audit is needed.

---

## 8. Validate Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element reflects the intended .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid compatibility issues between assemblies.

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment package.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected files are present before deploying to the target environment.