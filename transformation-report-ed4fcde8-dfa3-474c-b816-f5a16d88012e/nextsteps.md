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

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review the test results carefully. Any failing tests may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

---

## 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, confirm the following:

- Connection strings in `appsettings.json` (or equivalent configuration) are correct for the target environment.
- Any Entity Framework migrations are up to date. Run the following if applicable:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If the project previously used `System.Data` or ADO.NET directly, verify that the queries execute correctly against the target database.

---

## 5. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Confirm the following:

- Configuration has been moved to `appsettings.json`.
- Any environment-specific settings are handled via `appsettings.{Environment}.json` or environment variables.
- `System.Configuration.ConfigurationManager` usages, if any remain, are backed by the appropriate NuGet package (`System.Configuration.ConfigurationManager`).

---

## 6. Run the Web Application Locally

Start the `Bookstore.Web` project and verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following manually:

- Application starts without runtime exceptions.
- All pages and API endpoints load correctly.
- Authentication and authorization flows work as expected, if applicable.
- Static files (CSS, JavaScript, images) are served correctly.

---

## 7. Check for Platform-Specific API Usage

Review the codebase for any APIs that were available in .NET Framework but behave differently or are unavailable in cross-platform .NET:

- `System.Drawing` — requires the `System.Drawing.Common` package and may have limitations on non-Windows platforms.
- `System.Web` — should have been fully replaced during transformation. Confirm no remaining references exist.
- Windows Registry access or COM interop — these will not function on non-Windows platforms.

Run the following to check for any remaining `System.Web` references:

```bash
grep -r "System.Web" ./app --include="*.cs"
```

---

## 8. Validate Target Framework

Confirm each project is targeting the intended .NET version by inspecting the `.csproj` files:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported framework version.

---

## 9. Publish the Application

Once validation is complete, publish the application using:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.