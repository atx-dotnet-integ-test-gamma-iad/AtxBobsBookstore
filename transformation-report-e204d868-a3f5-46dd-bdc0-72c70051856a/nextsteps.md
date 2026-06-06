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

The steps below describe how to validate, test, and deploy the migrated solution.

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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another legacy framework moniker, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Windows-Specific Dependencies

Review `Bookstore.Data` and `Bookstore.Web` for any dependencies that may only function on Windows, such as:

- `System.Web` references
- Windows Registry access
- COM interop
- MSMQ or WCF components

These will not function on Linux or macOS and will require replacement with cross-platform alternatives.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to validate that existing functionality behaves as expected after migration.

```bash
dotnet test --configuration Release
```

Review test results for any failures that may indicate behavioral differences introduced by the framework change.

---

## 6. Manually Verify Application Behavior

Start the `Bookstore.Web` project locally and perform manual verification of core application flows, such as:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Verify the following areas at a minimum:

- Application startup and routing
- Database connectivity from `Bookstore.Data`
- Domain logic correctness from `Bookstore.Domain`
- Any authentication or session handling

---

## 7. Validate Database Connectivity and Migrations

If the project uses Entity Framework Core, confirm that migrations are up to date and that the connection string is correctly configured for the target environment.

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Review Configuration Files

Ensure that `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, `appsettings.Production.json`) are present and contain the correct values. Legacy `Web.config` or `App.config` settings should have been migrated to the `appsettings.json` structure.

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is correct before deploying to the target environment.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all expected files are present.