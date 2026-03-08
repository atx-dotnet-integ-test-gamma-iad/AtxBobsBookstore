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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

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

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Validate Runtime Behavior

### 3.1 Run the Web Project Locally

Start the web application and verify it runs without runtime exceptions:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and exercise the core workflows, such as browsing books, managing inventory, or any other primary features.

### 3.2 Check Data Layer Connectivity

Verify that `Bookstore.Data` connects to the database correctly. Confirm the following:

- The connection string in `appsettings.json` (or equivalent) is correct for the target environment.
- If Entity Framework Core is in use, run any pending migrations:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- If the project was previously using Entity Framework 6, confirm it has been migrated to **Entity Framework Core**, as EF6 does not fully support cross-platform .NET.

---

## 4. Run Existing Tests

If the solution contains test projects, run them to validate that existing functionality has not regressed:

```bash
dotnet test
```

Review any failing tests and determine whether the failures are due to the migration or pre-existing issues.

---

## 5. Check for Platform-Specific Code

Even without build errors, certain APIs that were available in .NET Framework may behave differently or be unavailable at runtime on non-Windows platforms. Review the following areas:

- **`System.Web` dependencies**: These are not available in cross-platform .NET. Ensure all `System.Web` usages have been replaced with ASP.NET Core equivalents.
- **Registry access** (`Microsoft.Win32.Registry`): Not supported on Linux/macOS.
- **Windows Communication Foundation (WCF)**: The server-side WCF stack is not supported. Only a limited client-side implementation is available via `System.ServiceModel`.
- **File path separators**: Ensure file path handling uses `Path.Combine` and `Path.DirectorySeparatorChar` rather than hardcoded backslashes.

You can use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify remaining platform-specific calls.

---

## 6. Review Configuration

.NET applications use `appsettings.json` instead of `Web.config` or `App.config`. Confirm the following:

- All connection strings, application settings, and environment-specific values have been moved to `appsettings.json` or `appsettings.{Environment}.json`.
- The application reads configuration via `IConfiguration` rather than `ConfigurationManager`.

---

## 7. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Verify the contents of the `./publish` directory and confirm the application starts correctly from that output folder before deploying to the target environment.