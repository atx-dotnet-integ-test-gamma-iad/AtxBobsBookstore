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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Verify the following:

- `appsettings.json` contains all necessary configuration values (connection strings, app settings, etc.) that were previously in `Web.config`.
- Environment-specific overrides are handled via `appsettings.Development.json` or environment variables.
- Any `<connectionStrings>` or `<appSettings>` entries from the old `Web.config` have been migrated appropriately.

---

## 4. Verify Entity Framework or Data Access Layer

Since `Bookstore.Data` is present, confirm the data access layer is functioning correctly:

- If using **Entity Framework Core**, ensure migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If no migrations exist yet but a database context is present, create an initial migration:

```bash
dotnet ef migrations add InitialCreate --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the URL shown in the terminal output (typically `https://localhost:5001` or `http://localhost:5000`) and manually verify core functionality such as:

- Page rendering
- Database read/write operations
- Authentication and authorization (if applicable)

---

## 6. Execute Automated Tests

If a test project exists in the solution, run all tests to validate business logic and data access behavior:

```bash
dotnet test
```

If no test project currently exists, consider adding unit tests for the `Bookstore.Domain` layer and integration tests for `Bookstore.Data` to establish a baseline for future changes.

---

## 7. Check for Platform-Specific Code

Search the codebase for any APIs that were available in .NET Framework but are not supported in cross-platform .NET. Common areas to check include:

- `System.Web` references (should be replaced with ASP.NET Core equivalents)
- Windows Registry access (`Microsoft.Win32.Registry`)
- `HttpContext.Current` usage (replace with injected `IHttpContextAccessor`)
- `ConfigurationManager` usage (replace with `IConfiguration`)

You can use the [.NET Upgrade Assistant](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify remaining compatibility issues.

---

## 8. Publish the Application

Once validation is complete, publish the application to a target folder:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` folder and confirm the application runs correctly from the published output:

```bash
dotnet ./publish/Bookstore.Web.dll
```