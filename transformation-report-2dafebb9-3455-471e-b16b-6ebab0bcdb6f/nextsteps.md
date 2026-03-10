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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If the projects are targeting `net6.0` or `net7.0`, consider updating to `net8.0`, which is the current Long Term Support (LTS) release.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, verify that no Windows-specific APIs are being used that would break cross-platform compatibility. Look for usages of:

- `System.Web` (not available in modern .NET)
- Windows Registry access
- Windows-only file path assumptions (e.g., backslashes)
- COM interop or P/Invoke calls targeting Windows libraries

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package if platform-specific branching is needed.

---

## 5. Run the Application Locally

Start the `Bookstore.Web` project and verify the application runs as expected.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Manually walk through the key application flows, such as browsing, searching, and any data entry features, to confirm runtime behavior matches the legacy application.

---

## 6. Validate Data Layer

Since `Bookstore.Data` handles data access, verify the following:

- **Database connection strings** in `appsettings.json` are correctly configured for the target environment.
- **Entity Framework Core migrations** (if applicable) are up to date. Run the following to check:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- If the project previously used **Entity Framework 6**, confirm it has been migrated to **Entity Framework Core**, as EF6 has limited support on non-Windows platforms.

Apply any pending migrations against your development database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 7. Execute Automated Tests

If the solution contains test projects, run them to validate that existing functionality has not regressed.

```bash
dotnet test
```

Review the test output for any failures. Pay particular attention to tests covering the domain logic in `Bookstore.Domain`, as this layer is the most independent and foundational.

---

## 8. Review Configuration and Middleware

In `Bookstore.Web`, confirm that the ASP.NET Core middleware pipeline is correctly configured in `Program.cs` (or `Startup.cs` if still present). Key areas to check:

- Authentication and authorization middleware
- Static file serving
- Routing configuration
- Any legacy `HttpModule` or `HttpHandler` equivalents that should have been replaced with ASP.NET Core middleware

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Inspect the `./publish` directory to ensure all required assets, configuration files, and binaries are present before deploying to the target environment.