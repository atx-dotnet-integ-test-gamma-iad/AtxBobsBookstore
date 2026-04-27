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

Verify that no warnings or errors appear related to missing or incompatible packages.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Database Connectivity (Bookstore.Data)

Since `Bookstore.Data` is likely responsible for data access, confirm that:

- The connection string in your configuration file (`appsettings.json`) is correct for your target environment.
- Any Entity Framework migrations are up to date by running:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

- If you were previously using `App.config` for connection strings, ensure those values have been moved to `appsettings.json`.

### 5. Check for Windows-Specific Dependencies

Even without build errors, runtime issues can arise from Windows-specific APIs. Review the following areas:

- Any use of `System.Web` namespaces, which are not available in cross-platform .NET.
- Registry access, Windows Authentication, or COM interop calls.
- File path separators — ensure paths use `Path.Combine` rather than hardcoded backslashes.

### 6. Run the Web Application Locally

Start the `Bookstore.Web` project and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

- Navigate through the primary user-facing pages.
- Test any forms, search functionality, and data retrieval features.
- Check the console and application logs for runtime exceptions.

### 7. Review Configuration Files

Confirm that the following configuration concerns have been addressed:

- `web.config` settings relevant to the application have been migrated to `appsettings.json` or `Program.cs`/`Startup.cs`.
- Logging configuration is set up using the `Microsoft.Extensions.Logging` infrastructure.
- Any environment-specific settings are handled using environment variables or `appsettings.{Environment}.json` files.

### 8. Validate Target Framework

Open each `.csproj` file and confirm the `TargetFramework` value is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid compatibility issues between them.