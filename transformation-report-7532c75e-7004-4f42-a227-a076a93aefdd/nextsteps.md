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

Review the output for any warnings related to package version conflicts or deprecated packages. Address any that appear.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or target framework compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration.

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding them to cover critical areas such as:

- Domain model logic in `Bookstore.Domain`
- Data access operations in `Bookstore.Data`
- Controller actions and middleware behavior in `Bookstore.Web`

---

## 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas during manual testing:

- Application startup and routing
- Database connectivity and data retrieval through `Bookstore.Data`
- Any authentication or session-based functionality
- Static file serving and view rendering

---

## 5. Review Configuration Files

Confirm that configuration files have been correctly migrated and are appropriate for cross-platform .NET.

- Verify that `appsettings.json` contains the correct connection strings and application settings.
- Ensure there are no remaining references to `Web.config` or `App.config` patterns that are not compatible with the new configuration system.
- Check that environment-specific settings (e.g., `appsettings.Development.json`) are in place.

---

## 6. Check Target Framework Compatibility

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting an older version such as `net6.0` or `net7.0`, consider updating to `net8.0` or the latest LTS release.

---

## 7. Review Entity Framework or Data Access Layer

If `Bookstore.Data` uses Entity Framework Core, verify the following:

- Migrations are up to date and can be applied successfully.
- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is compatible with the target framework version.

Apply pending migrations if applicable:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Publish the Application

Once validation is complete, publish the application to confirm a clean release output.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present, including static assets and configuration files.