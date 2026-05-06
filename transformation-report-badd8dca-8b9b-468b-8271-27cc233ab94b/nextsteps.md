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

Perform a full solution build to confirm there are no compilation issues:

```bash
dotnet build --configuration Release
```

Review the output for any warnings that may indicate deprecated APIs or compatibility concerns, even if they do not block the build.

### 3. Review Target Framework

Open each `.csproj` file and confirm the `TargetFramework` is set to the intended cross-platform .NET version, for example:

```xml
<TargetFramework>net8.0</TargetFramework>
```

Ensure all three projects target the same framework version to avoid inter-project compatibility issues.

### 4. Check for Windows-Specific Dependencies

Search the codebase for any APIs or packages that are Windows-only, such as:

- `Microsoft.Win32` namespace usage
- `System.Drawing` (without the `System.Drawing.Common` cross-platform package)
- Any P/Invoke calls targeting Windows DLLs

These will not cause build errors on Windows but will fail at runtime on Linux or macOS.

### 5. Run the Application Locally

Start the web application and verify it runs as expected:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj
```

Navigate to the application in a browser and exercise the core functionality, including any pages that interact with the `Bookstore.Data` and `Bookstore.Domain` layers.

### 6. Run Existing Tests

If the solution contains a test project, execute the test suite to validate business logic and data access behavior:

```bash
dotnet test
```

Review any failing tests, as they may indicate behavioral differences introduced by the migration.

### 7. Validate Database Connectivity

If `Bookstore.Data` uses Entity Framework Core, confirm the database connection string in `appsettings.json` is correct for the target environment. If migrations are used, verify they are up to date:

```bash
dotnet ef migrations list --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

Apply any pending migrations if needed:

```bash
dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
```

### 8. Test on the Target Platform

If the goal is cross-platform support, run the application on the target operating system (Linux or macOS) to surface any runtime issues that would not appear during a Windows build.

```bash
dotnet publish --configuration Release --runtime linux-x64 --self-contained false
```

Then execute the published output on the target machine and verify expected behavior.