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

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Address any warnings that surface during this step, particularly those related to nullable reference types or obsolete APIs, as these may indicate subtle compatibility issues introduced during migration.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that business logic and data access behavior remain intact:

```bash
dotnet test --configuration Release
```

Review test output carefully. A passing build does not guarantee that runtime behavior is correct.

### 4. Verify Database Connectivity and Migrations

Since the solution includes a `Bookstore.Data` project, confirm that any Entity Framework Core migrations are up to date and compatible with the target runtime:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

If migrations are present and the database schema needs to be applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

Ensure the connection string in `appsettings.json` or `appsettings.Development.json` is correctly configured for your target environment.

### 5. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate through the application and confirm that pages load correctly, data is retrieved and displayed as expected, and no runtime exceptions occur.

### 6. Review Configuration Files

Check the following areas for any values that may still reference legacy .NET Framework-specific settings:

- `appsettings.json` — verify connection strings, logging configuration, and any custom keys
- `Program.cs` / `Startup.cs` — confirm middleware registration and service configuration are consistent with the target .NET version
- Any remaining `web.config` or `app.config` files — these are generally not used in cross-platform .NET and their relevant settings should be migrated to `appsettings.json`

### 7. Check for Platform-Specific API Usage

Even without build errors, some APIs that compiled successfully may behave differently or be unsupported on non-Windows platforms at runtime. Review the following areas:

- File path handling — ensure `Path.Combine` is used rather than hardcoded backslashes
- Registry access — not available on Linux or macOS
- Windows-specific authentication or identity APIs

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining platform-specific concerns.