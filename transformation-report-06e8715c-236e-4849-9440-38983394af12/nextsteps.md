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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET (e.g., `net8.0`). Mixing framework versions across projects can cause runtime issues even when the build succeeds.

Example of what to look for:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in cross-platform .NET compared to .NET Framework. Pay particular attention to:

- **`Bookstore.Data`**: Verify that Entity Framework usage has been updated to EF Core. Confirm that connection strings and database provider packages (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) are correctly configured.
- **`Bookstore.Web`**: Confirm that any previously used `System.Web` APIs have been replaced with their ASP.NET Core equivalents. Check areas such as authentication, session management, HTTP context access, and bundling/minification.
- **`Bookstore.Domain`**: Check for any use of `AppDomain`, `BinaryFormatter`, or other APIs that are restricted or removed in .NET.

---

## 5. Run Unit Tests

If the solution contains a test project, run the tests to verify that business logic and data access behavior remain correct after migration.

```bash
dotnet test
```

If no test project exists, consider manually verifying core domain logic and data access operations.

---

## 6. Run the Application Locally

Start the web application locally and navigate through its primary features to check for runtime errors.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas at runtime:

- Application startup and middleware configuration in `Program.cs` or `Startup.cs`
- Database connectivity and migrations (run `dotnet ef database update` if using EF Core migrations)
- Page rendering and routing
- Any file system paths that may have been hardcoded using Windows-style separators (`\`) instead of `Path.Combine`

---

## 7. Verify Configuration Files

Ensure that `appsettings.json` contains all necessary configuration values that may have previously been stored in `Web.config` or `App.config`. Key areas to check:

- Connection strings
- Logging configuration
- Application-specific settings

---

## 8. Check Static Files and wwwroot

In ASP.NET Core, static files must reside in the `wwwroot` folder. Confirm that CSS, JavaScript, and image assets have been moved to `wwwroot` and that the `UseStaticFiles()` middleware is present in the application pipeline.

---

## 9. Validate on Target Operating System

If cross-platform support is a goal, test the application on the intended target OS (Linux or macOS) to surface any remaining platform-specific issues such as:

- Case-sensitive file paths
- Windows-only APIs or P/Invoke calls
- Registry access