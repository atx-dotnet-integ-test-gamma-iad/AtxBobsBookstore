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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly and re-run the build.

---

## 4. Check for Windows-Specific APIs

Even without build errors, some APIs may have been carried over from the legacy project that are Windows-only at runtime. Use the .NET compatibility analyzer to surface these.

```bash
dotnet build /p:EnableNETAnalyzers=true /p:PlatformCompatibilityAnalyzer=true
```

Pay particular attention to `Bookstore.Data` if it uses any database access libraries that previously relied on Windows-specific features (e.g., MSSQL with Windows Authentication, MSMQ, or COM interop).

---

## 5. Run Unit Tests

If the solution contains a test project, execute the test suite to validate core logic.

```bash
dotnet test --configuration Release --logger trx
```

Review the `.trx` output files for any failing tests. If no test project exists, consider adding one to cover critical paths in `Bookstore.Domain` and `Bookstore.Data`.

---

## 6. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date and the database connection string is correctly configured for the target environment.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of date:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the web application and verify it runs correctly on the local machine.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL indicated in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and exercise the primary application workflows manually.

---

## 8. Review Configuration Files

Confirm that `appsettings.json` (and any environment-specific variants such as `appsettings.Production.json`) contain the correct values for the target environment. Legacy projects often stored configuration in `Web.config` or `App.config`, which may not have been fully migrated.

- Connection strings
- Logging configuration
- Any third-party service keys or endpoints

---

## 9. Publish the Application

Once the application has been validated locally, publish it to the target deployment directory.

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` folder to confirm all necessary files are present before deploying to the target server or hosting environment.