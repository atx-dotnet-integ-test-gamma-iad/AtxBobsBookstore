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

Perform a full solution build to confirm the absence of errors in a clean build context:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during this step, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

### 3. Run Unit Tests

If test projects exist in the solution, execute them to verify that business logic and data access behavior remain intact after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework APIs and their cross-platform .NET equivalents.

### 4. Verify Entity Framework or Data Access Layer

Since `Bookstore.Data` is present, confirm that your data access layer is functioning correctly:

- Verify that your database connection strings are correctly configured in `appsettings.json` or environment variables.
- If using Entity Framework Core, confirm that migrations are up to date by running:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

- Apply any pending migrations to your target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and verify that it runs without runtime exceptions:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the application's key pages and features.
- Check the console output and application logs for any runtime errors or unhandled exceptions.
- Pay particular attention to areas that rely on Windows-specific APIs (e.g., `System.Drawing`, registry access, Windows authentication), as these may compile successfully but fail at runtime on non-Windows platforms.

### 6. Review Configuration Files

- Confirm that `appsettings.json` and any environment-specific variants (`appsettings.Development.json`, etc.) contain all required configuration values that may have previously resided in `Web.config` or `App.config`.
- Verify that connection strings, logging configuration, and any custom application settings have been correctly migrated.

### 7. Check Static Assets and Middleware

For the `Bookstore.Web` project, confirm that static file serving, routing, and middleware are configured correctly in `Program.cs` or `Startup.cs`. Ensure that any HTTP modules or HTTP handlers from the legacy project have been replaced with the appropriate ASP.NET Core middleware equivalents.

### 8. Cross-Platform Smoke Test (Optional but Recommended)

If cross-platform support is a goal, run the application on a non-Windows environment (Linux or macOS) to surface any remaining platform-specific dependencies that may not have been caught during the build phase.