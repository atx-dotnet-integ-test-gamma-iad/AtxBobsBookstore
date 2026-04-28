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

Verify that no warnings or errors appear during the restore process, particularly around package compatibility or target framework mismatches.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test
```

Review test results carefully. Any failing tests may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas manually:

- Application startup and routing
- Database connectivity from `Bookstore.Data` (confirm connection strings are configured correctly for the new environment)
- Any file system paths that may have been hardcoded using Windows-style separators (`\`) — these should be replaced with `Path.Combine` or forward slashes for cross-platform compatibility

### 5. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files to ensure:

- Connection strings are valid and point to the correct database
- Any absolute file paths have been updated to be platform-agnostic
- Authentication or session settings have been carried over correctly from the legacy configuration

### 6. Check Data Layer Compatibility

In `Bookstore.Data`, confirm that:

- The Entity Framework (or other ORM) version being used is compatible with cross-platform .NET
- Any database migrations are up to date by running:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply pending migrations if necessary:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 7. Target Framework Confirmation

Open each `.csproj` file and confirm that the `<TargetFramework>` element reflects the intended cross-platform .NET version (for example, `net8.0`). Ensure consistency across all three projects to avoid inter-project compatibility issues.

### 8. Publishing the Application

Once validation is complete, publish the application using:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all required assets, static files, and configuration files are present before deploying to the target environment.