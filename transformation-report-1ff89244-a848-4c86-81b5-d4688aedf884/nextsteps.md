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

Ensure the build completes with zero errors and review any warnings, as some warnings may indicate compatibility concerns that could surface at runtime.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting an older version such as `net6.0` or `net7.0`, consider updating to `net8.0` as those versions have reached or are approaching end of life.

---

## 4. Check for Removed or Changed APIs

Some APIs available in .NET Framework are not present or have changed in cross-platform .NET. Review the following areas manually:

- **`System.Web` references**: These are not available in .NET. If any remain, they need to be replaced with ASP.NET Core equivalents.
- **`HttpContext`**: Ensure usage has been migrated to `Microsoft.AspNetCore.Http.HttpContext`.
- **`ConfigurationManager`**: Replace with `Microsoft.Extensions.Configuration`.
- **`EntityFramework` (non-Core)**: Ensure the project is using `Microsoft.EntityFrameworkCore` and not the legacy `EntityFramework` package.

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tool to assist with this review.

---

## 5. Run the Application Locally

Start the web application locally to verify it runs without runtime errors:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate through the key areas of the application and check for:

- Pages loading without HTTP 500 errors
- Database connectivity (if applicable)
- Correct routing behavior

---

## 6. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date and the database schema is correct:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to your development database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 7. Run Existing Tests

If the solution contains a test project, execute the test suite to confirm existing functionality has not regressed:

```bash
dotnet test
```

Review any failing tests and determine whether they are failing due to migration-related changes or pre-existing issues.

---

## 8. Verify Configuration Files

Confirm that `appsettings.json` contains all necessary configuration that was previously held in `Web.config` or `App.config`, including:

- Connection strings
- Application settings
- Logging configuration

The `Web.config` file is not used for application configuration in ASP.NET Core. Any remaining `Web.config` should only contain IIS-specific settings if deploying to IIS.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present.

---

## 10. Deploy to Target Environment

Copy the published output to your target hosting environment. If hosting on IIS:

- Ensure the [ASP.NET Core Hosting Bundle](https://dotnet.microsoft.com/en-us/download/dotnet) is installed on the server.
- Configure the IIS site to point to the publish directory.
- Confirm the `web.config` generated in the publish output contains the correct `aspNetCore` handler configuration.

If hosting on Linux, ensure the target machine has the appropriate .NET runtime installed and configure a process manager such as `systemd` to manage the application process.