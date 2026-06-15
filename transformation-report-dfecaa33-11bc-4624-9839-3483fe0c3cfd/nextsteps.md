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

Confirm that all three projects build without errors or warnings.

### 3. Review Target Framework

Open each `.csproj` file and verify the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure none of the projects still reference `net48` or any other Windows-only framework moniker.

### 4. Check for Windows-Specific APIs

Even without build errors, some APIs may have been carried over from the legacy project that are Windows-specific and will fail at runtime on non-Windows platforms. Use the .NET Compatibility Analyzer to surface these:

```bash
dotnet add package Microsoft.DotNet.Analyzers.Compatibility
```

Review any resulting warnings in the build output.

### 5. Run Existing Tests

If a test project exists in the solution, execute the test suite:

```bash
dotnet test --configuration Release
```

If no tests exist, consider writing basic integration and unit tests covering the core domain logic in `Bookstore.Domain` and the data access layer in `Bookstore.Data` before deploying.

### 6. Verify Database Migrations

If `Bookstore.Data` uses Entity Framework Core, verify that all migrations are present and up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are missing or out of sync, generate a new migration:

```bash
dotnet ef migrations add InitialMigration --project Bookstore.Data --startup-project Bookstore.Web
```

Apply the migrations against your target database:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 7. Run the Application Locally

Start the web application locally to verify runtime behavior:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and confirm that core functionality such as data retrieval, form submissions, and page rendering behave as expected.

### 8. Review Configuration Files

Check `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) to confirm that:

- Connection strings are correct for the target environment.
- Any legacy `Web.config` or `App.config` values have been properly migrated to the new configuration system.
- Secrets are not stored in plain text within configuration files.

### 9. Validate on a Non-Windows Platform (Optional but Recommended)

Since the goal is cross-platform compatibility, run the application on a Linux or macOS environment to confirm there are no platform-specific runtime issues:

```bash
dotnet run --project Bookstore.Web
```

Address any runtime exceptions that surface on non-Windows platforms.

## Deployment

Once all validation steps above pass:

1. Publish the application using the `dotnet publish` command targeting your intended runtime:

```bash
dotnet publish Bookstore.Web --configuration Release --runtime linux-x64 --self-contained false
```

2. Copy the output from the `publish` directory to your target server or hosting environment.
3. Ensure the target environment has the correct .NET runtime version installed.
4. Configure your web server (e.g., Nginx, IIS, or Kestrel directly) to serve the application.