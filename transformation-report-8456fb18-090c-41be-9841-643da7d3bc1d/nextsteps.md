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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects — `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web` — build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported and consistent version of .NET (e.g., `net8.0`). Mixing framework versions across projects in the same solution can cause runtime issues even when the build succeeds.

Example of what to look for in each `.csproj`:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs that existed in .NET Framework may behave differently or have been replaced in cross-platform .NET. Pay particular attention to:

- **`Bookstore.Data`**: Check any database access code (e.g., Entity Framework). Ensure the correct EF Core packages are referenced and that any `Database.SetInitializer` or `ObjectContext` usage has been replaced with EF Core equivalents.
- **`Bookstore.Web`**: If this was previously an ASP.NET MVC project, confirm it has been migrated to ASP.NET Core. Review `Startup.cs` or `Program.cs` for correct middleware configuration, and verify that `Web.config` settings have been moved to `appsettings.json` or equivalent.
- **`Bookstore.Domain`**: Verify that any serialization, reflection, or threading APIs still behave as expected under cross-platform .NET.

---

## 5. Run Unit Tests

If the solution contains a test project, run all tests to validate core functionality.

```bash
dotnet test
```

If no test project exists, consider writing basic integration or unit tests for the domain and data layers before deploying to a production environment.

---

## 6. Run the Application Locally

Start the web application locally to verify it runs correctly end-to-end.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Manually test the following areas:

- Application startup and homepage load
- Database connectivity through `Bookstore.Data`
- Core domain logic in `Bookstore.Domain`
- Any authentication or authorization flows
- Form submissions and data persistence

---

## 7. Review Configuration Files

Ensure that any configuration previously stored in `Web.config` or `App.config` has been correctly migrated to `appsettings.json`. Check the following:

- Connection strings
- Application settings keys
- Environment-specific overrides (e.g., `appsettings.Development.json`)

---

## 8. Validate Cross-Platform Behavior (If Applicable)

If the application is intended to run on Linux or macOS, test it on the target operating system. Common issues include:

- **File path separators**: Replace hardcoded backslashes (`\`) with `Path.Combine()` or forward slashes.
- **Case-sensitive file systems**: Ensure file and directory references match the exact casing on disk.
- **Windows-specific APIs**: Search for any remaining usage of APIs from `Microsoft.Win32` or similar namespaces that are not supported cross-platform.

---

## 9. Publish the Application

Once local validation is complete, publish the application for deployment.

```bash
dotnet publish --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.