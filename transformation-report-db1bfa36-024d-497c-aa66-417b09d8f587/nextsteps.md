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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is still targeting `net48` or `netstandard2.0`, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect the code and project references for any APIs or libraries that are Windows-only. Common areas to check include:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Authentication** or NTLM-specific configurations
- **System.Drawing** (use `System.Drawing.Common` with caution, or migrate to a cross-platform alternative)
- **Web.config** transformations (these should be replaced with `appsettings.json`)

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify platform-specific calls.

---

## 5. Validate Configuration Files

Ensure that `Web.config` or `App.config` settings have been properly migrated to `appsettings.json` and that the application reads configuration through `IConfiguration`.

Check that the following are present and correctly configured in `Bookstore.Web`:

- `appsettings.json`
- `appsettings.Development.json` (for local development overrides)
- `Program.cs` or `Startup.cs` using the modern .NET hosting model

---

## 6. Verify Database Connectivity (Bookstore.Data)

If the project uses Entity Framework, confirm the version being used is Entity Framework Core and not the legacy `System.Data.Entity` namespace.

```bash
dotnet ef dbcontext info --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations exist, verify they are compatible:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Update the connection string in `appsettings.json` to point to the correct database instance for your environment.

---

## 7. Run Unit Tests

If the solution contains test projects, run them to validate that business logic in `Bookstore.Domain` and data access in `Bookstore.Data` behave as expected.

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests and determine whether the failures are due to migration-related changes or pre-existing issues.

---

## 8. Run the Application Locally

Start the web application locally to perform manual validation.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Walk through the core application flows, such as browsing books, managing inventory, and any authentication flows, to confirm that behavior matches the original application.

---

## 9. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web -c Release -o ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web -c Release -r linux-x64 --self-contained true -o ./publish
```

Review the contents of the `./publish` folder before deploying to the target environment.