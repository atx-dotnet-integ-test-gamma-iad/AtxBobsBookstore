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

Check the output for any warnings, particularly around nullable reference types, obsolete APIs, or platform compatibility annotations, as these can indicate areas that may cause runtime issues even when the build succeeds.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing functionality behaves as expected after the migration:

```bash
dotnet test --configuration Release
```

Review any failing tests carefully, as failures may point to behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, validate the following areas:

- **Data access**: Confirm that database connections, queries, and migrations work as expected. If Entity Framework is in use, run `dotnet ef database update` to ensure migrations apply cleanly.
- **Domain logic**: Exercise the primary business logic flows to confirm correct behavior.
- **Web layer**: Navigate through the application's routes and verify that pages render correctly, form submissions work, and no runtime exceptions are thrown.

### 5. Review Configuration Files

Inspect `appsettings.json` and any environment-specific configuration files to ensure that:

- Connection strings are correct for the target environment.
- Any configuration keys that were previously in `Web.config` or `App.config` have been properly migrated to the new configuration system.

### 6. Check for Platform-Specific API Usage

Even without build errors, some APIs behave differently or are unsupported on non-Windows platforms. If cross-platform deployment is intended, test the application on the target operating system (Linux or macOS) and watch for `PlatformNotSupportedException` at runtime.

Use the [.NET Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) if you want to perform a static analysis pass for platform-specific API calls.

### 7. Review Target Framework

Open each `.csproj` file and confirm the `<TargetFramework>` element is set to the intended version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

If any project still targets `net48` or another legacy moniker, update it to the desired cross-platform target.