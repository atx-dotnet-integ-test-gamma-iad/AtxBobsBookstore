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

Address any warnings that appear, particularly those related to nullable reference types, obsolete APIs, or platform compatibility.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release --verbosity normal
```

Review test output carefully. Any failing tests may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically check the following areas:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the expected database and that migrations (if using Entity Framework) are applied correctly.
- **Domain logic**: Exercise key domain operations through the UI or API endpoints to confirm `Bookstore.Domain` behaves correctly.
- **Web layer**: Navigate through the application to confirm pages render, forms submit, and routing works as expected.

### 5. Check for Platform-Specific API Usage

Even without build errors, some APIs that compiled successfully may behave differently or throw at runtime on non-Windows platforms. Review the following:

- Any use of `System.Drawing` (not fully supported cross-platform without additional packages such as `SkiaSharp` or `System.Drawing.Common` with a runtime flag).
- File path handling — ensure `Path.Combine` is used rather than hardcoded backslashes.
- Registry access or Windows-specific configuration sources.
- Any P/Invoke calls or `DllImport` attributes targeting Windows-only native libraries.

### 6. Review Configuration

Confirm that `appsettings.json` and any environment-specific configuration files (`appsettings.Development.json`, etc.) are present and correctly configured for the target environment. Pay particular attention to:

- Connection strings
- Any paths that were previously set as absolute Windows paths

### 7. Target Framework Verification

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is self-contained and deployable:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to confirm all expected assets, views, and static files are present.