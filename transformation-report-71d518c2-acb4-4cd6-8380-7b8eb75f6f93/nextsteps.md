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

Run a NuGet package restore to confirm all dependencies resolve correctly against the new target framework.

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages. If any packages targeting the old .NET Framework are present, check for their cross-platform equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no issues beyond what was reported.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during this step, particularly those related to nullable reference types, obsolete APIs, or platform compatibility analyzers.

---

## 3. Run Existing Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after migration.

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic unit tests for the core logic in `Bookstore.Domain` and integration tests for `Bookstore.Data` to establish a baseline.

---

## 4. Validate Data Access Layer (`Bookstore.Data`)

- Confirm that Entity Framework (or whichever ORM is in use) has been updated to a version compatible with .NET.
- If Entity Framework 6 was used in the original project, verify whether it has been migrated to **EF Core**, as EF6 has limited cross-platform support.
- Run any existing database migrations or apply the schema to a local database instance:

```bash
dotnet ef database update
```

- Verify that connection strings in configuration files (e.g., `appsettings.json`) are correctly formatted for the target database.

---

## 5. Validate the Web Layer (`Bookstore.Web`)

- If the original project was ASP.NET Web Forms or ASP.NET MVC (on .NET Framework), confirm the migration target is **ASP.NET Core MVC** or **Razor Pages**.
- Start the application locally and navigate through key pages to verify rendering and routing:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

- Check that middleware configuration in `Program.cs` or `Startup.cs` is complete, including authentication, static files, and routing.
- Verify that any configuration previously stored in `Web.config` has been moved to `appsettings.json` and is being read correctly.

---

## 6. Check for Platform-Specific API Usage

Use the .NET Compatibility Analyzer or review the code manually for any APIs that may have been available in .NET Framework but are not supported in cross-platform .NET. Common areas to check include:

- `System.Web` namespace usage (should be replaced with ASP.NET Core equivalents)
- Windows Registry access
- `AppDomain` usage
- Binary serialization (`BinaryFormatter` is obsolete and disabled by default)

---

## 7. Test on Target Platform

If the goal is cross-platform support, run the application on the intended non-Windows platform (e.g., Linux or macOS) to surface any remaining platform-specific issues.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Publish the Application

Once validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets and configuration files.