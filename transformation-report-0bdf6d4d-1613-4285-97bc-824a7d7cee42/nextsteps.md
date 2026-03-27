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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas that may cause runtime issues.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported and consistent version of .NET across all projects, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Mixing framework versions between projects in the same solution can cause subtle runtime or compatibility issues.

---

## 4. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that existed in .NET Framework but have changed or been removed in modern .NET. Common areas to check include:

- `System.Web` references (not available in modern .NET; replaced by `Microsoft.AspNetCore`)
- `ConfigurationManager` (replaced by `Microsoft.Extensions.Configuration`)
- `HttpContext` and related types (behavior differs in ASP.NET Core)
- Entity Framework 6 vs. Entity Framework Core differences if `Bookstore.Data` uses EF

---

## 5. Run Unit Tests

If the solution contains a test project, run all tests to validate that the business logic in `Bookstore.Domain` and data access in `Bookstore.Data` behave as expected:

```bash
dotnet test --configuration Release
```

If no test project currently exists, consider adding one targeting `Bookstore.Domain` at minimum to verify core logic.

---

## 6. Run the Web Application Locally

Start the `Bookstore.Web` project locally and manually verify key functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Validate the following areas manually:

- Application startup without exceptions
- Database connectivity from `Bookstore.Data`
- Core user-facing pages and features load correctly
- Any authentication or authorization flows behave as expected

---

## 7. Review Configuration Files

Ensure that `appsettings.json` (and `appsettings.Production.json` if applicable) contain the correct configuration values, including:

- Database connection strings
- Any API keys or external service endpoints
- Logging configuration

If the original project used `Web.config`, confirm that all relevant settings have been migrated to `appsettings.json`.

---

## 8. Validate Database Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to a test database before deploying to production:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

---

## 9. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files, static assets, and configuration files are present before deploying to the target environment.