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

Review the output for any warnings related to package version conflicts or deprecated packages. If any packages still reference old .NET Framework-specific versions, update them to their cross-platform equivalents using:

```bash
dotnet add <project> package <PackageName>
```

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly:
- Nullable reference type warnings
- Obsolete API usage
- Platform compatibility warnings (e.g., `CA1416`)

---

## 3. Verify Configuration Files

Check that `appsettings.json` (and environment-specific variants such as `appsettings.Development.json`) are present in `Bookstore.Web` and contain the correct configuration values, including:

- Database connection strings
- Any API keys or service endpoints previously stored in `Web.config`

If the project previously used `Web.config` or `App.config`, confirm that all relevant settings have been migrated to the appropriate `appsettings.json` file or environment variables.

---

## 4. Verify the Data Layer

Since `Bookstore.Data` handles data access, confirm the following:

- The correct database provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or another provider).
- Any existing migrations are present and up to date.
- Run the following command to apply migrations against your target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialCreate --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application URL shown in the console output.
- Walk through the core user flows (e.g., browsing books, adding to cart, placing an order) to confirm expected behavior.
- Check the console and any log output for unhandled exceptions or warnings.

---

## 6. Run Existing Tests

If the solution contains a test project, execute the test suite to validate business logic and data access behavior.

```bash
dotnet test
```

Review the results for any failing tests. Failures may indicate runtime behavioral differences between the legacy .NET Framework version and the new cross-platform .NET version, such as:

- Changes in `System.Text.Json` vs `Newtonsoft.Json` behavior
- Differences in culture/locale handling
- Changes in Entity Framework Core query translation

---

## 7. Review Static Assets and Middleware

For `Bookstore.Web`, confirm the following:

- Static files (CSS, JavaScript, images) are served correctly. Ensure `app.UseStaticFiles()` is present in `Program.cs` or `Startup.cs`.
- Any custom HTTP modules or handlers from the legacy project have been replaced with the equivalent ASP.NET Core middleware.
- Authentication and authorization configuration has been correctly migrated to the ASP.NET Core pipeline.

---

## 8. Validate Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element targets the intended cross-platform .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure no project still references `net48` or any other .NET Framework moniker unless intentionally targeting multiple frameworks.

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including:
- The compiled assemblies
- `appsettings.json`
- Static web assets (`wwwroot`)

Deploy the contents of the publish output to your target hosting environment (e.g., IIS, Azure App Service, or a Linux server with the ASP.NET Core runtime installed).