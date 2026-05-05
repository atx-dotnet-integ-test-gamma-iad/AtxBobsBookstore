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

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, consider finding their cross-platform equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) to confirm the selected version is still under active or LTS support.

---

## 4. Validate the Data Layer (`Bookstore.Data`)

- Confirm that any Entity Framework or data access dependencies have been updated to their cross-platform versions (e.g., `Microsoft.EntityFrameworkCore` instead of `System.Data.Entity`).
- If using EF Core, verify that migrations are present and up to date:

```bash
dotnet ef migrations list --project Bookstore.Data
```

- Apply migrations against a local or development database to confirm schema compatibility:

```bash
dotnet ef database update --project Bookstore.Data
```

---

## 5. Validate the Domain Layer (`Bookstore.Domain`)

- Review domain models and business logic for any use of APIs that were Windows-specific or have changed behavior in cross-platform .NET.
- Run any existing unit tests targeting this layer:

```bash
dotnet test
```

---

## 6. Validate the Web Layer (`Bookstore.Web`)

- Confirm the project is using `Microsoft.AspNetCore.*` packages and not legacy `System.Web` references, as `System.Web` is not available in cross-platform .NET.
- Launch the application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and exercise the primary workflows (browsing, searching, and any authentication flows if present).
- Check application logs for runtime exceptions that would not surface at compile time.

---

## 7. Configuration and Secrets

- Verify that `Web.config` settings have been migrated to `appsettings.json` or environment variables, as `Web.config` is not used in ASP.NET Core.
- Confirm connection strings and any environment-specific settings are correctly configured for the target environment.

---

## 8. Run the Full Test Suite

If the solution contains a test project, execute all tests and confirm they pass:

```bash
dotnet test --configuration Release --logger trx
```

Review the `.trx` output for any failures or skipped tests that may indicate behavioral regressions introduced during the migration.

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assets, views, and static files are present before deploying to the target environment.