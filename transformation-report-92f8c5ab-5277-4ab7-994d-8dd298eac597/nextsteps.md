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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to confirm all dependencies resolve correctly under the new target framework.

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages. If any packages target `net4x` exclusively, consider finding their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after migration.

```bash
dotnet test --configuration Release
```

Review any failing tests carefully. Failures may indicate behavioral differences between the legacy .NET Framework APIs and their cross-platform .NET equivalents.

---

## 4. Verify Data Layer (`Bookstore.Data`)

- Confirm that the database provider package (e.g., Entity Framework Core) is correctly referenced and configured.
- If the project previously used `System.Data` or Entity Framework 6, verify whether a migration to EF Core was performed and that all `DbContext` configurations, migrations, and connection strings are correct.
- Run any pending EF Core migrations against a development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Verify Configuration in `Bookstore.Web`

- Confirm that `appsettings.json` contains all configuration values that were previously in `Web.config` or `App.config`, including connection strings and application settings.
- Verify that the `Program.cs` and `Startup.cs` (or the minimal hosting model in `Program.cs`) correctly registers all services, middleware, and routing.
- Check that any static files, views, or Razor pages are present in the expected directories (`wwwroot`, `Views`, `Pages`).

---

## 6. Run the Application Locally

Start the web application and manually verify core functionality.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser.
- Test primary user flows such as browsing, searching, and any data entry forms.
- Check the console and application logs for runtime exceptions or warnings.

---

## 7. Review Platform-Specific API Usage

Use the .NET Upgrade Analyzer or the `dotnet-compatibility` tooling to identify any remaining platform-specific API calls that may not behave correctly on non-Windows systems if cross-platform support is required.

```bash
dotnet add package Microsoft.DotNet.ApiCompat
```

Pay particular attention to:
- File path handling (use `Path.Combine` rather than hardcoded separators)
- Registry access (`Microsoft.Win32.Registry` is Windows-only)
- Windows-specific authentication or identity APIs

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

Review the contents of the `./publish` directory before deploying to the target environment.