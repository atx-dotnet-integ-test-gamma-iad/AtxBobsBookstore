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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `netstandard` or older `net4x` target frameworks exclusively, consider finding updated equivalents that support the current .NET target.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly:
- Nullable reference type warnings, which may indicate areas where null safety was not enforced in the legacy code.
- Obsolete API usage warnings, which may point to APIs that have been removed or changed in modern .NET.

---

## 3. Review Configuration Files

Legacy ASP.NET projects relied on `Web.config` and `App.config`. These are replaced by `appsettings.json` in modern .NET. Verify the following:

- Connection strings previously in `Web.config` have been moved to `appsettings.json` under `Bookstore.Web`.
- Any environment-specific settings are represented using `appsettings.Development.json` or `appsettings.Production.json` as appropriate.
- The `Startup.cs` or `Program.cs` file correctly reads configuration via `IConfiguration`.

---

## 4. Verify Entity Framework or Data Access Layer

Within `Bookstore.Data`, confirm the following:

- If Entity Framework is used, verify the version. Legacy projects may have used EF 6, whereas modern .NET projects should use EF Core.
- Run any pending migrations or verify the database schema is compatible:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is referenced and up to date.

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web --configuration Development
```

- Navigate to the application in a browser and exercise the primary workflows (browsing books, data retrieval, etc.).
- Check the console output and application logs for any runtime exceptions.
- Verify that middleware (authentication, routing, static files, etc.) is functioning as expected.

---

## 6. Execute Unit and Integration Tests

If a test project exists in the solution, run the test suite to validate business logic and data access behavior.

```bash
dotnet test
```

- Review any failing tests and determine whether failures are due to behavioral changes in the migrated code or test setup issues specific to the new runtime.
- Pay particular attention to tests covering `Bookstore.Domain` logic, as domain models are typically the most portable but can be affected by changes in serialization or type behavior.

---

## 7. Validate Static Assets and Razor Views

For `Bookstore.Web`, confirm the following:

- Razor views (`.cshtml`) render correctly. Legacy `System.Web.Mvc` helpers may have been replaced with Tag Helpers in ASP.NET Core.
- Static files (CSS, JavaScript, images) are served correctly from the `wwwroot` folder.
- Bundling and minification, if previously handled by `BundleConfig.cs`, has been replaced with an appropriate alternative such as LibMan or a build tool.

---

## 8. Publish the Application

Once the application has been validated locally, publish it for deployment.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

- Review the contents of the `./publish` folder to confirm all required files are present.
- Verify the target runtime identifier is appropriate for the deployment environment (e.g., `--runtime win-x64` or `--runtime linux-x64`) if a self-contained deployment is required.