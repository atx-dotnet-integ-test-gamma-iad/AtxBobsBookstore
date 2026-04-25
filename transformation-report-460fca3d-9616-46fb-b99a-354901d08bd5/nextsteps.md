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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Review the output for any warnings related to package compatibility or missing packages.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Confirm that all three projects build without errors or warnings.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after migration:

```bash
dotnet test
```

Review test results and investigate any failures, as they may indicate behavioral differences introduced by the migration to cross-platform .NET.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following areas manually:

- Application startup and routing
- Database connectivity from `Bookstore.Data` (verify connection strings are correctly configured for the target environment)
- Domain logic correctness through the UI or API endpoints

### 5. Review Configuration Files

Cross-platform .NET projects use `appsettings.json` rather than `Web.config` or `App.config`. Confirm the following:

- Connection strings are present and correct in `appsettings.json`
- Any environment-specific settings are placed in `appsettings.Development.json` or similar environment-specific files
- No legacy configuration references remain in the codebase

### 6. Check for Platform-Specific API Usage

Even without build errors, some APIs may have changed behavior on non-Windows platforms. Review the code for usage of:

- File path separators (use `Path.Combine` rather than hardcoded separators)
- Windows-specific registry or COM interop calls
- `System.Drawing` (which has limited support outside Windows without additional packages)

### 7. Verify Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element targets the intended version of .NET, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported framework version.

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required files, static assets, and dependencies are present before deploying to the target environment.