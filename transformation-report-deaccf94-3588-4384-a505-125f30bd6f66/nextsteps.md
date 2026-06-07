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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or warnings that could indicate runtime issues.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific APIs

Even without build errors, the code may still use Windows-specific APIs that will fail at runtime on non-Windows platforms. Use the .NET Compatibility Analyzer to surface these:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Alternatively, run the solution through the [.NET Upgrade Assistant](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) to identify any remaining platform-specific API usage.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to validate that business logic in `Bookstore.Domain` and data access in `Bookstore.Data` behave correctly:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests and address regressions that may have been introduced during the transformation.

---

## 6. Validate Database Connectivity (`Bookstore.Data`)

If `Bookstore.Data` uses Entity Framework Core or another ORM, verify the following:

- The connection string in `appsettings.json` is valid and points to the correct database instance.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql`) is compatible with the target framework version.

---

## 7. Run the Web Application Locally

Start the web application to verify it runs correctly end-to-end:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and exercise the primary workflows (browsing, searching, and any data entry flows).
- Check the console output and application logs for any runtime exceptions.

---

## 8. Review `appsettings.json` and Configuration

Confirm that configuration values previously stored in `Web.config` or `App.config` have been correctly migrated to `appsettings.json`. Pay particular attention to:

- Connection strings
- Application-specific settings
- Any environment-specific overrides (`appsettings.Development.json`, `appsettings.Production.json`)

---

## 9. Validate Static Assets and Middleware (`Bookstore.Web`)

If the project previously used ASP.NET MVC on .NET Framework, confirm the following have been correctly configured in `Program.cs` or `Startup.cs`:

- Static file serving (`app.UseStaticFiles()`)
- Routing (`app.UseRouting()`, `app.MapControllers()` or `app.MapRazorPages()`)
- Authentication and authorization middleware, if applicable

---

## 10. Test on a Non-Windows Platform (Optional but Recommended)

Since the goal of the transformation is cross-platform compatibility, consider running the application on a Linux or macOS environment to confirm there are no hidden platform dependencies:

```bash
dotnet run --project Bookstore.Web
```

Address any `PlatformNotSupportedException` or similar runtime errors that surface in this environment.