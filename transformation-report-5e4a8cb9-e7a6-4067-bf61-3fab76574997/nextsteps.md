# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution (`Bookstore.Data`, `Bookstore.Web`, and `Bookstore.Domain`). The steps below outline how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no issues beyond what was captured in the initial error report:

```bash
dotnet build --configuration Release
```

Address any warnings that surface, particularly those related to nullable reference types or obsolete APIs, as these can indicate latent compatibility issues.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

---

## 4. Check for Windows-Specific Dependencies

Even without build errors, runtime failures can occur if the code relies on Windows-specific APIs. Review the following areas:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Communication Foundation (WCF)** server-side components
- **System.Drawing** (GDI+) — replace with a cross-platform alternative such as `SkiaSharp` or `ImageSharp` if used
- **Web.config** — confirm that configuration has been migrated to `appsettings.json` and that `System.Configuration.ConfigurationManager` usage has been replaced where applicable

---

## 5. Run Existing Tests

If the solution contains a test project, execute the tests to validate core functionality:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as they may indicate behavioral differences between .NET Framework and modern .NET (e.g., changes in `HttpContext`, serialization defaults, or globalization behavior).

---

## 6. Validate the Data Layer (`Bookstore.Data`)

- Confirm that the Entity Framework version in use is EF Core and not EF 6 targeting .NET Framework.
- Run any pending migrations against a development database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- Verify connection strings in `appsettings.json` are correct and that the database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) is referenced.

---

## 7. Run the Web Application Locally

Start the application and navigate through its primary workflows to confirm runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the following:
- Application starts without exceptions
- Database connectivity is functional
- All major routes and pages render correctly
- Authentication and authorization behave as expected, if applicable

---

## 8. Review Middleware and Startup Configuration

In ASP.NET Core, the application startup pipeline differs significantly from ASP.NET on .NET Framework. Confirm the following in `Program.cs` or `Startup.cs`:

- Middleware is registered in the correct order (e.g., `UseAuthentication` before `UseAuthorization`)
- Static files are served correctly via `UseStaticFiles`
- Any custom HTTP modules or handlers from the legacy project have been converted to middleware

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is self-contained and correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the `./publish` directory to ensure all necessary files are present before deploying to the target environment.