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

If the solution contains test projects, execute them to verify that existing functionality behaves as expected:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may point to behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

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
- **Domain logic**: Exercise the core business logic paths exposed through `Bookstore.Domain` to confirm expected outputs.
- **Web layer**: Navigate through the application pages and endpoints to confirm routing, model binding, and rendering work as intended.

### 5. Review Configuration Files

Cross-platform .NET uses `appsettings.json` rather than `Web.config` or `App.config`. Confirm the following:

- Connection strings have been moved to `appsettings.json` or environment-specific variants such as `appsettings.Production.json`.
- Any configuration keys previously read via `ConfigurationManager` have been updated to use the `IConfiguration` abstraction.
- Sensitive values such as connection strings or API keys are not committed to source control and are instead managed via environment variables or a secrets manager such as the .NET Secret Manager tool:
  ```bash
  dotnet user-secrets init --project app/Bookstore.Web/Bookstore.Web.csproj
  ```

### 6. Check for Platform-Specific API Usage

Even without build errors, some APIs that existed in .NET Framework may behave differently or have reduced functionality on cross-platform .NET. Review the codebase for usage of the following and test them explicitly:

- `System.Drawing` (GDI+ is not fully supported on Linux/macOS without additional packages)
- Windows Registry access
- `HttpContext.Current`
- Any COM interop or P/Invoke calls targeting Windows-specific libraries

### 7. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory to ensure all required assets, static files, and configuration files are present before deploying to the target environment.