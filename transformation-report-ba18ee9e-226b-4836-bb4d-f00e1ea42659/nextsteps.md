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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility. While warnings do not prevent a build from succeeding, they can indicate areas of the code that may behave unexpectedly at runtime.

---

## 3. Verify Runtime Compatibility

Check each project for any APIs that were available in .NET Framework but have changed behavior or are absent in cross-platform .NET. Common areas to inspect include:

- **`System.Configuration`**: `ConfigurationManager` is available via the `System.Configuration.ConfigurationManager` NuGet package, but consider migrating to `Microsoft.Extensions.Configuration` if not already done.
- **`System.Web`**: This namespace is not available in cross-platform .NET. Confirm that `Bookstore.Web` has been fully migrated to ASP.NET Core.
- **Entity Framework**: If `Bookstore.Data` uses Entity Framework 6, verify whether it has been migrated to Entity Framework Core, as EF6 has limited support on non-Windows platforms.
- **File paths**: Ensure no hardcoded Windows-style paths (`\`) exist. Use `Path.Combine` or forward slashes for cross-platform compatibility.

---

## 4. Run Existing Tests

If the solution contains a test project, execute the test suite to validate that the business logic in `Bookstore.Domain` and data access in `Bookstore.Data` behave as expected after migration.

```bash
dotnet test
```

If no tests currently exist, consider writing unit tests for the core domain logic and integration tests for the data layer before proceeding to deployment.

---

## 5. Test the Web Application Locally

Run the `Bookstore.Web` project locally and manually verify the application's key functionality.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Specifically verify:

- All pages load without HTTP 500 errors.
- Database connectivity works as expected (check connection strings in `appsettings.json`).
- Authentication and authorization flows function correctly if present.
- Static assets (CSS, JavaScript, images) are served properly.

---

## 6. Review Configuration Files

Ensure that configuration has been properly migrated from `Web.config` or `App.config` to `appsettings.json`. Confirm the following:

- Connection strings are present and correct in `appsettings.json`.
- Environment-specific settings are separated using `appsettings.Development.json` and `appsettings.Production.json` where appropriate.
- Any secrets (API keys, passwords) are stored using the .NET Secret Manager or environment variables rather than in committed configuration files.

---

## 7. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including the compiled assemblies, `appsettings.json`, and static web assets.

---

## 8. Verify Target Platform

Confirm that the target deployment environment has the correct .NET runtime installed. Check the target framework moniker in each `.csproj` file (e.g., `net8.0`) and ensure the matching runtime is available on the deployment machine.

```bash
dotnet --info
```