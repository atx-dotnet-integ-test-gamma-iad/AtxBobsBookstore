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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET. For example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET release schedule](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) to confirm the chosen version is still under active support.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect the code and project references for any APIs that are Windows-only. Common areas to check include:

- `System.Drawing` (use a cross-platform alternative such as `SkiaSharp` if needed)
- Registry access (`Microsoft.Win32.Registry`)
- Windows-specific authentication or identity APIs

You can use the [.NET Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify platform-specific API usage.

---

## 5. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework or another ORM, verify the following:

- The connection string in `appsettings.json` is correct for the target environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql`, etc.) is compatible with the target framework version.

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests to verify functional correctness after the migration:

```bash
dotnet test --configuration Release --logger "console;verbosity=normal"
```

Review any failing tests and determine whether they are caused by behavioral differences in the new runtime or by legitimate regressions.

---

## 7. Run the Web Application Locally

Start the web application and perform manual smoke testing:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Verify the following at a minimum:

- The application starts without exceptions.
- Core pages and routes load correctly.
- Database read and write operations function as expected.
- Authentication and authorization flows work if applicable.

---

## 8. Review Configuration and Middleware

If the project was previously an ASP.NET (System.Web) application, confirm that the middleware pipeline in `Program.cs` or `Startup.cs` is correctly configured for ASP.NET Core. Key areas to review:

- Static file serving (`app.UseStaticFiles()`)
- Routing (`app.UseRouting()`, `app.MapControllers()`, etc.)
- Authentication and session middleware ordering
- Error handling middleware

---

## 9. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required assets, configuration files, and binaries are present before deploying to the target environment.