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

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally to confirm it starts and operates correctly:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas manually:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. Verify connection strings in your configuration files (e.g., `appsettings.json`) are valid for the target environment.
- **Domain logic**: Exercise the core domain functionality through the UI or API endpoints to confirm expected behavior.
- **Static assets and routing**: Confirm that pages load correctly and that any static files (CSS, JavaScript, images) are served as expected.

### 5. Review Configuration Files

Ensure that any configuration previously held in `Web.config` or `App.config` has been properly migrated to `appsettings.json` or `appsettings.{Environment}.json`. Pay particular attention to:

- Database connection strings
- Application-specific settings
- Authentication or authorization configuration

### 6. Check for Platform-Specific Code

Review the codebase for any APIs or libraries that were available in .NET Framework but may behave differently or require alternatives in cross-platform .NET. Common areas to inspect include:

- `System.Web` references (should no longer be present)
- Windows Registry access
- Windows Communication Foundation (WCF) client or server usage
- Any P/Invoke calls targeting Windows-specific native libraries

### 7. Target Framework Verification

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

or for the web project:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target a consistent and supported version of .NET.

### 8. Deploy to Target Environment

Once local validation is complete, publish the application using the following command:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Copy the contents of the `./publish` directory to your target server or hosting environment and verify the application runs correctly there, including database connectivity and any environment-specific configuration.