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

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Verify the following:

- `appsettings.json` contains the correct connection strings and application settings previously held in `Web.config`.
- Any environment-specific settings are placed in `appsettings.Development.json` or `appsettings.Production.json` as appropriate.
- Confirm that `Startup.cs` or `Program.cs` correctly reads from the new configuration sources.

---

## 4. Verify Entity Framework or Data Layer

Since `Bookstore.Data` is present, confirm the data access layer is functioning correctly:

- If using **Entity Framework Core**, verify the `DbContext` is registered in the dependency injection container.
- Run any pending migrations or verify the schema is up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If using a different ORM or ADO.NET, confirm connection strings and provider names are correct for the target platform.

---

## 5. Run the Application Locally

Start the application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing books, adding items, and any authentication flows, to confirm end-to-end functionality.

---

## 6. Execute Unit and Integration Tests

If the solution contains test projects, run them to validate business logic and data access behavior.

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to the migration or pre-existing issues.

---

## 7. Check for Platform-Specific Code

Search the codebase for any remaining platform-specific APIs that may cause issues on Linux or macOS if cross-platform deployment is intended:

- `System.Web` references (should have been replaced by `Microsoft.AspNetCore`)
- Windows Registry access (`Microsoft.Win32.Registry`)
- Windows-only file path assumptions (e.g., hardcoded backslashes)
- `HttpContext.Current` usage, which does not exist in ASP.NET Core

Use the [.NET Upgrade Assistant](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify any remaining issues.

---

## 8. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory and confirm all required assets and configuration files are present before deploying to the target environment.