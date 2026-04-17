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

Perform a full solution build to confirm the absence of errors in a clean build environment:

```bash
dotnet build --configuration Release
```

Check the output for any warnings that, while non-blocking, may indicate areas of concern such as obsolete API usage or nullable reference warnings.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release --verbosity normal
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework APIs and their cross-platform .NET equivalents.

### 4. Verify Data Layer Functionality

Since `Bookstore.Data` is likely responsible for database access, confirm the following:

- The correct database provider package is referenced (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or equivalent).
- Connection strings in configuration files (`appsettings.json`) are valid and accessible in the new environment.
- Any pending migrations are applied:

```bash
dotnet ef database update --project Bookstore.Data --startup-project Bookstore.Web
```

### 5. Run the Web Application Locally

Start the web application and manually verify core functionality:

```bash
dotnet run --project Bookstore.Web --configuration Release
```

Navigate to the application in a browser and test the primary user-facing features, such as browsing, searching, and any data entry flows.

### 6. Review Configuration Files

Inspect `appsettings.json` and any environment-specific variants (`appsettings.Development.json`, etc.) to ensure:

- Connection strings are correct for the target environment.
- Any configuration keys previously stored in `Web.config` or `App.config` have been properly migrated to the new configuration system.

### 7. Check for Platform-Specific API Usage

Even without build errors, some APIs may behave differently or have reduced functionality on non-Windows platforms. Review the codebase for usage of:

- `System.Drawing` (not fully supported cross-platform without additional packages)
- Windows Registry access
- Windows-specific file path assumptions (e.g., backslashes)
- `HttpContext.Current` or other ASP.NET Framework-specific statics

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.PlatformAbstractions` tooling to assist in identifying any remaining compatibility concerns.

### 8. Review Target Framework

Confirm that all three projects are targeting the intended framework version. Open each `.csproj` file and verify the `<TargetFramework>` element reflects the desired version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still references `net48` or another legacy moniker, update it accordingly and rebuild.