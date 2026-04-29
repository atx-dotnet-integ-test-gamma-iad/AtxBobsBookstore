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

If the solution contains test projects, execute them with:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding unit tests for the `Bookstore.Domain` layer and integration tests for `Bookstore.Data` to verify database interactions behave as expected under the new framework.

---

## 4. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, confirm the following:

- The connection string in `appsettings.json` is correctly configured for your target environment.
- Run any pending migrations to ensure the schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and verify that:

- Pages load without errors.
- Data is read from and written to the database correctly.
- Any authentication or authorization flows function as expected.

---

## 6. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` for application configuration. Confirm that:

- All settings previously in `Web.config` or `App.config` have been migrated to `appsettings.json`.
- Environment-specific overrides are placed in `appsettings.{Environment}.json` files.
- Secrets such as connection strings are not committed to source control. Use the .NET Secret Manager for local development:

```bash
dotnet user-secrets init --project Bookstore.Web
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "your_connection_string"
```

---

## 7. Check for Platform-Specific API Usage

Review the codebase for any APIs that were available in .NET Framework but have limited or no support in cross-platform .NET, including:

- `System.Web` references (should have been removed or replaced).
- Windows Registry access.
- COM interop dependencies.
- `HttpContext` usage outside of the request pipeline.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to surface any remaining compatibility concerns.

---

## 8. Validate Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent framework version to avoid inter-project compatibility issues.