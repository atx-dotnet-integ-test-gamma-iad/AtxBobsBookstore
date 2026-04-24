# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Overview

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

The following steps outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

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

Verify that all three projects build without warnings or errors. Address any warnings that may indicate compatibility concerns with the target framework.

---

## 3. Review Configuration Files

- Check `appsettings.json` in `Bookstore.Web` to ensure connection strings, logging settings, and any environment-specific values are correctly configured for the new runtime.
- If the legacy project used `Web.config` or `App.config`, confirm that all relevant settings have been migrated to `appsettings.json` or `appsettings.{Environment}.json`.
- Verify that any configuration sections previously handled by `System.Configuration.ConfigurationManager` have been replaced with the `Microsoft.Extensions.Configuration` equivalents.

---

## 4. Database and Data Layer Validation

- If `Bookstore.Data` uses Entity Framework, confirm the version has been updated to Entity Framework Core and that the `DbContext` configuration is compatible.
- Run any existing migrations or create a new initial migration to verify the model is consistent with the database schema:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is referenced and configured correctly in the startup project.

---

## 5. Run Existing Tests

If the solution contains a test project, execute the test suite to validate that existing functionality behaves as expected:

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to behavioral changes introduced by the migration or pre-existing issues.

---

## 6. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web
```

- Navigate through the application and verify that core functionality such as browsing, searching, and managing books operates correctly.
- Check the console output and application logs for any runtime exceptions or warnings.
- Confirm that middleware, routing, and authentication (if applicable) are functioning as expected under ASP.NET Core.

---

## 7. Check for Removed or Changed APIs

Review the code in all three projects for usage of APIs that were available in .NET Framework but have changed or been removed in cross-platform .NET:

- `System.Web` references should no longer be present.
- `HttpContext`, `HttpRequest`, and `HttpResponse` usage should align with the ASP.NET Core equivalents.
- Any use of `System.Drawing` should be replaced with a supported alternative such as `SkiaSharp` or `ImageSharp` if running on non-Windows platforms.
- Verify that any reflection-based or platform-specific code has been reviewed for cross-platform compatibility.

---

## 8. Validate Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting the same framework version to avoid inter-project compatibility issues.

---

## 9. Publishing the Application

Once validation is complete, publish the application using the following command:

```bash
dotnet publish Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.