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

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific Dependencies

Even when a project builds successfully, it may still contain APIs or packages that are Windows-only. Run the .NET compatibility analyzer or review the following areas manually:

- Any usage of `System.Web` (not available on cross-platform .NET)
- References to `Microsoft.Web.*` packages
- Registry access (`Microsoft.Win32.Registry`)
- Windows Communication Foundation (WCF) server-side components

Replace or remove any Windows-specific dependencies with cross-platform equivalents where applicable.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to verify runtime behavior has not regressed.

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences between .NET Framework and modern .NET.

---

## 6. Validate Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` likely contains data access logic, verify the following:

- Connection strings in `appsettings.json` are correct for the target environment.
- If Entity Framework is used, run a check to confirm migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations if needed:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the web application and verify it runs as expected on the local machine.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm functionality is intact.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` contains all settings previously held in `Web.config` or `App.config`. Common items to verify include:

- Connection strings
- Logging configuration
- Application-specific settings

The `System.Configuration.ConfigurationManager` approach used in .NET Framework has been replaced by `Microsoft.Extensions.Configuration` in modern .NET. Confirm all configuration reads have been updated accordingly.

---

## 9. Publish the Application

Once local validation is complete, publish the application to a target directory.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` folder and confirm all required assets, views, and static files are present before deploying to the target environment.