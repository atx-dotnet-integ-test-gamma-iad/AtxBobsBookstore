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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages reference `netstandard` or older `net4x` target frameworks, consider updating them to versions that explicitly support the target framework you are using (e.g., `net6.0`, `net7.0`, or `net8.0`).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation errors.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly:
- **Nullable reference type warnings** — These may have been introduced if the new project targets a framework version where nullable context is enabled by default.
- **Obsolete API warnings** — Some APIs used in the legacy code may be marked obsolete in newer .NET versions.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Verify the following:

- `appsettings.json` contains all necessary configuration values that were previously in `Web.config`, including connection strings, application settings, and environment-specific values.
- Any `<connectionStrings>` or `<appSettings>` entries from the old `Web.config` have been migrated to `appsettings.json`.
- Environment-specific overrides are handled via `appsettings.Development.json` or environment variables.

---

## 4. Verify the Data Layer (`Bookstore.Data`)

- Confirm that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) is present and at a version compatible with your target framework.
- If Entity Framework is used, verify that migrations are intact and functional:

```bash
dotnet ef migrations list --project app/Bookstore.Data
```

- Run a test migration or update against a development database to confirm schema compatibility:

```bash
dotnet ef database update --project app/Bookstore.Data
```

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and exercise the primary workflows (browsing books, user authentication if present, etc.).
- Check the console output and application logs for any runtime exceptions.

---

## 6. Check for Platform-Specific Code

Search the solution for any APIs or patterns that were Windows-specific in the original .NET Framework project and may not behave correctly cross-platform:

- `System.Web` references — These should no longer be present. If found, they need to be replaced with `Microsoft.AspNetCore` equivalents.
- Registry access (`Microsoft.Win32.Registry`) — Not supported on Linux/macOS.
- Windows file path separators — Replace hardcoded `\` with `Path.Combine` or `Path.DirectorySeparatorChar`.
- `HttpContext.Current` — This is not available in ASP.NET Core; use dependency-injected `IHttpContextAccessor` instead.

You can search for these patterns using:

```bash
grep -rn "System.Web" app/
grep -rn "HttpContext.Current" app/
grep -rn "Registry" app/
```

---

## 7. Execute Unit and Integration Tests

If the solution contains test projects, run them to validate correctness after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether failures are caused by migration-related changes or pre-existing issues.

---

## 8. Validate on the Target Operating System

If the goal is to run this application on Linux or macOS, perform the steps above on the target operating system rather than solely on Windows. File system case sensitivity and path differences can introduce issues that are not apparent on Windows.

---

## 9. Publish the Application

Once the application has been validated, publish it for deployment:

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.