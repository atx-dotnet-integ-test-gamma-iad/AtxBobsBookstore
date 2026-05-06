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

Ensure the build completes with zero errors and review any warnings, as some warnings may indicate runtime issues that do not surface at compile time.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET release schedule](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) to confirm the selected version is still under active support.

---

## 4. Check for Removed or Changed APIs

Some APIs available in .NET Framework are not present or have changed in cross-platform .NET. Review the following areas:

- **`System.Web` dependencies**: These are not available in .NET. Ensure `Bookstore.Web` has fully migrated to ASP.NET Core equivalents.
- **Entity Framework**: If `Bookstore.Data` uses Entity Framework, confirm it has been updated to Entity Framework Core and that migrations are compatible.
- **Configuration**: Verify that `Web.config` or `App.config` usage has been replaced with `appsettings.json` and the `Microsoft.Extensions.Configuration` APIs.
- **Windows-only APIs**: If any project used Windows-specific APIs (e.g., registry access, Windows authentication), verify cross-platform alternatives are in place.

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tool to identify any remaining incompatible API usage.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to validate core functionality:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no tests currently exist, consider writing tests for the core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding to deployment.

---

## 6. Run the Application Locally

Start the web application locally to verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Verify the following manually:

- The application starts without runtime exceptions.
- All pages or API endpoints load correctly.
- Database connectivity works as expected (check connection strings in `appsettings.json`).
- Authentication and authorization behave correctly if applicable.

---

## 7. Validate Database Migrations

If Entity Framework Core is used in `Bookstore.Data`, confirm that migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to a test database before targeting production:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Publish the Application

Once local validation is complete, publish the application to a target directory:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.