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

Review the output for any warnings related to package compatibility or version conflicts. Address any packages that may have been targeting the old .NET Framework and verify their cross-platform equivalents are in place.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Confirm that all three projects build without warnings or errors. Pay particular attention to any warnings flagged as obsolete APIs or platform-specific calls that may have been carried over from the legacy project.

### 3. Review Platform-Specific Code

Even with a clean build, there may be code paths that rely on Windows-specific behavior. Manually inspect the following areas:

- **File system paths**: Ensure `Path.Combine` is used instead of hardcoded backslashes.
- **Registry access**: Any use of `Microsoft.Win32.Registry` will not function on non-Windows platforms.
- **Windows Authentication or IIS-specific configuration**: Verify that `Bookstore.Web` does not rely on IIS-specific middleware or configuration that is unavailable cross-platform.
- **Connection strings**: Confirm that any database connection strings in `appsettings.json` are correctly configured for the target database provider.

### 4. Run Unit Tests

If the solution contains a test project, execute the tests to verify existing functionality:

```bash
dotnet test
```

If no test project exists, consider writing basic integration or unit tests for the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data`.

### 5. Run the Application Locally

Start the web application locally to verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and verify that:

- Pages load without runtime exceptions.
- Database connectivity is functioning (if applicable).
- Any authentication or authorization flows behave correctly.

### 6. Verify Entity Framework Migrations (If Applicable)

If `Bookstore.Data` uses Entity Framework Core, confirm that migrations are up to date and can be applied:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations to the target database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 7. Test on Target Platform

If the intent is to run this application on a non-Windows platform (Linux or macOS), run the application on that platform explicitly to surface any remaining platform-specific issues that would not appear during a Windows build.

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assets, configuration files, and binaries are present before deploying to the target environment.