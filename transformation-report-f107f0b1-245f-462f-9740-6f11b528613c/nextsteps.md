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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check their respective NuGet pages for recommended replacements compatible with the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without errors or unexpected warnings.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Confirm the following:

- Connection strings and application settings have been moved to `appsettings.json` and/or `appsettings.{Environment}.json`.
- Any environment-specific configuration (e.g., development vs. production database connections) is correctly separated by environment.
- Sensitive values such as connection strings or API keys are not hardcoded and are instead managed via environment variables or a secrets manager such as the .NET Secret Manager tool.

```bash
dotnet user-secrets init
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "your-connection-string"
```

---

## 4. Verify Database Connectivity (Bookstore.Data)

If the project uses Entity Framework Core, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`, `Npgsql.EntityFrameworkCore.PostgreSQL`).
- Migrations are present and up to date.

List existing migrations:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

Apply migrations to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If no migrations exist and a code-first approach is intended, create an initial migration:

```bash
dotnet ef migrations add InitialCreate --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to verify it runs as expected.

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Navigate to the URL printed in the console output (typically `https://localhost:{port}`) and confirm the application loads correctly.

---

## 6. Execute Unit and Integration Tests

If the solution contains test projects, run all tests to confirm existing functionality is intact after the migration.

```bash
dotnet test
```

Review the test results for any failures. Failures at this stage may indicate behavioral differences between the original .NET Framework APIs and their .NET equivalents that require code-level adjustments.

---

## 7. Address Platform-Specific API Usage

Review the codebase for any APIs that were available in .NET Framework but behave differently or are unavailable in cross-platform .NET. Common areas to check include:

- `System.Web` references — these are not available in cross-platform .NET and should have been replaced during transformation.
- Windows Registry access (`Microsoft.Win32.Registry`) — not available on Linux/macOS.
- `AppDomain` usage — partially supported; some members throw `PlatformNotSupportedException`.
- HTTP modules and handlers — these should have been replaced with ASP.NET Core middleware.

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.ApiCompat` tool to surface any remaining incompatibilities.

---

## 8. Validate Static Assets and Razor Views

For the `Bookstore.Web` project, manually review the following:

- Razor views (`.cshtml`) render correctly and do not rely on removed HTML helpers that have no direct equivalent.
- Static files (CSS, JavaScript, images) are placed under the `wwwroot` folder, which is the expected location in ASP.NET Core.
- Bundling and minification, if previously handled by `BundleConfig.cs`, has been replaced with an alternative such as `LibMan`, `npm`, or a build tool like `webpack`.

---

## 9. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including `appsettings.json` and static assets under `wwwroot`.