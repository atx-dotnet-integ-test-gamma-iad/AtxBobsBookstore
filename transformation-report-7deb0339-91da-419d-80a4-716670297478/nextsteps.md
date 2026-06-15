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

Run a NuGet package restore to ensure all dependencies are resolved correctly:

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

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy) to confirm your chosen version is still within its support window.

---

## 4. Check for Windows-Specific Dependencies

Since this is a Bookstore web application that was migrated from a legacy project, verify that no Windows-only APIs are being used. Run the .NET Compatibility Analyzer if not already done:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Pay particular attention to:
- `System.Web` references (should be replaced with `Microsoft.AspNetCore`)
- Any use of the Windows registry or Windows-specific file paths
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

---

## 5. Validate the Data Layer

In `Bookstore.Data`, confirm the following:

- If Entity Framework is used, ensure it has been migrated to **Entity Framework Core**.
- Verify the connection string configuration has been moved from `Web.config` or `App.config` to `appsettings.json`.
- Run any existing database migrations to confirm they apply cleanly:

```bash
dotnet ef database update
```

If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration
dotnet ef database update
```

---

## 6. Validate the Domain Layer

In `Bookstore.Domain`, confirm that:

- All models and business logic compile without warnings.
- Any data annotations or validation attributes are sourced from `System.ComponentModel.DataAnnotations`, which is available cross-platform.

---

## 7. Validate the Web Layer

In `Bookstore.Web`, confirm the following:

- The `Startup.cs` or `Program.cs` file follows the ASP.NET Core conventions appropriate for your target framework version.
- Authentication and authorization middleware is correctly configured if used.
- Static files, routing, and middleware are registered in the correct order within the request pipeline.
- Run the application locally:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the displayed local URL and verify core application functionality such as browsing, searching, and any data entry flows.

---

## 8. Run Existing Tests

If a test project exists in the solution, execute the test suite to confirm existing behavior is preserved:

```bash
dotnet test
```

Review any failing tests and determine whether they reflect regressions introduced during migration or tests that require updating due to API changes in ASP.NET Core.

---

## 9. Configuration Migration Check

Confirm that all configuration previously held in `Web.config` or `App.config` has been moved to `appsettings.json` or environment variables. Key areas to check include:

- Database connection strings
- Application settings (e.g., API keys, feature flags)
- Logging configuration

Example `appsettings.json` structure:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  }
}
```

---

## 10. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all necessary files are present before deploying to your target environment.