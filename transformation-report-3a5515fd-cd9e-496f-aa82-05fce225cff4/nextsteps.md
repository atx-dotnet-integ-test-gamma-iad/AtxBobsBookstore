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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

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

Ensure the build completes with zero errors and review any warnings that may indicate deprecated APIs or compatibility concerns.

---

## 3. Run Unit and Integration Tests

If the solution contains test projects, execute them with the following command:

```bash
dotnet test --configuration Release --verbosity normal
```

Review the test output carefully. Any failing tests may indicate behavioral regressions introduced during the migration.

---

## 4. Verify Database Connectivity and Migrations

Since the solution includes a `Bookstore.Data` project, verify that any Entity Framework Core migrations are up to date and compatible with the new target framework.

Check the current migration state:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If migrations need to be applied to the database:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application locally to perform manual validation:

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Verify the following:
- The application starts without runtime exceptions.
- All pages and routes load correctly.
- Database read and write operations function as expected.
- Any authentication or authorization flows behave correctly.

---

## 6. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files (e.g., `appsettings.Development.json`) to confirm that:
- Connection strings are correct for the target environment.
- Any settings that were previously stored in `Web.config` have been properly migrated to the new configuration system.

---

## 7. Check for Removed or Changed APIs

Review the code for any use of APIs that were available in .NET Framework but have changed or been removed in cross-platform .NET. Common areas to check include:

- `System.Web` namespace usage (should be fully replaced by ASP.NET Core equivalents).
- `HttpContext` access patterns.
- Any use of Windows-specific APIs if cross-platform support is required.

The [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) can assist in identifying remaining compatibility concerns.

---

## 8. Publish the Application

Once local validation is complete, publish the application using:

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all required assets, static files, and configuration files are present before deploying to the target environment.