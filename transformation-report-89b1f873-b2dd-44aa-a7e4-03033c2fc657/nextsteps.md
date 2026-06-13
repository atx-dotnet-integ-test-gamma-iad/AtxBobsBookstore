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

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Project Target Frameworks

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other .NET Framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Review all three projects for any remaining dependencies that are Windows-only. Common areas to check include:

- `System.Web` references (should be replaced with `Microsoft.AspNetCore.*`)
- Windows Registry access
- `System.Drawing` (replace with a cross-platform alternative such as `SkiaSharp` if needed)
- COM interop or P/Invoke calls targeting Windows APIs

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package to identify remaining platform-specific code.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to validate that business logic and data access behavior is preserved:

```bash
dotnet test --configuration Release --verbosity normal
```

If no tests currently exist, consider writing basic tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before deploying.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, verify the following:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`)
- Connection strings in `appsettings.json` are correctly configured
- Run any pending migrations to ensure the schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the web application and verify it runs correctly on the local development machine:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and test the primary user-facing functionality, including any pages that interact with `Bookstore.Domain` and `Bookstore.Data`.

---

## 8. Test on a Non-Windows Platform (If Cross-Platform is Required)

If the goal of the migration includes running on Linux or macOS, run the application on the target platform and verify:

- File path handling uses `Path.Combine` rather than hardcoded backslashes
- No Windows-specific environment variables are assumed
- Logging and configuration load correctly from `appsettings.json`

---

## 9. Review Application Configuration

Confirm that configuration previously stored in `Web.config` or `App.config` has been fully migrated to `appsettings.json` and that the application reads it correctly using `IConfiguration`.

---

## 10. Publish the Application

Once validation is complete, publish the application to the target environment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and deploy it to the target server or hosting environment according to your infrastructure requirements.