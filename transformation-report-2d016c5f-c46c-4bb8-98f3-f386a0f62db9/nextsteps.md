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

Review the output for any warnings that may indicate compatibility issues even if the build succeeds.

### 3. Run Unit Tests

If the solution contains any test projects, execute them to verify that existing functionality has not been broken during the migration:

```bash
dotnet test --configuration Release
```

Review the test results and investigate any failures, as they may point to behavioral differences between the legacy .NET Framework and the new cross-platform .NET runtime.

### 4. Verify Runtime Behavior

Run the web application locally and manually verify core functionality:

```bash
dotnet run --project app/Bookstore.Web/Bookstore.Web.csproj --configuration Release
```

Check the following areas specifically, as they are common sources of runtime issues after migration:

- **Database connectivity**: Confirm that `Bookstore.Data` connects to the database correctly. Check your connection strings in `appsettings.json` and ensure the database provider (e.g., SQL Server, SQLite) is supported on the target platform.
- **Entity Framework migrations**: If using Entity Framework, verify that migrations apply cleanly:
  ```bash
  dotnet ef database update --project app/Bookstore.Data/Bookstore.Data.csproj --startup-project app/Bookstore.Web/Bookstore.Web.csproj
  ```
- **Static files and routing**: Navigate through the application and confirm that pages, static assets, and API routes resolve correctly.
- **Authentication and authorization**: If the application uses authentication, verify that login flows and session handling work as expected under ASP.NET Core.

### 5. Review Configuration Files

Compare the original `Web.config` or `App.config` files against the new `appsettings.json` to ensure all configuration values were carried over, including:

- Connection strings
- Application settings
- Logging configuration

### 6. Check for Platform-Specific API Usage

Search the codebase for any APIs that were available in .NET Framework but may behave differently or require alternative implementations in cross-platform .NET:

- `System.Web` references (should no longer be present)
- Windows-specific APIs such as the registry, WCF, or MSMQ
- Any use of `AppDomain` or remoting APIs

Use the [.NET Upgrade Assistant compatibility analyzer](https://learn.microsoft.com/en-us/dotnet/core/porting/upgrade-assistant-overview) or the `Microsoft.DotNet.ApiCompat` tooling to assist with this review if needed.

### 7. Publish the Application

Once validation is complete, publish the application to confirm the output is correct:

```bash
dotnet publish app/Bookstore.Web/Bookstore.Web.csproj --configuration Release --output ./publish
```

Review the contents of the `./publish` directory and confirm all required files, assemblies, and assets are present before deploying to your target environment.