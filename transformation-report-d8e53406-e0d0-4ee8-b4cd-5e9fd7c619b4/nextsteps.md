# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected across any of the three projects in the solution (`Bookstore.Data`, `Bookstore.Web`, and `Bookstore.Domain`). The steps below focus on validating and testing the migrated solution before deploying it.

---

## 1. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported cross-platform .NET version (e.g., `net8.0`).

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure no project still references `net48` or any other Windows-only framework moniker.

---

## 2. Restore Dependencies

Run a full NuGet restore from the solution root to confirm all packages resolve correctly.

```bash
dotnet restore
```

Review the output for any warnings about packages that are deprecated, have known vulnerabilities, or target older frameworks. Replace or update those packages as needed.

---

## 3. Build the Solution

Perform a clean build to confirm there are no warnings that could indicate runtime issues.

```bash
dotnet build --configuration Release
```

Address any warnings related to nullable reference types, obsolete APIs, or platform compatibility before proceeding.

---

## 4. Run Unit and Integration Tests

If the solution contains a test project, execute the tests to verify business logic and data access behavior are intact after migration.

```bash
dotnet test --configuration Release --logger "console;verbosity=detailed"
```

If no tests currently exist, consider writing basic tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before deploying.

---

## 5. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, verify that:

- The connection string in `appsettings.json` is correct for your target environment.
- Any pending migrations are applied.

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

If you migrated from Entity Framework 6, confirm that all EF Core-specific API changes (e.g., `OnConfiguring`, `DbContextOptions`) are correctly implemented.

---

## 6. Run the Web Application Locally

Start the web application and manually verify core functionality such as browsing, searching, and any authentication flows.

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Check the console output and browser for any runtime exceptions, missing static files, or broken routes.

---

## 7. Check for Windows-Specific APIs

Review the codebase for any remaining Windows-specific dependencies that may compile successfully but fail at runtime on Linux or macOS. Common areas to check include:

- Use of `System.Drawing` (replace with a cross-platform alternative such as `SkiaSharp` if needed).
- Registry access via `Microsoft.Win32`.
- Windows Authentication middleware (if cross-platform support is required).

You can use the .NET Compatibility Analyzer to assist with this:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

---

## 8. Review Logging and Configuration

Confirm that the application uses `Microsoft.Extensions.Logging` and `Microsoft.Extensions.Configuration` rather than any legacy `System.Configuration` or `log4net` patterns. Ensure `appsettings.json` contains all configuration values previously held in `Web.config` or `App.config`.

---

## 9. Publish the Application

Once validation is complete, publish the application to confirm the output is self-contained and correct.

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and verify all required assets, static files, and configuration files are present before deploying to your target environment.