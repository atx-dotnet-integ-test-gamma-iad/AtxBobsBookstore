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

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check [NuGet.org](https://www.nuget.org) for updated versions compatible with your target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly:
- Nullable reference type warnings
- Obsolete API usage warnings
- Platform compatibility warnings

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to your intended .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid interoperability issues.

---

## 4. Database Migration Validation

Since `Bookstore.Data` is likely responsible for data access, verify that any Entity Framework Core migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, add or update them:

```bash
dotnet ef migrations add <MigrationName> --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run Unit and Integration Tests

If the solution contains a test project, execute all tests to validate core functionality:

```bash
dotnet test --configuration Release
```

Review the test results for any failures. Pay particular attention to tests covering:
- Domain logic in `Bookstore.Domain`
- Data access and repository methods in `Bookstore.Data`
- Controller actions and middleware in `Bookstore.Web`

---

## 6. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Manually verify the following:
- The application starts without runtime exceptions
- Database connectivity is functional
- Key application routes and pages load correctly
- Any authentication or authorization flows behave as expected

---

## 7. Review Configuration Files

Check `appsettings.json` and `appsettings.Development.json` in `Bookstore.Web` to confirm:
- Connection strings are correct for the target environment
- Any legacy `web.config` settings have been properly migrated to `appsettings.json`
- Logging configuration is appropriate

---

## 8. Check for Removed or Changed APIs

Review the code for any usage of APIs that have changed behavior between .NET Framework and modern .NET. Common areas to check include:
- `HttpContext` and `HttpRequest` usage
- `System.Web` references (these are not available in modern .NET)
- `ConfigurationManager` usage, which should be replaced with `IConfiguration`
- Any Windows-specific APIs if cross-platform support is required

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) to identify any remaining compatibility concerns.