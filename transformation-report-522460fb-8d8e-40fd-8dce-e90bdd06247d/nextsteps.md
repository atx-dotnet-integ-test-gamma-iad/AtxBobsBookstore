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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the transformation.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding unit tests for the core logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

---

## 4. Verify Entity Framework Core Migrations (if applicable)

If `Bookstore.Data` uses Entity Framework, confirm that migrations are compatible with the new target framework. Run the following to check the current migration state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

Apply the migration to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Web Application Locally

Start the web application to verify it runs correctly in the new cross-platform environment:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL indicated in the console output (typically `http://localhost:5000` or `https://localhost:5001`) and manually verify the following:

- Application startup completes without exceptions
- Core pages and routes load correctly
- Data is read from and written to the database as expected
- Authentication and authorization flows work correctly (if applicable)

---

## 6. Review Configuration Files

Check `appsettings.json` and any environment-specific configuration files (e.g., `appsettings.Development.json`) to confirm the following:

- Connection strings are updated to reflect the target database environment
- Any configuration keys that were previously stored in `Web.config` have been correctly migrated to the `appsettings.json` format
- Logging configuration is appropriate for the target environment

---

## 7. Check for Platform-Specific Code

Review the codebase for any remaining usage of Windows-specific APIs or libraries that may cause issues on Linux or macOS. Common areas to check include:

- File path separators — use `Path.Combine` rather than hardcoded backslashes
- Registry access — not available on non-Windows platforms
- `System.Drawing` — limited support outside of Windows without additional packages such as `System.Drawing.Common`
- Windows Authentication — requires additional configuration on non-Windows hosts

---

## 8. Review Deprecated or Removed APIs

The migration to modern .NET may have introduced usage of APIs that behave differently or have been removed. Review the following:

- Any use of `HttpContext.Current` should be replaced with dependency-injected `IHttpContextAccessor`
- `ConfigurationManager` usage should be replaced with `IConfiguration`
- `System.Web` references should be fully removed and replaced with `Microsoft.AspNetCore` equivalents

Run a search across the solution for any remaining `System.Web` references:

```bash
grep -r "System.Web" --include="*.cs" .
```

---

## 9. Validate Target Framework

Confirm that all projects are targeting the intended .NET version by inspecting each `.csproj` file and verifying the `<TargetFramework>` element. For example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web`.