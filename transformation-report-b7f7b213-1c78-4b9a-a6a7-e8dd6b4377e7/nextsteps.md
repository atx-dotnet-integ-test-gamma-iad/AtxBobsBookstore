# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution (`Bookstore.Data`, `Bookstore.Web`, and `Bookstore.Domain`). The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no issues beyond what was reported:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types or obsolete APIs, as these can indicate areas of the code that may behave differently under modern .NET.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to an appropriate and supported version of .NET (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target a consistent framework version to avoid interoperability issues.

---

## 4. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that were available in .NET Framework but have been removed or altered in cross-platform .NET. Common areas to check include:

- `System.Web` references (not available in .NET Core/.NET 5+)
- `ConfigurationManager` usage (requires the `System.Configuration.ConfigurationManager` NuGet package)
- Windows-specific APIs such as the registry or certain WCF bindings
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

---

## 5. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, confirm the correct version is referenced:

- For EF Core, ensure the appropriate provider package is installed (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Run any pending migrations or verify the database schema is compatible:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit Tests

If the solution contains a test project, execute the tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release
```

If no tests currently exist, consider writing tests for the core logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before deploying.

---

## 7. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Manually test the primary user-facing workflows, such as browsing, searching, and any checkout or account functionality, to confirm the application behaves as expected after migration.

---

## 8. Review Configuration Files

Ensure that `appsettings.json` (and `appsettings.Production.json` if applicable) contains all necessary configuration values that were previously held in `Web.config` or `App.config`. Key areas include:

- Connection strings
- Logging configuration
- Application-specific settings

---

## 9. Publish the Application

Once local validation is complete, publish the application using:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.