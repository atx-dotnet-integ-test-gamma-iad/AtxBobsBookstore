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

Review any failing tests and determine whether they are caused by behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally and manually exercise the core features:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas specifically:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly and that queries return expected results. Pay attention to any Entity Framework or ADO.NET provider changes that may affect connection strings or query behavior.
- **Domain logic**: Verify that business rules in `Bookstore.Domain` produce the same results as the legacy application.
- **Web layer**: Navigate through the application and confirm that pages render correctly, form submissions work, and routing behaves as expected.

### 5. Review Configuration Files

Cross-platform .NET uses `appsettings.json` rather than `Web.config` or `App.config` for most configuration. Confirm that:

- Connection strings have been migrated correctly to `appsettings.json`.
- Any environment-specific settings are handled using the appropriate `appsettings.{Environment}.json` files.
- Authentication, authorization, and middleware configurations are present and correct in `Program.cs` or `Startup.cs`.

### 6. Check for Platform-Specific API Usage

Even without build errors, some APIs behave differently or are unsupported on non-Windows platforms. Review the codebase for usage of:

- `System.Drawing` (replaced by libraries such as `SkiaSharp` or `ImageSharp` for cross-platform use)
- Windows Registry access
- Windows-specific file path assumptions (e.g., backslash separators)
- `System.Web` remnants that may have been shimmed during transformation

Use the .NET Upgrade Assistant compatibility analyzer or the `Microsoft.DotNet.PlatformAbstractions` tooling to identify any remaining concerns.

### 7. Validate the Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 8. Publish the Application

Once validation is complete, produce a published output to confirm the application can be packaged correctly:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected assets, views, and static files are present.