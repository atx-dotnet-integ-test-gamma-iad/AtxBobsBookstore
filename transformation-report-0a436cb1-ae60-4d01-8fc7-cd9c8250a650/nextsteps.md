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

## 4. Check for Windows-Specific APIs

Even without build errors, some APIs used in the original project may be Windows-specific and will fail at runtime on non-Windows platforms. Use the .NET Compatibility Analyzer to surface these issues.

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Review any analyzer warnings in the build output and replace platform-specific APIs with cross-platform alternatives where applicable.

---

## 5. Verify Entity Framework Core Configuration

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The project references `Microsoft.EntityFrameworkCore` and the appropriate database provider (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- The `DbContext` is registered correctly in the dependency injection container within `Bookstore.Web`.
- Any pending migrations are up to date.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

Apply any pending migrations to the target database.

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If the solution contains a test project, execute the test suite to validate business logic and data access behavior.

```bash
dotnet test --configuration Release
```

Review the test results and address any failures before proceeding.

---

## 7. Run the Application Locally

Start the web application locally to verify runtime behavior.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application URL printed in the console output and manually verify:

- Pages load without errors.
- Data is read from and written to the database correctly.
- Authentication and authorization behave as expected, if applicable.

---

## 8. Review `appsettings.json` and Configuration

Confirm that connection strings and other configuration values in `appsettings.json` are correct for the target environment. Legacy projects sometimes store configuration in `Web.config`, which is not used by ASP.NET Core.

- Migrate any relevant values from `Web.config` to `appsettings.json`.
- Ensure environment-specific overrides are placed in `appsettings.Production.json` as needed.

---

## 9. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent deployment.

**Framework-dependent:**
```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory and deploy them to the target host.