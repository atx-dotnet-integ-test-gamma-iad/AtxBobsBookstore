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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is still targeting `net48` or `netstandard2.0`, update it to a current .NET target where appropriate.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect the code and project references for any APIs or libraries that are Windows-only. Common areas to check include:

- `System.Web` references (not available on .NET Core/5+)
- Windows Registry access (`Microsoft.Win32.Registry`)
- COM interop or P/Invoke calls targeting Windows-specific DLLs
- Any use of `HttpContext` patterns from classic ASP.NET

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package to identify platform-specific code paths.

---

## 5. Run the Application Locally

Start the web application to verify it runs correctly in the new runtime.

```bash
cd app/Bookstore.Web
dotnet run
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and any data entry flows, to confirm basic functionality is intact.

---

## 6. Validate Data Access

Since `Bookstore.Data` handles data concerns, verify the following:

- **Entity Framework Core migrations**: If the project uses EF Core, confirm that migrations are present and up to date.
  ```bash
  dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
  ```
- **Database connectivity**: Confirm connection strings in `appsettings.json` are correct for your target environment.
- **Schema compatibility**: Apply any pending migrations against a test database.
  ```bash
  dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
  ```

If the project previously used `System.Data` or ADO.NET directly, test all data access paths manually.

---

## 7. Execute Existing Tests

If the solution contains test projects, run them to verify that business logic in `Bookstore.Domain` and data access in `Bookstore.Data` behave as expected.

```bash
dotnet test
```

Review any failing tests to determine whether failures are due to migration-related behavioral changes or pre-existing issues.

---

## 8. Configuration and Environment Settings

Compare the old `Web.config` or `App.config` files with the new `appsettings.json` to ensure all configuration values have been carried over, including:

- Connection strings
- Application settings keys
- Authentication or authorization configuration
- Logging settings

---

## 9. Publish the Application

Once validation is complete, publish the application to a target directory.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj \
  --configuration Release \
  --output ./publish
```

Review the contents of the `./publish` folder to confirm all required files, static assets, and configuration files are present before deploying to the target environment.