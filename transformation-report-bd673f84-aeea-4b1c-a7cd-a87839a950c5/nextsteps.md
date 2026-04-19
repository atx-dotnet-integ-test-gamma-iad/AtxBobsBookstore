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

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, check [NuGet.org](https://www.nuget.org) for updated or replacement packages compatible with the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly:
- Nullable reference type warnings
- Obsolete API usage warnings
- Platform compatibility warnings (e.g., `[SupportedOSPlatform]`)

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Verify the following:

- `appsettings.json` contains all necessary configuration values previously held in `Web.config`, including connection strings, application settings, and environment-specific values.
- `appsettings.Development.json` exists and contains development-specific overrides where appropriate.
- Any configuration transformations previously handled by `Web.config` transforms are now handled via environment-specific `appsettings.{Environment}.json` files or environment variables.

---

## 4. Verify Database Connectivity (Bookstore.Data)

If the project uses Entity Framework, confirm the following:

- The connection string in `appsettings.json` is correct for your target database.
- If using Entity Framework Core (migrated from EF6), run the following to verify migrations are in place:

```bash
dotnet ef migrations list --project app/Bookstore.Data
```

- If no migrations exist and a database schema is expected, create an initial migration:

```bash
dotnet ef migrations add InitialCreate --project app/Bookstore.Data
dotnet ef database update --project app/Bookstore.Data
```

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

- Navigate to the application URL shown in the console output.
- Walk through the core user-facing functionality (e.g., browsing books, searching, any account features) to confirm expected behavior.
- Check the console output and application logs for any runtime exceptions or unhandled errors.

---

## 6. Check Middleware and HTTP Pipeline

In cross-platform .NET, the HTTP pipeline is configured in `Program.cs` (and optionally `Startup.cs` depending on the .NET version targeted). Verify:

- Authentication and authorization middleware is correctly registered and ordered.
- Static files middleware is present if the application serves CSS, JavaScript, or images.
- Error handling middleware is configured for both development and production environments.
- Any custom HTTP modules or handlers from the legacy project have been replaced with equivalent middleware.

---

## 7. Execute Unit and Integration Tests

If the solution contains test projects, run all tests to validate correctness after migration.

```bash
dotnet test
```

Review test results for any failures. Failures at this stage may indicate:
- Behavioral differences between .NET Framework and cross-platform .NET APIs.
- Missing or changed dependencies.
- Configuration not being loaded correctly in the test context.

If no test projects exist, consider writing basic integration tests that cover the primary data access and web request flows before deploying to a production environment.

---

## 8. Validate Target Framework

Confirm each project is targeting the intended .NET version by inspecting the `.csproj` files.

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and currently supported version of .NET. Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) to confirm the selected version is still within its support window.

---

## 9. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all expected files are present, including static assets and configuration files. Verify that no sensitive configuration values (e.g., production connection strings or secrets) are hardcoded in published configuration files.