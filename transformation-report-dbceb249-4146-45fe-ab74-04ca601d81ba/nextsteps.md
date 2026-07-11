# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

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

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `net4x` or older target frameworks exclusively, consider finding their cross-platform equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or unexpected warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still targets `net48`, `netcoreapp3.1`, `net5.0`, `net6.0`, or `net7.0`, consider updating to `net8.0` or the latest LTS release.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, scan each project for APIs or packages that are Windows-only. Common areas to check:

- **`Bookstore.Data`**: Confirm the database provider (e.g., Entity Framework Core) is configured with a cross-platform-compatible database driver. If `System.Data.SqlClient` is referenced, replace it with `Microsoft.Data.SqlClient`.
- **`Bookstore.Web`**: Confirm there are no references to `System.Web`, MSMQ, or Windows Registry APIs.
- **`Bookstore.Domain`**: Check for any use of `System.Drawing` (GDI+), which requires additional native dependencies on Linux/macOS.

---

## 5. Run Database Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date.

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If there are pending migrations or the migration history does not match the current model, generate a new migration:

```bash
dotnet ef migrations add <MigrationName> --project app/Bookstore.Data --startup-project app/Bookstore.Web
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 6. Run Existing Tests

If the solution contains a test project, execute the test suite to confirm existing functionality is preserved.

```bash
dotnet test --configuration Release
```

Review any failing tests carefully. Failures after a framework migration often indicate:

- Behavioral differences in APIs between .NET Framework and modern .NET.
- Missing configuration or environment-specific settings.
- Changed default serialization or encoding behavior.

---

## 7. Validate Application Configuration

Review `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) in `Bookstore.Web` to ensure:

- Connection strings are correct and use a supported format.
- Any configuration keys previously stored in `Web.config` or `App.config` have been migrated to the appropriate `appsettings.json` sections.
- Logging, authentication, and middleware settings are correctly configured for ASP.NET Core.

---

## 8. Run the Application Locally

Start the application and perform manual verification of core functionality.

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify:

- Pages load without errors.
- Database reads and writes function correctly.
- Authentication and authorization behave as expected.
- Static assets (CSS, JavaScript, images) are served correctly.

---

## 9. Test on Target Operating Systems

If cross-platform support is a requirement, run the application on each target operating system (Windows, Linux, macOS) to identify any platform-specific runtime issues that would not surface during a build.

---

## 10. Publish the Application

Once validation is complete, publish the application for deployment.

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets and configuration files.