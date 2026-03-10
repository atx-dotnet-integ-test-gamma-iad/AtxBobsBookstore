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

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

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

If any project is still targeting `net48` or `netstandard2.0`, update it accordingly and re-run the build.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect the code and project references for any APIs that are Windows-only. Common areas to check include:

- `System.Web` usage (not available in .NET Core/5+)
- Windows Registry access (`Microsoft.Win32.Registry`)
- Windows Communication Foundation (WCF) server-side components
- `HttpContext` usage that relied on `System.Web.HttpContext` rather than `Microsoft.AspNetCore.Http.HttpContext`

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package to identify platform-specific calls.

---

## 5. Validate the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework (or whichever ORM is in use) has been migrated to its .NET-compatible version (e.g., EF Core instead of EF 6 for full cross-platform support).
- Run any existing database migrations to verify schema compatibility:

```bash
dotnet ef database update --project Bookstore.Data
```

- If migrations do not exist, generate an initial migration and review it before applying:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data
```

---

## 6. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite to identify any runtime regressions introduced during the migration.

```bash
dotnet test --configuration Release --logger trx
```

Review the `.trx` output file for failed tests. Pay particular attention to tests that cover:

- Data access and repository logic
- Domain model behavior
- Web controller or middleware behavior

If no tests currently exist, consider adding basic smoke tests for the most critical paths before deploying.

---

## 7. Run the Application Locally

Start the web application locally to perform manual validation.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Verify the following:

- The application starts without exceptions
- Database connectivity is functional
- Core user-facing pages load and behave correctly
- Authentication and authorization flows work as expected (if applicable)

---

## 8. Review Configuration Files

Ensure that `appsettings.json` contains all necessary configuration values that were previously stored in `Web.config` or `App.config`. Key areas to verify:

- Connection strings
- Application-specific settings
- Logging configuration

The `Web.config` and `App.config` files are not used in .NET 5+ applications. Any remaining configuration values in those files must be migrated to `appsettings.json` or environment variables.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.