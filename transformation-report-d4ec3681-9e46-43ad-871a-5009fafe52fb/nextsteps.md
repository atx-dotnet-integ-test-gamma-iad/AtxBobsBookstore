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

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a currently supported version of .NET (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) to confirm your chosen version is still within its support window.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project, verify that no Windows-only APIs are being used without a compatibility shim. Common areas to check include:

- `System.Web` references (should be replaced with `Microsoft.AspNetCore.*`)
- Registry access (`Microsoft.Win32.Registry`)
- Windows Communication Foundation (WCF) server-side components

Run the .NET Upgrade Assistant compatibility analyzer if needed:

```bash
dotnet tool install -g upgrade-assistant
upgrade-assistant analyze .
```

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to verify runtime behavior matches expectations:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no tests currently exist, consider writing integration or unit tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 6. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, verify the following:

- The connection string in `appsettings.json` is correct for your target environment.
- Migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

- If migrating from Entity Framework 6 (EF6) to EF Core, review any breaking changes in query behavior, lazy loading configuration, and relationship mapping.

---

## 7. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas at runtime:

- Application startup completes without exceptions.
- Routing and page rendering work as expected.
- Data is read from and written to the database correctly.
- Authentication and authorization flows behave correctly if applicable.

---

## 8. Review Configuration Files

Ensure that any settings previously stored in `Web.config` or `App.config` have been properly migrated to `appsettings.json` and are being read via `IConfiguration`. Pay particular attention to:

- Connection strings
- Application-specific settings
- Logging configuration

---

## 9. Address Runtime Warnings and Deprecations

After running the application, monitor the console and log output for:

- Deprecation warnings from ASP.NET Core middleware
- EF Core query translation warnings
- Any `PlatformNotSupportedException` at runtime

These will not appear as build errors but can affect correctness and long-term maintainability.