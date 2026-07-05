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

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects. A mismatch in target frameworks between `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web` can cause runtime issues even when the build succeeds.

---

## 4. Check for Windows-Specific Dependencies

Search the codebase for APIs or packages that are Windows-only, such as:

- `Microsoft.Win32` registry access
- Windows-specific file path assumptions (e.g., backslashes)
- `System.Drawing` (which has limited cross-platform support; consider replacing with `SkiaSharp` or `ImageSharp`)

Use the .NET Compatibility Analyzer if needed:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

---

## 5. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql.EntityFrameworkCore.PostgreSQL`)
- Connection strings in `appsettings.json` are correct for the target environment
- Run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to verify that core logic in `Bookstore.Domain` and `Bookstore.Data` behaves as expected.

```bash
dotnet test
```

Review any failing tests carefully, as they may indicate behavioral differences between the old .NET Framework and the new cross-platform .NET runtime.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

Check the following manually:

- All pages load without exceptions
- Database reads and writes function correctly
- Authentication and authorization flows work as expected
- Static files (CSS, JS, images) are served correctly

---

## 8. Review Configuration and Middleware

In ASP.NET Core, configuration and middleware differ from legacy ASP.NET. Confirm the following in `Program.cs` or `Startup.cs`:

- `appsettings.json` is present and correctly structured
- Middleware is registered in the correct order (e.g., `UseAuthentication` before `UseAuthorization`)
- Any legacy `HttpModule` or `HttpHandler` implementations have been replaced with ASP.NET Core middleware equivalents

---

## 9. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish --project Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Verify the contents of the `./publish` directory before deploying to the target environment.