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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Validate the Data Layer (`Bookstore.Data`)

- If the project uses **Entity Framework**, verify that the correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Run any existing **migrations** to confirm they apply cleanly against your target database:

```bash
dotnet ef database update --project Bookstore.Data
```

- Confirm that connection strings in configuration files (`appsettings.json`) are correct and accessible in the new environment.

---

## 4. Run Unit and Integration Tests

If the solution contains a test project, execute the tests to verify functional correctness:

```bash
dotnet test --configuration Release --verbosity normal
```

Pay close attention to:
- Any tests that relied on Windows-specific behavior or APIs.
- Tests that reference file paths using backslashes, which may fail on Linux or macOS.
- Tests that depend on `System.Web` or other legacy namespaces that may have been removed.

---

## 5. Validate the Web Layer (`Bookstore.Web`)

- Start the application locally and navigate through the primary workflows:

```bash
dotnet run --project Bookstore.Web
```

- Verify that routing, middleware, and authentication behave as expected.
- Check that static files (CSS, JS, images) are served correctly.
- If the project previously used `System.Web` (e.g., `HttpContext`, `HttpRequest`), confirm those usages have been replaced with their `Microsoft.AspNetCore.Http` equivalents.

---

## 6. Review Configuration

- Confirm that `appsettings.json` and `appsettings.{Environment}.json` contain all settings that were previously in `Web.config` or `App.config`.
- Verify that environment-specific configuration (e.g., connection strings, API keys) is correctly loaded using `IConfiguration`.
- Check that logging configuration has been migrated to the `Microsoft.Extensions.Logging` format.

---

## 7. Cross-Platform Validation

If the intent is to run on Linux or macOS, verify the following:
- File path separators use `Path.Combine` or forward slashes rather than hardcoded backslashes.
- Any registry access, COM interop, or Windows-specific APIs have been removed or conditionally compiled.
- Casing of file names and directories is consistent, as Linux file systems are case-sensitive.

---

## 8. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the output directory to confirm all necessary files, including runtime dependencies and static assets, are present before deploying to the target environment.