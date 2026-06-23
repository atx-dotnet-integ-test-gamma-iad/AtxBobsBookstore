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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay particular attention to any warnings about nullable reference types or obsolete APIs, as these may indicate areas that need attention even if they do not block the build.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). For example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target a consistent framework version to avoid runtime compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Even when a project builds successfully, it may still contain APIs or packages that only function on Windows. Review the following:

- Any use of `Microsoft.Win32` namespaces
- Registry access or Windows-specific file paths
- Packages that have not been updated for cross-platform support

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package to identify platform-specific code.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the tests to validate core functionality:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing basic integration or unit tests for the `Bookstore.Domain` and `Bookstore.Data` layers before proceeding to deployment.

---

## 6. Validate the Web Application Locally

Run the `Bookstore.Web` project locally to confirm it starts and functions correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following:

- The application starts without runtime exceptions
- Database connections (if any) are functional and connection strings are correctly configured for the new environment
- All major routes and pages load as expected
- Static assets are served correctly

---

## 7. Review Configuration Files

Ensure that `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, `appsettings.Production.json`) are present and correctly configured. Legacy `Web.config` or `App.config` settings should have been migrated to the `appsettings.json` format. Confirm that:

- Connection strings are present and correct
- Any environment variables referenced in configuration are defined in the target environment
- Sensitive values are not hardcoded and are managed via environment variables or a secrets manager

---

## 8. Verify Database Compatibility

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The EF Core version referenced is compatible with the target .NET version
- Migrations are up to date by running:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- Apply any pending migrations to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory before deploying to the target environment.