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

Address any warnings that surface during this step, particularly those related to nullable reference types or obsolete APIs, as these may indicate areas that were not fully modernized.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing behavior has been preserved after the transformation:

```bash
dotnet test --configuration Release
```

Review test output carefully. Failures here may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, validate the following areas:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the expected database and that migrations (if using Entity Framework) are applied correctly.
- **Domain logic**: Exercise key business logic paths exposed through `Bookstore.Domain` to confirm correct behavior.
- **Web layer**: Navigate through the application's pages or API endpoints to confirm routing, model binding, and rendering work as expected.

### 5. Check for Platform-Specific Code

Search the codebase for any remaining usage of Windows-specific APIs or libraries that may not surface as build errors but could cause runtime failures on non-Windows platforms:

- `Microsoft.Win32` namespace usage
- `System.Drawing` (GDI+) without the `System.Drawing.Common` package configured
- Registry access
- Windows-only authentication mechanisms (e.g., NTLM, Windows Authentication)

### 6. Review Configuration Files

Confirm that `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) are present and contain the correct values for the target environment. Legacy `Web.config` or `App.config` values may need to be manually migrated to the new configuration system if they were not handled during transformation.

### 7. Target Framework Verification

Open each `.csproj` file and confirm the `<TargetFramework>` element targets the intended version of .NET (e.g., `net8.0`):

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure consistency across all three projects to avoid inter-project compatibility issues.