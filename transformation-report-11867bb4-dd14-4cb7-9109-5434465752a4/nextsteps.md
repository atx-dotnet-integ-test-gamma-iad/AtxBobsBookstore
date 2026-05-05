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

## Validation and Testing

### 1. Restore Dependencies

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or version conflicts, particularly for packages that may have been updated during the transformation.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that the build output reports zero errors and review any warnings that may indicate deprecated APIs or compatibility concerns.

### 3. Run Unit Tests

If the solution contains test projects, execute them to confirm existing functionality is preserved:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects exist, consider writing basic tests for the core domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

### 4. Run the Web Application Locally

Start the web application to verify it runs as expected on the new runtime:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Navigate to the application in a browser and manually verify:

- Pages load without errors
- Data access operations (reads and writes) function correctly
- Any authentication or session-related features behave as expected

### 5. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 6. Review Removed or Changed APIs

Cross-platform .NET removes or changes certain APIs that were available in .NET Framework. Manually review the following areas:

- **Configuration**: Confirm that `System.Configuration.ConfigurationManager` usage has been replaced with `Microsoft.Extensions.Configuration` if applicable.
- **Entity Framework**: If `Bookstore.Data` uses Entity Framework, confirm it has been migrated to Entity Framework Core and that migrations are up to date.
- **HTTP and Web APIs**: Confirm that any `System.Web` dependencies have been fully replaced with ASP.NET Core equivalents in `Bookstore.Web`.

### 7. Verify Database Connectivity

If the application uses a database, confirm the connection string in `appsettings.json` is correctly configured for the target environment and that the application can connect and query the database without errors.

### 8. Check Runtime Behavior on Target OS

If the intent is to run this application on Linux or macOS, test it explicitly on that operating system. Pay particular attention to:

- File path separators
- Case-sensitive file and directory references
- Any platform-specific library dependencies that may have been present in the original project