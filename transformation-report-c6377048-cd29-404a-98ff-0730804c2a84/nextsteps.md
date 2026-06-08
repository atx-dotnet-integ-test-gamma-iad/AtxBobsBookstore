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

Verify that all three projects build without warnings or errors. Pay particular attention to any warnings about nullable reference types or obsolete APIs, as these can indicate areas that may need attention.

### 3. Run Unit Tests

If the solution contains test projects, execute them to confirm existing functionality is preserved:

```bash
dotnet test --configuration Release
```

Review test results and investigate any failures, as they may indicate behavioral differences introduced during the migration.

### 4. Verify Runtime Behavior

Start the web application locally and perform manual verification:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas manually:

- All pages load without HTTP 500 errors
- Database connectivity works as expected (check connection strings in `appsettings.json` for any platform-specific paths or configurations that may need updating)
- Any file system paths used in the application are updated to use `Path.Combine` or forward-slash-compatible formats
- Authentication and session handling behaves correctly

### 5. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files:

- Confirm connection strings are valid for the target environment
- Check that any Windows-specific configuration (e.g., Windows Authentication, registry-based settings) has been replaced with cross-platform equivalents
- Ensure logging configuration is appropriate for the target platform

### 6. Check Entity Framework Migrations (if applicable)

If `Bookstore.Data` uses Entity Framework Core, verify that migrations are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

If the database schema needs to be updated:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 7. Deployment

Once validation is complete, publish the application using:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to your target server and ensure the correct .NET runtime version is installed on that server. Confirm the runtime version with:

```bash
dotnet --list-runtimes
```