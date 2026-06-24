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

If the solution contains any test projects, execute them to verify that existing functionality has not regressed:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may indicate behavioral differences between the legacy .NET Framework runtime and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Start the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Specifically, check the following areas:

- **Data access**: Confirm that `Bookstore.Data` connects to the database correctly. If Entity Framework is in use, verify that migrations are up to date by running:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Domain logic**: Exercise the key business logic paths exposed by `Bookstore.Domain` to confirm they produce expected results.
- **Web layer**: Navigate through the application's pages or API endpoints to confirm routing, model binding, and responses are functioning as expected.

### 5. Review Configuration Files

Cross-platform .NET uses `appsettings.json` rather than `Web.config` or `App.config`. Confirm the following:

- Connection strings are present and correct in `appsettings.json`.
- Any environment-specific settings are placed in the appropriate `appsettings.{Environment}.json` file.
- No legacy configuration values were lost during transformation.

### 6. Check for Platform-Specific API Usage

Even without build errors, some APIs that existed in .NET Framework may behave differently or have reduced functionality on non-Windows platforms. Review the codebase for usage of the following and test them explicitly:

- `System.Drawing` (GDI+ is not fully supported cross-platform without additional packages such as `SkiaSharp`).
- Windows Registry access.
- COM interop.
- `HttpContext.Current` (replaced by dependency-injected `IHttpContextAccessor`).

### 7. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all expected assets, static files, and configuration files are present before deploying to the target environment.