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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding with any builds or tests.

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages that may need to be updated.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no issues beyond what was captured in the initial error report.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, deprecated APIs, or target framework compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a currently supported version of .NET (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting an older or unsupported framework version, update it accordingly and re-run the build.

---

## 4. Verify Runtime Behavior of Bookstore.Data

Since `Bookstore.Data` typically handles database access, confirm the following:

- The correct database provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Connection strings in `appsettings.json` are valid and accessible in the new environment.
- Any database migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply pending migrations if necessary:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run Existing Tests

If the solution contains a test project, execute the tests to validate that the core logic in `Bookstore.Domain` and `Bookstore.Data` behaves as expected.

```bash
dotnet test
```

Review any failing tests and determine whether they are caused by migration-related changes or pre-existing issues.

---

## 6. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify that the application loads and functions correctly.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following areas manually:

- Application startup without exceptions in the console output.
- All major routes and pages load correctly.
- Database read and write operations function as expected.
- Any authentication or authorization flows work correctly.

---

## 7. Review Configuration Files

Confirm that the following configuration concerns have been addressed in `appsettings.json` and `appsettings.Production.json`:

- Connection strings point to the correct database instances.
- Any API keys or secrets previously stored in `Web.config` have been moved to the appropriate .NET configuration source (e.g., `appsettings.json`, environment variables, or the Secret Manager tool).
- Logging configuration is present and correct.

---

## 8. Check for Removed or Changed APIs

Review the code in all three projects for usage of APIs that were available in .NET Framework but have changed or been removed in cross-platform .NET. Common areas to check include:

- `System.Web` references, which are not available in cross-platform .NET.
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core.
- Any use of `ConfigurationManager`, which should be replaced with `IConfiguration`.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all required assets, static files, and configuration files are present before deploying to the target environment.