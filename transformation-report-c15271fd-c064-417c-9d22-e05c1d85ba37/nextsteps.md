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

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). For example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects are targeting the same framework version to avoid inter-project compatibility issues.

---

## 4. Check for Removed or Changed APIs

Even without build errors, some APIs available in .NET Framework may behave differently or have been replaced in cross-platform .NET. Review the following areas:

- **`Bookstore.Data`**: If Entity Framework is used, confirm it has been migrated from EF 6 to EF Core. Verify that database provider packages (e.g., `Microsoft.EntityFrameworkCore.SqlServer`) are referenced and that any existing migrations are still valid.
- **`Bookstore.Web`**: If this was previously an ASP.NET MVC or Web Forms project, confirm it has been migrated to ASP.NET Core. Web Forms is not supported in cross-platform .NET and would require a rewrite of affected pages.
- **`Bookstore.Domain`**: Check for any usage of `System.Configuration.ConfigurationManager`, which is not available by default in cross-platform .NET and requires the `System.Configuration.ConfigurationManager` NuGet package.

---

## 5. Run Unit Tests

If the solution contains a test project, run all tests to verify that business logic and data access behavior remain correct after migration.

```bash
dotnet test
```

If no test project exists, consider writing basic tests for critical paths in `Bookstore.Domain` and `Bookstore.Data` before proceeding.

---

## 6. Validate Database Connectivity

If `Bookstore.Data` uses a database, verify the connection string in `appsettings.json` (replacing any legacy `Web.config` or `App.config` connection strings) and confirm the application can connect to the database at runtime.

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=your_server;Database=your_db;Trusted_Connection=True;"
  }
}
```

If EF Core migrations are used, apply them to confirm the schema is consistent:

```bash
dotnet ef database update
```

---

## 7. Run the Application Locally

Start the web application locally and navigate through key functionality to confirm runtime behavior is correct.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Test the following areas manually:

- Application startup and home page load
- Any database-driven pages (e.g., book listings, search)
- Form submissions and data writes
- Authentication and authorization, if applicable

---

## 8. Review Middleware and Configuration

In ASP.NET Core, application configuration and middleware are handled differently than in legacy ASP.NET. Confirm the following in `Program.cs` or `Startup.cs`:

- Middleware is registered in the correct order (e.g., `UseAuthentication` before `UseAuthorization`)
- Static files, routing, and error handling middleware are configured
- Environment-specific configuration (e.g., `appsettings.Development.json`) is present and correct

---

## 9. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all necessary files are present, including `appsettings.json` and static assets.