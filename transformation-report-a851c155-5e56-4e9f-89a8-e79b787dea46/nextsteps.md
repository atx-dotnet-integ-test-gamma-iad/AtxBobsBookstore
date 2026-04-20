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

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no tests currently exist, consider writing basic tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

Since `Bookstore.Data` is likely responsible for data access, verify the following:

- The connection string in your configuration file (e.g., `appsettings.json`) is correct for your target environment.
- If Entity Framework Core is in use, confirm that migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, apply them with:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to confirm it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and exercise the primary workflows to check for any runtime exceptions or unexpected behavior that would not have been caught at compile time.

---

## 6. Review Configuration Files

Cross-platform .NET handles configuration differently than the legacy .NET Framework. Verify the following:

- `Web.config` transformations have been replaced with `appsettings.json` and environment-specific variants (e.g., `appsettings.Production.json`).
- Any settings previously stored in `Web.config` under `<appSettings>` or `<connectionStrings>` have been moved to `appsettings.json`.
- Environment variables or secrets management is in place for sensitive values such as connection strings and API keys.

---

## 7. Check for Platform-Specific Code

Review the codebase for any APIs or libraries that were available in .NET Framework but are not available or behave differently in cross-platform .NET. Common areas to check include:

- Use of `System.Web` namespaces, which are not available in cross-platform .NET.
- Windows-specific APIs such as the registry, certain cryptography providers, or COM interop.
- Any third-party libraries that may still target .NET Framework only.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling if a more thorough audit is needed.

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assets, configuration files, and dependencies are present before deploying to the target environment.