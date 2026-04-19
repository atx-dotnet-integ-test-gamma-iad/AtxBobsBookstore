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

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not prevent a successful build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences between the legacy .NET Framework version and the new cross-platform .NET version.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Manually test the following areas at a minimum:

- **Data access**: Confirm that `Bookstore.Data` connects to the database and performs read/write operations correctly. Check that any Entity Framework migrations are up to date by running:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Domain logic**: Exercise the core business logic exposed by `Bookstore.Domain` to confirm expected outputs.
- **Web layer**: Navigate through the application pages, submit forms, and verify that responses are correct.

### 5. Review Configuration Files

Cross-platform .NET uses `appsettings.json` rather than `Web.config` or `App.config`. Confirm the following:

- Connection strings have been moved to `appsettings.json` or environment variables.
- Any environment-specific settings (e.g., development vs. production) are handled using `appsettings.Development.json` and `appsettings.Production.json`.
- No legacy configuration values remain that reference Windows-specific paths or registry entries.

### 6. Check for Platform-Specific API Usage

Even without build errors, some APIs may have changed behavior on non-Windows platforms. Review the codebase for usage of:

- `System.Drawing` (replaced by libraries such as `SkiaSharp` or `ImageSharp` for cross-platform support)
- Windows registry access (`Microsoft.Win32.Registry`)
- Windows-specific file path assumptions (e.g., hardcoded backslashes)

Use `Path.Combine` and `Path.DirectorySeparatorChar` where file paths are constructed manually.

### 7. Target Framework Verification

Open each `.csproj` file and confirm the `TargetFramework` element reflects the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0-windows</TargetFramework>
```

Ensure no project still references `net4x` or `netstandard2.0` unless intentional.

### 8. Publish the Application

Once validation is complete, publish the application to confirm the output is self-contained and correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected assemblies and static assets are present before deploying to the target environment.