# Next Steps

## Issues resolved
- Transformed Bookstore.Domain.csproj to net8.0
- Transformed Bookstore.Data.csproj to net8.0
- Transformed Bookstore.Web.csproj to net8.0

## Summary

The transformation appears to have completed successfully. No build errors were detected in any of the three projects in the solution:

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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Ensure the build completes with zero errors and review any warnings, particularly those related to nullable reference types or obsolete APIs introduced by the framework upgrade.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Pay close attention to any tests that interact with data access logic in `Bookstore.Data`, as Entity Framework or database provider behavior may differ between the old and new framework versions.

### 4. Verify Runtime Behavior

Start the web application locally and navigate through its core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas manually:

- Application startup and landing page load without errors.
- Database connectivity is functioning (check connection strings in `appsettings.json` or `appsettings.Development.json`).
- Any authentication or authorization flows work as expected.
- CRUD operations related to the bookstore domain (browsing, adding, updating, or removing books) function correctly.

### 5. Review Configuration Files

Confirm that configuration values previously stored in `Web.config` or `App.config` have been correctly migrated to `appsettings.json`. Key areas to check include:

- Database connection strings.
- Application-specific settings.
- Logging configuration.

### 6. Check for Removed or Changed APIs

Review the code in all three projects for use of any APIs that were available in .NET Framework but have changed behavior or been removed in cross-platform .NET. Common areas include:

- `System.Web` references, which are not available in cross-platform .NET.
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core.
- Any Windows-specific APIs used in `Bookstore.Data` or `Bookstore.Domain`.

### 7. Database Migration Verification

If the project uses Entity Framework, verify that migrations are up to date and compatible with the new runtime:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If any pending migrations exist or if the migration history appears inconsistent, review and reconcile them before deploying to any environment.

### 8. Deployment

Once the above steps have been completed and validated, publish the application using the following command:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Verify the contents of the `./publish` directory and deploy to your target hosting environment according to your infrastructure requirements.