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

Check the output for any warnings that, while non-breaking, may indicate deprecated APIs or framework-specific code that could cause runtime issues.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, verify the following areas which are commonly affected by cross-platform migrations:

- **File paths**: Ensure no hardcoded Windows-style paths (e.g., `C:\` or backslashes) exist in configuration or code.
- **Database connectivity**: Confirm that the connection strings in `appsettings.json` or `web.config` are correct and that `Bookstore.Data` can reach the database.
- **Authentication and Authorization**: If the application uses Windows Authentication or any Windows-specific identity providers, these will require reconfiguration for cross-platform environments.
- **Static files and routing**: Confirm that pages, assets, and API routes resolve correctly when running under the new host (Kestrel vs. IIS).

### 5. Review Configuration Files

Check that configuration previously held in `web.config` has been properly migrated to `appsettings.json`. Key areas to inspect include:

- Connection strings
- Application settings / feature flags
- Logging configuration
- Any HTTP handler or module configurations that need to be replaced with ASP.NET Core middleware

### 6. Inspect Third-Party Library Compatibility

Review all NuGet dependencies across the three projects and confirm they target .NET Standard 2.0+ or the current .NET version being used. Libraries that only target .NET Framework may work via compatibility shims but could produce unexpected behavior at runtime.

```bash
dotnet list package --outdated
```

Update any outdated packages where a compatible version is available.

### 7. Check for Platform-Specific API Usage

Search the codebase for APIs that are not supported on non-Windows platforms. Common examples include:

- `System.Web` references (should have been removed during transformation)
- `Registry` access via `Microsoft.Win32`
- COM interop
- `HttpContext.Current` (replaced by dependency-injected `IHttpContextAccessor` in ASP.NET Core)

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining incompatibilities.