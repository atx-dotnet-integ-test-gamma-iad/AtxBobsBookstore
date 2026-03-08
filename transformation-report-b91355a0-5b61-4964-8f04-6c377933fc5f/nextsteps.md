# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check NuGet for cross-platform compatible versions.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without errors or warnings.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Confirm the following:

- `appsettings.json` exists in `Bookstore.Web` and contains the correct connection strings and application settings.
- Any environment-specific settings are placed in `appsettings.Development.json` or `appsettings.Production.json` as appropriate.
- `Web.config` transformations, if they existed in the original project, have been migrated to the `appsettings.json` structure.

---

## 4. Verify Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm the following:

- If Entity Framework is used, verify it has been updated to **Entity Framework Core**.
- Run any pending migrations to ensure the database schema is up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If a different ORM or ADO.NET is used, verify that connection strings and provider names are compatible with .NET.

---

## 5. Run Unit Tests

If a test project exists in the solution, execute the tests to validate business logic and data access behavior.

```bash
dotnet test
```

Review any failing tests and determine whether they are failing due to migration issues or pre-existing defects.

---

## 6. Run the Application Locally

Start the web application locally to perform manual validation.

```bash
dotnet run --project Bookstore.Web
```

Verify the following:

- The application starts without runtime exceptions.
- All pages and routes load as expected.
- Database reads and writes function correctly.
- Authentication and authorization behave as expected, if applicable.

---

## 7. Check for Platform-Specific Code

Search the codebase for any APIs or libraries that were specific to Windows or .NET Framework and may not function correctly on cross-platform .NET:

- `System.Web` references — these are not available in .NET and must be replaced.
- Windows Registry access (`Microsoft.Win32.Registry`).
- COM interop dependencies.
- `HttpContext.Current` usage — replace with dependency-injected `IHttpContextAccessor`.

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.ApiCompat` tool if a more thorough audit is needed.

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets and configuration files.

---

## 9. Deploy to the Target Environment

Copy the published output to the target server or hosting environment. Ensure the target environment has the correct .NET runtime installed:

```bash
dotnet --list-runtimes
```

If hosting on IIS, confirm that the **ASP.NET Core Hosting Bundle** is installed and that the IIS site is configured to use the correct application pool (No Managed Code).