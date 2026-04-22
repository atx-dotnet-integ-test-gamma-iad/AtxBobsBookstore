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

Ensure all three projects are targeting the same or compatible framework versions to avoid interoperability issues.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, verify that no Windows-specific APIs or libraries remain in use. Common areas to check include:

- `System.Web` references (not available in cross-platform .NET)
- Windows Registry access
- COM interop
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling if needed.

---

## 5. Run the Application Locally

Start the web application locally to verify it runs as expected.

```bash
cd app/Bookstore.Web
dotnet run
```

Navigate to the displayed localhost URL and perform basic smoke testing:

- Confirm the home page loads
- Test any primary user-facing features such as browsing, searching, or purchasing books
- Check that database connectivity is functioning if `Bookstore.Data` uses Entity Framework or another ORM

---

## 6. Validate the Data Layer

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date.

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If migrations are missing or out of date, apply them to the target database.

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 7. Execute Unit and Integration Tests

If the solution contains test projects, run all tests to validate that existing functionality has not regressed.

```bash
dotnet test
```

Review the test output for any failures. Pay particular attention to tests covering the domain logic in `Bookstore.Domain`, as this layer is the most foundational.

---

## 8. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment package.

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.