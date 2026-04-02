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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or deprecated packages targeting older frameworks.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Confirm that all three projects build without errors or warnings.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests and determine whether they are caused by behavioral differences introduced by the migration or pre-existing issues.

### 4. Verify Database Connectivity

Since the solution includes a `Bookstore.Data` project, verify that your data access layer is functioning correctly:

- Confirm that your connection strings in `appsettings.json` (or equivalent) are correctly configured for the target environment.
- If Entity Framework Core is in use, run any pending migrations:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If a different ORM or ADO.NET is used, manually verify that queries execute as expected against your database.

### 5. Run the Web Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate to the application in a browser and exercise the primary workflows.
- Check the console output and application logs for any runtime exceptions or warnings.
- Verify that any static files, views, or Razor pages render correctly.

### 6. Review Configuration Files

Cross-platform .NET handles configuration differently than legacy .NET Framework projects. Verify the following:

- `appsettings.json` contains all settings that were previously in `Web.config` or `App.config`.
- Any environment-specific settings are placed in `appsettings.{Environment}.json`.
- Confirm that `ASPNETCORE_ENVIRONMENT` is set appropriately in your local environment.

### 7. Check for Platform-Specific API Usage

Even without build errors, there may be runtime issues caused by APIs that are not fully supported on all platforms. Run the .NET Compatibility Analyzer if not already done:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
dotnet build
```

Address any warnings surfaced by the analyzer related to platform-specific behavior.

### 8. Review Deprecated or Replaced APIs

Check for use of APIs that exist in cross-platform .NET but behave differently from their .NET Framework counterparts. Common areas to review include:

- `System.Web` replacements (e.g., `HttpContext`, session handling, authentication middleware)
- `ConfigurationManager` replaced by `Microsoft.Extensions.Configuration`
- `BinaryFormatter` which is disabled by default in modern .NET

### 9. Deploy to Target Environment

Once local validation is complete, deploy the application to your target environment:

- Publish the application using:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

- Copy the output from the `./publish` directory to your target server or hosting environment.
- Confirm that the correct .NET runtime version is installed on the target machine.
- Verify application startup and basic functionality in the deployed environment.