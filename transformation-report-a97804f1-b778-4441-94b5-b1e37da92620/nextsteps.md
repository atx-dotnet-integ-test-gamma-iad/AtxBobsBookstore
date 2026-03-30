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

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported modern .NET version (e.g., `net8.0`).

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or `netstandard2.0`, update it to align with the rest of the solution.

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect `Bookstore.Data` and `Bookstore.Web` for any remaining Windows-specific APIs or packages, such as:

- `System.Web` references
- Windows Registry access
- `Microsoft.Web.*` packages intended for classic ASP.NET (not ASP.NET Core)

Replace or remove any such dependencies as needed.

---

## 5. Verify Database Connectivity (Bookstore.Data)

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- Connection strings in `appsettings.json` are correctly configured for the target environment.
- Run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run Unit and Integration Tests

If a test project exists in the solution, execute the tests to validate business logic and data access behavior.

```bash
dotnet test
```

Review test results for any failures that may indicate behavioral differences introduced during migration.

---

## 7. Run the Application Locally

Start the web application locally to perform manual validation.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify:

- Pages load correctly
- Data is retrieved and displayed as expected
- Forms and user interactions function properly
- No unhandled exceptions appear in the console output

---

## 8. Review Application Logs

Check the application logs during local execution for runtime warnings or errors that would not surface at build time, such as:

- Missing configuration values
- Middleware ordering issues
- Dependency injection registration errors

---

## 9. Publish the Application

Once local validation is complete, publish the application to prepare it for deployment.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present.

---

## 10. Validate on Target Platform

If the intended deployment environment is Linux or macOS, run the published output on that platform to confirm cross-platform compatibility before final deployment.

```bash
dotnet ./publish/Bookstore.Web.dll
```