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

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to deprecated or incompatible packages. If any packages are flagged, check NuGet for updated versions compatible with the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without errors or warnings that could indicate runtime issues.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects so there are no framework version mismatches.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs that existed in .NET Framework may behave differently or have been replaced in cross-platform .NET. Pay particular attention to:

- **`Bookstore.Data`**: Verify Entity Framework usage. If the project was using Entity Framework 6 (EF6), confirm it has been migrated to Entity Framework Core and that database providers (e.g., SQL Server, SQLite) are correctly configured.
- **`Bookstore.Web`**: If the project was previously an ASP.NET Web Forms or ASP.NET MVC (.NET Framework) application, confirm it has been migrated to ASP.NET Core. Check middleware configuration in `Program.cs` or `Startup.cs`.
- **`Bookstore.Domain`**: Review any use of `System.Configuration`, `HttpContext`, or other APIs that do not exist in cross-platform .NET.

---

## 5. Run Unit Tests

If the solution contains a test project, run all tests to validate core logic.

```bash
dotnet test
```

If no test project exists, consider writing basic integration or unit tests for the domain and data layers before proceeding further.

---

## 6. Run the Application Locally

Start the web application locally to confirm it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and verify:

- Pages load correctly.
- Database connectivity is functional (check connection strings in `appsettings.json`).
- Core application workflows (e.g., browsing books, user authentication if applicable) behave as expected.

---

## 7. Validate Configuration

In cross-platform .NET, configuration is typically handled through `appsettings.json` rather than `Web.config` or `App.config`. Confirm the following:

- Connection strings are present in `appsettings.json`.
- Any environment-specific settings are placed in `appsettings.Development.json` or `appsettings.Production.json`.
- The `Web.config` file, if still present, is only used for IIS-specific settings and not for application configuration.

---

## 8. Publish the Application

Once local validation is complete, publish the application to produce deployment artifacts.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets and configuration files.

---

## 9. Deploy to Target Environment

Copy the published output to the target server or hosting environment. If hosting on IIS:

- Ensure the **ASP.NET Core Hosting Bundle** is installed on the server.
- Configure the IIS site to point to the published output directory.
- Verify the `web.config` generated during publish is present and correctly configured for the ASP.NET Core module.

If hosting on Linux:

- Confirm the .NET runtime matching the target framework is installed.
- Use a process manager such as `systemd` to manage the application process.