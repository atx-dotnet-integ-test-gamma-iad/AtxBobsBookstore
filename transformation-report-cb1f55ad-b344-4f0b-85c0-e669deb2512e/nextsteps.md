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

Review the output for any warnings about deprecated or unlisted packages that may need to be updated.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or unexpected warnings.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET across all projects (for example, `net8.0`). Mixing framework versions between projects can cause runtime issues even when the build succeeds.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs that existed in .NET Framework may behave differently or have been replaced in cross-platform .NET. Pay particular attention to:

- **`Bookstore.Data`**: Verify that Entity Framework usage has been migrated from EF 6 to EF Core if applicable. Check connection strings and database provider configuration in `DbContext`.
- **`Bookstore.Web`**: Confirm that any `System.Web` dependencies have been fully replaced with ASP.NET Core equivalents. Check middleware configuration, authentication, session handling, and HTTP context usage.
- **`Bookstore.Domain`**: Review any use of `AppDomain`, `ConfigurationManager`, or serialization APIs that differ between .NET Framework and cross-platform .NET.

---

## 5. Run Unit Tests

If the solution contains a test project, run all tests to verify that business logic and data access behave as expected after migration.

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic tests for critical paths in `Bookstore.Domain` and `Bookstore.Data` before proceeding.

---

## 6. Run the Application Locally

Start the web application locally to verify runtime behavior.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually verify the following:
- Application starts without exceptions.
- Database connectivity is functional (run any pending EF Core migrations if applicable using `dotnet ef database update`).
- Core user-facing features such as browsing, searching, and purchasing books function correctly.
- Authentication and authorization flows work as expected.

---

## 7. Review Configuration Files

Ensure that `appsettings.json` (and environment-specific variants such as `appsettings.Production.json`) contain all necessary configuration values that were previously stored in `Web.config` or `App.config`. Common items to check include:

- Database connection strings
- Application-specific settings
- Logging configuration

---

## 8. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.