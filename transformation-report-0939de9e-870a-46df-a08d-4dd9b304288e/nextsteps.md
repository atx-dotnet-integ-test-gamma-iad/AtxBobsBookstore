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

Review the output for any warnings related to package version conflicts or deprecated packages. Address any that appear by updating the relevant `<PackageReference>` entries in the `.csproj` files.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compile-time issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or warnings that could indicate runtime issues.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects so there are no framework version mismatches between dependencies.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently in modern .NET compared to .NET Framework. Pay particular attention to:

- **`Bookstore.Data`**: Verify that Entity Framework Core is being used in place of any legacy Entity Framework 6 code. Check that database context configuration, migrations, and connection strings are compatible with EF Core conventions.
- **`Bookstore.Web`**: Confirm that any middleware, routing, authentication, or session handling previously configured via `System.Web` has been replaced with the ASP.NET Core equivalents in `Program.cs` or `Startup.cs`.
- **`Bookstore.Domain`**: Confirm that no types from `System.Web` or other Windows-specific namespaces are referenced.

---

## 5. Run Database Migrations

If Entity Framework Core is used in `Bookstore.Data`, verify that migrations are in place and up to date.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, add or update them:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit Tests

If the solution contains a test project, execute the tests to validate that business logic and data access behavior is consistent with the original application.

```bash
dotnet test
```

Review any failing tests and determine whether they indicate a behavioral regression introduced during migration or a test that requires updating to reflect new API usage.

---

## 7. Run the Application Locally

Start the web application locally and verify core functionality.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Manually verify the following areas:

- Application starts without exceptions
- Database connectivity is functional
- Core pages and routes load correctly
- Authentication and authorization behave as expected
- Form submissions and data operations function correctly

---

## 8. Review Configuration Files

Ensure that `appsettings.json` (and `appsettings.Development.json`) contain all necessary configuration values that were previously stored in `Web.config` or `App.config`. This includes:

- Connection strings
- Application settings
- Logging configuration

The `Web.config` file is no longer the primary configuration source in ASP.NET Core. Confirm that all values have been migrated to the appropriate `appsettings.json` entries or environment variables.

---

## 9. Validate Logging

Confirm that the logging framework is correctly configured in `Program.cs`. If the original application used a third-party logger such as NLog or Serilog, verify the provider has been registered and is producing output as expected.

---

## 10. Publish the Application

Once local validation is complete, publish the application to confirm the output is clean.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required assets, static files, and configuration files are present before deploying to the target environment.