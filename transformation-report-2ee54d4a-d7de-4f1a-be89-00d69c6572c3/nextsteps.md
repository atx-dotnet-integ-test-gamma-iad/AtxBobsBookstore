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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

For `Bookstore.Web`, also verify that the project SDK is correct for a web application:

```xml
<Project Sdk="Microsoft.NET.Sdk.Web">
```

---

## 4. Verify Configuration Files

- Confirm that `web.config` has been replaced or supplemented by `appsettings.json` and `appsettings.{Environment}.json`.
- Check that `Program.cs` and `Startup.cs` (or the combined `Program.cs` in minimal hosting model) correctly configure services and middleware.
- Ensure connection strings in `appsettings.json` are valid and point to the correct database.

---

## 5. Database and Data Layer Validation

If `Bookstore.Data` uses Entity Framework, verify the following:

- The correct EF Core NuGet packages are referenced (e.g., `Microsoft.EntityFrameworkCore`, the appropriate database provider).
- Run any pending migrations to ensure the schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the URL shown in the console output (typically `https://localhost:{port}`) and exercise the primary features of the application, including any pages that interact with `Bookstore.Domain` and `Bookstore.Data`.

---

## 7. Execute Unit and Integration Tests

If a test project exists in the solution, run all tests to confirm expected behavior is preserved after migration:

```bash
dotnet test
```

Review any failing tests carefully. Failures may indicate behavioral differences between .NET Framework and modern .NET that require code adjustments.

---

## 8. Check for Platform-Specific API Usage

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining Windows-specific APIs that may cause issues on non-Windows environments:

```bash
dotnet tool install -g dotnet-compatibility
```

Pay particular attention to:
- `System.Web` references (should be fully removed)
- Windows Registry access
- Windows-only file path assumptions

---

## 9. Validate Static Assets and Bundling

For `Bookstore.Web`, confirm that static files (CSS, JavaScript, images) are served correctly. If the project previously used `System.Web.Optimization` for bundling, ensure it has been replaced with a supported alternative such as `WebOptimizer` or a front-end build tool.

---

## 10. Review Logging and Error Handling

Confirm that logging is configured using `Microsoft.Extensions.Logging` and that unhandled exceptions are surfaced appropriately in both development and production environments via the middleware pipeline.