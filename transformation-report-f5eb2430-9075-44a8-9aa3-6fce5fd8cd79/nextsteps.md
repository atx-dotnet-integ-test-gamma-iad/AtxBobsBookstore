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

Review the output for any warnings related to package compatibility or version conflicts, particularly for packages that may have changed between .NET Framework and modern .NET.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-breaking, may indicate deprecated APIs or patterns that should be addressed.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended modern .NET version (e.g., `net8.0`). Ensure consistency across all three projects.

### 4. Run Unit Tests

If a test project exists in the solution, execute the tests to verify that business logic and data access behavior remain intact after migration:

```bash
dotnet test --configuration Release
```

If no test project exists, consider writing basic tests covering the core domain logic in `Bookstore.Domain` and data access operations in `Bookstore.Data`.

### 5. Validate Data Access Layer

In `Bookstore.Data`, verify the following:

- If Entity Framework is used, confirm the version is EF Core and not EF 6. EF 6 is not fully supported on cross-platform .NET.
- Run any existing database migrations or verify that `dotnet ef migrations list` returns the expected migration history:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Confirm connection strings in `appsettings.json` are correctly configured and that no legacy `Web.config` or `App.config` connection string entries are being relied upon.

### 6. Check for Configuration Migration

Verify that any settings previously stored in `Web.config` have been moved to `appsettings.json`. Pay particular attention to:

- Connection strings
- Application settings keys
- Authentication or authorization configuration

### 7. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the locally running application and test the primary user-facing features such as browsing, searching, and any data entry workflows.

### 8. Check for Platform-Specific API Usage

Search the codebase for any APIs that were available in .NET Framework but are absent or behave differently in modern .NET. Common areas to check include:

- `System.Web` references (these are not available in modern .NET)
- `HttpContext` usage outside of the ASP.NET Core request pipeline
- `AppDomain` usage
- Binary serialization via `BinaryFormatter`, which is disabled by default in .NET 5+

### 9. Review Startup and Middleware Configuration

In `Bookstore.Web`, confirm that the application startup follows the ASP.NET Core model using either `Program.cs` with the minimal hosting model or a `Startup.cs` class. Ensure middleware such as authentication, static files, and routing is registered correctly.

### 10. Verify Static Files and Views

If the project uses Razor Views or static assets, confirm that:

- Static files are located under the `wwwroot` folder
- Razor view syntax is compatible with ASP.NET Core (e.g., no legacy `WebForms` `.aspx` files remain)
- Tag Helpers or HTML Helpers are functioning as expected