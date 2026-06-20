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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If the projects are targeting `net6.0` or `net7.0`, consider upgrading to `net8.0` as those versions have reached or are approaching end-of-life.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, verify that no Windows-specific APIs are being used unintentionally. Run the .NET Compatibility Analyzer if it is not already included:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Pay particular attention to:
- `System.Web` references (not available in .NET Core/5+)
- Windows Registry access
- Windows-only file path assumptions

---

## 5. Run the Application Locally

Start the `Bookstore.Web` project and verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually test the following areas:
- Application startup and landing page load
- Database connectivity through `Bookstore.Data`
- Domain logic correctness through `Bookstore.Domain`
- Any authentication or authorization flows
- CRUD operations related to bookstore entities

---

## 6. Verify Database Migrations

If the project uses Entity Framework Core, confirm that migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to your target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 7. Execute Automated Tests

If the solution contains test projects, run them to validate that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures. If no test projects exist, consider adding unit tests for the core domain logic in `Bookstore.Domain` and integration tests for the data layer in `Bookstore.Data`.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, `appsettings.Production.json`) are present and correctly configured. Legacy `Web.config` or `App.config` settings should have been migrated to `appsettings.json`. Confirm that:

- Connection strings are correct
- Any environment-specific values are externalized and not hardcoded
- Logging configuration is present

---

## 9. Publish the Application

Once validation is complete, publish the application to a target folder:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required files are present before deploying to the target environment.