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

Review the output for any warnings related to deprecated or incompatible packages. If any packages reference `netstandard` or older `net4x` target frameworks, consider updating them to versions that explicitly support the target framework you are now using (e.g., `net6.0`, `net7.0`, or `net8.0`).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during this step, particularly:
- Nullable reference type warnings, which may have been introduced by the migration
- Obsolete API usage warnings
- Assembly binding warnings

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the traditional sense. Verify the following:

- Connection strings and application settings have been moved to `appsettings.json` in `Bookstore.Web`
- Any environment-specific settings are placed in `appsettings.Development.json` or `appsettings.Production.json`
- Confirm that `Startup.cs` or the top-level `Program.cs` correctly reads from these configuration files using `IConfiguration`

---

## 4. Verify Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm the following:

- If using Entity Framework, verify the version is compatible with your target framework (EF Core is required for cross-platform .NET)
- Run any pending migrations or verify the database schema is up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If the project previously used EF 6 (classic), a migration to EF Core may be required. Check for any unsupported APIs such as `ObjectContext`, `Database.SetInitializer`, or `lazy loading proxies` configured in the legacy style.

---

## 5. Run the Application Locally

Start the web application locally to confirm it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Development
```

- Navigate to the application in a browser and exercise the primary workflows (browsing books, managing inventory, etc.)
- Check the console output and application logs for any runtime exceptions
- Verify that static files (CSS, JavaScript, images) are served correctly

---

## 6. Run Existing Tests

If the solution contains a test project, execute the test suite:

```bash
dotnet test
```

- Review any failing tests and determine whether the failures are due to the migration or pre-existing issues
- Pay particular attention to tests that rely on `HttpContext`, `Session`, or other ASP.NET-specific abstractions that may have changed between legacy ASP.NET and ASP.NET Core

---

## 7. Validate Cross-Platform Behavior

If the intent is to run this application on Linux or macOS, test it on the target operating system:

- File path separators (`\` vs `/`) can cause issues if paths are hardcoded
- Case-sensitive file systems on Linux may expose issues with static file references or view names
- Confirm that any file I/O operations in `Bookstore.Data` or `Bookstore.Domain` use `Path.Combine` rather than hardcoded separators

---

## 8. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` folder to confirm all required files are present before deploying to the target environment.