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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no errors or warnings that may have been missed:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, modern version of .NET (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, review each project for any remaining Windows-specific APIs or libraries. Common areas to check include:

- `Microsoft.Win32` namespace usage
- Windows Registry access
- `System.Drawing` (which has platform limitations on non-Windows systems)
- Any remaining references to `System.Web`

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` package if cross-platform abstractions are needed.

---

## 5. Run Existing Tests

If the solution contains a test project, run the test suite to validate that existing functionality behaves as expected after migration:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether they reflect regressions introduced during migration or pre-existing issues.

---

## 6. Validate the Web Application Locally

Run the `Bookstore.Web` project locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically verify:

- Application startup without exceptions
- Database connectivity from `Bookstore.Data`
- Domain logic behaves correctly through the UI
- Any authentication or session handling works as expected

---

## 7. Review Configuration Files

Check that `appsettings.json` (and environment-specific variants such as `appsettings.Production.json`) are properly configured. Confirm that:

- Connection strings are correct for the target environment
- Any configuration keys previously stored in `Web.config` have been migrated to `appsettings.json`
- Environment variables are used where appropriate for sensitive values such as passwords or API keys

---

## 8. Database Migration Validation

If the project uses Entity Framework, verify that migrations are up to date and can be applied cleanly:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply pending migrations against a test database before deploying to production:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 9. Publish the Application

Once validation is complete, publish the application using the following command:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files and assets are present before deploying to the target environment.