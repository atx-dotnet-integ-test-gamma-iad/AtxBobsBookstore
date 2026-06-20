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

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another .NET Framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific Dependencies

Search the codebase for APIs or packages that are Windows-only, such as:

- `System.Web`
- `Microsoft.Web.*`
- Windows Registry access
- COM interop

If any are found, replace them with cross-platform equivalents or apply runtime platform guards using `RuntimeInformation.IsOSPlatform`.

---

## 5. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality has not regressed.

```bash
dotnet test --configuration Release
```

Review the test output for any failures and address them before proceeding.

---

## 6. Validate the Data Layer

Since `Bookstore.Data` likely interacts with a database, verify the following:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Any existing migrations are compatible with the new target framework.
- Run a migration check:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or inconsistent, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 7. Run the Web Application Locally

Start the web application and verify it runs correctly on the local development machine.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the URL shown in the terminal output and confirm that the application loads and behaves as expected.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` and `appsettings.Development.json` contain the correct configuration values, including:

- Connection strings
- Logging settings
- Any environment-specific values previously stored in `Web.config`

Note that `Web.config` is not used in cross-platform .NET. All configuration should be handled through `appsettings.json` or environment variables.

---

## 9. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment package.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.