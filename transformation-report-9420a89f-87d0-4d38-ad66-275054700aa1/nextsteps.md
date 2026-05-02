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

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Runtime Compatibility

Check that any APIs used in the codebase are supported on cross-platform .NET. Pay particular attention to:

- **`System.Web` dependencies** — these are not available in .NET Core or later. If any references remain, they will need to be replaced with ASP.NET Core equivalents.
- **Windows-only APIs** — use the [.NET Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify any platform-specific calls.
- **Entity Framework** — if the project uses Entity Framework 6, confirm whether it has been migrated to Entity Framework Core, as EF6 has limited cross-platform support.

---

## 4. Run the Application Locally

Start the web application locally to verify basic functionality.

```bash
cd app/Bookstore.Web
dotnet run
```

Navigate to the application in a browser and manually verify core user flows such as browsing books, authentication (if applicable), and any data operations.

---

## 5. Check Database Connectivity

If the application uses a database, confirm the connection string in `appsettings.json` is correctly configured for the target environment. Run any pending Entity Framework Core migrations if applicable.

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If migrations do not exist yet, generate an initial migration from the current model.

```bash
dotnet ef migrations add InitialCreate --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 6. Run Automated Tests

If the solution contains a test project, execute the test suite to confirm existing behavior is preserved after migration.

```bash
dotnet test
```

Review any failing tests and determine whether they reflect genuine regressions or tests that need to be updated to reflect new API usage patterns.

---

## 7. Review Configuration

The legacy project likely used `Web.config` or `App.config` for configuration. Confirm that all relevant settings have been migrated to `appsettings.json` and that environment-specific overrides are in place using `appsettings.{Environment}.json` where needed.

---

## 8. Publish the Application

Once the application has been validated locally, publish it to prepare for deployment.

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm the output is complete before deploying to the target environment.