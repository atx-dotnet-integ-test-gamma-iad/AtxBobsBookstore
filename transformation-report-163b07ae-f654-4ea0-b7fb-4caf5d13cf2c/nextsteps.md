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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Do this for all three projects:
- `Bookstore.Domain.csproj`
- `Bookstore.Data.csproj`
- `Bookstore.Web.csproj`

---

## 4. Review Configuration Files

- Confirm that `appsettings.json` (and `appsettings.Development.json`) exist in `Bookstore.Web` and contain the correct configuration, including database connection strings.
- If the original project used `Web.config` or `App.config`, verify that all relevant settings have been migrated to `appsettings.json` or the appropriate .NET configuration provider.

---

## 5. Validate the Data Layer

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer`).
- Run any pending migrations or verify the database schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests to verify that existing functionality behaves as expected after migration:

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to migration-related changes or pre-existing issues.

---

## 7. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the application in a browser and verify that core pages load correctly.
- Test primary user flows such as browsing, searching, and any data entry forms.
- Check the console and application logs for runtime exceptions or warnings.

---

## 8. Check for Platform-Specific Code

Search the codebase for any APIs or libraries that were Windows-specific in the original .NET Framework project. Common areas to check include:

- `System.Web` references (should be replaced with ASP.NET Core equivalents)
- Windows Registry access
- COM interop
- `HttpContext.Current` usage (replace with injected `IHttpContextAccessor`)

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to assist with this if needed.

---

## 9. Review Middleware and Startup Configuration

In `Bookstore.Web`, confirm that `Program.cs` (or `Startup.cs` if still present) correctly configures:

- Routing
- Authentication and authorization (if applicable)
- Static file serving
- Database context registration via dependency injection

---

## 10. Publish the Application

Once local validation is complete, publish the application to verify the output is correct:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.