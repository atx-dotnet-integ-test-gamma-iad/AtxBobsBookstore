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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, consider updating them to versions that explicitly support the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or unexpected warnings.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them to confirm that existing behavior has been preserved after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Pay close attention to any tests that interact with:
- Database access logic in `Bookstore.Data`
- Domain model behavior in `Bookstore.Domain`
- HTTP request handling or middleware in `Bookstore.Web`

If no test projects currently exist, consider adding them to cover critical paths before deploying.

---

## 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas at a minimum:
- Application starts without exceptions
- Database connections are established correctly (check connection strings in `appsettings.json`)
- Core pages and routes load as expected
- Any authentication or authorization flows behave correctly

---

## 5. Review Configuration Files

Cross-platform .NET uses `appsettings.json` rather than `Web.config` or `App.config` for most configuration. Confirm that:

- Connection strings have been migrated to `appsettings.json`
- Environment-specific settings are handled using `appsettings.Development.json` and `appsettings.Production.json`
- Any configuration that previously relied on `System.Configuration.ConfigurationManager` has been updated to use `Microsoft.Extensions.Configuration`

---

## 6. Check for Platform-Specific Code

Even without build errors, some code may have been written with Windows-specific assumptions. Review the following:

- File path separators — use `Path.Combine()` rather than hardcoded backslashes
- Any use of the Windows registry or Windows-only APIs
- Case sensitivity in file paths, which matters on Linux and macOS

---

## 7. Review Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm that:

- The correct EF Core provider is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or another provider appropriate for your database)
- Migrations are present and up to date by running:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- The database schema can be applied cleanly:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 8. Publish the Application

Once validation is complete, publish the application to a self-contained or framework-dependent deployment:

**Framework-dependent:**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

**Self-contained (example for Linux x64):**
```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --runtime linux-x64 --self-contained true --output ./publish
```

Review the contents of the `./publish` directory to confirm all expected files are present before deploying to the target environment.