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

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects are targeting a consistent framework version.

### 4. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

### 5. Check for Platform-Specific Code

Search the codebase for any APIs that were previously Windows-specific and may have been carried over. Common areas to inspect include:

- File path handling — ensure `Path.Combine` is used rather than hardcoded backslashes.
- Registry access — `Microsoft.Win32.Registry` is not available on non-Windows platforms.
- Windows Authentication or IIS-specific configuration in `Bookstore.Web`.

### 6. Verify Database Connectivity

Since `Bookstore.Data` is present, confirm that the database connection strings in `appsettings.json` are valid for the target environment and that the chosen data provider (e.g., Entity Framework Core) is compatible with the target platform.

If Entity Framework Core is used, verify that any pending migrations are up to date:

```bash
dotnet ef migrations list --project Bookstore.Data --startup-project Bookstore.Web
```

### 7. Run the Application Locally

Start the web application locally to confirm it runs as expected:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and exercise the primary workflows to confirm runtime behavior is correct.

### 8. Test on Target Operating System

If the goal is cross-platform support, run the application on the intended non-Windows operating system (e.g., Linux or macOS) to surface any remaining platform-specific issues that would not appear during a Windows build.

### 9. Review Startup and Middleware Configuration

In `Bookstore.Web`, review `Program.cs` (and `Startup.cs` if still present) to confirm that middleware and service registrations are consistent with the cross-platform .NET hosting model. Remove any references to `UseIIS` or `UseIISIntegration` if IIS is no longer the intended host.

## Deployment

Once local validation is complete, publish the application using:

```bash
dotnet publish --project Bookstore.Web --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to the target server and configure the appropriate runtime host (e.g., Kestrel behind a reverse proxy such as Nginx or Apache on Linux).