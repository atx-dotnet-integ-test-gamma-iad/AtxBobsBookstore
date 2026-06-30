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

The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before attempting to build or run the solution.

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or `netcoreapp3.1`, update it accordingly and re-run the restore and build steps.

---

## 4. Check for Removed or Changed APIs

Some APIs available in .NET Framework are not present or have changed in cross-platform .NET. Review the following areas manually:

- **`System.Web` dependencies**: These are not available in .NET. If any remain, they need to be replaced with ASP.NET Core equivalents.
- **`HttpContext`**: Ensure usage is through `IHttpContextAccessor` where appropriate.
- **Configuration**: Confirm that `Web.config` has been replaced with `appsettings.json` and that `IConfiguration` is used throughout.
- **Entity Framework**: If the project uses Entity Framework, confirm it has been migrated to Entity Framework Core and that migrations are intact.

---

## 5. Run Unit Tests

If the solution contains a test project, execute the tests to validate core logic.

```bash
dotnet test
```

Review test results for any failures that may indicate behavioral differences introduced by the migration.

---

## 6. Run the Application Locally

Start the web application locally to verify runtime behavior.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Manually test the following areas:

- Application startup and home page load
- Database connectivity (if applicable)
- Core user-facing features such as browsing, searching, and any checkout or account functionality
- Error pages and logging output

---

## 7. Validate Database Connectivity and Migrations

If the project uses Entity Framework Core, confirm the database schema is up to date.

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Verify that the connection string in `appsettings.json` points to the correct database instance.

---

## 8. Review Middleware and Startup Configuration

In ASP.NET Core, application configuration is handled in `Program.cs` (and optionally `Startup.cs` in older templates). Confirm the following are properly configured:

- Authentication and authorization middleware
- Static file serving
- Routing
- Any custom middleware that was previously in `Global.asax` or HTTP modules

---

## 9. Deploy to Target Environment

Once local validation is complete, publish the application for deployment.

```bash
dotnet publish --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to the target server or hosting environment. Ensure the target environment has the correct .NET runtime installed.

```bash
dotnet --list-runtimes
```

The runtime version should match or be compatible with the `TargetFramework` specified in the project file.