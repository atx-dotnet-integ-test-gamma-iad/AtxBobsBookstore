# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects:

- `Bookstore.Domain`
- `Bookstore.Data`
- `Bookstore.Web`

## Validation Steps

### 1. Restore Dependencies

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate compatibility issues, even if the build succeeds.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not been broken during the migration:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may point to behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, check the following areas:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly and that queries return expected results. Pay attention to any Entity Framework Core migration differences if the project was previously using EF6.
- **Domain logic**: Verify that business rules in `Bookstore.Domain` behave as expected.
- **Web layer**: Navigate through the application's pages and endpoints to confirm routing, model binding, and rendering work correctly.

### 5. Check for Removed or Changed APIs

Cross-platform .NET does not include certain APIs that were available in .NET Framework. Review the following areas manually:

- Any use of `System.Web` namespaces, which are not available in modern .NET. These should have been replaced with `Microsoft.AspNetCore` equivalents.
- `ConfigurationManager` usage should be replaced with `Microsoft.Extensions.Configuration`.
- `HttpContext` and related types should reference the ASP.NET Core versions.

### 6. Review Target Framework Monikers

Open each `.csproj` file and confirm that the `<TargetFramework>` element references a supported cross-platform .NET version, such as `net8.0` or `net9.0`:

```xml
<TargetFramework>net8.0</TargetFramework>
```

### 7. Validate Database Connectivity

If the project uses Entity Framework, confirm that any required database migrations are up to date:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If migrations do not exist yet, consider generating an initial migration based on the current model.

### 8. Review Application Configuration

Confirm that `appsettings.json` contains the correct configuration values, including connection strings, that were previously stored in `Web.config` or `App.config` in the legacy project.