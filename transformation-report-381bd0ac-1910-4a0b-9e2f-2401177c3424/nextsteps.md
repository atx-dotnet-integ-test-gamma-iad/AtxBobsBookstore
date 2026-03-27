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

Verify that no warnings or errors appear during the restore process, particularly around package compatibility or target framework mismatches.

### 2. Build the Solution

Perform a full solution build to confirm the absence of errors:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that, while non-blocking, may indicate deprecated APIs or compatibility concerns worth addressing.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests to determine whether they are caused by behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas manually:

- **Data access**: Confirm that `Bookstore.Data` connects to the database and performs reads and writes correctly. Verify that any Entity Framework migrations are up to date by running:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Domain logic**: Exercise the core business logic paths through the UI or via tests to confirm expected behavior.
- **Web layer**: Navigate through the application pages, checking for runtime exceptions, broken routes, or missing static assets.

### 5. Review Configuration Files

Cross-platform .NET no longer uses `Web.config` or `App.config` as the primary configuration mechanism. Confirm that:

- `appsettings.json` (and `appsettings.{Environment}.json`) contains all necessary configuration values previously held in `Web.config`.
- Connection strings are correctly defined and accessible at runtime.
- Any environment-specific settings are properly separated.

### 6. Check for Platform-Specific API Usage

Even without build errors, some APIs may have changed behavior on non-Windows platforms. Review the codebase for usage of:

- `System.Web` namespaces, which are not available in cross-platform .NET.
- Windows-specific file path assumptions (e.g., backslashes).
- Windows Registry access.
- Any third-party libraries that may have been targeting .NET Framework only.

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to assist with this review if needed.

### 7. Validate Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element reflects the intended modern .NET version (e.g., `net8.0` or `net9.0`):

```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
</PropertyGroup>
```

Ensure consistency across all three projects to avoid cross-framework compatibility issues.

## Deployment

Once the above validation steps pass:

1. Publish the application using:
   ```bash
   dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
   ```
2. Verify the contents of the `./publish` directory include all expected assemblies, static files, and configuration files.
3. Deploy the contents of the `./publish` directory to your target hosting environment, ensuring the correct .NET runtime version is installed on the host.