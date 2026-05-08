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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended modern .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects so there are no cross-targeting mismatches.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, verify that no Windows-only APIs are being used without the appropriate platform compatibility guard. Look for usages of:

- `System.Web` (not available in .NET Core+)
- Windows Registry access
- COM interop components
- `HttpContext` usage patterns specific to ASP.NET (non-Core)

If `System.Web` references remain, they will need to be replaced with their ASP.NET Core equivalents.

---

## 5. Validate the Data Layer

For `Bookstore.Data`, confirm the following:

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) is referenced and up to date.
- Any existing migrations are compatible with the new runtime. Run the following to verify:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations are missing or broken, consider generating a new initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to a test database to confirm schema integrity:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application locally to verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, adding to cart, checkout if applicable) to confirm expected behavior.

Check the console output and application logs for any runtime exceptions or unhandled errors.

---

## 7. Execute Existing Tests

If the solution contains a test project, run all tests to validate business logic and data access behavior:

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to migration issues or pre-existing defects.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` (and `appsettings.Development.json`) contain the correct configuration values, including:

- Database connection strings
- Any API keys or external service endpoints
- Logging configuration

Legacy `Web.config` or `App.config` values should have been migrated to `appsettings.json`. Confirm no critical settings were lost during transformation.

---

## 9. Validate Static Assets and Views

For `Bookstore.Web`, confirm that:

- Razor views (`.cshtml`) render correctly.
- Static files (CSS, JavaScript, images) are served properly from the `wwwroot` directory.
- Any bundling or minification configuration has been updated to use the .NET-compatible tooling (e.g., LibMan or npm-based tooling instead of legacy Bundler & Minifier).

---

## 10. Publish the Application

Once all validation steps pass, publish the application to confirm the output is complete and self-contained:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present before deploying to the target environment.