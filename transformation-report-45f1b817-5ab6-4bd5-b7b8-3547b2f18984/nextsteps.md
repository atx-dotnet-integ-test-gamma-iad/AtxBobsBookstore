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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, consider finding their cross-platform equivalents on [NuGet](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas of the code that may behave differently on cross-platform .NET.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy) to confirm your chosen version is still within its support window.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, audit each project for APIs or libraries that are Windows-only. Common areas to check include:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Communication Foundation (WCF)** — client-side is available via `System.ServiceModel`, but server-side is not supported on cross-platform .NET
- **`System.Drawing`** — requires additional native dependencies on non-Windows platforms
- **Windows-specific authentication** (e.g., NTLM, Windows Identity)

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify these.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing unit tests for the core logic in `Bookstore.Domain` and integration tests for `Bookstore.Data` to validate database interactions.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, run the following to verify the model and migrations are consistent:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If the database schema needs to be updated:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Ensure the connection string in `appsettings.json` is correctly configured for your target environment.

---

## 7. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the displayed local URL and manually verify that core functionality — such as browsing, searching, and any data-driven pages — works correctly.

---

## 8. Review Configuration Migration

Legacy .NET Framework projects used `Web.config` and `App.config`. Cross-platform .NET uses `appsettings.json` and environment variables. Confirm that:

- All connection strings have been moved to `appsettings.json`
- Any custom configuration sections from `Web.config` have been re-implemented using the `Microsoft.Extensions.Configuration` API
- Sensitive values (e.g., connection strings, API keys) are not hardcoded and are instead sourced from environment variables or a secrets manager

---

## 9. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Verify the contents of the `./publish` directory before deploying to your target environment.