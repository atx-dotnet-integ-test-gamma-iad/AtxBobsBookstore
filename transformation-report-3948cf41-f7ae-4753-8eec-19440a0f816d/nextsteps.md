# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution (`Bookstore.Data`, `Bookstore.Web`, and `Bookstore.Domain`). The steps below focus on validating and testing the migrated solution before deploying it.

---

## 1. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 2. Restore Dependencies

Run a NuGet restore to ensure all packages resolve correctly against the new target framework.

```bash
dotnet restore
```

Review the output for any warnings about packages that do not support the target framework or that have been deprecated. Replace any such packages with their supported equivalents.

---

## 3. Build the Solution

Perform a full solution build to confirm there are no compile-time issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface at this stage, particularly those related to nullable reference types or obsolete APIs, as these can indicate subtle behavioral differences from the original project.

---

## 4. Run Unit Tests

If the solution contains a test project, execute the test suite to verify that business logic and data access behavior remain consistent after migration.

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic tests covering the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding.

---

## 5. Validate Database Connectivity and Migrations

Since `Bookstore.Data` is present, verify that any Entity Framework Core configuration is correct.

- Confirm the connection string in `appsettings.json` is valid for the target environment.
- If Entity Framework migrations are used, apply them against a test database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Inspect the resulting schema to confirm it matches expectations.

---

## 6. Run the Application Locally

Start the web application and perform manual smoke testing of core functionality.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following at a minimum:

- The application starts without runtime exceptions.
- Pages or API endpoints load and return expected data.
- Any authentication or authorization flows behave correctly.
- Static assets are served properly.

---

## 7. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` for runtime configuration. Confirm that:

- All configuration has been moved to `appsettings.json` or environment variables.
- Any `Web.config` or `App.config` transforms that were relied upon previously have been replicated in the new configuration system.
- Sensitive values such as connection strings are not committed to source control and are instead managed via user secrets or environment variables.

```bash
dotnet user-secrets set "ConnectionStrings:Default" "your_connection_string"
```

---

## 8. Check for Platform-Specific API Usage

Review the codebase for any APIs that were available in .NET Framework but behave differently or are unavailable in cross-platform .NET. Common areas to inspect include:

- `System.Web` references (should be fully removed).
- Windows registry access.
- `AppDomain` usage.
- Any P/Invoke calls targeting Windows-specific libraries.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify remaining compatibility concerns.

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm the application runs from the published output before deploying to the target environment.