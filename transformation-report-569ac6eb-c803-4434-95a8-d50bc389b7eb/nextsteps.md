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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, consider updating them to versions that explicitly support the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues beyond what was reported.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Configuration Files

Cross-platform .NET projects use `appsettings.json` rather than `Web.config` or `App.config`. Verify the following:

- `appsettings.json` and `appsettings.Development.json` exist in `Bookstore.Web` and contain the correct connection strings and application settings.
- Any environment-specific configuration that previously lived in `Web.config` transforms has been moved to the appropriate `appsettings.{Environment}.json` files.
- The `ASPNETCORE_ENVIRONMENT` environment variable is set appropriately on the target machine.

---

## 4. Verify the Data Layer

Since `Bookstore.Data` depends on `Bookstore.Domain`, confirm the following:

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) is present and targets the correct version.
- Any existing migrations are compatible with the new runtime. Run the following to list current migrations:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

- If the schema needs to be updated, apply migrations against a non-production database first:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows (browsing books, user authentication if present, data retrieval) to confirm end-to-end functionality.

Check the console output and any log files for runtime exceptions or unhandled errors.

---

## 6. Execute Existing Tests

If the solution contains test projects, run them now to validate that business logic and data access behavior are preserved.

```bash
dotnet test
```

Review any failing tests carefully. Failures may indicate behavioral differences between the legacy .NET Framework runtime and the current .NET runtime, particularly around:

- Globalization and string comparison behavior
- Timezone handling
- Reflection-based operations
- HTTP client behavior

---

## 7. Validate Static Assets and Middleware

For `Bookstore.Web`, confirm the following:

- Static files (CSS, JavaScript, images) are served correctly. In ASP.NET Core, `UseStaticFiles()` must be explicitly called in the middleware pipeline.
- Any HTTP modules or HTTP handlers from the legacy project have been replaced with the equivalent ASP.NET Core middleware.
- Authentication and authorization middleware is configured correctly in `Program.cs` or `Startup.cs`.

---

## 8. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment package.

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Windows x64):**
```bash
dotnet publish app/Bookstore.Web --configuration Release --runtime win-x64 --self-contained true --output ./publish
```

Verify the contents of the `./publish` directory before deploying to the target environment.

---

## 9. Confirm Target Runtime on the Server

If deploying framework-dependent, ensure the correct .NET runtime is installed on the target server.

```bash
dotnet --list-runtimes
```

The runtime version must be greater than or equal to the version targeted in the project files.