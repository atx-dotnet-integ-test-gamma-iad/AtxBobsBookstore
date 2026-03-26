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

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the tests to verify that business logic and data access behavior remain intact after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding tests for the core logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

If `Bookstore.Data` uses Entity Framework Core, confirm that your database migrations are up to date and compatible with the new target framework:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are present but have not been applied, run:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Ensure that connection strings in `appsettings.json` or environment-specific configuration files are correctly configured for the target environment.

---

## 5. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and verify that:

- Pages load without errors
- Data is read from and written to the database correctly
- Any authentication or authorization flows behave as expected

---

## 6. Review Configuration Files

Check the following configuration aspects that commonly require attention after a cross-platform migration:

- **File paths**: Ensure no hardcoded Windows-style paths (`C:\...`) exist in configuration or code. Use `Path.Combine` for path construction.
- **Environment variables**: Confirm that any environment-specific settings are correctly defined for the target deployment environment.
- **`appsettings.json`**: Verify that all required keys are present and that the structure is valid JSON.

---

## 7. Check for Platform-Specific API Usage

Review the codebase for any remaining usage of Windows-specific APIs that may not be available on Linux or macOS. Common areas to check include:

- Registry access (`Microsoft.Win32.Registry`)
- Windows Identity and impersonation APIs
- `System.Drawing` (GDI+), which requires additional native dependencies on non-Windows platforms

Use the [.NET Upgrade Assistant](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify any remaining platform-specific calls.

---

## 8. Deploy to Target Environment

Once local validation is complete, publish the application:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to your target server or hosting environment and configure the web server (e.g., IIS, Nginx, or Kestrel as a standalone host) to serve the application.

Refer to the official documentation for hosting options:
- [Host ASP.NET Core on Windows with IIS](https://learn.microsoft.com/en-us/aspnet/core/host-and-deploy/iis/)
- [Host ASP.NET Core on Linux with Nginx](https://learn.microsoft.com/en-us/aspnet/core/host-and-deploy/linux-nginx)