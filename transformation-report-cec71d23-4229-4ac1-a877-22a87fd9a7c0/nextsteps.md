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

Verify that all three projects build without warnings or errors. Pay attention to any nullable reference warnings or obsolete API usage that may have been introduced during transformation.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to your intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects. Mismatched target frameworks can cause runtime issues even when the build succeeds.

---

## 4. Check for Windows-Specific Dependencies

Search the codebase for any APIs or packages that are Windows-only, such as:

- `Microsoft.Win32` registry access
- `System.Windows.Forms`
- `System.Drawing` (without the `System.Drawing.Common` cross-platform package)
- Any COM interop usage

If found, these will need to be replaced with cross-platform alternatives or conditionally compiled using runtime checks:

```csharp
if (OperatingSystem.IsWindows())
{
    // Windows-specific logic
}
```

---

## 5. Validate Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework Core, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql.EntityFrameworkCore.PostgreSQL`).
- Connection strings in `appsettings.json` are correct for the target environment.
- Run any pending migrations to ensure the schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute all tests to validate business logic and data access behavior:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether failures are due to the migration or pre-existing issues.

---

## 7. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Manually verify the following:

- Application starts without exceptions.
- Pages and routes load correctly.
- Database read and write operations function as expected.
- Authentication and authorization flows work if applicable.

---

## 8. Review Middleware and Configuration

In `Bookstore.Web`, review `Program.cs` (or `Startup.cs` if still present) to confirm:

- Middleware is registered in the correct order.
- Services are registered in the dependency injection container.
- Configuration sources such as `appsettings.json` and environment variables are wired up correctly.

If the project previously used `Startup.cs`, consider consolidating into the minimal hosting model in `Program.cs` if it has not already been done.

---

## 9. Verify Static Files and Bundling

Confirm that static assets such as CSS, JavaScript, and images are served correctly. If the project previously used `System.Web.Optimization` for bundling, ensure it has been replaced with a supported alternative such as `BundleMinifier` or a front-end build tool.

---

## 10. Publish the Application

Once all validation steps pass, publish the application for deployment:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present before deploying to the target environment.