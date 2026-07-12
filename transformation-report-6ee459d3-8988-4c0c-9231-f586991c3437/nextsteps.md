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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Verify that all three projects build without warnings or errors. Pay particular attention to any warnings about nullable reference types or obsolete APIs, as these can indicate areas that may need further attention.

### 3. Run Unit Tests

If the solution contains test projects, execute them with:

```bash
dotnet test
```

Review the test results to confirm that existing behavior has been preserved after the transformation. If test coverage is low, consider adding tests for critical domain logic in `Bookstore.Domain` and data access logic in `Bookstore.Data`.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and functions correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas manually:

- Application startup completes without exceptions
- Database connectivity works as expected (check connection strings in `appsettings.json` or `appsettings.Development.json`)
- Core application routes and pages load correctly
- Any data read/write operations function as expected

### 5. Review Configuration Files

Cross-platform .NET projects use `appsettings.json` instead of `Web.config` or `App.config`. Confirm the following:

- Connection strings have been migrated correctly
- Any environment-specific settings are present in `appsettings.Development.json`
- No legacy configuration references remain in the codebase

### 6. Check for Platform-Specific Code

Search the codebase for any APIs or patterns that may have been available in .NET Framework but behave differently or are unavailable in cross-platform .NET:

- `System.Web` namespace references
- Windows Registry access
- Windows-specific file path assumptions (e.g., hardcoded backslashes)
- `HttpContext` usage patterns that differ between ASP.NET and ASP.NET Core

### 7. Review Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm the following:

- The correct version of Entity Framework (Core) is being used
- Database migrations are present and up to date by running:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

- Apply any pending migrations to a development database:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present, then deploy the output to your target hosting environment.