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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

For the web project, confirm it is using the appropriate web SDK:

```xml
<Project Sdk="Microsoft.NET.Sdk.Web">
```

---

## 4. Check Configuration Files

- Confirm that `appsettings.json` (and `appsettings.Development.json`) are present in `Bookstore.Web` and contain the correct connection strings and application settings.
- If the original project used `Web.config` or `App.config`, verify that all relevant settings have been migrated to `appsettings.json` or the appropriate .NET configuration mechanism.
- Ensure that any `connectionStrings` previously in `Web.config` are now represented correctly in `appsettings.json`.

---

## 5. Validate the Data Layer

- Confirm that Entity Framework (or whichever ORM is in use) has been updated to its .NET-compatible version.
- If using Entity Framework Core, verify that migrations are present and up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to a local development database to confirm schema compatibility:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application locally to verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the application in a browser and exercise the core functionality, including:

- Browsing and searching for books
- Any authentication or authorization flows
- Data creation, update, and deletion operations

Check the console output and application logs for any runtime exceptions or warnings.

---

## 7. Run Existing Tests

If the solution contains a test project, execute the test suite to validate business logic and data access behavior:

```bash
dotnet test
```

Review test results for any failures that may indicate behavioral differences introduced during migration.

---

## 8. Review Removed or Changed APIs

Cross-platform .NET does not support certain APIs that were available in .NET Framework. Review the following areas manually:

- **`System.Web` dependencies**: These are not available in .NET. Ensure all usages have been replaced with ASP.NET Core equivalents.
- **`HttpContext` usage**: Confirm access patterns use the ASP.NET Core `IHttpContextAccessor` where appropriate.
- **`ConfigurationManager`**: Confirm this has been replaced with `IConfiguration`.
- **Windows-specific APIs**: If any Windows-only libraries or P/Invoke calls exist in `Bookstore.Data` or `Bookstore.Domain`, assess whether cross-platform alternatives are needed.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.