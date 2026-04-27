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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check [NuGet.org](https://www.nuget.org) for updated versions compatible with your target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay particular attention to:
- Any nullable reference type warnings introduced by the new SDK
- Any implicit `using` directive conflicts
- Any API surface changes between the legacy .NET Framework and the current .NET version

---

## 3. Review Configuration Files

Check that configuration files have been correctly migrated:

- Confirm that `Web.config` settings (if any) have been moved to `appsettings.json` or `appsettings.{Environment}.json` in `Bookstore.Web`.
- Verify that connection strings in `appsettings.json` are correct and point to the appropriate database.
- Ensure that any environment-specific settings are handled using the `IConfiguration` system rather than `ConfigurationManager`.

---

## 4. Verify the Data Layer

Since `Bookstore.Data` depends on `Bookstore.Domain`, validate the data layer first:

- Confirm that Entity Framework (or whichever ORM is in use) is using the correct provider package for cross-platform .NET (e.g., `Microsoft.EntityFrameworkCore.SqlServer` instead of the legacy EF6 provider).
- If using EF Core, run the following to verify that migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data
```

- Apply any pending migrations to a development database:

```bash
dotnet ef database update --project app/Bookstore.Data
```

---

## 5. Run the Application Locally

Start the web application locally to confirm it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and exercise the primary user flows (browsing books, searching, etc.).
- Check the console output and application logs for any runtime exceptions.
- Verify that database connectivity is working as expected.

---

## 6. Execute Existing Tests

If the solution contains a test project, run all tests to validate that behavior has not regressed during migration.

```bash
dotnet test
```

Review the test results carefully. Failures may indicate:
- Behavioral differences between .NET Framework and cross-platform .NET
- Mocking or reflection-based tests that rely on removed APIs
- Changes in exception types or error messages

If no test project currently exists, consider adding unit tests for the core domain logic in `Bookstore.Domain` and integration tests for the data access layer in `Bookstore.Data`.

---

## 7. Check for Removed or Changed APIs

Review the code for any usage of APIs that were removed or significantly changed in cross-platform .NET. Microsoft provides a compatibility analyzer that can assist with this:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Additionally, consult the [.NET Upgrade Assistant documentation](https://learn.microsoft.com/en-us/dotnet/core/porting/) for known breaking changes relevant to your target version.

---

## 8. Validate Static Assets and Middleware (Bookstore.Web)

- Confirm that static files (CSS, JavaScript, images) are served correctly under `wwwroot`.
- Verify that all middleware registered in `Program.cs` or `Startup.cs` is compatible with the current ASP.NET Core version.
- Check that authentication and authorization configurations, if present, are functioning as expected.