# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution (`Bookstore.Data`, `Bookstore.Web`, and `Bookstore.Domain`). The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no issues beyond what was captured in the initial error report:

```bash
dotnet build --configuration Release
```

Address any warnings that may surface, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, modern version of .NET (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that were available in .NET Framework but have been removed or altered in cross-platform .NET. Common areas to check include:

- `System.Web` references (not available in .NET Core/.NET 5+)
- `ConfigurationManager` usage (requires the `System.Configuration.ConfigurationManager` NuGet package)
- Windows-specific APIs such as the registry or certain `System.Drawing` features
- Entity Framework 6 vs. Entity Framework Core differences if EF is used in `Bookstore.Data`

---

## 5. Run Existing Tests

If the solution contains a test project, run the tests to validate core functionality:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether failures are caused by behavioral differences in the new runtime or by incomplete migration of dependencies.

---

## 6. Manually Test the Web Application

Start the `Bookstore.Web` project locally and verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Test the following areas manually:

- Application startup and landing page rendering
- Database connectivity through `Bookstore.Data`
- Domain logic correctness through `Bookstore.Domain`
- Any authentication or session management features
- Form submissions and data persistence

---

## 7. Review Configuration Files

Confirm that `appsettings.json` (or `appsettings.Development.json`) contains all necessary configuration values that were previously stored in `Web.config` or `App.config`. Key items to verify:

- Database connection strings
- Application-specific settings
- Logging configuration

---

## 8. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations are missing or out of sync, create a new migration to reflect the current model state:

```bash
dotnet ef migrations add InitialMigration --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 9. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all required assets, configuration files, and binaries are present before deploying to the target environment.