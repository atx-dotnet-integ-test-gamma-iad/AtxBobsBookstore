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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to an appropriate and supported version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same framework version to avoid inter-project compatibility issues.

---

## 4. Validate Runtime Behavior

### 4.1 Database Connectivity (`Bookstore.Data`)

- Confirm that the connection string in `appsettings.json` is correct for your target environment.
- If Entity Framework Core is in use, verify that migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 4.2 Domain Logic (`Bookstore.Domain`)

- Review any business logic classes that previously relied on .NET Framework-specific APIs (e.g., `System.Web`, `ConfigurationManager`).
- Confirm that any such dependencies have been replaced with their .NET equivalents.

### 4.3 Web Layer (`Bookstore.Web`)

- Run the web project locally and navigate through the application to verify core functionality:

```bash
dotnet run --project Bookstore.Web
```

- Check that routing, middleware, and authentication (if applicable) behave as expected.
- Review `Program.cs` and `Startup.cs` (if present) to ensure the middleware pipeline is correctly configured for cross-platform .NET.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to validate that existing functionality has not regressed:

```bash
dotnet test
```

Review any failing tests and determine whether they are failing due to migration-related changes or pre-existing issues.

---

## 6. Check for Platform-Specific Code

Use the .NET Compatibility Analyzer or review the code manually for any remaining platform-specific APIs that may not behave consistently across operating systems. Common areas to check include:

- File path separators (use `Path.Combine` rather than hardcoded separators)
- Registry access (`Microsoft.Win32.Registry` is Windows-only)
- `System.Drawing` usage (limited cross-platform support; consider `SkiaSharp` or `ImageSharp` as alternatives)

---

## 7. Publish the Application

Once validation is complete, publish the application for your target environment.

### Framework-Dependent Deployment

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

### Self-Contained Deployment

```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Replace `linux-x64` with the appropriate runtime identifier for your target platform (e.g., `win-x64`, `osx-x64`).

---

## 8. Verify Published Output

After publishing, navigate to the output directory and confirm the expected files are present. Run the published application directly to perform a final smoke test:

```bash
cd ./publish
dotnet Bookstore.Web.dll
```

Confirm the application starts without errors and that core pages and data operations function correctly.