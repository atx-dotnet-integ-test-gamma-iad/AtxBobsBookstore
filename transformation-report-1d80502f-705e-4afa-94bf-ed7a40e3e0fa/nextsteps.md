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

Review the output for any warnings about deprecated or incompatible packages. If any packages are flagged, check for updated versions on [NuGet.org](https://www.nuget.org) and update the `.csproj` references accordingly.

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay particular attention to any warnings about obsolete APIs or target framework compatibility, as these can indicate areas that may cause runtime issues.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET, such as `net8.0`.

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project is still targeting `net48` or `netcoreapp3.1`, update it to a current supported version.

---

## 4. Verify Configuration Files

Check that `appsettings.json` (and `appsettings.Development.json`) in `Bookstore.Web` contains all required configuration entries, including:

- Database connection strings
- Any application-specific settings that were previously in `Web.config` or `App.config`

Legacy `Web.config` and `App.config` files are not used in cross-platform .NET. Confirm that all relevant settings have been migrated to the `appsettings.json` structure.

---

## 5. Verify Database Connectivity

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The correct EF Core provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Microsoft.EntityFrameworkCore.Sqlite`).
- The `DbContext` is registered correctly in the dependency injection container within `Bookstore.Web`'s `Program.cs` or `Startup.cs`.
- Run any pending migrations to ensure the database schema is up to date:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application locally to verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

Navigate to the URL shown in the console output (typically `https://localhost:5001` or `http://localhost:5000`) and exercise the core functionality of the application, including:

- Browsing and searching for books
- Any authentication or user account features
- Data read and write operations

---

## 7. Check for Platform-Specific Code

Search the solution for any APIs or libraries that were Windows-specific in the original .NET Framework project. Common areas to check include:

- Use of `System.Web` (not available in cross-platform .NET)
- Windows Registry access (`Microsoft.Win32.Registry`)
- Windows-only file path assumptions
- COM interop or P/Invoke calls targeting Windows DLLs

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify remaining platform-specific dependencies if needed.

---

## 8. Execute Unit and Integration Tests

If the solution contains test projects, run them to validate that existing behavior has been preserved after the migration.

```bash
dotnet test
```

Review any failing tests carefully, as failures may indicate behavioral differences between .NET Framework and cross-platform .NET rather than pre-existing bugs.

---

## 9. Publish the Application

Once the application has been validated locally, publish it to prepare for deployment.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required files are present, including static assets and configuration files.