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

Review the output for any warnings related to package compatibility or version conflicts, particularly for packages that may have been updated during the transformation.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Confirm that all three projects build without errors or warnings.

### 3. Review Target Framework

Open each `.csproj` file and verify the `<TargetFramework>` element is set to the intended cross-platform .NET version (e.g., `net8.0`). Ensure consistency across all projects:

- `Bookstore.Domain.csproj`
- `Bookstore.Data.csproj`
- `Bookstore.Web.csproj`

### 4. Database and Data Layer Validation

If the project uses Entity Framework Core, run the following to verify migrations are in a valid state:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations were created under the legacy framework, consider verifying that the generated SQL is compatible with your target database provider.

### 5. Run Unit and Integration Tests

If a test project exists in the solution, execute the test suite:

```bash
dotnet test
```

Review any failing tests, as they may indicate behavioral differences introduced by the framework migration.

### 6. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Manually verify the following areas at runtime:

- Application startup and routing
- Database connectivity and data retrieval
- Any authentication or session-related functionality
- Static file serving (CSS, JS, images)

### 7. Review `web.config` and `appsettings.json`

If the legacy project used `web.config` for configuration, confirm that all relevant settings (connection strings, app settings) have been migrated to `appsettings.json` or environment-specific variants such as `appsettings.Production.json`.

### 8. Check for Platform-Specific Code

Search the codebase for any remaining Windows-specific APIs or dependencies that may not be available on Linux or macOS:

- `System.Web` references
- Windows Registry access
- Windows-only file path assumptions (e.g., hardcoded backslashes)

Use `dotnet` tooling or a code search to identify these:

```bash
grep -r "System.Web" ./
grep -r "Registry" ./
```

Replace or abstract any identified platform-specific code as needed.

### 9. Verify Publish Output

Produce a publish output to confirm the application can be packaged correctly:

```bash
dotnet publish Bookstore.Web --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files are present.