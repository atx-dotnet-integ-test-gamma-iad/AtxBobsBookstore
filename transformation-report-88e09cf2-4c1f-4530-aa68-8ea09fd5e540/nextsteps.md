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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific APIs

Even without build errors, the code may reference Windows-specific APIs that will fail at runtime on non-Windows platforms. Use the .NET Compatibility Analyzer to surface these:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

Look for analyzer warnings prefixed with `CA1416` (platform compatibility). Common problem areas include:

- `Microsoft.Win32` registry access
- Windows-specific file path assumptions (e.g., backslashes)
- `System.Drawing` (GDI+) usage in `Bookstore.Web`

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core logic:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no test project exists, consider writing basic unit tests for the domain and data layers before deploying.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify the following:

- The connection string in `appsettings.json` is correct for the target environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql`) is compatible with the target .NET version.

---

## 7. Run the Web Application Locally

Start the web application and verify it runs correctly:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:

- The application starts without runtime exceptions.
- All routes resolve correctly.
- Static assets load as expected.
- Any authentication or session middleware is functioning.

Review the console output and application logs for runtime warnings or errors.

---

## 8. Review Configuration Files

Confirm that the following files are present and correctly configured in `Bookstore.Web`:

- `appsettings.json` — base configuration
- `appsettings.Production.json` — production-specific overrides (connection strings, logging levels)

Ensure no sensitive values (passwords, API keys) are hardcoded. Use environment variables or a secrets manager for sensitive configuration.

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (specify target runtime):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Verify the contents of the `./publish` directory before deploying to the target environment.