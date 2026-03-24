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

Review the output for any warnings about deprecated or incompatible package versions. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

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
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is still targeting `net48` or `netstandard2.0`, update it to a current .NET target where appropriate.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect each project for APIs or packages that are Windows-only. Common areas to check include:

- `System.Drawing` (use a cross-platform alternative such as `SkiaSharp` if needed)
- Windows Registry access (`Microsoft.Win32.Registry`)
- COM interop usage
- Any `[SupportedOSPlatform("windows")]` warnings emitted during the build

---

## 5. Run Existing Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests and determine whether the failures are due to migration-related changes or pre-existing issues.

---

## 6. Validate the Web Application at Runtime

Start the `Bookstore.Web` project locally and manually verify core functionality.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically verify:

- Application startup without exceptions
- Database connectivity from `Bookstore.Data` (check connection strings in `appsettings.json`)
- Core domain logic in `Bookstore.Domain` behaves as expected through the UI or API endpoints

---

## 7. Review Configuration Files

Confirm that configuration previously held in `Web.config` or `App.config` has been correctly migrated to `appsettings.json` and that environment-specific settings are handled via `appsettings.{Environment}.json`.

Check that the following are present and correctly configured:

- Database connection strings
- Logging configuration
- Any application-specific settings previously in `<appSettings>` or `<connectionStrings>` sections

---

## 8. Database Migration Verification

If the project uses Entity Framework, confirm that migrations are compatible with the new runtime.

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj
```

If the database schema needs to be updated:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj
```

---

## 9. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment.

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.