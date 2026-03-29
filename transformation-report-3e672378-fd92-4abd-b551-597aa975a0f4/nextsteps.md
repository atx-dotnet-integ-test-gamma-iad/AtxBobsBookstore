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

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check [NuGet.org](https://www.nuget.org) for updated versions compatible with the target .NET version.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended modern .NET version (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects so there are no cross-targeting conflicts.

---

## 4. Check for Removed or Changed APIs

Some APIs available in .NET Framework are not present or have changed in modern .NET. Review the following areas manually:

- **`Bookstore.Data`**: Verify Entity Framework usage. If the project was using Entity Framework 6, confirm it has been migrated to Entity Framework Core and that database context configurations, migrations, and connection strings are correct.
- **`Bookstore.Web`**: If this was an ASP.NET Web Forms or MVC project targeting .NET Framework, confirm it has been converted to ASP.NET Core. Check that middleware configuration in `Program.cs` or `Startup.cs` is correct.
- **`Bookstore.Domain`**: Confirm that any serialization, reflection, or configuration-related code functions as expected under the new runtime.

---

## 5. Run Database Migrations

If Entity Framework Core is in use, verify that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Update Configuration Files

- Confirm that `appsettings.json` contains the correct connection strings and application settings previously held in `Web.config` or `App.config`.
- Verify that environment-specific settings (e.g., `appsettings.Development.json`) are configured appropriately.

---

## 7. Run the Application Locally

Start the web application locally to perform a basic smoke test:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the application in a browser and verify that core functionality such as page rendering, data retrieval, and form submissions work as expected.

---

## 8. Execute Existing Tests

If the solution contains a test project, run the test suite to validate business logic and data access behavior:

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to legitimate regressions or test code that itself requires updating for .NET compatibility.

---

## 9. Validate Logging and Error Handling

- Confirm that logging is configured correctly using `Microsoft.Extensions.Logging` or a compatible provider such as Serilog or NLog.
- Trigger known error conditions manually and verify that exceptions are handled and logged as expected.

---

## 10. Publish the Application

Once validation is complete, publish the application to verify the output is correct:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.