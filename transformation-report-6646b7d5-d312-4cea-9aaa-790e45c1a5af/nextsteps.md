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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, locate them in the respective `.csproj` files and replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

If no test projects currently exist, consider adding tests for the core logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Validate the Data Layer

Since `Bookstore.Data` likely interacts with a database, verify the following:

- **Connection strings** in `appsettings.json` (or equivalent) are correctly configured for the target environment.
- If Entity Framework is in use, confirm that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If the project previously used `System.Data` or ADO.NET directly, test database connectivity manually against the target database.

---

## 5. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:
- The application starts without exceptions in the console output.
- All pages and endpoints load correctly.
- Any authentication, session handling, or HTTP module behavior that was previously handled by ASP.NET (classic) now functions correctly under ASP.NET Core middleware.

---

## 6. Review Configuration Migration

Legacy .NET Framework projects used `Web.config` and `App.config`. Confirm that all relevant configuration values have been moved to `appsettings.json` or environment variables, including:

- Connection strings
- Application settings (e.g., API keys, feature flags)
- Logging configuration

Ensure that `ConfigurationManager` references, if any remain, have been replaced with the `Microsoft.Extensions.Configuration` abstractions.

---

## 7. Check for Platform-Specific Code

Review the codebase for any APIs that were available in .NET Framework but are unavailable or behave differently in cross-platform .NET:

- `System.Web` references should have been fully removed.
- `HttpContext`, `HttpRequest`, and `HttpResponse` usages should use the ASP.NET Core equivalents.
- Any use of the Windows Registry, COM interop, or Windows-only APIs should be identified and either replaced or conditionally compiled.

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify remaining compatibility concerns.

---

## 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.