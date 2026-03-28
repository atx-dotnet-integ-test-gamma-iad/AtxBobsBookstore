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

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a currently supported version of .NET (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is targeting an older or end-of-life version such as `netcoreapp3.1` or `net5.0`, update it to a supported version and re-run the restore and build steps.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, verify that no Windows-specific APIs or libraries remain that would break cross-platform compatibility. Common areas to check include:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Communication Foundation (WCF)** server-side components
- **System.Drawing** (use `System.Drawing.Common` with caution or replace with a cross-platform alternative)
- **Web.config** transformations (these should be replaced with `appsettings.json`)

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package to identify platform-specific calls.

---

## 5. Validate Configuration Files

Ensure that `Web.config` or `App.config` settings have been properly migrated to `appsettings.json` and that the application reads configuration using `IConfiguration`.

- Connection strings should appear under the `ConnectionStrings` section in `appsettings.json`.
- Application settings should be migrated to strongly typed options classes using `IOptions<T>`.

---

## 6. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
cd app/Bookstore.Web
dotnet run
```

Navigate to the application in a browser and exercise the primary workflows such as browsing, searching, and any data entry flows to confirm end-to-end functionality.

---

## 7. Run Existing Tests

If the solution contains a test project, execute the test suite to validate that existing behavior has been preserved.

```bash
dotnet test
```

Review any failing tests carefully. Failures may indicate behavioral differences between .NET Framework and modern .NET that need to be addressed in the application code.

---

## 8. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Migrations are up to date. Run the following to apply any pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 9. Test on Target Platforms

Since the goal is cross-platform compatibility, test the application on each intended operating system (Windows, Linux, macOS) to surface any platform-specific runtime issues that would not appear during compilation.

```bash
dotnet run --project app/Bookstore.Web
```

Run this on each target platform and verify consistent behavior.

---

## 10. Publish the Application

Once validation is complete, publish the application for deployment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files and assets are present before deploying to the target environment.