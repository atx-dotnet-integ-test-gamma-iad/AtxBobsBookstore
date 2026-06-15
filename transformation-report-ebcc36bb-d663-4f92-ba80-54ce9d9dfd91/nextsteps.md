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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs that may have been introduced during the migration.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

---

## 4. Check for Windows-Specific Dependencies

Review each project for any remaining references to Windows-specific APIs or libraries (e.g., `System.Web`, `Microsoft.Web.*`, Windows Registry access, or MSMQ). These will not function on Linux or macOS and will require replacement or removal.

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to assist with this check.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release
```

Review test output for any failures that may indicate behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

---

## 6. Validate Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, verify the following:

- The connection string in `appsettings.json` (or equivalent configuration) is correctly configured for the target environment.
- Entity Framework Core migrations (if applicable) are up to date. Run the following to apply any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If the project previously used Entity Framework 6, confirm it has been migrated to Entity Framework Core and that all queries function correctly.

---

## 7. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and confirm that routing, data access, and rendering all function as expected. Pay particular attention to any areas that relied on `System.Web` or ASP.NET MVC 5 constructs, as these would have been replaced with ASP.NET Core equivalents.

---

## 8. Review Configuration Migration

Confirm that configuration previously stored in `Web.config` or `App.config` has been correctly moved to `appsettings.json`. Key areas to check include:

- Connection strings
- Application settings
- Authentication configuration
- Logging settings

---

## 9. Validate on Target Operating Systems

If cross-platform support is a requirement, run the application on each target operating system (Windows, Linux, macOS) to identify any platform-specific runtime issues that would not surface during a build.

```bash
dotnet run --project Bookstore.Web
```

Test on each platform and compare behavior.

---

## 10. Publish the Application

Once validation is complete, publish the application to the desired output format:

**Framework-dependent deployment:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained deployment (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory and confirm all required files are present before deploying to the target environment.