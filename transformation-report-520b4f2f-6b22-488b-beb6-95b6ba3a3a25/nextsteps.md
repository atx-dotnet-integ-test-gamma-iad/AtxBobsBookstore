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

Run a NuGet package restore to ensure all dependencies are resolved correctly before proceeding:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents from NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

For the web project, confirm it uses:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Avoid `net48` or any other .NET Framework moniker, as these are Windows-only.

---

## 4. Check for Windows-Specific APIs

Run the .NET Compatibility Analyzer or review the code manually for any APIs that are Windows-specific. Common areas to check in a Bookstore application include:

- `System.Web` references (should be replaced with `Microsoft.AspNetCore`)
- `ConfigurationManager` (replace with `Microsoft.Extensions.Configuration`)
- Windows Registry access
- `HttpContext.Current` (replace with injected `IHttpContextAccessor`)

---

## 5. Database and Data Layer Validation

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The project references `Microsoft.EntityFrameworkCore` and the appropriate database provider (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Any existing migrations are still valid by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply migrations to a test database to verify schema integrity:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release --verbosity normal
```

Review test results for any failures that may indicate behavioral differences between the old and new framework versions.

---

## 7. Run the Application Locally

Start the web application locally and verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Manually test key application flows such as:

- Browsing and searching for books
- User authentication and authorization (if applicable)
- Adding, editing, and deleting records
- Any external service integrations (payment, email, etc.)

---

## 8. Review `appsettings.json` Configuration

Confirm that all configuration previously stored in `Web.config` or `App.config` has been correctly migrated to `appsettings.json` in `Bookstore.Web`. Pay particular attention to:

- Database connection strings
- Application-specific settings
- Logging configuration

---

## 9. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the output directory contains all required files before deploying to the target environment.