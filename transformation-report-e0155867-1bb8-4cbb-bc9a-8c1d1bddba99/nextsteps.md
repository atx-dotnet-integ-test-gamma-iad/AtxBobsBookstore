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

Review the output for any warnings related to package compatibility or version conflicts, particularly for packages that may have been updated during the transformation.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Ensure consistency across all three projects.

### 4. Run Unit Tests

If the solution contains a test project, execute the test suite:

```bash
dotnet test
```

If no tests currently exist, consider writing tests that cover the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before proceeding further.

### 5. Verify Database Connectivity

Since `Bookstore.Data` is a data layer project, verify that:

- The connection string in `appsettings.json` (or equivalent configuration) is valid and points to the correct database.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list
dotnet ef database update
```

- If the project previously used Entity Framework 6 (EF6), confirm it has been migrated to Entity Framework Core and that all queries behave as expected.

### 6. Run the Web Application Locally

Start the web application to confirm it runs correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate through the application and verify that:

- Pages load without runtime exceptions.
- Data is read from and written to the database correctly.
- Any authentication or authorization mechanisms function as expected.

### 7. Check for Removed Windows-Specific APIs

Even without build errors, some APIs that were available in .NET Framework may have changed behavior in cross-platform .NET. Manually review the codebase for usage of the following and test them explicitly at runtime:

- `System.Web` references (these are not available in cross-platform .NET).
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core.
- Any file path handling that assumes Windows-style directory separators.
- Windows Registry access or Windows-specific configuration mechanisms.

### 8. Review Configuration System

.NET Framework projects often rely on `System.Configuration` and `Web.config`. Confirm that configuration has been migrated to the ASP.NET Core configuration system using `appsettings.json` and `IConfiguration`. Verify all configuration keys are present and correctly read at runtime.

### 9. Validate Middleware and Application Startup

Review `Program.cs` (and `Startup.cs` if present) to confirm that all middleware, services, and dependency injection registrations are correctly configured for ASP.NET Core.