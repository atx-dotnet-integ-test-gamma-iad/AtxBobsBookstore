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

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

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

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without errors or warnings.

---

## 3. Run Unit Tests

If the solution contains test projects, execute them to confirm that existing logic behaves as expected after migration:

```bash
dotnet test
```

Review the test results for any failures that may indicate behavioral regressions introduced during the transformation.

---

## 4. Verify Database Connectivity and Migrations

Since the solution includes a `Bookstore.Data` project, verify that any Entity Framework Core migrations are up to date and compatible with the new target framework.

Check the current migration state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or outdated, create a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

Apply pending migrations to the database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to confirm it runs as expected:

```bash
dotnet run --project Bookstore.Web
```

Navigate to the URL indicated in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and manually verify the following:

- Pages load without errors
- Data is read from and written to the database correctly
- Any authentication or authorization flows function as expected

---

## 6. Review Configuration Files

Inspect `appsettings.json` and `appsettings.Development.json` in `Bookstore.Web` to confirm the following:

- Connection strings are correct for the target environment
- Any configuration keys that previously existed in `Web.config` have been properly migrated to the new JSON-based configuration system
- Logging settings are appropriate

---

## 7. Check for Removed or Changed APIs

Review any usages of APIs that may have been removed or altered in the target version of .NET. Pay particular attention to:

- `System.Web` references, which are not available in cross-platform .NET
- Any HTTP module or HTTP handler patterns that need to be replaced with ASP.NET Core middleware
- `HttpContext` usage patterns that differ between .NET Framework and .NET Core

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) if further static analysis is needed.

---

## 8. Publish the Application

Once validation is complete, publish the application to a target directory:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm the output is complete before deploying to the target environment.