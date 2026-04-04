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

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific Dependencies

Inspect `Bookstore.Data` and `Bookstore.Web` for any dependencies that are Windows-only, such as:

- `System.Web` references
- Windows Registry access
- COM interop
- `Microsoft.Web.Infrastructure`

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify platform-specific calls that may fail on Linux or macOS.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to verify that existing functionality has not regressed.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests and determine whether failures are caused by the migration or were pre-existing issues.

---

## 6. Validate the Data Layer

In `Bookstore.Data`, verify the following:

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql`) is compatible with the new target framework.
- Any connection strings in `appsettings.json` or `web.config` have been migrated to the appropriate configuration system (`appsettings.json` and `IConfiguration`).
- Migrations, if using Entity Framework Core, are up to date by running:

```bash
dotnet ef migrations list
```

---

## 7. Validate the Web Layer

In `Bookstore.Web`, confirm the following:

- The project uses `Microsoft.AspNetCore.*` packages rather than `System.Web`.
- `Program.cs` and `Startup.cs` (or the combined `Program.cs` in minimal hosting model) are correctly configured.
- Static files, routing, and middleware are functioning as expected.
- Authentication and authorization configurations, if present, have been updated to use ASP.NET Core equivalents.

Run the web application locally to perform a basic smoke test:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and verify that core pages load without errors.

---

## 8. Review Configuration Files

Ensure that `web.config` settings have been migrated to `appsettings.json` where applicable. The `web.config` file in ASP.NET Core is only used for IIS hosting configuration (e.g., the ASP.NET Core Module settings) and is not a general application configuration file.

---

## 9. Test on Target Platform

If cross-platform support is a goal, run and test the application on the intended target operating system (Linux or macOS) to surface any remaining platform-specific issues that may not appear on Windows.

---

## 10. Publish the Application

Once validation is complete, publish the application using the appropriate runtime identifier for your target environment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj \
  --configuration Release \
  --runtime linux-x64 \
  --self-contained false \
  --output ./publish
```

Adjust `--runtime` and `--self-contained` based on your deployment target and whether the .NET runtime will be pre-installed on the host.