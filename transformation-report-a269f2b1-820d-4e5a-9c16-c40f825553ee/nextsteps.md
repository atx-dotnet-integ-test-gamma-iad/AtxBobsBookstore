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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Do this for all three projects:

- `Bookstore.Domain/Bookstore.Domain.csproj`
- `Bookstore.Data/Bookstore.Data.csproj`
- `Bookstore.Web/Bookstore.Web.csproj`

---

## 4. Check for Windows-Specific Dependencies

Even when a build succeeds, some packages or APIs may only function on Windows. Review the following:

- Any use of `Microsoft.Win32`, `System.Drawing`, or COM interop.
- NuGet packages that have not been updated for cross-platform .NET.
- Configuration or file path handling that assumes Windows-style paths (e.g., backslashes).

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package to identify platform-specific calls.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic integration or unit tests covering the core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql.EntityFrameworkCore.PostgreSQL`).
- Connection strings in `appsettings.json` are correct for the target environment.
- Run any pending migrations to confirm the database schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the web application and perform manual smoke testing:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that core pages load, data is retrieved correctly, and no runtime exceptions occur.

---

## 8. Review Middleware and Configuration (Bookstore.Web)

If the original project was ASP.NET (Framework), confirm that the middleware pipeline in `Program.cs` or `Startup.cs` has been correctly migrated to the ASP.NET Core model. Key areas to check:

- Authentication and authorization middleware.
- Static file serving.
- Session and cookie configuration.
- Any custom HTTP modules or handlers that would need to be replaced with ASP.NET Core middleware.

---

## 9. Test on a Non-Windows Platform (Optional but Recommended)

Since the goal is cross-platform compatibility, if possible, run the application on Linux or macOS to surface any remaining platform-specific issues:

```bash
dotnet run --project Bookstore.Web
```

---

## 10. Review Warnings and Deprecated APIs

After all functional validation is complete, revisit any build warnings that were noted in step 2. Address deprecated API usage and nullable reference type warnings to improve long-term maintainability of the codebase.