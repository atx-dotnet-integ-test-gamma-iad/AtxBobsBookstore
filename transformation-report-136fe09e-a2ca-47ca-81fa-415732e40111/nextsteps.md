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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages are flagged, update them using:

```bash
dotnet add <project> package <PackageName>
```

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) report a successful build with no errors or warnings that could affect runtime behavior.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-EOL version of .NET, such as `net8.0`.

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project is still targeting `net48` or `netcoreapp3.1`, update the target framework accordingly and re-run the restore and build steps.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs behave differently or have been removed in modern .NET. Pay particular attention to the following areas:

- **`System.Web` dependencies**: These are not available in .NET. If any code references `System.Web`, it must be replaced with ASP.NET Core equivalents.
- **`HttpContext`**: Ensure it is accessed via dependency injection (`IHttpContextAccessor`) rather than `HttpContext.Current`.
- **`ConfigurationManager`**: Replace with `Microsoft.Extensions.Configuration` and `appsettings.json`.
- **Entity Framework**: If the project uses EF6, consider migrating to EF Core. Verify that the `Bookstore.Data` project is using the correct EF Core packages and that migrations are up to date.

---

## 5. Run Database Migrations

If the project uses Entity Framework Core, verify that all migrations are applied and the schema is consistent.

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If no migrations exist yet and you are starting from an existing database, consider scaffolding the initial migration:

```bash
dotnet ef migrations add InitialCreate --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing books, adding items, and any authentication flows, to confirm expected behavior.

---

## 7. Execute Unit and Integration Tests

If the solution contains test projects, run them to validate that business logic and data access behavior remain correct after migration.

```bash
dotnet test --configuration Release
```

Review the test output for any failures. Pay close attention to tests that cover:

- Data access logic in `Bookstore.Data`
- Domain model behavior in `Bookstore.Domain`
- Controller and middleware behavior in `Bookstore.Web`

If no tests currently exist, consider adding basic integration tests using `Microsoft.AspNetCore.Mvc.Testing` to cover the most critical application paths.

---

## 8. Review `appsettings.json` and Configuration

Confirm that all configuration values previously stored in `Web.config` or `App.config` have been correctly moved to `appsettings.json` or `appsettings.{Environment}.json`.

Key areas to verify:

- Database connection strings
- Application-specific settings
- Logging configuration

Ensure that sensitive values such as connection strings or API keys are stored using the .NET Secret Manager for local development:

```bash
dotnet user-secrets init --project Bookstore.Web
dotnet user-secrets set "ConnectionStrings:Default" "your_connection_string"
```

---

## 9. Publish the Application

Once the application has been validated locally, publish it for deployment.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory to ensure all required files are present before deploying to the target environment.