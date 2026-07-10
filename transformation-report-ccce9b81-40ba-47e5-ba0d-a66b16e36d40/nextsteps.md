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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a currently supported version of .NET (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is targeting an older or end-of-life version such as `netcoreapp3.1` or `net5.0`, update it to a supported release.

---

## 4. Verify Configuration Files

Check that `appsettings.json` (and any environment-specific variants such as `appsettings.Development.json`) in `Bookstore.Web` contains the correct configuration values, including:

- Database connection strings
- Any API keys or service endpoints
- Logging configuration

If the original project used `Web.config` or `App.config`, confirm that all relevant settings have been migrated to the `appsettings.json` format.

---

## 5. Verify Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm that:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or the appropriate provider for your database).
- Any pending migrations are up to date.

To list existing migrations:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

To apply migrations to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

Navigate to the URL shown in the console output and manually verify that core functionality such as browsing, searching, and any data-driven pages work as expected.

---

## 7. Run Existing Tests

If the solution contains a test project, execute the test suite to confirm existing behavior is preserved.

```bash
dotnet test
```

Review any failing tests and determine whether they indicate a regression introduced during migration or a test that requires updating due to API changes in the new target framework.

---

## 8. Check for Windows-Specific API Usage

Since this is a cross-platform migration, scan the codebase for any APIs that are Windows-only. The .NET Compatibility Analyzer can assist with this. You can enable it by adding the following to a `.csproj` file:

```xml
<PropertyGroup>
  <PlatformTarget>AnyCPU</PlatformTarget>
</PropertyGroup>
```

Pay particular attention to:

- `System.Web` references (these are not available in .NET Core/5+)
- Windows Registry access
- Windows-specific file path assumptions (e.g., backslashes)
- COM interop

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to the target environment.