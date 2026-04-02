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

Review the output for any warnings about deprecated or incompatible packages. If any packages targeting the old .NET Framework are still present, check for their .NET-compatible equivalents on [NuGet.org](https://www.nuget.org).

---

## 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues.

```bash
dotnet build --configuration Release
```

Address any warnings that surface during the build, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

---

## 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to a supported, non-end-of-life version of .NET. As of now, the recommended versions are:

- `net8.0` (LTS)
- `net9.0` (Standard Term Support)

Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

---

## 4. Check for Windows-Specific Dependencies

Since this is a cross-platform migration, inspect each project for any remaining Windows-specific APIs or libraries. Common areas to check include:

- **Registry access** (`Microsoft.Win32.Registry`)
- **Windows Authentication** or IIS-specific middleware in `Bookstore.Web`
- **File path separators** — replace hardcoded backslashes (`\`) with `Path.Combine` or `Path.DirectorySeparatorChar`
- **`System.Drawing`** — if used, replace with a cross-platform alternative such as `SkiaSharp` or `ImageSharp`

You can use the [.NET Upgrade Assistant](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to identify remaining platform-specific calls.

---

## 5. Validate the Data Layer (`Bookstore.Data`)

- Confirm that Entity Framework (if used) has been migrated to **Entity Framework Core**.
- Run any existing database migrations to verify they apply cleanly:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If migrations do not exist yet, generate an initial migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

---

## 6. Run the Application Locally

Start the web application and verify it runs without runtime errors.

```bash
dotnet run --project Bookstore.Web
```

Navigate to the displayed local URL and exercise the core functionality of the application, including:

- Browsing and searching for books
- Any authentication or authorization flows
- Data reads and writes through the `Bookstore.Data` layer

---

## 7. Execute Unit and Integration Tests

If the solution contains test projects, run them to confirm existing behavior is preserved.

```bash
dotnet test
```

Review any failing tests carefully. Failures may indicate behavioral differences between .NET Framework and modern .NET that require code adjustments.

If no tests currently exist, consider adding tests for the core domain logic in `Bookstore.Domain` as a baseline for validating correctness going forward.

---

## 8. Review Configuration Files

- Ensure `appsettings.json` contains all configuration values that were previously in `Web.config` or `App.config`.
- Confirm connection strings, logging settings, and any environment-specific overrides are correctly structured.
- Remove any legacy `Web.config` or `App.config` files if they are no longer needed, or verify they are only retained for IIS deployment scenarios.

---

## 9. Publish the Application

Once the application has been validated locally, publish it for deployment.

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and confirm all required assets, static files, and configuration files are present before deploying to the target environment.