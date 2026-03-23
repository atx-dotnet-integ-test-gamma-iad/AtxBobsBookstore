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

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a currently supported version of .NET (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `netcoreapp` or `net4x` target monikers, update them to a supported modern target.

---

## 4. Check for Windows-Specific Dependencies

Since this was a legacy project migration, inspect each project for any remaining Windows-specific APIs or packages, such as:

- `System.Web` references
- `Microsoft.Web.*` packages
- Windows Registry access
- `HttpContext` usage patterns specific to ASP.NET (non-Core)

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify these if needed.

---

## 5. Run Existing Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after migration.

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether failures are due to migration-related behavioral changes or pre-existing issues.

---

## 6. Validate the Data Layer (`Bookstore.Data`)

- Confirm that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) is compatible with the new target framework.
- Run any pending migrations or verify the schema is consistent:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If `dotnet-ef` is not installed globally:

```bash
dotnet tool install --global dotnet-ef
```

---

## 7. Validate the Web Layer (`Bookstore.Web`)

- Run the web project locally and navigate through the primary application flows.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Verify the following:
  - Application startup completes without exceptions.
  - Routing behaves as expected.
  - Static files, views, or Razor Pages render correctly.
  - Authentication and authorization (if present) function correctly.

---

## 8. Review `appsettings.json` and Configuration

Ensure that configuration previously stored in `Web.config` or `App.config` has been correctly migrated to `appsettings.json`. Pay particular attention to:

- Connection strings
- Application-specific settings
- Environment-specific overrides (`appsettings.Development.json`, `appsettings.Production.json`)

---

## 9. Perform a Runtime Smoke Test

Exercise the main functional areas of the application manually or via integration tests to confirm end-to-end behavior is intact after migration. Focus on:

- Browsing and searching for books
- Any CRUD operations in the data layer
- User-facing pages in the web layer

---

## 10. Prepare for Deployment

Once validation is complete:

1. Publish the application using the .NET CLI:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

2. Verify the contents of the `./publish` directory are complete and include all required assets.
3. Deploy the published output to the target hosting environment (IIS, Azure App Service, Linux server, etc.) following the platform-specific deployment documentation.