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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check [NuGet.org](https://www.nuget.org) for updated versions compatible with your target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended modern .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same framework version to avoid inter-project compatibility issues.

---

## 4. Run Database Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that your migrations are up to date and compatible with the new runtime:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the core functionality, including any data access operations handled by `Bookstore.Data` and domain logic in `Bookstore.Domain`.

---

## 6. Execute Unit and Integration Tests

If the solution contains test projects, run them to verify that existing behavior has been preserved after migration:

```bash
dotnet test --configuration Release
```

Review the test output for any failures. Pay particular attention to tests that cover data access and domain logic, as these areas are most likely to surface behavioral differences between the legacy and modernized runtimes.

---

## 7. Validate Configuration Files

Check `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) in `Bookstore.Web` to confirm that:

- Connection strings are correct and accessible.
- Any configuration keys previously stored in `Web.config` have been properly migrated to the `appsettings.json` format.
- Environment variables or secrets used in production are accounted for.

---

## 8. Check for Windows-Specific API Usage

Since this is a cross-platform migration, scan the codebase for any remaining Windows-specific APIs that may compile successfully but fail at runtime on Linux or macOS. Tools that can assist with this include:

```bash
dotnet build /p:EnableWindowsTargeting=false
```

Additionally, the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) built into the .NET SDK will flag platform-specific calls during the build.

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.