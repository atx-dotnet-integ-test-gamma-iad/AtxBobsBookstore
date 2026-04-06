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

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check [NuGet.org](https://www.nuget.org) for updated versions compatible with the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Inspect all three projects for any remaining Windows-specific APIs or packages, such as:

- `System.Web` references
- `Microsoft.Web.*` packages
- Windows Registry access
- COM interop

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining platform-specific code.

---

## 5. Validate the Data Layer (`Bookstore.Data`)

- Confirm that the database provider (e.g., Entity Framework Core) is correctly configured in the `.csproj` and `DbContext`.
- If Entity Framework Core is in use, verify that migrations are present and up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to a local development database to confirm they execute without errors:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and verify it runs on a non-Windows platform or in a cross-platform environment:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Confirm the application starts without runtime exceptions.
- Navigate through the core application routes to verify basic functionality.
- Check that database connectivity is working as expected.

---

## 7. Execute Unit and Integration Tests

If test projects exist in the solution, run them to validate business logic and data access behavior:

```bash
dotnet test --configuration Release --verbosity normal
```

Review the test output for any failures that may indicate behavioral regressions introduced during the migration.

---

## 8. Review Application Configuration

- Confirm that `Web.config` has been fully replaced by `appsettings.json` and that all configuration values (connection strings, app settings) have been migrated correctly.
- Verify that environment-specific configuration files (e.g., `appsettings.Development.json`) are in place.
- Ensure `Program.cs` and `Startup.cs` (or the combined `Program.cs` in minimal hosting model) correctly wire up services, middleware, and configuration.

---

## 9. Validate Logging and Error Handling

- Confirm that any legacy `System.Diagnostics` or `log4net` logging has been replaced with `Microsoft.Extensions.Logging` or a compatible provider.
- Test error handling by triggering known edge cases and confirming that errors are logged and surfaced appropriately.

---

## 10. Deploy to Target Environment

Once local validation is complete:

1. Publish the application using the appropriate runtime identifier for the target platform:

```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained false
```

2. Copy the published output to the target server or hosting environment.
3. Configure the web server (e.g., Nginx, IIS on Windows, or Kestrel directly) to serve the application.
4. Verify the deployed application connects to the production database and functions correctly.