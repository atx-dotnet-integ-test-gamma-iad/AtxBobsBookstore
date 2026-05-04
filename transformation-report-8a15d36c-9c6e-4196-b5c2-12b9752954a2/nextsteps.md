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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors in a clean build context:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during this step, particularly those related to nullable reference types or obsolete APIs, as these can indicate subtle compatibility issues.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that business logic and data access behavior remain intact after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

If no test projects currently exist, consider adding unit tests for the core logic in `Bookstore.Domain` and data access logic in `Bookstore.Data` before proceeding further.

### 4. Verify Database Connectivity

Since `Bookstore.Data` is likely responsible for data access, confirm that:

- The connection string in your configuration file (`appsettings.json`) is correct for your target environment.
- Any Entity Framework Core migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Application Locally

Start the web application locally to confirm it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and verify that core functionality such as page rendering, data retrieval, and form submissions work correctly.

### 6. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` as the primary configuration mechanism. Confirm that:

- All relevant settings from any legacy `Web.config` or `App.config` files have been moved to `appsettings.json`.
- Environment-specific settings are handled using `appsettings.Development.json` or environment variables where appropriate.

### 7. Check for Platform-Specific Code

Review the codebase for any remaining Windows-specific APIs or libraries that may not behave correctly on Linux or macOS. Common areas to check include:

- File path handling (use `Path.Combine` rather than hardcoded backslashes).
- Registry access, which is not available on non-Windows platforms.
- Any use of `System.Web` namespaces, which are not part of cross-platform .NET.

### 8. Publish the Application

Once local validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and configuration files are present before deploying to your target environment.