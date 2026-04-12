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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check their NuGet pages for recommended replacements targeting .NET.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Resolve any warnings that may indicate compatibility concerns, such as obsolete API usage or nullable reference warnings, as these can surface runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration.

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

Since the solution includes a `Bookstore.Data` project, verify that your data access layer is functioning correctly.

- If the project uses **Entity Framework Core**, confirm that your `DbContext` configuration is correct for the target database provider.
- Run any pending migrations against your target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If you were previously using **Entity Framework 6 (EF6)**, confirm that the migration to EF Core was handled, as EF6 is not supported on cross-platform .NET. Check for any EDMX files or `ObjectContext` usage that may need to be replaced with EF Core equivalents.

---

## 5. Review Configuration Files

Cross-platform .NET uses `appsettings.json` rather than `Web.config` or `App.config`. Verify the following:

- Connection strings previously in `Web.config` have been moved to `appsettings.json`.
- Any environment-specific settings are handled using `appsettings.{Environment}.json` or environment variables.
- The `Bookstore.Web` project reads configuration correctly through `IConfiguration`.

---

## 6. Check for Windows-Specific Dependencies

Review all three projects for any remaining Windows-specific APIs or libraries that would prevent the application from running cross-platform. Common areas to check include:

- Use of `System.Web` namespaces, which are not available in cross-platform .NET.
- Windows Registry access.
- Windows-only NuGet packages.
- File path separators hardcoded as backslashes (`\`). Use `Path.Combine` or `Path.DirectorySeparatorChar` instead.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Walk through the primary user-facing features of the application to confirm that routing, data access, and rendering are all working as expected.

---

## 8. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment package.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory and confirm all required assets, static files, and configuration files are present before deploying to your target environment.