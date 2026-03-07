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

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are still referenced, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Validate the Data Layer (`Bookstore.Data`)

- If the project uses **Entity Framework**, confirm that the correct EF Core version is referenced rather than the legacy `EntityFramework` (EF6) package.
- Run any existing **database migrations** to verify they apply cleanly:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration and review the output schema for correctness:

```bash
dotnet ef migrations add InitialCreate --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 4. Validate the Domain Layer (`Bookstore.Domain`)

- Review domain models and ensure no types rely on assemblies or namespaces that were specific to .NET Framework (e.g., `System.Web`, `System.Runtime.Serialization` in its legacy form).
- Confirm that any serialization attributes or data annotations are sourced from `System.ComponentModel.DataAnnotations` and are compatible with .NET.

---

## 5. Validate the Web Layer (`Bookstore.Web`)

- Confirm the project is using **ASP.NET Core** and not legacy `System.Web`-based ASP.NET.
- Check `Program.cs` and any `Startup.cs` to ensure middleware, dependency injection, and routing are configured correctly for ASP.NET Core.
- Verify that configuration is being read through `IConfiguration` (e.g., `appsettings.json`) rather than `System.Configuration.ConfigurationManager`. If `ConfigurationManager` is still in use, migrate those settings to `appsettings.json`.
- Check that authentication and authorization middleware, if present, uses the ASP.NET Core equivalents.

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and exercise the primary workflows (e.g., browsing books, adding to cart, checkout if applicable).
- Review the console output and application logs for any runtime exceptions or warnings.

---

## 7. Run Existing Tests

If the solution contains a test project, execute the test suite to confirm existing behavior is preserved.

```bash
dotnet test
```

- Review any failing tests and determine whether the failures are due to migration issues or pre-existing problems.
- Pay particular attention to tests that interact with the database or HTTP layer, as these are most likely to surface compatibility issues post-migration.

---

## 8. Review `appsettings.json` and Environment Configuration

- Confirm that connection strings, API keys, and other environment-specific values have been moved from `Web.config` to `appsettings.json` or environment variables.
- Ensure sensitive values are not committed to source control. Consider using the **Secret Manager** tool for local development:

```bash
dotnet user-secrets init --project Bookstore.Web
dotnet user-secrets set "ConnectionStrings:Default" "your_connection_string"
```

---

## 9. Publish the Application

Once local validation is complete, publish the application to verify the output is correct.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required assets, static files, and configuration files are present before deploying to the target environment.