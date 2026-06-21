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

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `netstandard` or `net4x` targets exclusively, consider finding their cross-platform equivalents on [NuGet](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing behavior has been preserved after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, it is worth adding tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

Since `Bookstore.Data` is present, the project likely uses Entity Framework Core or a similar ORM. Verify the following:

- The connection string in `appsettings.json` (or equivalent) points to a valid and accessible database.
- If Entity Framework Core is in use, confirm that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to confirm it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL printed in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and manually verify that core functionality such as browsing, searching, and any data-driven pages work correctly.

---

## 6. Review Platform-Specific Code

Search the solution for any remaining Windows-specific APIs or patterns that may not behave correctly on Linux or macOS:

- `Registry` access (`Microsoft.Win32.Registry`)
- Windows file path separators (use `Path.Combine` instead of hardcoded `\`)
- `HttpContext.Current` (not available in ASP.NET Core)
- `System.Web` references (not available in .NET Core or later)

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify any remaining issues.

---

## 7. Review Configuration and Middleware

Confirm that the `Bookstore.Web` project is using the ASP.NET Core configuration and middleware pipeline correctly:

- Ensure `appsettings.json` and `appsettings.{Environment}.json` contain all necessary configuration values previously stored in `Web.config` or `App.config`.
- Verify that authentication, authorization, error handling, and static file middleware are all registered in `Program.cs` or `Startup.cs`.

---

## 8. Validate Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to a currently supported version of .NET:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) to confirm the chosen version is within its support window.