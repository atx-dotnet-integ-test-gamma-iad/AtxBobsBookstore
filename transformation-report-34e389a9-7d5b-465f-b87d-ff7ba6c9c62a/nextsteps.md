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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents via NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay particular attention to any warnings about obsolete APIs, as these may indicate areas that need further modernization.

---

## 3. Validate the Data Layer (`Bookstore.Data`)

- Confirm that your database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent) is compatible with the target .NET version.
- If the project uses Entity Framework, run the following to verify migrations are intact:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations are missing or outdated, create a new migration to reflect the current model state:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 4. Validate the Domain Layer (`Bookstore.Domain`)

- Review all domain models and ensure no types are relying on assemblies or namespaces that were specific to .NET Framework (e.g., `System.Web`, `System.Runtime.Serialization` from older targets).
- Run any existing unit tests targeting domain logic:

```bash
dotnet test
```

---

## 5. Validate the Web Layer (`Bookstore.Web`)

- Check `Program.cs` and `Startup.cs` (if present) to confirm the middleware pipeline and service registrations are consistent with ASP.NET Core conventions.
- Verify that configuration is being read correctly. Legacy `Web.config` settings should have been migrated to `appsettings.json`. Confirm the following file exists and contains the expected values:

```
Bookstore.Web/appsettings.json
```

- Confirm that authentication, authorization, and any session/cookie middleware are properly configured for ASP.NET Core.
- Run the web application locally:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the application in a browser and exercise the primary workflows (browsing, searching, and any account-related features) to confirm expected behavior.

---

## 6. Review Static Files and Bundling

- Ensure static files (CSS, JavaScript, images) are located under `wwwroot` in the `Bookstore.Web` project.
- If the legacy project used `BundleConfig.cs` or `System.Web.Optimization`, verify that bundling and minification has been replaced with a supported alternative such as `WebOptimizer` or a front-end build tool.

---

## 7. Run the Full Test Suite

If the solution contains test projects, execute all tests to confirm functional correctness after migration:

```bash
dotnet test --configuration Release --logger trx
```

Review the `.trx` output files for any failures and address them before proceeding.

---

## 8. Publish the Application

Once validation is complete, publish the application to a target folder:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` folder to confirm all required assemblies, static files, and configuration files are present before deploying to the target environment.