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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is still targeting `net48` or `netstandard2.0`, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project, inspect the code and project references for any APIs or packages that are Windows-only, such as:

- `System.Web`
- `Microsoft.Web.Infrastructure`
- Windows Registry access
- COM interop

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify platform-specific calls that may fail on Linux or macOS.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after migration.

```bash
dotnet test --configuration Release --logger trx
```

Review the `.trx` output for any failed or skipped tests. Pay particular attention to tests covering data access logic in `Bookstore.Data` and domain logic in `Bookstore.Domain`, as these layers are most likely to be affected by framework-level behavioral differences.

---

## 6. Validate the Data Layer

In `Bookstore.Data`, confirm the following:

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) is compatible with the target framework version.
- Connection strings in `appsettings.json` are correctly configured and not relying on `Web.config` or `App.config` entries from the legacy project.
- Any migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

---

## 7. Validate the Web Layer

In `Bookstore.Web`, confirm the following:

- The application starts without runtime errors:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

- Middleware configuration in `Program.cs` or `Startup.cs` is correctly set up for the cross-platform .NET hosting model.
- Static files, routing, and authentication (if applicable) function as expected by navigating through the application manually or via integration tests.
- Any references to `HttpContext`, session, or authentication that previously relied on `System.Web` have been replaced with their `Microsoft.AspNetCore` equivalents.

---

## 8. Verify Configuration

Ensure that configuration is being loaded correctly from `appsettings.json` rather than `Web.config`. Confirm that environment-specific overrides (e.g., `appsettings.Development.json`) are in place and that sensitive values such as connection strings are not hardcoded.

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is self-contained and deployable.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present, then deploy the output to your target environment.