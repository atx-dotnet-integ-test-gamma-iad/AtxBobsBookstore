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

## Validation and Testing

### 1. Restore Dependencies

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-blocking, may indicate compatibility concerns worth addressing.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Example:

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

### 4. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences between the legacy .NET Framework and the current .NET runtime.

### 5. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access project, confirm that:

- The connection string in your configuration file (`appsettings.json` or equivalent) is valid and points to the correct database.
- Any Entity Framework migrations are up to date by running:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If you are using `Database.SetInitializer` or other EF 6 patterns, confirm they have been replaced with the appropriate EF Core equivalents.

### 6. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and confirm that:

- Pages render without errors.
- Data is read from and written to the database correctly.
- Authentication and authorization (if applicable) function as expected.

### 7. Check for Runtime-Only Issues

Some issues do not surface at build time. Pay attention to the following areas during manual testing:

- **Configuration**: Ensure `appsettings.json` contains all settings previously held in `Web.config` or `App.config`, including connection strings and application settings.
- **Static files**: Confirm that static assets (CSS, JS, images) are served correctly under the `wwwroot` folder structure expected by ASP.NET Core.
- **HTTP handlers and modules**: If the legacy project used `HttpHandlers` or `HttpModules`, verify they have been replaced with the appropriate ASP.NET Core middleware.
- **Session and caching**: Confirm session state and caching configurations have been migrated to their ASP.NET Core equivalents.

### 8. Review Removed Windows-Specific APIs

Run the .NET Upgrade Analyzer or review the code manually for any APIs that are Windows-only and may fail on Linux or macOS at runtime despite building successfully:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Address any `CA1416` platform compatibility warnings that appear after adding the analyzer.