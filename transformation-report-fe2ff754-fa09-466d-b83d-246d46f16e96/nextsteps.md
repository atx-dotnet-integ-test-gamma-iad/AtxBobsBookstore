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

Verify that no warnings or errors are reported during restoration.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output and confirm that all three projects report a successful build with zero errors.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not been broken during the migration:

```bash
dotnet test --configuration Release
```

Review the test results and address any failing tests before proceeding.

### 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is a data access layer, confirm that:

- The connection strings in your configuration files (e.g., `appsettings.json`) are valid and updated for the target environment.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of date, apply them with:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Application Locally

Start the web application locally to perform a basic smoke test:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that core pages and features load without errors. Check the console output and application logs for any runtime exceptions.

### 6. Review Target Framework

Confirm that all projects are targeting the intended .NET version by inspecting each `.csproj` file and verifying the `<TargetFramework>` element. For example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects.

### 7. Review Removed or Changed APIs

Cross-platform .NET removes certain APIs that were available in .NET Framework. Manually review the following areas for potential runtime issues that would not surface as build errors:

- Any use of `System.Web` namespaces, which are not available in cross-platform .NET.
- Windows-specific APIs such as the registry, certain cryptography providers, or Windows identity features.
- Any third-party libraries that may have been targeting .NET Framework and have not been updated to a compatible version.

### 8. Check Application Configuration

Ensure that configuration files have been properly migrated:

- `Web.config` settings should be moved to `appsettings.json` or `appsettings.{Environment}.json`.
- Confirm that environment-specific configuration (e.g., development vs. production) is correctly structured.
- Verify that any HTTP pipeline middleware previously configured in `Global.asax` or `Startup.cs` has been correctly registered in the new `Program.cs` entry point.