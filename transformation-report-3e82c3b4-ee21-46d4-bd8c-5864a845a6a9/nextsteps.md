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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Review all NuGet package references across the three projects for packages that are Windows-only. Common examples include:

- `System.Drawing.Common` (requires additional configuration on Linux/macOS as of .NET 6+)
- `Microsoft.Win32.*` namespaces
- Any COM interop or P/Invoke calls targeting Windows APIs

If any are found, replace them with cross-platform alternatives or add a runtime guard where appropriate.

---

## 5. Database and Data Layer Validation

In `Bookstore.Data`, verify the following:

- The Entity Framework Core (or whichever ORM is in use) package version is compatible with the target framework.
- Connection strings in configuration files (`appsettings.json`) are correct and do not rely on Windows-specific authentication mechanisms (e.g., Windows Integrated Security) if cross-platform deployment is intended.
- Run any pending migrations to confirm the data layer functions as expected:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute the test suite to validate core functionality.

```bash
dotnet test
```

Pay attention to any tests that may have been written against Windows-specific behavior, file paths using backslashes, or registry access.

---

## 7. Run the Application Locally

Start the web application locally to perform a manual smoke test.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Verify the following at a minimum:

- The application starts without exceptions.
- Database connectivity is established.
- Core user-facing pages load and function correctly.

---

## 8. Review Configuration and Environment Variables

Confirm that `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) have been updated to reflect the new project structure and any changed namespaces or assembly names resulting from the migration.

---

## 9. Validate on Target Platform

If the goal is Linux or macOS deployment, run the application on the intended target operating system to catch any remaining platform-specific issues that may not surface on Windows.

```bash
dotnet publish --configuration Release --runtime linux-x64 --self-contained false
```

Test the published output on the target machine or environment before promoting to production.