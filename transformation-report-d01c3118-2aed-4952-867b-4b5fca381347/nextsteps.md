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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check their NuGet pages for recommended replacements compatible with the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, as some warnings may indicate compatibility concerns that could surface at runtime.

---

## 3. Review Configuration Files

- Check `appsettings.json` and any environment-specific variants (e.g., `appsettings.Development.json`) in `Bookstore.Web` to confirm connection strings, logging settings, and other configurations are correct for the new runtime.
- If the legacy project used `Web.config` or `App.config`, verify that all relevant settings have been migrated to the appropriate `appsettings.json` or `appsettings.{Environment}.json` files.
- Confirm that any environment variables or secrets previously stored in `Web.config` (e.g., `<appSettings>` or `<connectionStrings>`) are now handled via the .NET configuration system or a secrets manager.

---

## 4. Verify Database Connectivity

Since the solution includes a `Bookstore.Data` project, confirm that the data layer connects correctly:

- Verify the connection string in `appsettings.json` points to the correct database instance.
- If Entity Framework is in use, run the following to check that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations if necessary:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite to validate business logic and data access behavior:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may indicate behavioral differences introduced by the migration to cross-platform .NET.

---

## 6. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application and verify that core functionality works as expected.
- Check application logs for any runtime exceptions or deprecation warnings.
- Test any areas that relied on Windows-specific APIs or libraries, as these are the most likely sources of runtime issues even when the build succeeds.

---

## 7. Check for Runtime Compatibility Issues

Even with a clean build, certain areas warrant manual inspection:

- **Windows-specific APIs**: Search the codebase for usages of APIs that may not be supported cross-platform, such as the Windows Registry, certain `System.Drawing` methods, or COM interop.
- **File path handling**: Ensure file paths use `Path.Combine` and `Path.DirectorySeparatorChar` rather than hardcoded backslashes.
- **Globalization**: .NET on Linux uses ICU libraries for globalization by default. If the app relies on culture-specific behavior, test it explicitly on the target OS.

---

## 8. Publish the Application

Once local validation is complete, publish the application for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.