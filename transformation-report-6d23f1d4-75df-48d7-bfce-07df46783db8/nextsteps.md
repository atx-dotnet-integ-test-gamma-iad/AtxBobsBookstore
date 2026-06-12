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

The steps below describe how to validate, test, and deploy the migrated solution.

---

## 1. Restore Dependencies

Run a NuGet package restore to ensure all dependencies are resolved correctly before building:

```bash
dotnet restore
```

Review the output for any warnings about deprecated or unlisted packages. If any packages are flagged, consider updating them to versions that target `net6.0` or later using:

```bash
dotnet list package --outdated
dotnet add <project> package <PackageName>
```

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs, as these may indicate areas that need attention.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the traditional sense. Verify the following:

- `appsettings.json` exists in `Bookstore.Web` and contains the correct connection strings and application settings that were previously in `Web.config`.
- Environment-specific overrides such as `appsettings.Development.json` are present if needed.
- Any configuration previously handled by `System.Configuration.ConfigurationManager` has been migrated to `Microsoft.Extensions.Configuration`.

---

## 4. Verify the Data Layer

In `Bookstore.Data`, confirm the following:

- The Entity Framework version being used is EF Core, not EF 6. Check the `.csproj` for a reference to `Microsoft.EntityFrameworkCore` rather than `EntityFramework`.
- The `DbContext` class uses EF Core conventions.
- Run any pending migrations or verify the database schema is up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the web application and verify it runs without runtime errors:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the core functionality, including:

- Browsing and searching for books
- Any authentication or authorization flows
- Data reads and writes through the `Bookstore.Data` layer

Check the console output and application logs for any runtime exceptions.

---

## 6. Execute Unit and Integration Tests

If the solution contains test projects, run them to validate business logic and data access behavior:

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no tests currently exist, consider writing tests that cover the core domain logic in `Bookstore.Domain` and the data access methods in `Bookstore.Data` before deploying to a production environment.

---

## 7. Check for Platform-Specific Code

Since this was a legacy project, scan the codebase for any remaining Windows-specific APIs that may cause issues on Linux or macOS:

- `System.Drawing` (replace with a cross-platform alternative such as `SkiaSharp` if used)
- `Microsoft.Win32` registry access
- Windows file path separators hardcoded as `\` (use `Path.Combine` instead)
- Any P/Invoke calls to Windows DLLs

---

## 8. Validate the Published Output

Publish the application and verify the output is complete:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all necessary files, static assets, and configuration files are present.