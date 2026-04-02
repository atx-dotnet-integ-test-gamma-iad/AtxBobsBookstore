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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

For the web project, confirm it is using:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Avoid `net48` or any `netcoreapp` monikers, as these are either platform-specific or out of support.

---

## 4. Check for Windows-Specific Dependencies

Inspect `Bookstore.Data` and `Bookstore.Domain` for any remaining references to Windows-specific libraries such as:

- `System.Web`
- `Microsoft.Win32`
- Windows Registry access
- COM interop components

Replace or remove these where possible using cross-platform alternatives.

---

## 5. Review Entity Framework or Data Access Layer

If `Bookstore.Data` uses Entity Framework, confirm the correct version is referenced:

- **Entity Framework Core** is required for cross-platform .NET.
- **Entity Framework 6** (classic) is not fully cross-platform.

Check the connection string configuration in `appsettings.json` and ensure it is not relying on a `Web.config` or `App.config` file, which are not the standard configuration mechanism in modern .NET.

```bash
dotnet ef migrations list
dotnet ef database update
```

Run these commands to verify the database context is functional.

---

## 6. Run Unit Tests

If the solution contains test projects, execute them to validate core logic:

```bash
dotnet test --configuration Release --verbosity normal
```

Review the test results and address any failures that may have been introduced by the migration.

---

## 7. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
cd Bookstore.Web
dotnet run --configuration Release
```

Navigate to the displayed local URL and manually verify:

- Pages load without exceptions
- Data is read and written correctly
- Authentication and authorization behave as expected (if applicable)

Check the console output and application logs for any runtime warnings or errors.

---

## 8. Review `appsettings.json` Configuration

Confirm that all configuration previously stored in `Web.config` or `App.config` has been migrated to `appsettings.json` or `appsettings.{Environment}.json`. Key areas to check include:

- Database connection strings
- Application-specific settings
- Logging configuration

---

## 9. Validate Static Files and Middleware

For `Bookstore.Web`, confirm that the middleware pipeline in `Program.cs` or `Startup.cs` is correctly configured, including:

- Static file serving (`UseStaticFiles`)
- Routing (`UseRouting`)
- Authentication/Authorization middleware (if applicable)
- Exception handling middleware

---

## 10. Publish the Application

Once all validation steps pass, publish the application to a target directory:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the output directory to confirm all required files are present, then deploy the contents to your target hosting environment.