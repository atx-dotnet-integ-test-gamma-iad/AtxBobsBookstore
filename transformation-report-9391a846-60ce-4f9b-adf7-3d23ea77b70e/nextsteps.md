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

Address any warnings that surface, particularly those related to nullable reference types or obsolete APIs, as these may indicate areas that require attention even if they do not block the build.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported and intended version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects. A mismatch in target frameworks between `Bookstore.Domain`, `Bookstore.Data`, and `Bookstore.Web` can cause runtime issues even when the build succeeds.

---

## 4. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that existed in .NET Framework but have changed or been removed in cross-platform .NET. Common areas to check include:

- `System.Web` references, which are not available in cross-platform .NET
- `HttpContext` and related types, which now reside in `Microsoft.AspNetCore.Http`
- `ConfigurationManager`, which should be replaced with `Microsoft.Extensions.Configuration`
- Any Windows-specific APIs such as the registry or certain I/O operations

---

## 5. Database and Entity Framework Validation

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The EF provider package targets the correct version (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or another provider)
- Any existing migrations are compatible with the new EF Core version
- Run the following to verify the database context can be resolved:

```bash
dotnet ef dbcontext info --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations need to be updated, run:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit Tests

If the solution contains test projects, execute them to validate that business logic in `Bookstore.Domain` and data access in `Bookstore.Data` behave as expected:

```bash
dotnet test
```

Review any failing tests and determine whether the failures are due to migration-related changes or pre-existing issues.

---

## 7. Run the Web Application Locally

Start the web application and verify that it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and test core functionality such as browsing, searching, and any data entry workflows. Check the console output and application logs for exceptions or warnings.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` contains all necessary configuration values that were previously stored in `Web.config` or `App.config`. Key items to verify include:

- Connection strings
- Application-specific settings
- Logging configuration

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and dependencies are present before deploying to the target environment.