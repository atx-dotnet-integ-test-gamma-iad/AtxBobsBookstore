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

Ensure the build output shows **0 Error(s)** for all three projects before proceeding.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after the migration.

```bash
dotnet test --configuration Release --verbosity normal
```

Review the test results for any failures. Pay particular attention to tests covering:

- Data access logic in `Bookstore.Data`
- Domain model behavior in `Bookstore.Domain`
- Controller actions, middleware, and routing in `Bookstore.Web`

If no test projects currently exist, consider adding them to establish a baseline before making further changes.

---

## 4. Verify Database Connectivity and Migrations

If `Bookstore.Data` uses Entity Framework Core, confirm that your database connection string in `appsettings.json` (or environment-specific variants) is correctly configured for the target environment.

Check that all migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and manually verify core functionality such as navigation, data retrieval, and form submissions.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the console output for runtime exceptions or middleware configuration warnings. Also review the browser console and network tab for any client-side errors.

---

## 6. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` for runtime configuration. Confirm that all settings previously held in `Web.config` or `App.config` have been correctly moved to:

- `appsettings.json`
- `appsettings.{Environment}.json`
- Environment variables where appropriate

Verify that connection strings, application settings, and logging configuration are all present and correct.

---

## 7. Check for Platform-Specific Code

Even when a build succeeds, there may be runtime issues caused by APIs that behave differently across operating systems. Review the codebase for usage of:

- Windows-specific file path separators (use `Path.Combine` instead of hardcoded `\`)
- Windows registry access
- COM interop or Windows-only libraries
- `System.Drawing` (which has limited cross-platform support; consider replacing with a library such as `SkiaSharp` or `ImageSharp` if image processing is used)

---

## 8. Publish the Application

Once all validation steps pass, publish the application to a self-contained or framework-dependent deployment package.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.