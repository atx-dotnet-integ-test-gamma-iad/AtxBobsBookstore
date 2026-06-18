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

Check the output for any warnings that, while non-breaking, may indicate areas of concern such as obsolete API usage or nullable reference warnings.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review test results carefully. Any failing tests should be investigated to determine whether they reflect a regression introduced during the migration or a pre-existing issue.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, verify the following areas:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. Check connection strings in your configuration files (e.g., `appsettings.json`) to ensure they are appropriate for the target environment.
- **Domain logic**: Exercise the key business logic flows exposed through `Bookstore.Domain` to confirm they produce expected results.
- **Web layer**: Navigate through the application's pages or API endpoints to confirm routing, model binding, and rendering work as expected.

### 5. Review Configuration Files

Inspect `appsettings.json` and any environment-specific variants (e.g., `appsettings.Production.json`) to confirm that:

- Connection strings are valid and updated for the target platform.
- Any configuration keys that were previously stored in `Web.config` or `App.config` have been correctly migrated to the new configuration system.

### 6. Check for Platform-Specific API Usage

Even without build errors, certain APIs may behave differently or be unavailable on non-Windows platforms. If cross-platform deployment is intended, review the codebase for usage of:

- `System.Drawing` (GDI+ dependent)
- Windows Registry access
- Windows-specific authentication mechanisms
- Any P/Invoke calls targeting Windows-only native libraries

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to assist with this review.

### 7. Review Target Framework

Confirm that all three projects are targeting the intended .NET version by inspecting each `.csproj` file for the `<TargetFramework>` element. Ensure consistency across projects where applicable.

## Deployment

### 1. Publish the Application

Use the `dotnet publish` command to produce the deployment artifacts:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

### 2. Verify the Published Output

Inspect the `./publish` directory to confirm all expected files are present, including static assets, configuration files, and dependent assemblies.

### 3. Deploy to Target Environment

Copy the published output to the target server or hosting environment. Ensure the target machine has the correct .NET runtime version installed. You can verify the required runtime version from the `<TargetFramework>` value in the web project's `.csproj` file.

For self-contained deployments, add the `--self-contained true` flag along with a runtime identifier:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --self-contained true --runtime win-x64 --output ./publish
```

Replace `win-x64` with the appropriate runtime identifier for your target environment (e.g., `linux-x64`, `osx-x64`).