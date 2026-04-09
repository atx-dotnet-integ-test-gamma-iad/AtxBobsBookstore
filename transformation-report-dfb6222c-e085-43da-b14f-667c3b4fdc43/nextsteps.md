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

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is targeting an older version such as `net6.0` or `net7.0`, consider updating to `net8.0` as those versions have reached end of life.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect each project for any remaining Windows-specific APIs or packages. Common areas to check include:

- Use of `Microsoft.Win32` or `System.Windows` namespaces
- Registry access
- Windows-only NuGet packages

If any are found, either replace them with cross-platform alternatives or conditionally compile them using runtime checks such as `OperatingSystem.IsWindows()`.

---

## 5. Run the Application Locally

Start the web application locally to verify it runs as expected.

```bash
cd app/Bookstore.Web
dotnet run
```

Navigate to the URL shown in the terminal output (typically `https://localhost:5000` or similar) and verify the application loads correctly and core functionality works.

---

## 6. Verify Data Layer Functionality

If `Bookstore.Data` uses Entity Framework Core, confirm the following:

- The database provider package is compatible with the target framework (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql.EntityFrameworkCore.PostgreSQL`).
- Run any pending migrations against a local or development database.

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

Verify that data reads and writes function correctly through the application.

---

## 7. Execute Existing Tests

If the solution contains test projects, run them to confirm existing behavior has not regressed.

```bash
dotnet test
```

Review the test results and investigate any failures. Pay particular attention to integration tests that interact with the database or file system, as these are most likely to surface cross-platform issues.

---

## 8. Validate on Target Operating System

If the intended deployment environment is Linux or macOS, run the application on that operating system to catch any remaining platform-specific issues that may not surface on Windows. Pay attention to:

- File path separators (`\` vs `/`)
- Case-sensitive file and directory names
- Environment variable access

---

## 9. Publish the Application

Once validation is complete, publish the application for deployment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj \
  --configuration Release \
  --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.