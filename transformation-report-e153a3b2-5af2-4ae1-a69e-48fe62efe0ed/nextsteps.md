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

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) compile without warnings or errors.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

If any project still references `net48` or another .NET Framework moniker, update it accordingly.

---

## 4. Check for Windows-Specific Dependencies

Inspect `Bookstore.Data` and `Bookstore.Web` for any packages or APIs that are Windows-only, such as:

- `System.Web` references
- Windows Registry access
- COM interop
- `Microsoft.Web.Infrastructure`

Replace or remove any such dependencies with cross-platform alternatives.

---

## 5. Review Entity Framework or Data Access Configuration

If `Bookstore.Data` uses Entity Framework, confirm the correct provider package is referenced for cross-platform .NET. For example:

- **EF Core with SQL Server:** `Microsoft.EntityFrameworkCore.SqlServer`
- **EF Core with SQLite:** `Microsoft.EntityFrameworkCore.Sqlite`

Also verify that any database connection strings in `appsettings.json` are correctly configured and that `Startup.cs` or `Program.cs` registers the DbContext properly using `AddDbContext`.

---

## 6. Validate Application Configuration

Confirm that configuration previously held in `Web.config` has been migrated to `appsettings.json`. Key areas to check include:

- Connection strings
- Application settings
- Authentication configuration

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "your-connection-string-here"
  }
}
```

---

## 7. Run the Application Locally

Start the web application locally to verify runtime behavior.

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the URL shown in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and exercise the main application flows, such as browsing, searching, and any data entry forms.

---

## 8. Run Existing Tests

If the solution contains a test project, execute the test suite to validate business logic and data access behavior.

```bash
dotnet test
```

Review any failing tests and determine whether failures are due to migration-related changes or pre-existing issues.

---

## 9. Verify Static Assets and Middleware

For `Bookstore.Web`, confirm the following in `Program.cs` or `Startup.cs`:

- `app.UseStaticFiles()` is present to serve CSS, JavaScript, and image files.
- Middleware ordering is correct (e.g., authentication before authorization).
- Routing is configured with `app.MapControllers()` or `app.MapRazorPages()` as appropriate.

---

## 10. Publish the Application

Once local validation is complete, publish the application to a self-contained or framework-dependent output folder.

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj \
  --configuration Release \
  --output ./publish
```

Review the contents of the `./publish` folder to confirm all required files are present before deploying to the target environment.