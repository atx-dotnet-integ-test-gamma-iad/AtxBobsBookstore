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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs, as these may indicate areas that need attention.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test output for any failures. If tests were written against framework-specific behavior (e.g., `HttpContext`, `System.Web`), they may require updates to align with the ASP.NET Core equivalents.

---

## 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, confirm the following:

- Connection strings in `appsettings.json` (or `appsettings.Development.json`) are correctly configured for the target database.
- If Entity Framework is used, run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If the project previously used `System.Data` or ADO.NET patterns tied to .NET Framework, verify those data access calls function correctly under cross-platform .NET.

---

## 5. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:

- The application starts without runtime exceptions.
- All routes and pages load as expected.
- Authentication and authorization flows (if present) behave correctly.
- Static files (CSS, JavaScript, images) are served properly.

---

## 6. Review Configuration Changes

Cross-platform .NET no longer uses `Web.config` for application configuration. Confirm the following:

- All configuration values previously in `Web.config` have been moved to `appsettings.json`.
- Environment-specific settings are handled via `appsettings.{Environment}.json` or environment variables.
- Any `configSections`, `httpModules`, or `httpHandlers` from `Web.config` have been replaced with the appropriate ASP.NET Core middleware.

---

## 7. Check for Remaining Platform-Specific APIs

Search the codebase for any remaining usage of APIs that are not supported on cross-platform .NET:

- `System.Web` namespace references
- `HostingEnvironment`
- `HttpContext.Current`
- Windows Registry access (`Microsoft.Win32.Registry`)
- Windows-only cryptography or COM interop

Replace any identified usages with their cross-platform .NET equivalents.

---

## 8. Validate Logging and Error Handling

Confirm that logging is configured correctly using the built-in `Microsoft.Extensions.Logging` infrastructure or a compatible third-party provider (e.g., Serilog, NLog). Verify that unhandled exceptions are surfaced appropriately in both development and production environments.

---

## 9. Publish the Application

Once local validation is complete, publish the application to a target directory:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, including static assets and configuration files, are present before deploying to the target environment.