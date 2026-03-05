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

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents via NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

- Confirm that `appsettings.json` (and any environment-specific variants such as `appsettings.Development.json`) are present in `Bookstore.Web` and contain the correct connection strings and application settings.
- If the legacy project used `Web.config` or `App.config`, verify that all relevant settings have been migrated to `appsettings.json` or the appropriate .NET configuration mechanism.
- Check that the `Program.cs` and `Startup.cs` (or the combined `Program.cs` in minimal hosting model) correctly register all required services, middleware, and configuration sources.

---

## 4. Validate the Data Layer

- Confirm that `Bookstore.Data` is using a compatible version of Entity Framework Core (or whichever ORM is in use).
- If Entity Framework is used, verify that migrations are present and up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

- Apply migrations to a local or development database to confirm the schema is correct:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to perform an initial smoke test.

```bash
dotnet run --project app/Bookstore.Web
```

- Navigate to the application in a browser and verify that core pages load without errors.
- Check the console output and application logs for any runtime exceptions.
- Test primary user-facing functionality such as browsing, searching, and any authentication flows.

---

## 6. Execute Automated Tests

If the solution contains a test project, run the test suite to validate business logic and data access behavior.

```bash
dotnet test
```

- Review any failing tests and determine whether the failures are due to migration issues or pre-existing problems.
- Pay particular attention to tests covering `Bookstore.Domain` and `Bookstore.Data`, as these form the foundation of the application.

---

## 7. Check for Platform-Specific Code

Search the codebase for any APIs or libraries that were specific to .NET Framework and may not behave identically on cross-platform .NET.

Common areas to review:

- `System.Web` references (should have been fully replaced)
- Windows Registry access
- `HttpContext` usage patterns
- Any P/Invoke or COM interop calls
- `ConfigurationManager` usage (should be replaced with `IConfiguration`)

---

## 8. Validate on Target Operating System

If the intention is to run the application on Linux or macOS, test the application explicitly on that platform to catch any remaining OS-specific issues such as:

- File path separators
- Case-sensitive file system differences
- Missing Windows-specific dependencies

---

## 9. Prepare for Deployment

Once local validation is complete:

- Set the appropriate environment variable (`ASPNETCORE_ENVIRONMENT`) for the target environment.
- Publish the application using the .NET CLI:

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

- Verify the contents of the `./publish` directory and confirm all required assets, configuration files, and binaries are present before deploying to the target server.