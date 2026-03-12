# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

## Validation Steps

### 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that the output shows zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

### 3. Run Unit Tests

If the solution contains test projects, execute them to confirm existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, confirm the following:

- Connection strings in `appsettings.json` are correctly configured for the target environment.
- Any Entity Framework migrations are up to date. Run the following if applicable:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) is compatible with the target .NET version.

### 5. Check Runtime Behavior of Bookstore.Web

Launch the web application locally and verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:

- All routes resolve correctly.
- Authentication and authorization behave as expected, particularly if the legacy project used `System.Web` identity components that may have been replaced.
- Static files, views, and any Razor pages or MVC components render without errors.
- Review application logs for any runtime exceptions that would not surface at build time.

### 6. Review Configuration Files

Cross-platform .NET does not use `Web.config` for runtime configuration. Confirm that:

- All settings previously in `Web.config` or `App.config` have been migrated to `appsettings.json`.
- Environment-specific configuration (e.g., `appsettings.Development.json`) is in place.
- Any configuration transforms that existed in the legacy project have been accounted for.

### 7. Check for Windows-Specific API Usage

Even without build errors, certain APIs behave differently or are unavailable on non-Windows platforms. Search the codebase for usage of the following and test on the intended target platform if it is not Windows:

- `Microsoft.Win32` namespace
- Registry access
- Windows-specific file path assumptions (backslashes, drive letters)
- `System.Drawing` (GDI+), which has platform limitations outside of Windows

### 8. Review Target Framework

Confirm that all three projects are targeting the intended framework version by inspecting each `.csproj` file:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across projects to avoid compatibility issues between referenced assemblies.