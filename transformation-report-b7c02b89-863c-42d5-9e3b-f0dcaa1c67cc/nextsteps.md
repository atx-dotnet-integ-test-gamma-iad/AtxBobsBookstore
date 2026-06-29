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

Review the output for any warnings about deprecated or incompatible packages. If any packages reference `netstandard` or older `net4x` target frameworks, consider updating them to versions that explicitly support the target framework you are using (e.g., `net6.0`, `net7.0`, or `net8.0`).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Verify that all three projects (`Bookstore.Domain`, `Bookstore.Data`, `Bookstore.Web`) build without errors or warnings that could indicate runtime issues.

---

## 3. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` in the same way as .NET Framework. Confirm the following:

- `appsettings.json` exists in `Bookstore.Web` and contains the necessary configuration (connection strings, logging settings, etc.).
- Any environment-specific configuration is handled via `appsettings.Development.json` or `appsettings.Production.json`.
- If the original project used `Web.config` transforms, ensure equivalent configuration has been moved to the appropriate `appsettings` files.

---

## 4. Verify the Database Connection

If `Bookstore.Data` uses Entity Framework, confirm the following:

- The connection string in `appsettings.json` points to a valid and accessible database instance.
- Run any pending migrations to ensure the database schema is up to date.

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 5. Run the Application Locally

Start the application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

- Navigate to the URL shown in the console output (typically `https://localhost:5001` or `http://localhost:5000`).
- Walk through the core functionality of the application (browsing books, any data entry forms, etc.) to confirm expected behavior.
- Check the console output and any configured log files for exceptions or warnings during normal use.

---

## 6. Execute Existing Tests

If the solution contains test projects, run them to validate that business logic and data access behavior remain correct after migration.

```bash
dotnet test
```

Review any failing tests carefully. Failures may indicate behavioral differences between .NET Framework and cross-platform .NET that require code adjustments.

---

## 7. Check for Platform-Specific Code

Search the codebase for APIs that were available in .NET Framework but are absent or behave differently in cross-platform .NET. Common areas to check include:

- `System.Web` references — these are not available in cross-platform .NET and should have been replaced during transformation.
- Windows Registry access (`Microsoft.Win32.Registry`).
- `AppDomain` usage beyond what is supported in .NET Core and later.
- Any P/Invoke calls targeting Windows-only native libraries.

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify remaining issues if needed.

---

## 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Inspect the `./publish` directory to ensure all required files are present, including static assets, configuration files, and the compiled assemblies.