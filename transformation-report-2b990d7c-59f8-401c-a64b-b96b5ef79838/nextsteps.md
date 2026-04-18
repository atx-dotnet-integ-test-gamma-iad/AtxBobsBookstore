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

Run the following command from the root of the solution to ensure all NuGet packages are restored correctly:

```bash
dotnet restore
```

Verify that no warnings or errors appear during the restore process.

### 2. Build the Solution

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output and confirm that all three projects report a successful build with zero errors.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not been broken during the migration:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failing tests, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas manually:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. Verify your connection strings in `appsettings.json` are configured for the target environment.
- **Domain logic**: Exercise the core domain functionality through the UI or API endpoints to confirm correct behavior.
- **Static assets and routing**: Navigate through the web application to confirm pages load correctly and routing behaves as expected.

### 5. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` as the primary configuration mechanism. Confirm that:

- All configuration values previously in `Web.config` have been moved to `appsettings.json` or environment variables.
- Any configuration transforms that were previously handled by `Web.config` transformations are now handled through `appsettings.{Environment}.json` files.

### 6. Check for Windows-Specific Dependencies

Even though the build succeeds, runtime issues can still arise from Windows-specific APIs. Review the following:

- Any use of the Windows Registry.
- Windows-specific file path formats (e.g., hardcoded backslashes).
- Any P/Invoke calls or native library references that may not be available cross-platform.

Use the [.NET Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to assist in identifying these issues if they arise.

### 7. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected files are present before deploying to your target environment.