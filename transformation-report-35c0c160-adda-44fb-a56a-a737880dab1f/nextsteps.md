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

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Refer to the [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy) to confirm your chosen version is still in active or LTS support.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, review the following areas for any remaining Windows-specific dependencies:

- **`Bookstore.Data`**: Check for any usage of `System.Data.SqlClient`. If present, replace it with `Microsoft.Data.SqlClient`, which supports cross-platform scenarios.
- **`Bookstore.Web`**: Confirm that no `System.Web` references remain. These are not supported on cross-platform .NET.
- Review any file path handling to ensure `Path.Combine` is used instead of hardcoded backslashes.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the tests to validate that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences in the new framework version or by incomplete migration.

---

## 6. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Verify the following at runtime:

- Application starts without exceptions
- Database connectivity functions correctly (check connection strings in `appsettings.json`)
- Core application routes and pages load as expected
- Any authentication or session-based functionality behaves correctly

---

## 7. Review Configuration Files

Cross-platform .NET uses `appsettings.json` rather than `Web.config` or `App.config`. Confirm the following:

- Connection strings have been moved to `appsettings.json`
- Any environment-specific settings are handled using `appsettings.Development.json` or environment variables
- Sensitive values such as connection string passwords are not committed to source control; use user secrets locally via:

```bash
dotnet user-secrets init --project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Validate Database Migrations

If the project uses Entity Framework Core, confirm that migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations are missing or outdated, add a new migration to reflect the current model state:

```bash
dotnet ef migrations add PostMigration --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Then apply the migration to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 9. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory before deploying to the target environment.