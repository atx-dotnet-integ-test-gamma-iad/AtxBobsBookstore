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

Ensure the build completes with zero errors and review any warnings that may indicate compatibility concerns, such as obsolete APIs or platform-specific code.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another .NET Framework moniker, update it to the appropriate cross-platform target.

---

## 4. Check for Platform-Specific Code

Search the codebase for APIs that are Windows-specific and may not function correctly on Linux or macOS. Common areas to check include:

- `System.Web` namespace usage (should be replaced with `Microsoft.AspNetCore`)
- Windows Registry access (`Microsoft.Win32.Registry`)
- COM interop or P/Invoke calls
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify these areas if needed.

---

## 5. Validate the Data Layer (`Bookstore.Data`)

If the project uses Entity Framework, confirm the version in use:

- **Entity Framework Core** is the cross-platform successor to EF6.
- Run any pending migrations to verify the data layer connects and operates correctly.

```bash
dotnet ef database update --project Bookstore.Data
```

Confirm the connection string in `appsettings.json` (or equivalent configuration) is correct for the target environment.

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute the test suite to verify functional correctness after migration.

```bash
dotnet test
```

Review any failing tests. Failures may indicate behavioral differences between .NET Framework and modern .NET that require code adjustments.

---

## 7. Run the Application Locally

Start the web application locally and perform manual validation of core functionality.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Verify the following at a minimum:

- Application starts without runtime exceptions
- Pages load and render correctly
- Database read and write operations function as expected
- Authentication and authorization behave correctly, if applicable

---

## 8. Review Configuration and Middleware

ASP.NET Core uses a different configuration and middleware pipeline than ASP.NET. Confirm the following in `Bookstore.Web`:

- `Program.cs` or `Startup.cs` correctly registers all required services
- Middleware order is correct (e.g., authentication before authorization)
- `appsettings.json` contains all settings previously held in `Web.config` or `App.config`
- Any `Web.config` transforms have been migrated to the appropriate `appsettings.{Environment}.json` files

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is self-contained and correct.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required assets, static files, and configuration files are present before deploying to the target environment.