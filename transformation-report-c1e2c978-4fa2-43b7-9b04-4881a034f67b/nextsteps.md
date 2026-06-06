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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `net4x` or older target frameworks exclusively, consider finding their cross-platform equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly:
- Nullable reference type warnings
- Obsolete API usage
- Platform compatibility warnings (e.g., `CA1416`)

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element targets a supported cross-platform version of .NET (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Windows-Specific Dependencies

Review all three projects for any APIs or packages that are Windows-only. Common areas to inspect:

- `System.Web` references (should be replaced with ASP.NET Core equivalents)
- `Microsoft.Win32` usage
- Windows Registry access
- COM interop or P/Invoke calls targeting Windows libraries

Use the .NET Upgrade Assistant compatibility analyzer or the `dotnet-compatibility` tool to assist:

```bash
dotnet tool install -g dotnet-compatibility
```

---

## 5. Run Unit Tests

If the solution contains a test project, execute the test suite to verify functional correctness after migration:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no test project exists, consider writing basic integration or smoke tests that cover:
- Database connectivity (`Bookstore.Data`)
- Core domain logic (`Bookstore.Domain`)
- Key HTTP endpoints (`Bookstore.Web`)

---

## 6. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework, verify that the database provider package is compatible with the new target framework. For example, if using SQL Server:

```xml
<PackageReference Include="Microsoft.EntityFrameworkCore.SqlServer" Version="8.x.x" />
```

Run any pending migrations to ensure the schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, authentication if present, data submission). Check the console output and application logs for any runtime exceptions.

---

## 8. Review Configuration Files

Ensure `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) contain all necessary configuration that may have previously resided in `Web.config` or `App.config`. Key areas to check:

- Connection strings
- Logging configuration
- Application-specific settings

Legacy `Web.config` transformation logic should be replaced with the ASP.NET Core configuration system (`IConfiguration`).

---

## 9. Validate on a Non-Windows Platform (Optional but Recommended)

Since the goal is cross-platform compatibility, consider running the application on Linux or macOS to surface any remaining platform-specific issues:

```bash
dotnet run --project Bookstore.Web
```

Address any `PlatformNotSupportedException` or similar runtime errors that appear only on non-Windows systems.