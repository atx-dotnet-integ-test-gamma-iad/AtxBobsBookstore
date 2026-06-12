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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a currently supported version of .NET (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting an older or end-of-life version such as `netcoreapp3.1` or `net5.0`, update it to a supported version.

---

## 4. Check for Windows-Specific Dependencies

Since this is a legacy project migration, inspect each project for any remaining Windows-specific APIs or packages, such as:

- `System.Web` references
- Windows Registry access
- COM interop
- `Microsoft.Web.Infrastructure`

These will not function correctly on Linux or macOS. Replace them with cross-platform alternatives where applicable.

---

## 5. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework or another ORM, verify the following:

- The connection string in `appsettings.json` is correctly configured for the target environment.
- Any database migrations are up to date.

Run pending migrations if applicable:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If the EF tools are not installed:

```bash
dotnet tool install --global dotnet-ef
```

---

## 6. Run the Application Locally

Start the web application to confirm it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL shown in the terminal output and verify that core functionality behaves as expected.

---

## 7. Check Application Configuration

Review `appsettings.json` and `appsettings.Development.json` in `Bookstore.Web` for any configuration values that may have been specific to the old environment, such as:

- Hardcoded file paths using Windows-style separators (`\`)
- SMTP or external service endpoints
- Authentication settings (e.g., Windows Authentication vs. cookie/token-based)

Update these values to be environment-neutral or use environment variables where appropriate.

---

## 8. Execute Unit and Integration Tests

If the solution contains test projects, run them to validate business logic and data access behavior.

```bash
dotnet test
```

Review any failing tests and determine whether the failures are due to migration issues or pre-existing problems.

---

## 9. Validate Static Assets and Razor Views

For `Bookstore.Web`, manually verify that:

- All Razor views render correctly
- Static files (CSS, JavaScript, images) are served properly
- Bundling and minification, if used, is handled via a supported mechanism such as `LibMan` or a Node-based build step rather than the legacy `BundleConfig.cs` approach

---

## 10. Review Logging and Error Handling

Confirm that the application uses a supported logging framework such as `Microsoft.Extensions.Logging`. If the legacy project used `log4net` or `NLog`, verify that the configuration has been updated to work with the .NET hosting model and that log output appears as expected during local runs.