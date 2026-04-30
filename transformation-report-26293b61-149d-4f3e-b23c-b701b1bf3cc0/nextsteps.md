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

Verify that no warnings or errors are reported during the restore process.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific APIs

Search the codebase for any APIs that are Windows-specific and may not function correctly on Linux or macOS. Common areas to check include:

- Registry access (`Microsoft.Win32.Registry`)
- Windows-specific file path assumptions (e.g., backslashes)
- `System.Drawing` (GDI+), which requires additional native dependencies on non-Windows platforms
- COM interop or P/Invoke calls targeting Windows libraries

Use the .NET Compatibility Analyzer or the following command to help identify platform-specific issues:

```bash
dotnet build /p:EnableNETAnalyzers=true
```

---

## 5. Run Unit Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether failures are due to migration-related changes or pre-existing issues.

---

## 6. Validate Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- The database provider NuGet package is compatible with the target framework (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent).
- Connection strings in configuration files (`appsettings.json`) are correct and accessible in the new environment.
- Run any pending Entity Framework Core migrations if applicable:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project locally to verify that the application runs end-to-end:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm correct behavior, including:

- Page rendering
- Data retrieval and display
- Any form submissions or write operations

---

## 8. Review Configuration and Environment Variables

Confirm that `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, `appsettings.Production.json`) have been updated to reflect the new environment. Pay particular attention to:

- Connection strings
- Authentication settings
- Logging configuration

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present before deploying to the target environment.