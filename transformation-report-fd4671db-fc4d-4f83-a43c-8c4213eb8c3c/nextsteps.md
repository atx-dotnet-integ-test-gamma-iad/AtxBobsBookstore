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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to an appropriate and supported version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same or compatible framework versions to avoid interoperability issues.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, inspect the code and project files for any remaining Windows-specific dependencies, such as:

- `System.Web` references
- Windows Registry access
- COM interop
- `HttpContext` usage patterns specific to ASP.NET (non-Core)

Replace or abstract any such dependencies with cross-platform alternatives.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the test suite to verify that existing functionality behaves as expected after migration.

```bash
dotnet test
```

If no tests currently exist, consider writing basic integration or unit tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data`.

---

## 6. Run the Application Locally

Start the web application locally to verify runtime behavior.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Manually verify the following:

- Application starts without runtime exceptions
- Database connections in `Bookstore.Data` are functional
- Pages and routes in `Bookstore.Web` load correctly
- Any data read/write operations work as expected

---

## 7. Verify Configuration Files

Check that `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) are present and correctly configured. Legacy projects may have relied on `Web.config` or `App.config`, which should now be replaced with the `appsettings.json` pattern.

Confirm the following are correctly set:

- Connection strings
- Logging configuration
- Any application-specific settings previously stored in `Web.config`

---

## 8. Database Migration Check

If `Bookstore.Data` uses Entity Framework, verify that migrations are up to date and compatible with the new framework version.

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj
```

If the schema needs to be applied to a database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to your target environment.