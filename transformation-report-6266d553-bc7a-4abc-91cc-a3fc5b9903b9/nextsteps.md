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

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, check [NuGet.org](https://www.nuget.org) for their recommended replacements.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects — `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web` — report a successful build with no errors or unexpected warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure no project still references `net48` or any other Windows-only framework unless there is a specific reason to do so.

---

## 4. Check for Windows-Specific APIs

Even without build errors, the code may still contain Windows-specific API calls that will fail at runtime on non-Windows platforms. Use the .NET Compatibility Analyzer to surface these:

```bash
dotnet build /p:EnableNETAnalyzers=true /p:AnalysisMode=All
```

Pay particular attention to:
- Registry access (`Microsoft.Win32.Registry`)
- Windows-only file path assumptions (e.g., backslash separators)
- Any P/Invoke calls targeting Windows DLLs

---

## 5. Run Existing Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved after the migration:

```bash
dotnet test --configuration Release
```

Review the test output for any failures that may indicate behavioral regressions introduced during the transformation.

---

## 6. Validate the Web Application at Runtime

Start the `Bookstore.Web` project locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Confirm the following at a minimum:
- The application starts without runtime exceptions.
- Database connectivity through `Bookstore.Data` is functional.
- Core domain logic in `Bookstore.Domain` behaves as expected through the UI or API endpoints.

---

## 7. Verify Database Migrations

If the project uses Entity Framework Core, confirm that migrations are up to date and apply correctly against the target database:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj

dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations from the legacy project used a different provider (e.g., `System.Data.SqlClient` instead of `Microsoft.Data.SqlClient`), update the connection string and provider registration accordingly in `Program.cs` or `Startup.cs`.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` contains all configuration values that were previously held in `Web.config` or `App.config`. Common items to verify:
- Connection strings
- Application-specific settings
- Logging configuration

The legacy `<connectionStrings>` and `<appSettings>` sections from `Web.config` should now be represented as JSON in `appsettings.json`.

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is self-contained and correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all expected assemblies and static assets are present before deploying to the target environment.