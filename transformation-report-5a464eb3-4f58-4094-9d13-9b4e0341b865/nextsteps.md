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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to deprecated or incompatible package versions. If any packages targeting the old .NET Framework are still present, replace them with their .NET-compatible equivalents via NuGet.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Project Target Frameworks

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure none of the projects still reference `net48` or any other .NET Framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Inspect `Bookstore.Data` and `Bookstore.Web` for any dependencies that are Windows-only, such as:

- `System.Web` references
- Windows Registry access
- COM interop
- MSMQ or WCF components

These will not function on non-Windows platforms and will need to be replaced with cross-platform alternatives.

---

## 5. Review Entity Framework or Data Access Configuration

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The project references `Microsoft.EntityFrameworkCore` rather than `System.Data.Entity` (EF6).
- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is present and up to date.
- Any existing migrations are compatible with the new EF Core version by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or broken, consider regenerating them:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Review `Bookstore.Web` Startup Configuration

If the project was migrated from ASP.NET MVC (System.Web) to ASP.NET Core, verify the following in `Bookstore.Web`:

- `Program.cs` uses the minimal hosting model or `WebApplication.CreateBuilder`.
- Middleware is registered correctly (e.g., `UseRouting`, `UseAuthorization`, `UseStaticFiles`).
- Any `Web.config` settings have been migrated to `appsettings.json`.
- Authentication and authorization configurations have been updated to use ASP.NET Core's built-in middleware.

---

## 7. Run Unit Tests

If the solution contains a test project, execute the tests to validate core functionality:

```bash
dotnet test --configuration Release
```

If no tests exist, consider writing basic integration or unit tests for the domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding to deployment.

---

## 8. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Verify the following:
- The application starts without runtime exceptions.
- Database connectivity is functional.
- Core application routes and pages load correctly.
- Any static assets (CSS, JS, images) are served properly.

---

## 9. Publish the Application

Once local validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` folder to confirm all required files are present before deploying to the target environment.