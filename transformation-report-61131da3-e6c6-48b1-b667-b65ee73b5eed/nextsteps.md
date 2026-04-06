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

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent compilation.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences introduced by the migration.

### 4. Verify Runtime Behavior

Run the web application locally and manually exercise its core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, verify the following areas:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. Check connection strings in your configuration files (e.g., `appsettings.json`) to ensure they are valid for the target environment.
- **Domain logic**: Exercise the key business logic flows exposed by `Bookstore.Domain` to confirm they behave as expected.
- **Web layer**: Navigate through the application pages or API endpoints to confirm routing, model binding, and rendering work correctly.

### 5. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files (e.g., `appsettings.Production.json`) to confirm that:

- Connection strings are correct and use a format compatible with the new target framework.
- Any previously used `Web.config` or `App.config` settings have been properly migrated to the `appsettings.json` structure.

### 6. Check Target Framework Compatibility

Open each `.csproj` file and confirm the `<TargetFramework>` element targets the intended .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Also review any remaining NuGet package references to ensure they are compatible with the chosen target framework and are reasonably up to date.

### 7. Review Removed or Changed APIs

Cross-platform .NET removes certain APIs that were available in .NET Framework. Perform a review of the following common problem areas:

- **`System.Web` references**: These are not available in cross-platform .NET. Confirm none remain in the codebase.
- **Entity Framework**: If `Bookstore.Data` uses Entity Framework, confirm it has been migrated to Entity Framework Core and that migrations are up to date.
- **Authentication and authorization middleware**: If the web project uses authentication, confirm it has been updated to use the ASP.NET Core middleware pipeline.

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all expected files are present before deploying to the target environment.