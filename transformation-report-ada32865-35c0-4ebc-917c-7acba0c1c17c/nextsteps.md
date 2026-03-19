# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution (`Bookstore.Data`, `Bookstore.Web`, and `Bookstore.Domain`). The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no issues beyond what was captured in the initial error report:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types or obsolete APIs, as these can indicate subtle compatibility issues introduced during migration.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`):

- `Bookstore.Domain/Bookstore.Domain.csproj`
- `Bookstore.Data/Bookstore.Data.csproj`
- `Bookstore.Web/Bookstore.Web.csproj`

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Review each project's NuGet package references and source code for APIs that are Windows-only. Common areas to check include:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Communication Foundation (WCF)** server-side components
- **System.Drawing** (GDI+) — use `System.Drawing.Common` with caution or migrate to a cross-platform alternative
- **Web.config** transformations — these should have been replaced by `appsettings.json`

Run the .NET Upgrade Assistant compatibility analyzer if any uncertainty remains:

```bash
dotnet tool install -g upgrade-assistant
upgrade-assistant analyze ./Bookstore.sln
```

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate that business logic and data access behavior is preserved after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no tests exist, consider writing basic smoke tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding.

---

## 6. Validate the Web Application Locally

Start the web application and verify it runs correctly on your local machine:

```bash
dotnet run --project Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following:

- The application starts without runtime exceptions
- All routes and pages load as expected
- Database connectivity is functional (check connection strings in `appsettings.json`)
- Authentication and authorization flows work correctly if applicable

---

## 7. Review Configuration Migration

Confirm that any settings previously in `Web.config` or `App.config` have been correctly moved to `appsettings.json`. Pay particular attention to:

- Connection strings
- Application-specific keys
- Environment-specific overrides (use `appsettings.Development.json`, `appsettings.Production.json` as appropriate)

---

## 8. Test on a Non-Windows Platform (Optional but Recommended)

Since the goal is cross-platform compatibility, validate the application runs correctly on Linux or macOS if your deployment target requires it:

```bash
dotnet run --project Bookstore.Web/Bookstore.Web.csproj
```

Any platform-specific runtime errors that were not caught at build time will surface here.

---

## 9. Publish the Application

Once validation is complete, publish the application for deployment:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assets, configuration files, and binaries are present before deploying to your target environment.