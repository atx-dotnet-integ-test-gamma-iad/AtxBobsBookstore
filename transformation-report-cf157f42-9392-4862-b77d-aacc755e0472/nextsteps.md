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

Run the following command from the solution root to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear during the restore process, particularly around package compatibility with the target framework.

### 2. Build the Solution

Perform a full solution build to confirm the error-free state holds under a clean build:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that business logic and data access behavior remain intact after the migration:

```bash
dotnet test
```

Review test results for any failures that may indicate behavioral regressions introduced during the transformation.

### 4. Verify Database Connectivity and Migrations

Since the solution includes a `Bookstore.Data` project, confirm that any Entity Framework Core migrations are up to date and compatible with the new target framework:

```bash
dotnet ef migrations list --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

If migrations are present, apply them to a test database and verify the schema:

```bash
dotnet ef database update --project app/Bookstore.Data --startup-project app/Bookstore.Web
```

### 5. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify that core functionality is working as expected:

```bash
dotnet run --project app/Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows, such as browsing, searching, and any data entry forms.

### 6. Review Configuration Files

Check `appsettings.json` and any environment-specific configuration files in `Bookstore.Web` to ensure that:

- Connection strings are correct for the target environment.
- Any settings that were previously in `Web.config` have been properly migrated to the new configuration system.
- Logging and environment settings are configured appropriately.

### 7. Check for Removed or Changed APIs

Review the code in all three projects for any use of APIs that exist in .NET Framework but behave differently or have reduced functionality in cross-platform .NET. Common areas to check include:

- `System.Web` references, which are not available in cross-platform .NET.
- Windows-specific APIs such as the registry, Windows Identity, or WCF server-side components.
- Any third-party libraries that may have been targeting .NET Framework exclusively.

### 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web --configuration Release --output ./publish
```

Inspect the `./publish` directory to confirm all expected files, static assets, and configuration files are present before deploying to the target environment.