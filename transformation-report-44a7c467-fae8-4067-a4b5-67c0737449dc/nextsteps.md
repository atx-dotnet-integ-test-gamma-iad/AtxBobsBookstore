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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay particular attention to:
- Any remaining references to `System.Web` or other Windows-only namespaces.
- Any use of `HttpContext`, `HttpServerUtility`, or similar types that behave differently in ASP.NET Core.

---

## 3. Review Configuration Files

The legacy project likely used `Web.config` or `App.config` for configuration. In cross-platform .NET, configuration is typically handled via `appsettings.json`.

- Confirm that `appsettings.json` exists in `Bookstore.Web` and contains the necessary settings (connection strings, app settings, etc.).
- Confirm that `Program.cs` and/or `Startup.cs` correctly reads from `appsettings.json` using `IConfiguration`.

---

## 4. Validate the Data Layer

In `Bookstore.Data`, verify the following:

- If Entity Framework is used, confirm the project references `Microsoft.EntityFrameworkCore` and the appropriate database provider (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Run any pending migrations or verify the database schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If `Database.SetInitializer` or other EF 6-specific APIs were used, confirm they have been replaced with EF Core equivalents.

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and exercise the primary workflows (browsing books, user authentication, etc.).
- Check the console output and application logs for any runtime exceptions or unhandled errors.

---

## 6. Check for Windows-Specific Dependencies

Even if the build succeeds, there may be runtime dependencies that are Windows-specific. Review the following:

- File path separators: Replace hardcoded `\` with `Path.Combine()` or `/`.
- Registry access: Remove or replace any use of `Microsoft.Win32.Registry`.
- Windows Authentication: If used, confirm it is explicitly configured and supported in the target environment.

---

## 7. Execute Unit and Integration Tests

If the solution contains test projects, run them to validate business logic and data access behavior.

```bash
dotnet test
```

If no tests exist, consider writing basic integration tests for the `Bookstore.Data` repository methods and smoke tests for the key `Bookstore.Web` endpoints to establish a baseline.

---

## 8. Verify Target Framework

Confirm that all projects are targeting the intended .NET version by inspecting each `.csproj` file.

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web` to avoid cross-framework compatibility issues.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is self-contained and correct.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assemblies and static assets are present before deploying to the target environment.