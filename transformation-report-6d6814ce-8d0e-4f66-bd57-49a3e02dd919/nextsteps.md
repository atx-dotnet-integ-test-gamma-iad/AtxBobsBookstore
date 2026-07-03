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

The following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages reference `netstandard` or `net4x` target frameworks exclusively, consider finding cross-platform compatible alternatives.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues beyond what was reported.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Runtime Compatibility

Check for any APIs that were available in .NET Framework but have changed or been removed in cross-platform .NET. Common areas to inspect include:

- **Configuration**: Ensure `System.Configuration.ConfigurationManager` usage has been replaced with `Microsoft.Extensions.Configuration`.
- **Entity Framework**: Confirm that any Entity Framework 6 usage has been migrated to Entity Framework Core, or that the appropriate EF6 compatibility package is referenced.
- **HTTP Modules and Handlers**: If `Bookstore.Web` previously used HTTP Modules or Handlers, verify these have been converted to ASP.NET Core Middleware.
- **Global.asax**: Confirm that any logic from `Global.asax` has been moved to `Program.cs` or `Startup.cs`.
- **Web.config**: Verify that settings previously in `Web.config` have been moved to `appsettings.json` and are being read through `IConfiguration`.

---

## 4. Run Unit Tests

If the solution contains a test project, execute the tests to validate that existing functionality behaves as expected after migration.

```bash
dotnet test
```

If no test project exists, consider writing basic integration or unit tests for the core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding.

---

## 5. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Manually test the primary user-facing workflows such as browsing books, searching, and any checkout or account functionality. Pay attention to:

- Database connectivity and migrations (run `dotnet ef database update` if using EF Core migrations)
- Static file serving
- Authentication and authorization flows
- Any third-party integrations (payment gateways, email services, etc.)

---

## 6. Review Logging and Error Handling

Ensure that the application's logging configuration is functional under the new hosting model. ASP.NET Core uses `Microsoft.Extensions.Logging` by default. Confirm that log output appears as expected and that unhandled exceptions are captured appropriately.

---

## 7. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element targets an appropriate and actively supported version of .NET, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If the projects are targeting `net6.0` or `net7.0`, consider upgrading to `net8.0` as those versions are approaching or have reached end of support.

---

## 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is self-contained and correct.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all necessary files, static assets, and configuration files are present before deploying to the target environment.