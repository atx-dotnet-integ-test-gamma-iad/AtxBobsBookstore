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

Run the following command from the solution root to ensure all NuGet packages are properly restored:

```bash
dotnet restore
```

### 2. Build the Solution

Confirm the solution builds cleanly:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Run Unit Tests

If the solution contains test projects, execute them to verify that existing logic behaves as expected after migration:

```bash
dotnet test --configuration Release
```

Review any failing tests and determine whether they are caused by behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Review Target Framework

Open each `.csproj` file and confirm that the `<TargetFramework>` element is set to an appropriate and currently supported version, such as `net8.0`. Avoid using end-of-life versions like `net5.0` or `net6.0` if long-term support is a concern.

### 5. Verify Runtime Behavior of Bookstore.Web

Start the web application locally and navigate through its core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Check the following:

- Application starts without runtime exceptions
- All routes and pages load correctly
- Database connectivity works as expected through `Bookstore.Data`
- Domain logic in `Bookstore.Domain` produces correct results

### 6. Check for Windows-Specific Dependencies

Even when a project builds successfully, it may still contain APIs that only function on Windows. Search for usages of the following in your codebase:

- `Microsoft.Win32` namespace
- `System.Drawing` (requires additional setup on Linux/macOS)
- Registry access
- Windows-specific file path assumptions (e.g., hardcoded backslashes)

Use the [Platform Compatibility Analyzer](https://learn.microsoft.com/en-us/dotnet/standard/analyzers/platform-compat-analyzer) to assist with identifying these issues.

### 7. Review Entity Framework or Data Access Layer

In `Bookstore.Data`, confirm the following:

- The database provider package (e.g., `Microsoft.EntityFrameworkCore.SqlServer` or `Npgsql`) is compatible with the new target framework
- Any pending migrations are applied correctly:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Review Configuration Files

Ensure that `appsettings.json` contains all necessary configuration values that may have previously resided in `Web.config` or `App.config`. Key areas to check:

- Connection strings
- Logging configuration
- Application-specific settings

### 9. Test on Target Platforms

If cross-platform support is a goal, run and validate the application on each intended operating system (Windows, Linux, macOS) to surface any platform-specific runtime issues that would not appear during a build.