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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider writing basic tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

---

## 4. Verify Database Connectivity and Migrations

Since `Bookstore.Data` is likely responsible for data access, verify that any Entity Framework Core migrations are up to date and compatible with the target database:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are out of date or missing, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

Apply the migrations to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Validate Runtime Behavior

Run the web application locally and manually verify that core functionality works as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following at a minimum:

- The application starts without exceptions.
- Pages or API endpoints load correctly.
- Database reads and writes function as expected.
- Any authentication or authorization flows behave correctly.

Review the console output and application logs for any runtime exceptions or deprecation warnings.

---

## 6. Review Configuration Files

Confirm that `appsettings.json` and any environment-specific configuration files (e.g., `appsettings.Production.json`) contain the correct values for the target environment, including:

- Connection strings
- Logging levels
- Any third-party service keys or endpoints

Ensure that sensitive values are not hardcoded and are instead managed through environment variables or a secrets manager.

---

## 7. Target Framework Verification

Open each `.csproj` file and confirm that the `TargetFramework` is set to the intended version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Also confirm that no remaining references to `net4x` or `netstandard` target monikers exist unless intentionally retained for compatibility reasons.

---

## 8. Review Deprecated or Removed APIs

Search the codebase for any usage of APIs that were deprecated or removed in the target .NET version. The [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.UpgradeAssistant` tool can assist with identifying these.