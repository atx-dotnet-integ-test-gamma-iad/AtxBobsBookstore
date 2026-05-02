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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `net4x` or older target frameworks, consider finding their cross-platform equivalents on [NuGet](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without errors or warnings that could indicate runtime issues.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is still targeting `net6.0` or earlier, consider updating to `net8.0` as it is the current Long-Term Support (LTS) release.

---

## 4. Check for Platform-Specific Code

Search the codebase for APIs that were Windows-specific in the legacy project and may not behave correctly on Linux or macOS. Common areas to check include:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Identity / Authentication** (`System.Security.Principal.WindowsIdentity`)
- **File path separators** — use `Path.Combine` and `Path.DirectorySeparatorChar` rather than hardcoded backslashes
- **`System.Drawing`** — if used for image processing, consider replacing with a cross-platform library such as `SkiaSharp` or `ImageSharp`

---

## 5. Verify Entity Framework or Data Access Layer

If `Bookstore.Data` uses Entity Framework, confirm the correct provider is referenced and that any migrations are up to date.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to a local development database before testing.

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute the test suite to confirm existing functionality has not regressed.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

Review any failing tests and determine whether the failures are caused by the migration or pre-existing issues.

---

## 7. Run the Application Locally

Start the web application locally and verify that core functionality works as expected.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Manually test the following areas at a minimum:

- Application startup and home page load
- Database connectivity and data retrieval
- Any authentication or authorization flows
- Form submissions and data writes

---

## 8. Review Configuration Files

Ensure `appsettings.json` and `appsettings.Production.json` contain the correct values for the target environment. Legacy projects often stored configuration in `Web.config` or `App.config`. Confirm that all relevant settings have been migrated to the `appsettings.json` structure, including:

- Connection strings
- Logging configuration
- Any application-specific keys or feature flags

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment artifact.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Verify the contents of the `./publish` directory before deploying to the target environment.