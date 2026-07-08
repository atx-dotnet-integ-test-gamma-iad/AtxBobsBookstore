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

Perform a full solution build to confirm there are no errors or warnings that may have been missed:

```bash
dotnet build --configuration Release
```

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported modern .NET version (e.g., `net8.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure all three projects target the same framework version to avoid interoperability issues.

---

## 4. Check for Removed or Changed APIs

Review the code in each project for usage of APIs that were removed or significantly changed between .NET Framework and modern .NET. Common areas to check include:

- `System.Web` references (not available in modern .NET; should be replaced with ASP.NET Core equivalents)
- `HttpContext`, `HttpRequest`, and `HttpResponse` usage
- `ConfigurationManager` (replaced by `Microsoft.Extensions.Configuration`)
- `EntityFramework` (classic) vs `Microsoft.EntityFrameworkCore`
- `BinaryFormatter` (removed in .NET 9, deprecated in earlier versions)

---

## 5. Run Database Migrations (if applicable)

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Update Configuration Files

Confirm that `appsettings.json` exists in `Bookstore.Web` and contains the necessary configuration (connection strings, logging, etc.) that was previously in `Web.config` or `App.config`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information"
    }
  }
}
```

Remove any legacy `Web.config` or `App.config` files if they are no longer needed.

---

## 7. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and test core functionality such as:

- Browsing the bookstore catalog
- Searching for books
- Any authentication or user account features
- Data persistence (adding, editing, deleting records)

---

## 8. Execute Existing Tests

If the solution contains a test project, run all tests to confirm behavior has not regressed:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they reflect actual regressions or test code that also requires migration updates.

---

## 9. Review Middleware and Startup Configuration

In `Bookstore.Web`, review `Program.cs` (and `Startup.cs` if present) to ensure middleware is configured correctly for ASP.NET Core:

- Static files middleware (`UseStaticFiles`)
- Routing (`UseRouting`, `MapControllers`, or `MapRazorPages`)
- Authentication and authorization middleware order
- Exception handling middleware

---

## 10. Publish the Application

Once local validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` folder and confirm all required assets, views, and configuration files are present before deploying to the target environment.